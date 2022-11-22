#!/bin/sh

die() {
	echo "Failed installing secure boot key. Exit."
	exit 1
}

mount | grep efivarfs || mount -t efivarfs efivarfs /sys/firmware/efi/efivars

echo "Installing DB.esl ..."
efi-updatevar -e -f /usr/share/sbkeys/DB.esl db || die
efi-readvar -v db
echo "OK"

echo "Installing KEK.esl ..."
efi-updatevar -e -f /usr/share/sbkeys/KEK.esl KEK || die
efi-readvar -v KEK
echo "OK"

echo "Installing PK.auth ..."
efi-updatevar -f /usr/share/sbkeys/PK.auth PK || die
efi-readvar -v PK
echo "OK"

echo "Installed secure boot keys successfully"
