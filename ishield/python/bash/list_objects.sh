#!/bin/bash

# Check if all required arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <library_path> <slot_num> <pin>"
    exit 1
fi

# Parse the arguments
LIBRARY_PATH="$1"
SLOT_NUM="$2"
PIN="$3"

# Run the HSM command and capture the output
OUTPUT=$(pkcs11-tool --module "$LIBRARY_PATH" --slot "$SLOT_NUM" --login --pin "$PIN" --list-objects)


echo "$OUTPUT"

# Extract the object list from the output and convert it to JSON
OBJECT_LIST=$(echo "$OUTPUT" | awk '/Object {/{flag=1; next} /CKA_LABEL/{flag=0} flag')
JSON=$(echo "$OBJECT_LIST" | awk '{gsub(/^[[:space:]]+|[[:space:]]+$/, ""); gsub(/\\x/,"\\\\x"); print}' | jq -R 'split("\n")[:-1] | map(split(": ")) | [.[0], (.[1:] | join(": "))] | from_entries')

# Output the JSON-encoded object list
echo "$JSON"