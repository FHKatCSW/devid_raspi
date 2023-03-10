#!/bin/bash

#Clone the repository
git clone https://github.com/bentonstark/libhsm.git /home/$SUDO_USER/libhsm/

# Build libhsm
cd /home/$SUDO_USER/libhsm/build
./build_libhsm
sudo cp "/home/$SUDO_USER/libhsm/build/libhsm.so" /usr/lib/libhsm.so

echo "py-hsm has been set up."
