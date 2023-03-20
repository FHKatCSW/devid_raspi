#!/bin/bash

# Usage
# bash /home/admin/devid_raspi/ishield/request_cert.sh "campuspki.germanywestcentral.cloudapp.azure.com" "/home/admin/fhk_hmi_setup_v3.p12" "foo123" "/home/admin/test_csr_setup_1.csr"

EJBCA_BASE_URL=$1
P12_TOKEN=$2
P12_PASS=$3
CSR_FILE=$4

cert_profile_name="DeviceIdentity-Raspberry"
ee_profile_name="KF-CS-EE-DeviceIdentity-Raspberry"
ca_name="KF-CS-HMI-2023-CA"
username="fhk_hmi_setup_v3"
enrollment_code="foo123"

csr=$(cat $CSR_FILE)
template='{"certificate_request":$csr, "certificate_profile_name":$cp, "end_entity_profile_name":$eep, "certificate_authority_name":$ca, "username":$ee, "password":$pwd}'
json_payload=$(jq -n \
    --arg csr "$csr" \
    --arg cp "$cert_profile_name" \
    --arg eep "$ee_profile_name" \
    --arg ca "$ca_name" \
    --arg ee "$username" \
    --arg pwd "$enrollment_code" \
    "$template")

escaped_payload=$(echo "$json_payload" | sed 's/"/\\"/g')

echo $escaped_payload

client_cert="$P12_TOKEN:$P12_PASS"

#curl_response=$(curl -X POST -s \
#    --cert-type P12 \
#    --cert "$client_cert" \
#    -H 'Content-Type: application/json' \
#    -H  "accept: application/json" \
#    --data "$json_payload" \
#    "https://$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll")


curl_response=$(curl -k \
    --cert-type P12 \
    --cert $client_cert \
    -X POST "https://$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll" \
    -H  "accept: application/json" \
    -H  "Content-Type: application/json" \
    -d "$escaped_payload")

echo
echo "Response:"
echo "$curl_response"