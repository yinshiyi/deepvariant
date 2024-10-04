time python3 ${SHUFFLE_SCRIPT_DIR}/shuffle_tfrecords_beam.py \
  --project="${YOUR_PROJECT}" \
  --input_pattern_list="${OUTPUT_DIR}"/validation_set.with_label.tfrecord-?????-of-00016.gz \
  --output_pattern_prefix="${OUTPUT_DIR}/validation_set.with_label.shuffled" \
  --output_dataset_name="HG001" \
  --output_dataset_config_pbtxt="${OUTPUT_DIR}/validation_set.dataset_config.pbtxt" \
  --job_name=shuffle-tfrecords \
  --runner=DirectRunner \
  --direct_num_workers=0