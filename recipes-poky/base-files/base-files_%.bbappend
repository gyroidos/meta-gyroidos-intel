FILESEXTRAPATHS:append := '${@bb.utils.contains("INITRAMFS_IMAGE", [ 'gyroidos-installer-initramfs' ], ":${THISDIR}/${PN}", "",d)}'
