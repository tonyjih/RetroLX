#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# BATOCERA_BINARIES_DIR = batocera binaries sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
BATOCERA_BINARIES_DIR=$6

mkdir -p "${BATOCERA_BINARIES_DIR}/boot/packages" || exit 1
cp -r "${BUILD_DIR}"/repo/* "${BATOCERA_BINARIES_DIR}/boot/packages/" || exit 1

# Build Crust SCP firmware
#mkdir -p "${BATOCERA_BINARIES_DIR}/crust" || exit 1
#cp "${BOARD_DIR}/build-crust.sh" "${BATOCERA_BINARIES_DIR}/crust/" || exit 1
#cp "${BOARD_DIR}/crust/orangepi_one_plus_defconfig" "${BATOCERA_BINARIES_DIR}/crust/" || exit 1
#cd "${BATOCERA_BINARIES_DIR}/crust/" && ./build-crust.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

# Build U-Boot
mkdir -p "${BATOCERA_BINARIES_DIR}/uboot" || exit 1
cp "${BOARD_DIR}/build-uboot.sh" "${BATOCERA_BINARIES_DIR}/uboot/" || exit 1
cd "${BATOCERA_BINARIES_DIR}/uboot/" && ./build-uboot.sh "${HOST_DIR}" "${BOARD_DIR}" "${BINARIES_DIR}" || exit 1

# Create boot directories, copy boot files
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/boot"     || exit 1
mkdir -p "${BATOCERA_BINARIES_DIR}/boot/extlinux" || exit 1
cp "${BINARIES_DIR}/Image"                           "${BATOCERA_BINARIES_DIR}/boot/boot/linux"           || exit 1
cp "${BINARIES_DIR}/initrd.gz"                       "${BATOCERA_BINARIES_DIR}/boot/boot/initrd.gz"       || exit 1
cp "${BINARIES_DIR}/rootfs.squashfs"                 "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update" || exit 1
cp "${BINARIES_DIR}/modules"                         "${BATOCERA_BINARIES_DIR}/boot/boot/modules"         || exit 1
cp "${BINARIES_DIR}/sun50i-h6-orangepi-one-plus.dtb" "${BATOCERA_BINARIES_DIR}/boot/boot/"                || exit 1
cp "${BOARD_DIR}/boot/extlinux.conf"                 "${BATOCERA_BINARIES_DIR}/boot/extlinux/"            || exit 1

exit 0
