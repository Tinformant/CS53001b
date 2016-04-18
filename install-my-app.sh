#!/bin/bash
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b

echo "your install instructions for a single node go here"
echo "you could do this: aws s3 cp s3://${S3_BUCKET}/hello.war /usr/share/tomcat8/webapps/hello.war"
echo "you would write to simpledb here"
echo "you would loop reading simpledb here once every X seconds (say, 15?) until all nodes online"

aws configure set aws_access_key_id AKIAIUFZXMYYC7ZJJH7A
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1


sudo yum -y update
sudo yum -y install tomcat8
sudo yum -y install tomcat8-webapps tomcat8-docs-webapp tomcat8-admin-webapps #Install the Tomcat server

sudo chmod o+w /usr
sudo chmod o+w /usr/share
sudo chmod o+w /usr/share/tomcat8
sudo chown ec2-user:ec2-user /usr/share/tomcat8/webapps

aws s3 cp s3://edu-cornell-cs-cs5300s16-rs2357-proj1b/test-app.war /usr/share/tomcat8/webapps/test-app.war

sudo echo '0' > ~/var/tmp/reboot.txt

aws configure set preview.sdb true

amiLaunchIndex=$(curl http://169.254.169.254/latest/meta-data/ami-launch-index)
instanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
internalIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

sudo echo $instanceID > 'SelfID.txt'

aws sdb put-attributes --domain-name serverList --item-name $amiLaunchIndex --attributes Name="Internal IP",Value=$internalIP #Name="Public Host Name",Value=$publicHostName

sleep 15s

for (( i = 0; i < 5; i++ )); do
	echo $(aws sdb get-attributes --domain-name serverList --item-name $i) > serverMapping.txt
done

sudo service tomcat8 start
