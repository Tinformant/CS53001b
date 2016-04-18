#!/bin/bash
#CS5300 S16 Project1b
#Runze Si(rs2357), Brandon Gilrado(bjg226), Ziquan Miao(zm56)
accessKey=AKIAIUFZXMYYC7ZJJH7A
secretKey=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
keyPair=SiR #.pem file
AMI=ami-08111162 #Official free Amazon AMI
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b # S3 Bucket

#The following lines configure the credentials
aws configure set aws_access_key_id ${accessKey}
aws configure set aws_secret_access_key ${secretKey}
aws configure set default.region us-east-1

aws configure set preview.sdb true #Enable SimpleDB
aws sdb create-domain --domain-name serverList #Create a SimpleDB domain called "serverList"

#The following lines create a security group needed to acesss port 8080 and 22
aws ec2 create-security-group --group-name mySecurityGroup --description "My security group"
aws ec2 authorize-security-group-ingress --group-name mySecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-name mySecurityGroup --protocol tcp --port 8080 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ${AMI} --count 1 --instance-type t2.micro --key-name ${keyPair} --user-data file://install-my-app.sh --security-groups mySecurityGroup
