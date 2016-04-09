#!/bin/bash
AMI=XXX
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b

aws configure set aws_access_key_id AKIAICNPLUSMFTAXOLTQ
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1

aws s3 cp hello.war s3://${S3_BUCKET}/hello.war
aws ec2 run-instances --image-id ${AMI} --count 5 --instance-type t2.micro --user-data install-my-app.sh


