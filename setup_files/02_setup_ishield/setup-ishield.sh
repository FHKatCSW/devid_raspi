#!/bin/bash

# Load OpenSC
sudo wget https://github.com/swissbit-eis/OpenSC/archive/refs/tags/0.23.0-swissbit.tar.gz

# Bootstrap OpenSC
tar -xf 0.23.0-swissbit.tar.gz
cd OpenSC-0.23.0-swissbit/
sudo ./bootstrap
./configure --prefix=/usr
sudo make -j4 install

# Check status of the service
systemctl status pcscd

# Detect the location of the openssl configuration file
OPENSSL_CONF=$(openssl version -d | awk '{print $NF}' | tr -d '"')/openssl.cnf

# Add content to the beginning of the openssl configuration file
sed -e '1i\
# CUSTOM Confirguration for iShield
openssl_conf = openssl_init
' <OPENSSL_CONF

# Add content to the end of the openssl configuration file
sed -i -e '$a
# CUSTOM Confirguration for iShield
[openssl_init]
engines = engine_section

[engine_section]
pkcs11 = pkcs11_section

[pkcs11_section]
engine_id = pkcs11
MODULE_PATH = /usr/lib/opensc-pkcs11.so
init = 0
' OPENSSL_CONF

echo "✅ iShield setup finished"