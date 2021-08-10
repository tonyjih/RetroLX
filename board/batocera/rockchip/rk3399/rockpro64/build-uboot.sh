#!/bin/bash

# ARM Trusted Firmware BL31
export BL31="/rk3399/images/bl31.elf"
# Crust firmware (optional)
export SCP="/dev/null"

# Clone U-Boot mainline
git clone --depth 1 https://source.denx.de/u-boot/u-boot.git -b v2021.07
cd u-boot

# Make config
make rockpro64-rk3399_defconfig

# Build it
ARCH=aarch64 CROSS_COMPILE=/rk3399/host/bin/aarch64-buildroot-linux-gnu- make -j$(nproc)
mkdir -p ../../uboot-rockpro64

# Copy to appropriate place
cp idbloader.img ../../uboot-rockpro64/
cp u-boot.itb ../../uboot-rockpro64/
