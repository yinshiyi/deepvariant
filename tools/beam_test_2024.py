import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io.tfrecordio import ReadFromTFRecord, WriteToTFRecord

class ShuffleRecords(beam.PTransform):
    """Custom PTransform to shuffle records."""
    def expand(self, pcoll):
        return (pcoll
                | "Pair with random key" >> beam.Map(lambda x: (hash(x), x))
                | "Shuffle" >> beam.Reshuffle()
                | "Extract shuffled records" >> beam.Map(lambda x: x[1]))

def run(input_tfrecord, output_prefix, output_shards):
    # Define pipeline options
    options = PipelineOptions(
        runner='SparkRunner',
        spark_master='yarn',
        temp_location='s3://deepvariant-training-data-shiyi-2024-11/training-case-study/tmp/',  # Replace with your actual S3 path
        region='us-west-2'  # Specify your AWS region
    )

    # Create the pipeline
    with beam.Pipeline(options=options) as p:
        (
            p
            | "Read TFRecords" >> ReadFromTFRecord(file_pattern=input_tfrecord)
            | "Shuffle Records" >> ShuffleRecords()
            | "Write to S3" >> WriteToTFRecord(
                file_path_prefix=output_prefix,
                num_shards=output_shards
            )
        )

if __name__ == "__main__":
    # Input and output locations
    INPUT_TFRECORD = "s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/validation_set.with_label.tfrecord*.gz"
    OUTPUT_PREFIX = "s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples"
    OUTPUT_SHARDS = 10

    run(INPUT_TFRECORD, OUTPUT_PREFIX, OUTPUT_SHARDS)
