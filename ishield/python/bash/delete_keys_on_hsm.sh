#!/bin/bash

if [[ -z "$1" ]] || [[ -z "$2" ]] || [[ -z "$3" ]] || [[ -z "$4" ]]; then
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

p11tool --delete-object --type "$key_type"key --id "$id" --label "$label" --login --pin "$1"
