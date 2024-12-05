# pylint: disable=line-too-long
r"""Hello World with Apache Beam and SparkRunner on AWS.

To run on AWS using the Spark Runner:
1) Set up an AWS EMR cluster or use an existing Spark cluster.

2) Upload the input file to an S3 bucket.

3) Run the following command on your Spark cluster or submit it through EMR:

  python hello_world_beam_spark.py \
    --input_pattern_list="s3://your-bucket/input_data/hello_world.txt" \
    --output_pattern_prefix="s3://your-bucket/output_data/hello_world_output" \
    --runner=SparkRunner \
    --spark_master=yarn \
    --region=us-east-1

"""

import argparse
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions

def parse_cmdline(argv):
    """Parse the commandline arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--input_pattern_list', help='Input file in S3.')
    parser.add_argument('--output_pattern_prefix', help='Output file pattern in S3.')
    known_args, pipeline_args = parser.parse_known_args(argv)
    return known_args, pipeline_args

def run(argv=None):
    known_args, pipeline_args = parse_cmdline(argv)
    pipeline_options = PipelineOptions(pipeline_args)

    with beam.Pipeline(options=pipeline_options) as p:
        # Read input file and prepend "Hello, World!"
        (p
         | 'ReadInput' >> beam.io.ReadFromText(known_args.input_pattern_list)
         | 'AddHelloWorld' >> beam.Map(lambda x: f"Hello, World! {x}")
         | 'WriteOutput' >> beam.io.WriteToText(known_args.output_pattern_prefix))

if __name__ == '__main__':
    run()
