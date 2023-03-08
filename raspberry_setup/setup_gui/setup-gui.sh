#!/bin/bash

# Define the path to the virtual environment
VENV_PATH="/home/admin/devid_nameplate/nameplate_env"


# create a new virtual environment
python -m venv $VENV_PATH

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Install the requirements
pip install -r requirements.txt

# Freeze the requirements
pip freeze > requirements.txt

# Deactivate the virtual environment
deactivate

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/admin/devid_nameplate/run.py"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/pyqt_application.service"

# Set the working directory for the PyQt application
APP_WORKDIR="/home/admin/devid_nameplate"

echo "[Unit]
Description=IEEE 802.1 AR GUI

[Service]
User=root
Group=root
WorkingDirectory=$APP_WORKDIR
Environment="PATH=$VENV_PATH/bin"
ExecStart=$VENV_PATH/bin/python $APP_PATH
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE


# Reload systemd and start the PyQT application service
sudo systemctl daemon-reload
sudo systemctl start pyqt_application.service

# Enable the PyQT application service to start on boot
sudo systemctl enable pyqt_application.service

# journalctl --unit=pyqt_application.service -n 100 --no-pager