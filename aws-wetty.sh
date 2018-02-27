#!/bin/bash
#Install nginx and wetty on RHEL 7 for http login using port 8888
#These instructions are from this video on youtube - https://www.youtube.com/watch?v=gjHYl81t2bI

cd /tmp
sudo yum install wget -y
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo rm -rf epel-release-latest-7.noarch.rpm
sudo yum install nginx git gcc gcc-c++ openssl-devel -y
wget https://nodejs.org/dist/v8.9.4/node-v8.9.4.tar.gz
sudo mv node-v8.9.4.tar.gz /usr/local/src/
cd /usr/local/src
sudo tar -xvzf node-v8.9.4.tar.gz 
cd node-v8.9.4
sudo ./configure

#The following make can take more take 30 minutes
sudo make

sudo make install
sudo yum install npm nodejs
sudo chmod o+x /root
cd /root
sudo git clone https://github.com/krishnasrinivas/wetty
cd wetty
sudo npm install -y

#Setting the password for weblogin
echo "redhat" | sudo passwd ec2-user --stdin

sudo node app.js -p 8888

