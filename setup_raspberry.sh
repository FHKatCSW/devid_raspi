#!/bin/bash

function header {
    echo
    echo
    echo "⭐⭐⭐⭐⭐⭐"
    echo "$1"
    echo "⭐⭐⭐⭐⭐⭐"
    echo
    echo
}

function warn {
    echo
    echo "⚠️⚠️⚠️⚠️⚠️⚠️"
    echo "$1"
    echo "⚠️⚠️⚠️⚠️⚠️⚠️"
    echo
}

header Basic setup
sudo bash /home/"$USER"/devid_raspi/setup_files/01_setup_basic/setup-basic.sh

header Setup the iShield
sudo bash /home/"$USER"/devid_raspi/setup_files/02_setup_ishield/setup-ishield.sh

header Setup py-hsm
sudo bash /home/"$USER"/devid_raspi/setup_files/03_setup_pyhsm/setup-pyhsm.sh

header Setup HSM Log service
sudo bash /home/"$USER"/devid_raspi/setup_files/04_setup_hsm_log_service/setup-hsm-logger.sh

header Setup Certificate Storage
sudo bash /home/"$USER"/devid_raspi/setup_files/05_setup_certificate_storage/setup-certificate-storage.sh

header Setup REST API
sudo bash /home/"$USER"/devid_raspi/setup_files/06_setup_rest-api/setup-rest-api.sh

header Setup GUI
sudo bash /home/"$USER"/devid_raspi/setup_files/07_setup_gui/setup-gui.sh

warn This is the last step: Raspberry will reboot afterwards
header Setup Display
sudo bash /home/"$USER"/devid_raspi/setup_files/08_setup_display/setup-display.sh