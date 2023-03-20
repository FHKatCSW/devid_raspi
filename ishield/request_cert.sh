#!/bin/bash

# Usage
# bash request_cert.sh "https://campuspki.germanywestcentral.cloudapp.azure.com" "foo123" "/home/admin/raspi_auth_v1.p12" "/home/admin/setup_test_3.csr"

EJBCA_BASE_URL=$1
P12_TOKEN=$2
P12_PASS=$3
CSR_FILE=$4

cert_profile_name="DeviceIdentity-Raspberry"
ee_profile_name="KF-CS-EE-DeviceIdentity-Raspberry"
ca_name="KF-CS-HMI-2023-CA"
username="setup_test"
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


curl -X POST -s \
    --cert-type P12 \
    --cert "$P12_TOKEN:$P12_PASS" \
    -H 'Content-Type: application/json' \
    --data "$json_payload" \
    "https://$EJBCA_BASE_URL/ejbca/ejbca-rest-api/v1/certificate/pkcs10enroll" \
    | jq .

