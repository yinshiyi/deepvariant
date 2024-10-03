#!/bin/bash

# Variables
host="my-ec2-instance"
region="us-east-1"

# Step 1: Launch the EC2 instance
instance_id=$(aws ec2 run-instances \
    --image-id ami-096ea6a12ea24a797 \
    --count 1 \
    --instance-type t4g.small \
    --security-group-id sg-0b734813083db4ba2 \
    --key-name gpu \
    --block-device-mappings DeviceName=/dev/sda1,Ebs={VolumeSize=20} \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value='"${host}"'}]' \
    --query "Instances[0].InstanceId" \
    --output text \
    --region $region \
    --profile gpu)

echo "Launched EC2 instance with ID: $instance_id"

# Step 2: Create the CloudWatch alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "CPUUtilization-Low-${instance_id}" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 3600 \
    --threshold 1 \
    --comparison-operator LessThanOrEqualToThreshold \
    --dimensions "Name=InstanceId,Value=${instance_id}" \
    --evaluation-periods 2 \
    --alarm-actions arn:aws:sns:us-east-1:940583394710:idle-instance-alarm \
    --region $region \
    --profile gpu

echo "Alarm created for instance: $instance_id"
