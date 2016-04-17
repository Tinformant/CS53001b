#!/bin/bash
accessKey=AKIAIUFZXMYYC7ZJJH7A
secretKey=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
keyPair=SiR
AMI=ami-08111162 # EC2 Instances Control Panel, AMI ID
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b # S3 Bucket

#aws configure set aws_access_key_id AKIAJYTRJUGW4XRMLOLQ # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
#aws configure set aws_secret_access_key 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 # Account -> Security Credentials ->Users -> brandongiraldo -> Security Credentials
#aws configure set default.region us-east-1 # Leave this as is

aws configure set aws_access_key_id ${accessKey}
aws configure set aws_secret_access_key ${secretKey}
aws configure set default.region us-east-1

aws configure set preview.sdb true
aws sdb create-domain --domain-name serverList1

#Uncomment the following lines
#aws ec2 create-security-group --group-name mySecurityGroup --description "My security group"
#aws ec2 authorize-security-group-ingress --group-name mySecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
#aws ec2 authorize-security-group-ingress --group-name mySecurityGroup --protocol tcp --port 8080 --cidr 0.0.0.0/0

#aws s3 cp hello.war s3://${S3_BUCKET}/hello.war 
#Problem with ami, is a key-pair required?
#aws ec2 run-instances --image-id ${AMI} --count 1 --instance-type t2.micro --key-name SiR --user-data install-my-app.sh --security-groups mySecurityGroup
#"$(cat script.sh)"
aws ec2 run-instances --image-id ${AMI} --count 1 --instance-type t2.micro --key-name ${keyPair} --user-data file://install-my-app.sh --security-groups mySecurityGroup
