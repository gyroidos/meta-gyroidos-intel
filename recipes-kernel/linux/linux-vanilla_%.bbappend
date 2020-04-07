COMPATIBLE_MACHINE = "${MACHINE}"

SRC_URI += " \
    file://trustx-intel.cfg \
    file://qemu.cfg \
"

FILESEXTRAPATHS_prepend := "${THISDIR}/generic:"
