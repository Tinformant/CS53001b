#!/bin/bash
#CS5300 S16 Project1b
#Runze Si(rs2357), Brandon Gilrado(bjg226), Ziquan Miao(zm56)
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b #S3 bucket

#The following lines configure the credentials
aws configure set aws_access_key_id AKIAIUFZXMYYC7ZJJH7A
aws configure set aws_secret_access_key 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
aws configure set default.region us-east-1

#The following lines update yum and install Tomcat8
sudo yum -y update
sudo yum -y install tomcat8
sudo yum -y install tomcat8-webapps tomcat8-docs-webapp tomcat8-admin-webapps 

#The following lines change permissions to give access for deployment
sudo chmod o+w /usr
sudo chmod o+w /usr/share
sudo chmod o+w /usr/share/tomcat8
sudo chown ec2-user:ec2-user /usr/share/tomcat8/webapps

#aws s3 cp s3://edu-cornell-cs-cs5300s16-rs2357-proj1b/test-app.war /usr/share/tomcat8/webapps/test-app.war
aws s3 cp s3://edu-cornell-cs-cs5300s16-rs2357-proj1b/individualWebEnd.war /usr/share/tomcat8/webapps/individualWebEnd.war #Deploy the .war file

sudo echo '0' > ~/var/tmp/reboot.txt #Create reboot.txt

aws configure set preview.sdb true #Enable SimpleDB

amiLaunchIndex=$(curl http://169.254.169.254/latest/meta-data/ami-launch-index) #Get the instance's AMI launch index
instanceID=$(curl http://169.254.169.254/latest/meta-data/instance-id) #Get the instance's instance ID
internalIP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4) #Get the instance's internal IP

sudo echo $instanceID > ~/var/tmp/'SelfID.txt' #Create SelfID.txt

aws sdb put-attributes --domain-name serverList --item-name $amiLaunchIndex --attributes Name="Internal IP",Value=$internalIP #Write the instance's informance to SimpleDB

sleep 15s #Wait for 15 seconds

#The following lines will pull information from SimpleDB to each instance
for (( i = 0; i < 5; i++ )); do
	echo $(aws sdb get-attributes --domain-name serverList --item-name $i) > ~/var/tmp/serverMapping.txt
done

sudo service tomcat8 start #Start Tomcat8
