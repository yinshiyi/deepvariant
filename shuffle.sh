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
  --direct_num_workers=0