#!/bin/bash


# Set the working directory for the PyQt application
APP_WORKDIR="/home/admin/devid_nameplate"

# Install the requirements
pip install -r "$APP_WORKDIR/requirements.txt"
# pip install -r "/home/admin/devid_nameplate/requirements.txt"

# Freeze the requirements
#pip freeze > requirements.txt


# Define the path to the Flask app within the virtual environment
APP_PATH="/home/admin/devid_nameplate/run.py"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/pyqt_application.service"

echo "[Unit]
Description=IEEE 802.1 AR GUI
After=graphical.target

[Service]
WorkingDirectory=$APP_WORKDIR
Environment="DISPLAY=:0.0"
ExecStart=/usr/bin/python $APP_PATH
Restart=always

[Install]
WantedBy=graphical.target" | sudo tee $SERVICE_FILE


# Reload systemd and start the PyQT application service
sudo systemctl daemon-reload
sudo systemctl start pyqt_application.service

# Enable the PyQT application service to start on boot
sudo systemctl enable pyqt_application.service


# -------------------------
# Additional commands
# -------------------------

# Show the last 100 logs
# journalctl --unit=pyqt_application.service -n 100 --no-pager

