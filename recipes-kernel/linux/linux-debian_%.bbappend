COMPATIBLE_MACHINE = "${MACHINE}"

SRC_URI += " \
	file://defconfig \
	file://gyroidos-intel.cfg \
	file://qemu.cfg \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-debian:${THISDIR}/generic:"

#KBUILD_DEFCONFIG:genericx86-64 := "${THISDIR}/generic/defconfig"

require uefi-sign.inc
