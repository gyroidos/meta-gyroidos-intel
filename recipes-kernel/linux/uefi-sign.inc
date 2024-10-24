DEPENDS += "sbsigntool-native"

inherit p11-signing

TEST_CERT_DIR = "${TOPDIR}/test_certificates"
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

	certpath="${SECURE_BOOT_SIG_CERT}"
	if is_pkcs11_uri ${SECURE_BOOT_SIG_CERT}; then
		certpath="${WORKDIR}/SECURE_BOOT_SIG_CERT.pem"
		extract_cert "${SECURE_BOOT_SIG_CERT}" $certpath
	fi

	if is_pkcs11_uri ${SECURE_BOOT_SIG_KEY}; then
		sbsign --engine pkcs11 --key "${SECURE_BOOT_SIG_KEY}" --cert "$certpath" --output "${kernelbin_signed}" "${kernelbin}"
	else
		sbsign --key "${SECURE_BOOT_SIG_KEY}" --cert "$certpath" --output "${kernelbin_signed}" "${kernelbin}"
	fi
}
