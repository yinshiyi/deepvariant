YOUR_PROJECT=takara
BASE="/home/ubuntu/data/training-case-study"
OUTPUT_DIR="${BASE}/output"
time python3 tools/shuffle_tfrecords_beam.py \
  --project="${YOUR_PROJECT}" \
  --input_pattern_list="${OUTPUT_DIR}"/validation_set.with_label.tfrecord-?????-of-?????.gz \
  --output_pattern_prefix="${OUTPUT_DIR}/2/validation_set.with_label.shuffled" \
  --output_dataset_name="HG001" \
  --output_dataset_config_pbtxt="${OUTPUT_DIR}/2/validation_set.dataset_config.pbtxt" \
  --job_name=shuffle-tfrecords \
  --runner=DirectRunner \
  --direct_num_workers=0
  # --direct_running_mode=multi_threading \
