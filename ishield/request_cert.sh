#!/bin/bash

# Usage
# bash request_cert.sh "https://campuspki.germanywestcentral.cloudapp.azure.com" "foo123" "/home/admin/raspi_auth_v1.p12" "/home/admin/setup_test_3.csr"

EJBCA_BASE_URL=$1
P12_TOKEN=$2
P12_PASS=$3
CSR_FILE=$4


curl_response=$(curl -k -X POST \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
--cert cat $P12_TOKEN | base64 | tr -d '\n':<$P12_PASS> \
--data '{"certificateRequest":"'$(cat $CSR_FILE | tr -d '\n' | sed 's/-----END.*CERTIFICATE-----/-----END CERTIFICATE-----/g' | sed 's/-----BEGIN.*CERTIFICATE-----/-----BEGIN CERTIFICATE-----/g')'"}' \
"$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/generateCertificate")

echo $curl_response
#certificate=$(echo $curl_response | jq -r '.certificate')

#echo $certificate > certificate.pem