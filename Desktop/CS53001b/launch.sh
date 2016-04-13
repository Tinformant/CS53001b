#!/bin/bash
AMI=ami-97a7b4fd # EC2 Instances Control Panel, AMI ID
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b # S3 Bucket

#aws configure set aws_access_key_id AKIAJYTRJUGW4XRMLOLQ # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
#aws configure set aws_secret_access_key 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 # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
#aws configure set default.region us-east-1 # Leave this as is

aws configure set aws_access_key_id AKIAICNPLUSMFTAXOLTQ
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1

aws s3 cp hello.war s3://${S3_BUCKET}/hello.war # 
aws ec2 run-instances --image-id ${AMI} --count 5 --instance-type t2.micro --user-data install-my-app.sh


