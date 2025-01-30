MACHINE = "genericx86-64"

INITRAMFS_IMAGE_BUNDLE = "1"
INITRAMFS_IMAGE = "gyroidos-cml-initramfs"

IMAGE_FSTYPES = "cpio ext4"
GYROIDOS_FSTYPES = "wic wic.bmap"
GYROIDOS_PARTTABLE_TYPE = "gpt"
GYROIDOS_CONTAINER_ARCH = "qemux86-64"

GYROIDOS_HARDWARE = "x86"
GYROIDOS_LOGTTY = "tty11"

PKI_UEFI_KEYS = "y"

PACKAGE_CLASSES = "package_ipk"
BBMULTICONFIG = "container installer"

PREFERRED_PROVIDER_virtual/kernel:genericx86-64 ?= "linux-rolling-stable"
PREFERRED_PROVIDER_virtual/kernel:gyroidos-cml ?= "linux-rolling-stable"

INITRAMFS_MODULES = ""

INITRAMFS_MAXSIZE = "150000"

PACKAGE_INSTALL:append:pn-gyroidos-cml-initramfs = "${INITRAMFS_MODULES}"
PACKAGE_INSTALL:append:pn-gyroidos-installer-initramfs = "${INITRAMFS_MODULES}"

IMAGE_BOOT_FILES:genericx86-64 = "${KERNEL_DEPLOYSUBDIR}/bzImage-initramfs-${MACHINE}.bin.signed;EFI/BOOT/BOOTX64.EFI"
WKS_FILE:genericx86-64 = "gyroidos-cml.genericx86.wks.in"
