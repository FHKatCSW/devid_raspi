#!/bin/bash

# Usage
# bash transfer_auth_token.sh "hmipidev15.local" "admin" ".token/raspi_auth_v1.p12"

HOSTNAME=$1
USERNAME=$2
FILENAME=$3

scp $FILENAME $USERNAME@$HOSTNAME:/home/$USERNAME