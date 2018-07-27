#!/bin/bash
#################################################################################################
# This script will install nginx and wetty on RHEL 7 for weblogin incase ssh is blocked
# These instructions are from this video on youtube - https://www.youtube.com/watch?v=gjHYl81t2bI
#################################################################################################
# Start of user inputs
SETUSERPASSWD="no"
#SETUSERPASSWD="yes"
USERNAME="ec2-user"
PASSWORD="redhat"
LOGINPORT=80
# End of user input
#################################################################################################

INSTALLPACKAGES="nginx git gcc gcc-c++ openssl-devel npm nodejs"

if [[ $EUID != "0" ]]
then
	echo
	echo "##########################################################"
	echo "ERROR. You need to have root privileges to run this script"
	echo "##########################################################"
	exit 1
else
	echo
	echo "############################################################"
	echo "This script will enable weblogin on this server on port $LOGINPORT"
	echo "############################################################"
	sleep 5
fi


# Install epel repo
cd /tmp
yum install -y -q wget
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y -q epel-release-latest-7.noarch.rpm
rm -rf epel-release-latest-7.noarch.rpm


echo
echo "###################################################"
echo "Installing packages $INSTALLPACKAGES"
yum install -y -q $INSTALLPACKAGES > /dev/null 2>&1
echo "Done"
echo "###################################################"


echo
echo "#####################################################"
echo "Configuring npm"
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4.tar.gz
mv node-v8.9.4.tar.gz /usr/local/src/
cd /usr/local/src
tar -xvzf node-v8.9.4.tar.gz 
cd node-v8.9.4
./configure

# The following make can take more than an hour to complete
make
make install
cd /usr/local/src
git clone https://github.com/krishnasrinivas/wetty
cd wetty
npm install -y
echo "Configuration complete"
echo "#####################################################"

#Setting the password for weblogin
if [[ $SETUSERPASSWD == "yes" ]]
then
	echo "$PASSWORD" | passwd $USERNAME --stdin
fi

node app.js -p $LOGINPORT &


echo
echo "#########################################"
echo `date`
echo "Weblogin Installation complete"
echo -n "For weblogin- http://" && curl http://ident.me && echo ":80" && echo
echo "Done"
echo "#########################################"
echo "Initialization Complete"
