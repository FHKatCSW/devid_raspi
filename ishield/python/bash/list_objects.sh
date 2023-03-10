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
