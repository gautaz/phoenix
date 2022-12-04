#!/usr/bin/env sh

nim_mount() {
	local mountpoint="$1"
	modprobe nbd max_part=8
	qemu-nbd --connect=/dev/nbd0 ./disk.qcow2
	cryptsetup open /dev/nbd0p2 nim_test_luks
	mount -o compress=zstd,subvol=root /dev/mapper/nim_test_luks "$mountpoint"
	mount /dev/nbd0p1 "$mountpoint/boot"
	mount -o compress=zstd,subvol=home /dev/mapper/nim_test_luks "$mountpoint/home"
	mount -o compress=zstd,noatime,subvol=nix /dev/mapper/nim_test_luks "$mountpoint/nix"
	mount -o subvol=swap /dev/mapper/nim_test_luks "$mountpoint/swap"
}

nim_umount() {
	local mountpoint="$1"
	umount --recursive "$mountpoint"
	cryptsetup close nim_test_luks
	qemu-nbd --disconnect /dev/nbd0
	sleep 0.1
	rmmod nbd
}

if [ $UID != 0 ]; then
	echo "Needs root permissions to operate, use sudo."
	exit 10;
fi

if [ $# -lt 1 ]; then
	echo "A mountpoint is required as the only argument."
	exit 10;
fi

case "$(basename "$0")" in
	nimMount)
		nim_mount "$@"
		;;
	nimUmount)
		nim_umount "$@"
		;;
	*)
		echo "Unknown command: $0"
		echo "Known commands are nimMount and nimUmount."
		exit 10;
		;;
esac
