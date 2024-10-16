path="/home/ubuntu/data/"
server="ubuntu@large"
key="~/.ssh/gpu.pem"
rsync -e "ssh -i $key" \
    -r \
    /home/syin/lol/data/training-case-study \
    "$server:${path}"
