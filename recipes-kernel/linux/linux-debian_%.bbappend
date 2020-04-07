COMPATIBLE_MACHINE = "${MACHINE}"

SRC_URI += " \
	file://defconfig \
	file://trustx-intel.cfg \
	file://qemu.cfg \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-debian:${THISDIR}/generic:"

#KBUILD_DEFCONFIG_genericx86-64 := "${THISDIR}/generic/defconfig"
