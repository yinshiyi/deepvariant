BASE="/home/${USER}/data/training-case-study"
OUTPUT_DIR="${BASE}/output"
model="/home/${USER}/data/model/model.ckpt"
TRAINING_DIR="${OUTPUT_DIR}/training_dir"
BIN_VERSION="1.4.0"
INPUT_DIR="${BASE}/input"
LOG_DIR="${OUTPUT_DIR}/logs"
DATA_DIR="${INPUT_DIR}/data"
REF="${DATA_DIR}/ucsc_hg19.fa"
BAM_CHR1="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr1.bam"
BAM_CHR20="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr20.bam"

sudo docker run --gpus 1 \
  -v /home/${USER}:/home/${USER} \
  google/deepvariant:"${BIN_VERSION}-gpu" \
  /opt/deepvariant/bin/run_deepvariant \
  --model_type WGS \
  --customized_model "${TRAINING_DIR}/model.ckpt-50000" \
  --ref "${REF}" \
  --reads "${BAM_CHR20}" \
  --regions "chr20" \
  --output_vcf "${OUTPUT_DIR}/test_set.vcf.gz" \
  --num_shards=4