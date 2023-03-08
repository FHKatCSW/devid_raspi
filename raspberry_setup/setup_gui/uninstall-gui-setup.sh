#!/bin/bash

# Delete a service
sudo systemctl stop pyqt_application.service
sudo systemctl disable pyqt_application.service
sudo rm /etc/systemd/system/pyqt_application.service
sudo rm /etc/systemd/system/pyqt_application.service
sudo rm /usr/lib/systemd/system/pyqt_application.service
sudo rm /usr/lib/systemd/system/pyqt_application.service
sudo systemctl daemon-reload
sudo systemctl reset-failed