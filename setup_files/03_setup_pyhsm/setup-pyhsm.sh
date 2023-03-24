#!/bin/bash

# Set user
username="$1"

#Clone the repository
git clone https://github.com/bentonstark/libhsm.git

cp -r ./libhsm /home/$username/

# Build libhsm
cd /home/$username/libhsm/build
./build_libhsm
sudo cp "/home/$username/libhsm/build/libhsm.so" /usr/lib/libhsm.so

echo "✅ py-hsm setup finished"
