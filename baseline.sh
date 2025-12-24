sudo docker run --gpus 1 \
  -v /home/${USER}:/home/${USER} \
  google/deepvariant:"${BIN_VERSION}-gpu" \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type WGS \
  --ref "${REF}" \
  --reads "${BAM_CHR20}" \
  --regions "chr20" \
  --output_vcf "${OUTPUT_DIR}/baseline.vcf.gz" \
  --num_shards=4

time sudo docker run -it \
-v "${DATA_DIR}:${DATA_DIR}" \
-v "${OUTPUT_DIR}:${OUTPUT_DIR}" \
jmcdani20/hap.py:v0.3.12 /opt/hap.py/bin/hap.py \
  "${TRUTH_VCF}" \
  "${OUTPUT_DIR}/baseline.vcf.gz" \
  -f "${TRUTH_BED}" \
  -r "${REF}" \
  -o "${OUTPUT_DIR}/chr20-calling_general.happy.output" \
  -l chr20 \
  --engine=vcfeval \
  --pass-only