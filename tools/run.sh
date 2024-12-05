s3://deepvariant-training-data-shiyi-2024-11/pyspark_venv.tar.gz
s3://deepvariant-training-data-shiyi-2024-11/shuffle_tfrecords_beam.py
--conf spark.archives=s3://deepvariant-training-data-shiyi-2024-11/pyspark_venv.tar.gz
--conf spark.emr-serverless.driverEnv.PYSPARK_DRIVER_PYTHON=./environment/bin/python
--conf spark.emr-serverless.driverEnv.PYSPARK_PYTHON=./environment/bin/python 
--conf spark.executorEnv.PYSPARK_PYTHON=./environment/bin/python

--input_pattern_list="s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/training_set.with_label.shuffled-?????-of-?????.tfrecord.gz" 
--output_pattern_prefix="s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples" 
--output_dataset_name="HG001" 
--runner=SparkRunner 
--spark_master=yarn 
--region=us-east-1
  spark-submit     --master yarn      \
   --deploy-mode cluster     \
   shuffle_tfrecords_beam.py     \
    --input_pattern_list="s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/training_set.with_label.shuffled-?????-of-?????.tfrecord.gz" \
    --output_pattern_prefix="s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples" \
    --output_dataset_name="HG001" \
    --runner=SparkRunner \
    --spark_master=yarn \
    --region=us-east-1

python tools/shuffle_tfrecords_beam.py \
  --input_pattern_list="/path/to/local/tfrecords/*.tfrecord.gz" \
  --output_pattern_prefix="file:///path/to/output/training.examples" \
  --output_dataset_name="HG001" \
  --runner=DirectRunner

sudo -u hadoop yarn logs -applicationId application_1733349531230_0001
