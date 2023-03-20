#!/bin/bash

# Usage:
# bash /home/admin/devid_raspi/ishield/python/bash/list_objects.sh "0" "1234"

# Check if all required arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <slot_num> <pin>"
    exit 1
fi

# Parse the arguments
SLOT_NUM="$1"
PIN="$2"
PKCS11_MODULE=/usr/lib/opensc-pkcs11.so


# Run the HSM command and capture the output
OUTPUT=$(pkcs11-tool --module PKCS11_MODULE --slot "$SLOT_NUM" --login --pin "$PIN" --list-objects)

echo "$OUTPUT"
