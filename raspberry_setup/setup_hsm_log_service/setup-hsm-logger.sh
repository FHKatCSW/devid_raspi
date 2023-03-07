#!/bin/bash

# Create systemd service file
cat <<EOF | sudo tee /etc/systemd/system/hsm-logger.service
[Unit]
Description=HSM Communication Logger

[Service]
ExecStart=/usr/local/bin/hsm-logger.sh

[Install]
WantedBy=multi-user.target
EOF

# Create logger script
cat <<EOF | sudo tee /usr/local/bin/hsm-logger.sh
#!/bin/bash

LOG_FILE="/var/log/hsm.log"

# Create log file if it doesn't exist
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Monitor communication to HSM and write to log file
while true; do
    socat -x /dev/hsm >> "$LOG_FILE" 2>&1
done
EOF

# Make logger script executable
sudo chmod +x /usr/local/bin/hsm-logger.sh

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable and start service
sudo systemctl enable hsm-logger.service
sudo systemctl start hsm-logger.service

echo "HSM communication logger service has been set up."
