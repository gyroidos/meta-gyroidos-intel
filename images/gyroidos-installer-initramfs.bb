DECRIPTION = "Minimal initramfs-based root file system for CML"

PACKAGE_INSTALL = "\
	packagegroup-core-boot \
	${VIRTUAL-RUNTIME_base-utils} \
	udev \
	base-passwd \
	shadow \
	mingetty \
	cmld \
	service-static \
	control \
	scd \
	strace \
	iptables \
	ibmtss2 \
	tpm2d \
	rattestation \
	stunnel \
	openssl-tpm2-engine \
	e2fsprogs-resize2fs \
	e2fsprogs-mke2fs \
	e2fsprogs-e2fsck \
	kvmtool \
	${ROOTFS_BOOTSTRAP_INSTALL} \
	installer-boot \
	util-linux \
	util-linux-uuidgen \
	gptfdisk \
	parted \
	util-linux-sfdisk \
	dosfstools \
	installer-keytool \
"

IMAGE_LINUGUAS = " "

LICENSE = "GPL-2.0-only"

IMAGE_FEATURES = ""

export IMAGE_BASENAME = "gyroidos-installer-initramfs"
IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
inherit image

IMAGE_FEATURES:remove = "package-management"

IMAGE_ROOTFS_SIZE = "4096"

KERNELVERSION="$(cat "${STAGING_KERNEL_BUILDDIR}/kernel-abiversion")"

update_inittab () {
    sed -i "/ttyS[[:digit:]]\+/d" ${IMAGE_ROOTFS}/etc/inittab

    echo "tty1::respawn:${base_sbindir}/mingetty --autologin root tty1" >> ${IMAGE_ROOTFS}/etc/inittab
    mkdir -p ${IMAGE_ROOTFS}/dev
    mknod -m 622 ${IMAGE_ROOTFS}/dev/console c 5 1
    mknod -m 622 ${IMAGE_ROOTFS}/dev/tty1 c 4 1
}

update_modules_dep () {
	sh -c 'cd "${IMAGE_ROOTFS}" && depmod --basedir "${IMAGE_ROOTFS}" --config "${IMAGE_ROOTFS}/etc/depmod.d" ${KERNELVERSION}'
}

ROOTFS_POSTPROCESS_COMMAND:append = " update_modules_dep; "

# For debug purpose allow login if debug-tweaks is set in local.conf
ROOTFS_POSTPROCESS_COMMAND:append = '${@bb.utils.contains_any("EXTRA_IMAGE_FEATURES", [ 'debug-tweaks' ], " update_inittab ; ", "",d)}'

inherit extrausers
# password for root is 'root'
EXTRA_USERS_PARAMS = '${@bb.utils.contains_any("EXTRA_IMAGE_FEATURES", [ 'debug-tweaks' ], "usermod -p '\\$1\\$1234\\$XJI6P4bccABjEC1v6k64V1' root; ", "",d)}'
