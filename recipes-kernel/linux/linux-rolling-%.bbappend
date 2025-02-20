COMPATIBLE_MACHINE = "${MACHINE}"

SRC_URI += " \
    file://gyroidos-intel.cfg \
    file://qemu.cfg \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/generic:"

require uefi-sign.inc
