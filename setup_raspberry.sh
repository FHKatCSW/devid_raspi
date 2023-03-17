#!/bin/bash

function header {
    echo "⭐ ⭐ ⭐"
    echo "$1"
    echo
}

function warn {
    echo "⚠️ ⚠️ ⚠ "
    echo "$1"
    echo
}

echo "SUDO_USER: $SUDO_USER"

if ! command -v git &> /dev/null; then
    echo "Install git"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install git
fi

if [[ ! -d "/home/$SUDO_USER/devid_raspi" ]]; then
    echo "Clone devid_raspi repository"
    git clone https://github.com/FHKatCSW/devid_raspi.git
fi

header Basic setup
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/01_setup_basic/setup-basic.sh

header Setup the iShield
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/02_setup_ishield/setup-ishield.sh

header Setup py-hsm
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/03_setup_pyhsm/setup-pyhsm.sh

header Setup HSM Log service
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/04_setup_hsm_log_service/setup-hsm-logger.sh

header Setup Certificate Storage
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/05_setup_certificate_storage/setup-certificate-storgae.sh

header Setup REST API
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/06_setup_rest_api/setup-rest-api.sh

header Setup GUI
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/07_setup_gui/setup-gui.sh

warn This is the last step: Raspberry will reboot afterwards
header Setup Display
sudo bash /home/"$SUDO_USER"/devid_raspi/setup_files/08_setup_display/setup-display.sh