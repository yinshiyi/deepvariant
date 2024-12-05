#https://spark.apache.org/docs/latest/api/python/user_guide/python_packaging.html#using-virtualenv
#https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html
aws emr add-steps \
    --cluster-id j-14NIKY3MAI1QU \
    --steps Type=Spark,Name="SparkJob",ActionOnFailure=CONTINUE,Args="[
    '--master', 'yarn',
    '--deploy-mode', 'cluster',
    '--conf', 'spark.archives=s3://deepvariant-training-data-shiyi-2024-11/pyspark_venv.tar.gz#environment', 
    '--conf', 'spark.yarn.appMasterEnv.PYSPARK_PYTHON=./environment/bin/python',
    '--conf', 'spark.executorEnv.PYSPARK_PYTHON=./environment/bin/python',
    's3://deepvariant-training-data-shiyi-2024-11/test.py'
    ]" \
    --region us-east-1 \
    --profile gpu
