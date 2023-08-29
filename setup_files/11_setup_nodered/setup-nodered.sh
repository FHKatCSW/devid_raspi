#!/bin/bash

apt install nodejs npm
npm install -g --unsafe-perm node-red

# Create the node-red.service file
cat <<EOT > /etc/systemd/system/node-red.service
[Unit]
Description=Node-RED
After=syslog.target network.target

[Service]
ExecStart=/usr/bin/node-red-pi --max-old-space-size=128 -v
Restart=on-failure
KillSignal=SIGINT

[Install]
WantedBy=multi-user.target
EOT

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the Node-RED service
sudo systemctl enable node-red.service
sudo systemctl start node-red.service

echo "Node-RED service setup completed."