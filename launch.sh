#!/bin/bash

yum -y install tomcat8-webapps tomcat8-docs-webapp tomcat8-admin-webapps #Install the Tomcat server
<host>:8080/hello #Need to install the application code here
#Any other software?
wget http://169.254.169.254/latest/meta-data/local-ipv4 #Create a file names local-ipv4 that contains the internal ip address of the instance
wget http://169.254.169.254/latest/meta-data/ami-launch-index #Determine the instance's ami-launch-index
#Upload the internal IP address to SimpleDB at a domain + item + attribute name
sh whereeverItIsInstalled/startup #Start the tomcat server
AMI=XXX
S3_BUCKET=mys3bucket

aws s3 cp hello.war s3://${S3_BUCKET}/hello.war
aws ec2 run-instances --image-id ${AMI} --count 5 --instance-type t2.micro --user-data install-my-app.sh
