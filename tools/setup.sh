#!/bin/bash

# Remove the existing python alias if it exists
unalias python 2>/dev/null

# Create a virtual environment in a directory of your choice
python3 -m venv /mnt/venv/shuffle  # Using /mnt/venv to ensure it's outside the default temp directory
source /mnt/venv/shuffle/bin/activate

# Optionally, ensure pip is up-to-date
pip install --upgrade pip

# Install the python packages required for Apache Beam and TensorFlow
pip install setuptools --upgrade
pip install "apache_beam[aws]==2.61.0"  # Ensure compatibility with AWS services
pip install tensorflow==2.18.0

# Optionally, verify the installation and check Python version
which python
python --version

