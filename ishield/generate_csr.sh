#!/bin/bash

# Define the PKCS11_TOOL and PKCS11_MODULE variables
PKCS11_TOOL="/usr/bin/pkcs11-tool"
PKCS11_MODULE="/usr/lib/opensc-pkcs11.so"

# Define the subject information for the CSR
COUNTRY="US"
STATE="California"
CITY="San Francisco"
ORGANIZATION="Example Inc."
ORG_UNIT="IT Department"
COMMON_NAME="example.com"

# Get the ID of the existing private key on the PKCS11 device
KEY_ID=$($PKCS11_TOOL --module $PKCS11_MODULE --list-objects --login --pin 1234 | grep 'Private Key' | awk '{print $1}')

# Generate a CSR using the existing private key on the PKCS11 device
$PKCS11_TOOL --module $PKCS11_MODULE --certreq --id $KEY_ID --type rsa --subject "C=$COUNTRY,ST=$STATE,L=$CITY,O=$ORGANIZATION,OU=$ORG_UNIT,CN=$COMMON_NAME" --output-file example.csr --login --pin 1234