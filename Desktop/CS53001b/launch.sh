#!/bin/bash
AMI=amzn-ami-hvm-2016.03.0.x86_64-gp2 (ami-c229c0a2) # EC2 Instances Control Panel, AMI ID
S3_BUCKET=cs5300-bjg226-project1b # S3 Bucket

aws configure set aws_access_key_id AKIAJYTRJUGW4XRMLOLQ # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
aws configure set aws_secret_access_key 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 # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
aws configure set default.region us-east-1 # Leave this as is

aws s3 cp hello.war s3://${S3_BUCKET}/hello.war # 
aws ec2 run-instances --image-id ${AMI} --count 5 --instance-type t2.micro --user-data install-my-app.sh


