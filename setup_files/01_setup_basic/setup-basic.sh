#!/bin/bash

# curl -sSL https://raw.githubusercontent.com/FHKatCSW/devid_raspi/main/raspberry_setup/setup_basic/setup-basic.sh | bash


# update and upgrade the device
sudo apt-get update && sudo apt-get upgrade -y

# install relevant packages
sudo apt install libpcsclite-dev pcscd pcsc-tools libssl-dev libengine-pkcs11-openssl autoconf libtool openssl git python3-venv -y

# Upgrade pip
sudo python3 -m pip install --upgrade pip

# Clone the devid_api repository
git clone https://github.com/FHKatCSW/devid_api.git
git clone https://github.com/FHKatCSW/devid_raspi.git
git clone https://github.com/FHKatCSW/devid_nameplate.git

echo "✅ basic setup finished"