DEPENDS += "sbsigntool-native"

TEST_CERT_DIR = "${TOPDIR}/test_certificates"
SECURE_BOOT_SIGNING_KEY = "${TEST_CERT_DIR}/ssig_subca.key"
SECURE_BOOT_SIGNING_CERT = "${TEST_CERT_DIR}/ssig_subca.cert"
KERNEL_DEPLOYSUBDIR ?= "cml-kernel"

do_deploy:append () {
	kernelbin="${DEPLOYDIR}/${KERNEL_DEPLOYSUBDIR}/bzImage-initramfs-${MACHINE}.bin"
	if [ ${INITRAMFS_IMAGE_BUNDLE} != "1" ]; then
		kernelbin="${DEPLOYDIR}/${KERNEL_DEPLOYSUBDIR}/bzImage-${MACHINE}.bin"
	fi
	kernelbin_signed="${kernelbin}.signed"
	if [ -L "${kernelbin}" ]; then
		link=`readlink "${kernelbin}"`
		ln -sf ${link}.signed ${kernelbin}.signed
	fi

	sbsign --key "${SECURE_BOOT_SIGNING_KEY}" --cert "${SECURE_BOOT_SIGNING_CERT}" --output "${kernelbin_signed}" "${kernelbin}"
}
