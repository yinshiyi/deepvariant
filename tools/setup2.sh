#!/bin/bash
sudo pip install --no-cache-dir --upgrade pip
sudo pip install --no-cache-dir setuptools --upgrade
sudo pip install --no-cache-dir "apache_beam[aws]==2.61.0"
# Create a shared temporary directory for Apache Beam
mkdir -p /mnt/tmp/apache_beam
sudo chmod 1777 /mnt/tmp/apache_beam
export BEAM_TMP_DIR=/mnt/tmp/apache_beam
