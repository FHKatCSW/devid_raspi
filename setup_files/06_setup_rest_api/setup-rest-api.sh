#!/bin/bash

# Define the path to the virtual environment
VENV_PATH="/home/$SUDO_USER/devid_api/env"

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/$SUDO_USER/devid_api/run.py"

# Define the name of the Flask app module
APP_MODULE="app"

# Define the IP address and port for the Flask app to run on
IP_ADDRESS="0.0.0.0"
PORT="5000"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/devid-api.service"

# Write the systemd service file
echo "[Unit]
Description=Flask API

[Service]
User=$SUDO_USER
WorkingDirectory=$APP_PATH
Environment=\"PATH=$VENV_PATH/bin\"
ExecStart=$VENV_PATH/bin/gunicorn $APP_MODULE:app -b $IP_ADDRESS:$PORT --log-file /var/log/devid-api.log
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Reload the systemd daemon to read the new service file
sudo systemctl daemon-reload

# Start the devid API service
sudo systemctl start devid-api

# Enable the devid API service to start automatically on boot
sudo systemctl enable devid-api