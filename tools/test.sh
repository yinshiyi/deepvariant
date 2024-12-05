export AWS_PROFILE=gpu

python tools/beam_test_local.py \
    --runner=SparkRunner \
    --spark_master=local[*]


