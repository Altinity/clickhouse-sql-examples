#!/bin/bash
# Generate private CA and then use that to create ClickHouse server cert.
CERTS=$PWD/data/certs
cd $CERTS
# Generate CA key & cert. 
openssl genrsa -out fortress_ca.key 2048
openssl req -new -x509 -subj "/CN=Fortress CA" \
 -days 3650 -key fortress_ca.key \
 -extensions v3_ca -out fortress_ca.crt

# Generate server key and cert, sign with CA key. 
openssl req -newkey rsa:2048 -nodes \
 -subj "/CN=fortress" \
 -keyout server.key -out server.csr
openssl x509 -req -in server.csr -out server.crt \
 -CAcreateserial -CA fortress_ca.crt \
 -CAkey fortress_ca.key -days 365

# Generate Diffie-Hellman params
openssl dhparam -out dhparam.pem 4096

# Set to ClickHouse user:group
sudo chown 101:101 *
