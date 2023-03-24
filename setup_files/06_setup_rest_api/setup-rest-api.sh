#!/bin/bash

# Set user
username="$1"

function service_instruction {
  echo "Service name: $1"
  echo "👍 Status: systemctl status $1.service"
  echo "📄 Logs: journalctl --unit=$1.service -n 100 --no-pager"
  echo "↩️ Restart: sudo systemctl restart $1.service"
}

pip install requests-pkcs12
pip install cryptography==38.0.4

# Set the working directory for the PyQt application
APP_WORKDIR="/home/$username/devid_api"

# Define service name
SERVICE_NAME="devid-api"

# Define the path to the systemd service file
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

# Define the path to the Flask app within the virtual environment
APP_PATH="/home/$username/devid_api/run.py"

# Define the IP address and port for the Flask app to run on
IP_ADDRESS="0.0.0.0"
PORT="5000"

# Install the requirements
pip install -r "$APP_WORKDIR/requirements.txt"

# Write the systemd service file
echo "[Unit]
Description=IEEE 802.1 AR REST API
After=network.target

[Service]
User=$username
Environment="FLASK_APP=run.py"
WorkingDirectory=$APP_WORKDIR
ExecStart=flask run --host=$IP_ADDRESS --port=$PORT
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# Reload the systemd daemon to read the new service file
sudo systemctl daemon-reload

# Start the devid API service
sudo systemctl start devid-api

# Enable the devid API service to start automatically on boot
sudo systemctl enable devid-api

service_instruction $SERVICE_NAME

echo "✅ REST API setup finished"


# -------------------------
# Additional commands
# -------------------------

# Show the last 100 logs
# journalctl --unit=devid-api.service -n 100 --no-pager

# Restart the service
# sudo systemctl restart devid-api.service

