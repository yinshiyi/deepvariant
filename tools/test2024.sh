python beam_test_local.py --runner=SparkRunner \
    --spark_master=yarn \
    --temp_location=s3://deepvariant-training-data-shiyi-2024-11/tmp/apache_beam/ \
    --output=s3://deepvariant-training-data-shiyi-2024-11/output/
  
