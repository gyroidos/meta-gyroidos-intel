DEPENDS += "sbsigntool-native"

inherit p11-signing

TEST_CERT_DIR = "${TOPDIR}/test_certificates"
SECURE_BOOT_SIGNING_KEY ?= "${KERNEL_MODULE_SIG_KEY}"
SECURE_BOOT_SIGNING_CERT ?= "${STAGING_KERNEL_BUILDDIR}/certs/signing_key.x509"
SBSIGN_CMD = 'sbsign --key "${SECURE_BOOT_SIGNING_KEY}" --cert "${SECURE_BOOT_SIGNING_CERT}.pem" --output "${kernelbin_signed}" "${kernelbin}"'
SBSIGN_CMD:pkcs11-sign = 'sbsign --engine pkcs11 --key "${SECURE_BOOT_SIGNING_KEY}" --cert "${SECURE_BOOT_SIGNING_CERT}.pem" --output "${kernelbin_signed}" "${kernelbin}"'
KERNEL_DEPLOYSUBDIR ?= "cml-kernel"

do_deploy:prepend () {
        openssl x509 -in ${SECURE_BOOT_SIGNING_CERT} -outform PEM -out ${SECURE_BOOT_SIGNING_CERT}.pem
}

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

	${SBSIGN_CMD}
}
