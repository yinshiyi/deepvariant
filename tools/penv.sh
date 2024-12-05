# initialize a python virtual environment
python3 -m venv shuffle
source shuffle/bin/activate

# optionally, ensure pip is up-to-date
pip3 install --upgrade pip

# install the python packages
pip3 install setuptools --upgrade
pip3 install apache_beam==2.61.0  # 2.51.0 didn't work in my run.
pip3 install tensorflow==2.18.0  # For parsing tf.Example in shuffle_tfrecords_beam.py.

# package the virtual environment into an archive
pip3 install venv-pack
venv-pack -f -o pyspark_venv.tar.gz

# copy the archive to an S3 location
aws s3 cp pyspark_venv.tar.gz s3://deepvariant-training-data-shiyi-2024-11/ --profile gpu

# optionally, remove the virtual environment directory
rm -fr pyspark_venvsource