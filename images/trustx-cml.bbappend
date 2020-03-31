inherit trustmex86

##### provide a tarball for cml update
include images/trustx-signing.inc

GUESTS_OUT = "${DEPLOY_DIR_IMAGE}/cml_updates"
CLEAN_GUEST_OUT = ""
OS_NAME = "kernel"
UPDATE_OUT="${GUESTS_OUT}/${OS_NAME}-${TRUSTME_VERSION}"

do_sign_guestos_prepend () {
	mkdir -p "${UPDATE_OUT}"
	cp "${DEPLOY_DIR_IMAGE}/cml-kernel/bzImage-initramfs-${MACHINE}.bin.signed" "${UPDATE_OUT}/kernel.img"
	cp "${DEPLOY_DIR_IMAGE}/trustx-cml-firmware-${MACHINE}.squashfs" "${UPDATE_OUT}/firmware.img"
	cp "${DEPLOY_DIR_IMAGE}/cml-kernel/modules-${MODULE_TARBALL_LINK_NAME}.squashfs" "${UPDATE_OUT}/modules.img"
}

do_sign_guestos_append () {
	tar cf "${UPDATE_OUT}.tar" -C "${GUESTS_OUT}" \
		"${OS_NAME}-${TRUSTME_VERSION}" \
		"${OS_NAME}-${TRUSTME_VERSION}.conf" \
		"${OS_NAME}-${TRUSTME_VERSION}.sig" \
		"${OS_NAME}-${TRUSTME_VERSION}.cert"
}
