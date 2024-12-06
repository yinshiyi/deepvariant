# use docker to provide tensorflow and apache beam
spark-submit \
  --conf spark.kubernetes.container.image=shiyiyin/shuffle:latest \
  your_script.py
