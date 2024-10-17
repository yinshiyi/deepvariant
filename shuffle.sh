#
# git clone https://github.com/apache/beam-starter-python.git
# cd beam-starter-python
# python3 -m venv env
# source env/bin/activate

# pip3 install setuptools --upgrade
# pip3 install apache_beam # installed 2.59.0
# pip3 install tensorflow  # For parsing tf.Example in shuffle_tfrecords_beam.py.

# play around with snappy will make it crash in local server
# python-snappy
# python3 -m pip install snappy
# source ../beam-starter-python/shiyi/bin/activate
YOUR_PROJECT=takara
BASE="/home/syin/lol/data/training-case-study"
OUTPUT_DIR="${BASE}/output2"
time python3 tools/shuffle_tfrecords_beam.py \
  --project="${YOUR_PROJECT}" \
  --input_pattern_list="${OUTPUT_DIR}"/training_set.with_label.tfrecord-?????-of-00007.gz \
  --output_pattern_prefix="${OUTPUT_DIR}/training_set.with_label.shuffled" \
  --output_dataset_name="HG001" \
  --output_dataset_config_pbtxt="${OUTPUT_DIR}/training_set.dataset_config.pbtxt" \
  --job_name=shuffle-tfrecords \
  --runner=DirectRunner \
  --direct_num_workers=32
