#https://spark.apache.org/docs/latest/api/python/user_guide/python_packaging.html#using-virtualenv
#https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html
aws emr add-steps \
    --cluster-id j-4EIC3Q4MX967 \
    --steps Type=Spark,Name="SparkJob",ActionOnFailure=CONTINUE,Args="[
    '--master', 'yarn',
    '--deploy-mode', 'cluster',
    's3://deepvariant-training-data-shiyi-2024-11/beam_test_local.py',
    "--input_pattern_list=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/training_set.with_label.tfrecord-*.gz", 
    "--output_pattern_prefix=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples", 
    "--runner=SparkRunner",
    "--region=us-east-1"
    ]" \
    --region us-east-1 \
    --profile gpu
