path="/home/ubuntu/data/training-case-study"
server="ubuntu@large"
key="~/.ssh/gpu.pem"
rsync -e "ssh -i $key" \
    -r \
    "$server:${path}" \
    /home/syin/lol/data

# rsync -e "ssh -i $key" \
#     --list-only \
#     "$server:${path}"