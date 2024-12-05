import os
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
import argparse
import boto3

# Setup boto3 client
session = boto3.Session(profile_name='gpu')
s3_client = session.client('s3')

# Specify the bucket and the prefix (path to your folder)
bucket_name = 'deepvariant-training-data-shiyi-2024-11'
prefix = 'training-case-study/output/training_set.with_label.tfrecord'

# List files in the S3 path
response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=prefix)
files = [content['Key'] for content in response.get('Contents', [])]

# Print the files
for file in files:
    print(file)


def parse_cmdline(argv):
    """Parse the commandline arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('--output_pattern_prefix', help='Output file pattern in S3.')
    known_args, pipeline_args = parser.parse_known_args(argv)
    return known_args, pipeline_args

def run():
    # Hardcode the output path
    output_pattern_prefix = "s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples"
    input_pattern_prefix = "s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/validation_set.with_label.tfrecord*.gz"

    # Set pipeline options
    pipeline_args = [
        '--runner=SparkRunner',
        '--spark_master=local[*]'  # Use all available cores
    ]
    
    pipeline_options = PipelineOptions(pipeline_args)

    with beam.Pipeline(options=pipeline_options) as p:
        # Example: create a list of strings and write to the specified output path
        (p
         | 'ReadInput' >> beam.io.ReadFromTFRecord(input_pattern_prefix)
         | 'AddHelloWorld' >> beam.Map(lambda x: f"Hello, World! {x}")
         | 'WriteOutput' >> beam.io.WriteToText(output_pattern_prefix))

if __name__ == '__main__':
    run()
