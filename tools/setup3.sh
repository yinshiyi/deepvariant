#!/bin/bash
python3 -m venv /opt/beam_env
source /opt/beam_env/bin/activate
pip install "apache_beam[aws]==2.61.0"
deactivate
