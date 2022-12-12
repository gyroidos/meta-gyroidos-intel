inherit trustmegeneric
#
# Create an partitioned trustme image that can be dd'ed to the boot medium
#

do_uefi_bootpart[depends] += " \
    ${TRUSTME_GENERIC_DEPENDS} \
"

do_uefi_bootpart () {
	rm -fr ${TRUSTME_BOOTPART_DIR}

	if [ -z "${DEPLOY_DIR_IMAGE}" ];then
		bbfatal "Cannot get bitbake variable \"DEPLOY_DIR_IMAGE\""
		exit 1
	fi

	if [ -z "${TRUSTME_BOOTPART_DIR}" ];then
		bbfatal "Cannot get bitbake variable \"TRUSTME_BOOTPART_DIR\""
		exit 1
	fi

	if [ -z "${MACHINE}" ];then
		bbfatal "Cannot get bitbake variable \"MACHINE\""
		exit 1
	fi

	kernelbin="${DEPLOY_DIR_IMAGE}/cml-kernel/bzImage-initramfs-${MACHINE}.bin.signed"

	bbnote "Copying boot partition files to ${TRUSTME_BOOTPART_DIR}"

	machine=$(echo "${MACHINE}" | tr "_" "-")
	bbdebug 1 "Boot machine: $machine"

	install -d "${TRUSTME_BOOTPART_DIR}/EFI/BOOT/"
	install -d "${TRUSTME_IMAGE_OUT}"
	cp --dereference "${kernelbin}" "${TRUSTME_BOOTPART_DIR}/EFI/BOOT/BOOTX64.EFI"
	cp --dereference "${kernelbin}" "${TRUSTME_IMAGE_OUT}/cml-kernel.signed"
}


IMAGE_CMD:trustmex86 () {
	bbnote  "Using standard trustme partition"
	do_uefi_bootpart
	do_build_trustmeimage
}
