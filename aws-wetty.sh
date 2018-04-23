#!/bin/bash
#Install nginx and wetty on RHEL 7 for http login using port 8888
#These instructions are from this video on youtube - https://www.youtube.com/watch?v=gjHYl81t2bI


# User input
SETUSERPASSWD="no"
#SETUSERPASSWD="yes"
USERNAME="ec2-user"
PASSWORD="redhat"
LOGINPORT=80
# End of user input

PACKAGES="nginx git gcc gcc-c++ openssl-devel npm nodejs"

if [[ $EUID != "0" ]]
then
	echo "ERROR. Need to have root privileges to run this script"
	exit 1
fi



cd /tmp
yum install -y -q wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y -q epel-release-latest-7.noarch.rpm
rm -rf epel-release-latest-7.noarch.rpm
#yum install nginx git gcc gcc-c++ openssl-devel -y
yum install -y -q $PACKAGES
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4.tar.gz
mv node-v8.9.4.tar.gz /usr/local/src/
cd /usr/local/src
tar -xvzf node-v8.9.4.tar.gz 
cd node-v8.9.4
./configure

# The following make can take more than an hour to complete
make
make install
#yum -y install npm nodejs
#chmod o+x /root
# End of make


cd /usr/local/src
git clone https://github.com/krishnasrinivas/wetty
cd wetty
npm install -y

#Setting the password for weblogin
if [[ $SETUSERPASSWD == "yes" ]]
then
	echo "$PASSWORD" | passwd $USERNAME --stdin
fi

node app.js -p $PORT &

echo `date`
echo "Initialization Complete"
