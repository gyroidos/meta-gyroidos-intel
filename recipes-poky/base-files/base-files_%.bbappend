FILESEXTRAPATHS_append := '${@bb.utils.contains("INITRAMFS_IMAGE", [ 'trustx-installer-initramfs' ], ":${THISDIR}/${PN}", "",d)}'
