#!/bin/bash

usage() {
    echo "Usage: $0 --id=<ID> --label=<LABEL> --pin=<PIN> --cert=<CERTIFICATE>"
    exit 1
}

# Parse named arguments
for i in "$@"
do
case $i in
    --id=*)
    ID="${i#*=}"
    shift # past argument=value
    ;;
    --label=*)
    LABEL="${i#*=}"
    shift # past argument=value
    ;;
    --pin=*)
    PIN="${i#*=}"
    shift # past argument=value
    ;;
    --cert=*)
    CERT="${i#*=}"
    shift # past argument=value
    ;;
    *)
    usage
    ;;
esac
done

# Check that mandatory arguments are present
if [ -z "$ID" ] || [ -z "$LABEL" ] || [ -z "$PIN" ] || [ -z "$CERT" ]
then
    usage
fi

# Set the path to the pkcs11-tool and the PKCS#11 module
PKCS11_TOOL=/usr/bin/pkcs11-tool
PKCS11_MODULE=/usr/lib/opensc-pkcs11.so

# Import the device certificate
$PKCS11_TOOL --module $PKCS11_MODULE --write-object $CERT --type cert --id $ID --label $LABEL --login --pin $PIN
