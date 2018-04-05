#!/bin/bash
#Adding SSH password authentication to Centos/RHAT 7 and forcing user to change password at 1st login
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#Changing ec2-user password to redhat
echo "redhat" | passwd ec2-user --stdin
systemctl reload sshd
chage -d 0 ec2-user
