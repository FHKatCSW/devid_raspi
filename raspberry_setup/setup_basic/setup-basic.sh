#!/bin/bash

# update and upgrade the device
sudo apt-get update && sudo apt-get upgrade -y

# install relevant packages
sudo apt install libpcsclite-dev pcscd pcsc-tools libssl-dev libengine-pkcs11-openssl autoconf libtool openssl git -y

# Clone the devid_api repository
git clone https://github.com/FHKatCSW/devid_api.git