# pylint: disable=line-too-long
r"""Shuffle tf.Example files using Apache Beam with SparkRunner on AWS.

To run on AWS using the Spark Runner:
1) Set up an AWS EMR cluster or use an existing Spark cluster.

2) Upload the input files to an S3 bucket.

3) Run the following command on your Spark cluster or submit it through EMR:

  python shuffle_tfrecords_beam_spark.py \
    --input_pattern_list="s3://YOUR_INPUT_BUCKET/A.tfrecord.gz" \
    --output_pattern_prefix="s3://YOUR_OUTPUT_BUCKET/training.examples" \
    --output_dataset_name="HG001" \
    --runner=SparkRunner \
    --project=SET_YOUR_AWS_PROJECT_ID_HERE \
    --region=SET_YOUR_AWS_REGION_HERE \
    --staging_location=s3://YOUR_BUCKET_NAME/AND_STAGING_DIRECTORY \
    --temp_location=s3://YOUR_BUCKET_NAME/AND_TEMP_DIRECTORY

Make sure the AWS EMR cluster has access to read from and write to S3.

You can monitor the Spark job using the Spark UI.

"""
# pylint: enable=line-too-long

import argparse
import hashlib
import logging
import os
import textwrap

import apache_beam as beam
from apache_beam import coders
from apache_beam.options.pipeline_options import PipelineOptions
import tensorflow.compat.v1 as tf

COMMENT_HEADER = """#
# --input_pattern_list={}
# --output_pattern_prefix={}
#
"""


def parse_cmdline(argv):
  """Parse the commandline into known and pipeline arguments.

  The known arguments are required for this specific program to function,
  and the other pipeline arguments can be used to configure beam and the
  specific beam backend being used.

  Args:
    argv: List containing command-line arguments.

  Returns:
    A pair, the first of which are the known (non-pipeline) arguments
    and the second of which are the pipeline arguments.
  """
  parser = argparse.ArgumentParser()

  parser.add_argument(
      '--input_pattern_list',
      help='Comma-separated list of TFRecord filename patterns in S3.')
  parser.add_argument(
      '--output_pattern_prefix',
      help='Filename pattern for the output TFRecords in S3.')
  parser.add_argument(
      '--output_dataset_config_pbtxt',
      help='Optional.  If set, print out a human-readable version of '
      'DeepVariantDatasetConfig.')
  parser.add_argument(
      '--output_dataset_name',
      help='Optional unless --output_dataset_config_pbtxt is set.')

  known_args, pipeline_args = parser.parse_known_args(argv)

  return known_args, pipeline_args


def read_from_tfrecords_files(pipeline, input_filename_pattern_list):
  """Reads records from TFRecord files.

  Args:
    pipeline: Beam pipeline object.
    input_filename_pattern_list: List of filename patterns in S3.

  Returns:
    A PCollection of read tf.Examples.
  """
  readers = []
  for i, filepattern in enumerate(input_filename_pattern_list):
    readers.append(pipeline
                   | 'ReadTFRecordFiles_{}[{}]'.format(i, filepattern) >> beam
                   .io.ReadFromTFRecord(filepattern, coder=coders.BytesCoder()))
  return readers | 'Flatten' >> beam.Flatten()


def shuffle_records(input_examples):
  """Shuffles the input_examples in an effectively random order."""

  def sha1(input_bytes):
    """Returns the sha1 hash of input_bytes."""
    m = hashlib.sha1()
    m.update(input_bytes)
    return m.digest()

  return (input_examples
          | 'Randomize' >> beam.Map(lambda x: (sha1(x), x))
          | 'Groupby' >> beam.GroupByKey()
          | 'DropKey' >> beam.FlatMap(lambda x: x[1]))


def count_records_per_label(input_examples):
  """Counts records by label."""

  def label_example(input_bytes):
    """Returns the label of input_example."""
    example = tf.train.Example.FromString(input_bytes)
    label = example.features.feature['label'].int64_list.value[0]
    return label

  return (
      input_examples
      | 'LabelExample' >> beam.Map(lambda x: (label_example(x), x))
      | 'CountPerLabel' >> beam.combiners.Count.PerKey()
      |
      'ToString' >> beam.Map(lambda kv: u'# class{}: {}\n'.format(kv[0], kv[1]))
      | 'Concat1' >> beam.CombineGlobally(''.join))


def make_config_string(name, tfrecord_path, num_examples):
  return textwrap.dedent("""
  name: "{}"
  tfrecord_path: "{}-?????-of-?????.tfrecord.gz"
  num_examples: {}
  """.format(name, tfrecord_path, num_examples))


def write_summary_string_to_file(pipeline, output_examples, input_pattern_list,
                                 dataset_name, output_pattern_prefix,
                                 output_filename):
  """Writes a file summarizing the PCollection of Examples."""

  comment_str = pipeline | 'CreateFileHeader' >> beam.Create(
      [COMMENT_HEADER.format(input_pattern_list, output_pattern_prefix)])
  num_examples = (
      output_examples
      | 'CountOutputExamples' >> beam.combiners.Count.Globally())
  config_str = num_examples | 'MakeConfigStr' >> beam.Map(
      lambda n: make_config_string(dataset_name, output_pattern_prefix, n))

  num_examples_by_labels = count_records_per_label(output_examples)
  merged_strings = (comment_str, num_examples_by_labels,
                    config_str) | 'FlattenStrs' >> beam.Flatten()
  _ = (
      merged_strings
      | 'Concat2' >> beam.CombineGlobally(''.join)
      | 'WriteToFile' >> beam.io.WriteToText(
          output_filename,
          shard_name_template='',
          header='# Generated by shuffle_tfrecords_beam_spark.py'))


def main(argv=None):
  """Main entry point; defines and runs the pipeline."""
  known_args, pipeline_args = parse_cmdline(argv)

  pipeline_options = PipelineOptions(pipeline_args)

  # Ensure AWS-specific Spark configurations
  pipeline_options.view_as(PipelineOptions).add_experiment('use_s3')

  with beam.Pipeline(options=pipeline_options) as p:
    input_examples = read_from_tfrecords_files(
        p, known_args.input_pattern_list.split(','))
    output_examples = shuffle_records(input_examples)

    _ = output_examples | beam.io.WriteToTFRecord(
        file_path_prefix=known_args.output_pattern_prefix,
        file_name_suffix='.tfrecord.gz',
        coder=coders.BytesCoder())
    if known_args.output_dataset_config_pbtxt:
      if not known_args.output_dataset_name:
        raise ValueError('Need to set output_dataset_name.')
      write_summary_string_to_file(p, output_examples,
                                   known_args.input_pattern_list,
                                   known_args.output_dataset_name,
                                   known_args.output_pattern_prefix,
                                   known_args.output_dataset_config_pbtxt)


if __name__ == '__main__':
  logging.getLogger().setLevel(logging.INFO)
  main()
