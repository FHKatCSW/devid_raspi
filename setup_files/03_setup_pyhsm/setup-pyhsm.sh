#!/bin/bash

#Clone the repository
git clone https://github.com/bentonstark/libhsm.git /home/$USER/libhsm/

# Build libhsm
cd /home/$USER/libhsm/build
./build_libhsm
sudo cp "/home/$USER/libhsm/build/libhsm.so" /usr/lib/libhsm.so

echo "✅ py-hsm setup finished"
