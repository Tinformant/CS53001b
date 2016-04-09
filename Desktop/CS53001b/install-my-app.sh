#!/bin/bash
S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b

echo "your install instructions for a single node go here"
echo "you could do this: aws s3 cp s3://${S3_BUCKET}/hello.war /path/to/tomcat/webapps/hello.war"
echo "you would write to simpledb here"
echo "you would loop reading simpledb here once every X seconds (say, 15?) until all nodes online"

yum -y install tomcat8-webapps tomcat8-docs-webapp tomcat8-admin-webapps #Install the Tomcat server
aws s3 cp s3://${S3_BUCKET}/hello.war /path/to/tomcat/webapps/hello.war #Download the war file to each instance
<host>:8080/hello #Need to install the application code here
#Any other software?
wget http://169.254.169.254/latest/meta-data/local-ipv4 #3.1.2 Create a file names local-ipv4 that contains the internal ip address of the instance
ami=$(wget http://169.254.169.254/latest/meta-data/ami-launch-index) #3.1.3 Determine the instance's ami-launch-index
#Upload the internal IP address to SimpleDB at a domain + item + attribute name

aws configure set preview.sdb true #Enable SimpleDB

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Find the current directory
sh $DIR/startup #3.1.6 Start the tomcat server
