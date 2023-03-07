#!/bin/bash

# Define the path to the virtual environment
VENV_PATH="/home/admin/devid_api/env"

# Activate the virtual environment
source "$VENV_PATH/bin/activate"

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/admin/devid_api/run.py"

# Define the name of the Flask app module
APP_MODULE="app"

# Define the IP address and port for the Flask app to run on
IP_ADDRESS="0.0.0.0"
PORT="5000"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/flask-api.service"

# Write the systemd service file
echo "[Unit]
Description=Flask API

[Service]
User=root
Group=root
WorkingDirectory=$APP_PATH
Environment=\"PATH=$VENV_PATH/bin\"
ExecStart=$VENV_PATH/bin/gunicorn $APP_MODULE:app -b $IP_ADDRESS:$PORT --log-file /var/log/flask-api.log
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Reload the systemd daemon to read the new service file
sudo systemctl daemon-reload

# Start the Flask API service
sudo systemctl start flask-api

# Enable the Flask API service to start automatically on boot
sudo systemctl enable flask-api