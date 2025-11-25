#https://spark.apache.org/docs/latest/api/python/user_guide/python_packaging.html#using-virtualenv
#https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html
aws emr add-steps \
    --cluster-id j-MSS38CVZK1OP \
    --steps Type=Spark,Name="SparkJob",ActionOnFailure=CONTINUE,Args="[
    '--master', 'yarn',
    '--deploy-mode', 'cluster',
    's3://deepvariant-training-data-shiyi-2024-11/test.py'
    ]" \
    --region us-east-1 \
    --profile gpu
