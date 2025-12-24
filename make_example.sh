# amd64 architecture, but your machine is running an arm64 architecture

YOUR_PROJECT=takara
OUTPUT_GCS_BUCKET=REPLACE_WITH_YOUR_GCS_BUCKET
# might have to install gsutil to make sure the instance connect to deepvariant's standard files
BUCKET="gs://deepvariant"
VERSION="1.6.1"
DOCKER_IMAGE="google/deepvariant:${VERSION}"

MODEL_BUCKET="${BUCKET}/models/DeepVariant/${VERSION}/DeepVariant-inception_v3-${VERSION}+data-wgs_standard"
GCS_PRETRAINED_WGS_MODEL="${MODEL_BUCKET}/model.ckpt"

OUTPUT_BUCKET="${OUTPUT_GCS_BUCKET}/customized_training"
TRAINING_DIR="${OUTPUT_BUCKET}/training_dir"

BASE="/home/ubuntu/data/training-case-study"
DATA_BUCKET=gs://deepvariant/training-case-study/BGISEQ-HG001

INPUT_DIR="${BASE}/input"
BIN_DIR="${INPUT_DIR}/bin"
DATA_DIR="${INPUT_DIR}/data"
OUTPUT_DIR="${BASE}/output2"
LOG_DIR="${OUTPUT_DIR}/logs"
SHUFFLE_SCRIPT_DIR="${HOME}/deepvariant/tools"

REF="${DATA_DIR}/ucsc_hg19.fa"
BAM_CHR1="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr1.bam"
BAM_CHR20="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr20.bam"
BAM_CHR21="${DATA_DIR}/BGISEQ_PE100_NA12878.sorted.chr21.bam"
TRUTH_VCF="${DATA_DIR}/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_PGandRTGphasetransfer_chrs_FIXED.vcf.gz"
TRUTH_BED="${DATA_DIR}/HG001_GRCh37_GIAB_highconf_CG-IllFB-IllGATKHC-Ion-10X-SOLID_CHROM1-X_v.3.3.2_highconf_nosomaticdel_chr.bed"

N_SHARDS=7
mkdir -p "${OUTPUT_DIR}"
mkdir -p "${BIN_DIR}"
mkdir -p "${DATA_DIR}"
mkdir -p "${LOG_DIR}"

( time seq 0 $((N_SHARDS-1)) | \
  parallel --halt 2 --line-buffer \
    sudo docker run \
      -v ${HOME}:${HOME} \
      ${DOCKER_IMAGE} \
      make_examples \
      --mode training \
      --ref "${REF}" \
      --reads "${BAM_CHR1}" \
      --examples "${OUTPUT_DIR}/training_set.with_label.tfrecord@${N_SHARDS}.gz" \
      --truth_variants "${TRUTH_VCF}" \
      --confident_regions "${TRUTH_BED}" \
      --task {} \
      --regions "'chr1'" \
      --channels "insert_size" \
) 2>&1 | tee "${LOG_DIR}/training_set.with_label.make_examples.log"