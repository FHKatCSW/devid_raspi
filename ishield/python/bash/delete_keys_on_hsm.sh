#!/bin/bash

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]]; then
  echo "$1; $2; $3; $4"
  echo "Usage: $0 <priv|pub> [-i <id>|-l <label>] <pin>"
  exit 1
fi

key_type="$1"
id=""
label=""

shift

while getopts ":i:l:" opt; do
  case ${opt} in
    i)
      id="$OPTARG"
      ;;
    l)
      label="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

if [[ -z "$id" ]] && [[ -z "$label" ]]; then
  echo "Please specify either an ID or a label."
  exit 1
elif [[ -n "$id" ]] && [[ -n "$label" ]]; then
  echo "Please specify either an ID or a label, not both."
  exit 1
fi

echo "key_type = $key_type"
echo "id = $id"
echo "label = $label"

PKCS11_TOOL=/usr/bin/pkcs11-tool

if [[ -n "$id" ]]; then
  $PKCS11_TOOL --delete-object --type "$key_type"key --id=$id --login --pin $3
else
  $PKCS11_TOOL --delete-object --type "$key_type"key --label "$label" --login --pin $3
fi