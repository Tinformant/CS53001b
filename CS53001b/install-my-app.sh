S3_BUCKET=edu-cornell-cs-cs5300s16-rs2357-proj1b

echo "your install instructions for a single node go here"
echo "you could do this: aws s3 cp s3://${S3_BUCKET}/hello.war /usr/share/tomcat8/webapps/hello.war"
echo "you would write to simpledb here"
echo "you would loop reading simpledb here once every X seconds (say, 15?) until all nodes online"

echo "-------------------- INSTALLING TOMCAT 8 --------------------"
# Install the Tomcat server
sudo wget http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.54/bin/apache-tomcat-7.0.54.tar.gz
sudo tar -xvf apache-tomcat-7.0.54.tar.gz
sudo mv apache-tomcat-7.0.54 /usr/local/
sudo chmod 755 /etc/init.d/tomcat754
echo "-------------------- MOVING WAR FROM BUCKET TO SERVER --------------------"
sudo aws s3 cp s3://${S3_BUCKET}/hello.war  /var/lib/tomcat7/webapps/hello.war  #Download the war file to each instance
echo "-------------------- STARTING UP TOMCAT SERVER --------------------"
<host>:8080/hello #Need to install the application code here #Any other software?
echo "-------------------- RETRIVING SERVER META-DATA --------------------"
echo $(curl http://169.254.169.254/latest/meta-data/local-ipv4) #3.1.2 Create a file names local-ipv4 that contains the internal ip address of the instance
echo "-------------------- RETRIVING SERVER AMI DATA  --------------------"
ami=$(curl http://169.254.169.254/latest/meta-data/ami-launch-index) #3.1.3 Determine the instance's ami-launch-index
#Upload the internal IP address to SimpleDB at a domain + item + attribute name
echo ${ami}
echo "-------------------- STARTING UP SIMPLEDB --------------------"
aws configure set preview.sdb true #Enable SimpleDB
echo "-------------------- FINDING DIRECTORY --------------------"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" #Find the current directory
echo "-------------------- STARTING TOMCAT SERVER --------------------"
sh $DIR/startup #3.1.6 Start the tomcat server
# sudo /etc/init.d/tomcat754 start