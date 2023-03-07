#!/bin/bash

function header {
    echo
    echo
    echo "-----------------------------------------------"
    echo "$1"
    echo "-----------------------------------------------"
    echo
}

header Basic setup
sudo ./setup_basic/setup-basic.sh

header Setup the iShield
sudo ./setup_ishield/setup-ishield.sh

header Setup py-hsm
sudo ./setup_pyhsm/setup-raspi-py-hsm.sh

header Setup HSM Log service
sudo ./setup_hsm_log_service/setup-hsm-logger.sh

header Setup Certificate Storage
sudo ./setup_certificate_storage/setup-certificate-storage.sh

header Setup REST API
sudo ./setup_rest-api/setup-rest-api.sh

header Setup GUI
sudo ./setup_gui/setup-gui.sh

header Setup Display
sudo ./setup_display/setup-display.sh