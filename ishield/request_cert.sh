#!/bin/bash

# Usage
# bash request_cert.sh "https://campuspki.germanywestcentral.cloudapp.azure.com" "foo123" "home/admin/raspi_auth_v1.p12" "home/admin/setup_test_3.csr"

EJBCA_BASE_URL=$1
P12_TOKEN=$2
P12_PASS=$3
CSR_FILE=$4


curl_response=$(curl -k -X POST \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--cert $P12_TOKEN:<$P12_PASS> \
--data '{"certificateRequest":"'$(cat $CSR_FILE)'"}' \
"$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/generateCertificate")

certificate=$(echo $curl_response | jq -r '.certificate')

echo $certificate > certificate.pem