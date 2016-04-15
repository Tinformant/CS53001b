AMI=ami-8f1409e5 # EC2 Instances Control Panel, AMI ID
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b # S3 Bucket

aws configure set aws_access_key_id AKIAIHZOADZ35ISWMXZA
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1

# aws s3 cp hello.war s3://${S3_BUCKET}/hello.war # war can manually be put on S3
aws ec2 run-instances --image-id ${AMI} --count 5 --instance-type t2.micro --user-data install-my-app.sh
