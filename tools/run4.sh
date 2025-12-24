aws emr add-steps \
    --cluster-id j-12H7BHVU6VZVN \
    --steps Type=Spark,Name="SparkJob",ActionOnFailure=CONTINUE,Args='[
    "--master", "yarn",
    "--deploy-mode", "cluster",
    '--conf', 'spark.archives=s3://deepvariant-training-data-shiyi-2024-11/pyspark_venv.tar.gz#environment',
    '--conf', 'spark.yarn.appMasterEnv.PYSPARK_PYTHON=./environment/bin/python',
    '--conf', 'spark.executorEnv.PYSPARK_PYTHON=./environment/bin/python',
    "s3://deepvariant-training-data-shiyi-2024-11/beam_test.py", 
    "--input_pattern_list=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/training_set.with_label.tfrecord-*.gz", 
    "--output_pattern_prefix=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples", 
    "--region=us-east-1",
    "--temp_location=s3://deepvariant-training-data-shiyi-2024-11/temp",
    "--staging_location=s3://deepvariant-training-data-shiyi-2024-11/staging"
    ]' \
    --region us-east-1 \
    --profile gpu
