#!/bin/bash

# Install PyQT library
sudo apt-get install python3-pyqt5 -y

# Make the PyQT application file executable
chmod +x /home/pi/pyqt_application.py

# Create a systemd service for the PyQT application
sudo cat <<EOT > /etc/systemd/system/pyqt_application.service
[Unit]
Description=PyQT Application

[Service]
User=pi
ExecStart=/usr/bin/python3 /home/pi/pyqt_application.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd and start the PyQT application service
sudo systemctl daemon-reload
sudo systemctl start pyqt_application.service

# Enable the PyQT application service to start on boot
sudo systemctl enable pyqt_application.service