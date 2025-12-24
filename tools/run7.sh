#https://spark.apache.org/docs/latest/api/python/user_guide/python_packaging.html#using-virtualenv
#https://docs.aws.amazon.com/emr/latest/EMR-Serverless-UserGuide/using-python-libraries.html
aws emr add-steps \
    --cluster-id j-2ZGCPOYME76DC \
    --steps Type=Spark,Name="SparkJob",ActionOnFailure=CONTINUE,\
Args="[\
'--master', 'yarn',\
'--deploy-mode', 'cluster',\
'--conf', 'spark.yarn.appMasterEnv.BEAM_TMP_DIR=/mnt/tmp/apache_beam',\
'--conf', 'spark.executorEnv.BEAM_TMP_DIR=/mnt/tmp/apache_beam',\
'--conf', 'spark.executorEnv.TMPDIR=/mnt/tmp/apache_beam',\
'--conf', 'spark.yarn.appMasterEnv.TMPDIR=/mnt/tmp/apache_beam',\
'--conf', 'spark.executorEnv.PYTHONPATH=$PYTHONPATH:/usr/local/lib/python3.9/site-packages',\
'--conf', 'spark.executorEnv.PYSPARK_PYTHON=/usr/bin/python3',\
'--conf', 'spark.yarn.appMasterEnv.BEAM_HOME=/mnt/tmp/apache_beam',\
'--conf', 'spark.executorEnv.BEAM_HOME=/mnt/tmp/apache_beam',\
's3://deepvariant-training-data-shiyi-2024-11/beam_test_local.py',\
'--input_pattern_list=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/training_set.with_label.tfrecord-*.gz',\
'--output_pattern_prefix=s3://deepvariant-training-data-shiyi-2024-11/training-case-study/output/2024_12_emr/training.examples',\
'--region=us-east-1'\
]" \
    --region us-east-1 \
    --profile gpu
