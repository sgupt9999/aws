#!/bin/bash
#Adding SSH password authentication to Centos/RHAT 7 
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#Changing ec2-user password to redhat
echo "redhat" | sudo passwd ec2-user --stdin
sudo systemctl reload sshd
