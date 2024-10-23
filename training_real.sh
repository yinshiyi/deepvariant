YOUR_PROJECT=takara
OUTPUT_GCS_BUCKET=REPLACE_WITH_YOUR_GCS_BUCKET
# might have to install gsutil to make sure the instance connect to deepvariant's standard files
BUCKET="gs://deepvariant"
VERSION="1.6.1"
DOCKER_IMAGE="google/deepvariant:${VERSION}"
BIN_VERSION="1.4.0"
sudo docker pull google/deepvariant:"${BIN_VERSION}-gpu"

TRAINING_DIR="${OUTPUT_DIR}/training_dir"

BASE="/home/ubuntu/data/training-case-study"
DATA_BUCKET=gs://deepvariant/training-case-study/BGISEQ-HG001

INPUT_DIR="${BASE}/input"
BIN_DIR="${INPUT_DIR}/bin"
DATA_DIR="${INPUT_DIR}/data"
OUTPUT_DIR="${BASE}/output"
LOG_DIR="${OUTPUT_DIR}/logs"
SHUFFLE_SCRIPT_DIR="${HOME}/deepvariant/tools"


BUCKET="gs://deepvariant"
BIN_VERSION="1.4.0"
MODEL_BUCKET="${BUCKET}/models/DeepVariant/${BIN_VERSION}/DeepVariant-inception_v3-${BIN_VERSION}+data-wgs_standard"
GCS_PRETRAINED_WGS_MODEL="${MODEL_BUCKET}/model.ckpt"
gsutil cp $GCS_PRETRAINED_WGS_MODEL data/model.ckpt


BASE="/home/${USER}/data/training-case-study"
OUTPUT_DIR="${BASE}/output"
model="/home/${USER}/data/model.ckpt"
TRAINING_DIR="${OUTPUT_DIR}/training_dir"
BIN_VERSION="1.4.0"
LOG_DIR="${OUTPUT_DIR}/logs"

( time sudo docker run --gpus 1 \
  -v /home/${USER}:/home/${USER} \
  google/deepvariant:"${BIN_VERSION}-gpu" \
  /opt/deepvariant/bin/model_train \
  --dataset_config_pbtxt="${OUTPUT_DIR}/training_set.dataset_config.pbtxt" \
  --train_dir="${TRAINING_DIR}" \
  --model_name="inception_v3" \
  --number_of_steps=50000 \
  --save_interval_secs=300 \
  --batch_size=32 \
  --learning_rate=0.0005 \
  --start_from_checkpoint="${model}" \
) > "${LOG_DIR}/train.log" 2>&1 &

sudo docker run \
  -v /home/${USER}:/home/${USER} \
  google/deepvariant:"${BIN_VERSION}" \
  /opt/deepvariant/bin/model_eval \
  --dataset_config_pbtxt="${OUTPUT_DIR}/validation_set.dataset_config.pbtxt" \
  --checkpoint_dir="${TRAINING_DIR}" \
  --batch_size=512 > "${LOG_DIR}/eval.log" 2>&1 &