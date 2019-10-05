#!/bin/bash 

###################################################################
#Script Name	: generate_certs.sh
#Description	: Generate certificate authority and ca,servers, and client certs.
#Args           : 
#Author       	: Dilesh Fernando
#Email         	: fernando.dilesh@gmail.com
###################################################################

# Colors for console text
RED='\033[0;31m'
REDBLINK='\033[0;317m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color
#echo -e "\n${YELLOW}Text in color!${NC}"

echo -e "\n${YELLOW}Generate CA key${NC}"
openssl genrsa -passout pass:1111 -des3 -out ca.key 4096

echo -e "\n${YELLOW}Generate CA certificate${NC}"
openssl req -passin pass:1111 -new -x509 -days 365 -key ca.key -out ca.crt -subj  "/C=US/ST=KS/L=Lenexa/O=LeggettandPlatt/OU=ConsumerProducts/CN=Lenexa R&D CA"

echo -e "\n${YELLOW}Generate server key${NC}"
openssl genrsa -passout pass:1111 -des3 -out server.key 4096

echo -e "\n${YELLOW}Generate server signing request${NC}"
openssl req -passin pass:1111 -new -key server.key -out server.csr -subj  "/C=US/ST=KS/L=Lenexa/O=LeggettandPlatt/OU=ConsumerProducts/CN=localhost"

echo -e "\n${YELLOW}Self-sign server certificate${NC}"
openssl x509 -req -passin pass:1111 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

echo -e "\n${YELLOW}Remove passphrase from server key${NC}"
openssl rsa -passin pass:1111 -in server.key -out server.key

echo -e "\n${YELLOW}Generate client key"
openssl genrsa -passout pass:1111 -des3 -out client.key 4096

echo -e "\n${YELLOW}Generate client signing request${NC}"
openssl req -passin pass:1111 -new -key client.key -out client.csr -subj  "/C=US/ST=KS/L=Lenexa/O=LeggettandPlatt/OU=ConsumerProducts/CN=localhost"

echo -e "\n${YELLOW}Self-sign client certificate${NC}"
openssl x509 -passin pass:1111 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt

echo -e "\n${YELLOW}Remove passphrase from client key${NC}"
openssl rsa -passin pass:1111 -in client.key -out client.key

#This specific to this project. 
#Copy client certs to node_hello_grpc_client/cert folder
echo -e "\n${PURPLE}Copying client cert and CA cert to client program folder.${NC}"
cp ./{ca.crt,client.crt,client.key} ../../node_hello_grpc_client/certs

echo -e "\n${GREEN}All done!${NC}"