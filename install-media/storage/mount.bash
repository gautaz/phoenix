if [ ! -e /dev/mapper/pv ]; then
	cryptsetup open /dev/disk/by-label/pv pv
fi

if [ ! -e /dev/mapper/vg-system ]; then
	vgchange -a y vg
fi

mount -o compress=zstd,subvol=root /dev/mapper/vg-system /mnt
mkdir -p /mnt/{boot,home,nix}
mount /dev/disk/by-label/boot /mnt/boot
mount -o compress=zstd,subvol=home /dev/mapper/vg-system /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/mapper/vg-system /mnt/nix
