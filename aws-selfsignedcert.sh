#!/bin/bash
#
# This script will create a new root CA and an SSL certificate signed by this root agency
# It will then upload the cert to the associated AWS account
# AWS CLI needs to be installed on this machine
#

CN="testing-gelber.com" #Website address

yum install openssl -y @2>/dev/null

rm -rf rootca.*
rm -rf server.*

# Create a key and cert for new root agency
openssl req -x509 -days 365 -set_serial 100 -newkey rsa:4096 -nodes -keyout rootca.key -out rootca.crt -subj "/OU=RootAgency/CN=RootAgency"
# Create a key, csr and crt for the server
openssl req  -newkey rsa:4096 -nodes -keyout server.key -out server.csr -subj "/OU=$CN/CN=$CN"
openssl x509 -req -days 365 -set_serial 200 -CA rootca.crt -CAkey rootca.key -in server.csr -out server.crt
chmod 0600 *.key

aws iam upload-server-certificate --server-certificate-name gelber-cert --certificate-body file://server.crt --private-key file://server.key
