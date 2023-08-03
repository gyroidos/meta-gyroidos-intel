inherit trustmex86

##### provide a tarball for cml update
include images/trustx-signing.inc
do_sign_guestos[depends] += " \
    ${TRUSTME_GENERIC_DEPENDS} \
"
deltask do_sign_guestos
addtask do_sign_guestos after do_image before do_image_trustmex86

GUESTS_OUT = "${B}/cml_updates"
CLEAN_GUEST_OUT = ""
OS_NAME = "kernel"
UPDATE_OUT_GENERIC="${GUESTS_OUT}/${OS_NAME}"
UPDATE_OUT="${UPDATE_OUT_GENERIC}-${TRUSTME_VERSION}"
UPDATE_FILES="${UPDATE_OUT_GENERIC} ${UPDATE_OUT_GENERIC}.conf ${UPDATE_OUT_GENERIC}.sig ${UPDATE_OUT_GENERIC}.cert"

do_sign_guestos:prepend () {
	mkdir -p "${UPDATE_OUT}"
	cp "${DEPLOY_DIR_IMAGE}/cml-kernel/bzImage-initramfs-${MACHINE}.bin.signed" "${UPDATE_OUT}/kernel.img"
	cp "${DEPLOY_DIR_IMAGE}/trustx-cml-firmware-${MACHINE}.squashfs" "${UPDATE_OUT}/firmware.img"
	cp "${DEPLOY_DIR_IMAGE}/trustx-cml-modules-${MACHINE}.squashfs" "${UPDATE_OUT}/modules.img"
}

do_sign_guestos:append () {
	tar cf "${UPDATE_OUT}.tar" -C "${GUESTS_OUT}" \
		"${OS_NAME}-${TRUSTME_VERSION}" \
		"${OS_NAME}-${TRUSTME_VERSION}.conf" \
		"${OS_NAME}-${TRUSTME_VERSION}.sig" \
		"${OS_NAME}-${TRUSTME_VERSION}.cert"

	ln -sf "$(basename ${UPDATE_OUT})" "${UPDATE_OUT_GENERIC}"
	ln -sf "$(basename ${UPDATE_OUT}.conf)" "${UPDATE_OUT_GENERIC}.conf"
	ln -sf "$(basename ${UPDATE_OUT}.cert)" "${UPDATE_OUT_GENERIC}.cert"
	ln -sf "$(basename ${UPDATE_OUT}.sig)" "${UPDATE_OUT_GENERIC}.sig"
}

OS_CONFIG_IN := "${THISDIR}/${PN}/${OS_NAME}.conf"
OS_CONFIG = "${WORKDIR}/${OS_NAME}.conf"
prepare_kernel_conf () {
    cp "${OS_CONFIG_IN}" "${OS_CONFIG}"
}
IMAGE_PREPROCESS_COMMAND:append = " prepare_kernel_conf;"
