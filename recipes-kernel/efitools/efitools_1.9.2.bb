require efitools-common.inc

SRC_URI[md5sum] = "f2da7eb801f6965b19d61ca3341f9ecb"
SRC_URI[sha256sum] = "f4ece634a498bde73dc23d1aab1171a07b64718bd47f167240a7db4049e729b4"

DEPENDS = "gnu-efi openssl"

INSANE_SKIP:${PN} = "ldflags"

BINARIES = "\
	efi-keytool \
	efi-readvar \
	efi-updatevar \
"

INCLUDES = "\
	-I${S}/include \
	-I${STAGING_INCDIR} \
	-I${STAGING_INCDIR}/efi \
	-I${STAGING_INCDIR}/efi/${TARGET_ARCH} \
	-I${STAGING_INCDIR}/efi/protocol \
"

COMPILE_CFLAGS += "-D_XOPEN_SOURCE"
COMPILE_CFLAGS += "-DEFI_WARN_UNKOWN_GLYPH=EFI_WARN_UNKNOWN_GLYPH"

# overwrite compiler and compiler flags in makefile
EXTRA_OEMAKE = "\
        'CC = ${CC} -L ${STAGING_LIBDIR}' \
        'LD = ${LD}' \
	'INCDIR = ${INCLUDES}' \
"

do_compile() {
	oe_runmake ${BINARIES}
}

do_install () {
	install -d ${D}${bindir}
	for bin in ${BINARIES}; do
		install ${S}/${bin} ${D}${bindir}
	done
}
