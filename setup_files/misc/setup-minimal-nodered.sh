#!/bin/bash

function header {
    echo "****"
    echo "$1"
    echo "****"
    echo
}

function warn {
    echo "!!!!"
    echo "$1"
    echo "!!!!"
    echo
}

username="$1"


if ! command -v git &> /dev/null; then
    echo "Install git"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install git
fi

if [[ ! -d "/home/$username/devid_raspi" ]]; then
    echo "Clone devid_raspi repository"
    git clone https://github.com/FHKatCSW/devid_raspi.git
fi

header Basic setup
bash /home/"$username"/devid_raspi/setup_files/01_setup_basic/setup-basic.sh

header Setup the iShield
bash /home/"$username"/devid_raspi/setup_files/02_setup_ishield/setup-ishield.sh

header Setup py-hsm
bash /home/"$username"/devid_raspi/setup_files/03_setup_pyhsm/setup-pyhsm.sh $username

header Setup Certificate Storage
bash /home/"$username"/devid_raspi/setup_files/05_setup_certificate_storage/setup-certificate-storgae.sh

header Setup p11tool
bash /home/"$username"/devid_raspi/setup_files/09_setup_p11tool/setup-p11tool.sh

header Setup NodeRed
bash /home/"$username"/devid_raspi/setup_files/11_setup_nodered/setup-nodered.sh

