if [ ! -e /dev/mapper/system ]; then
	cryptsetup open /dev/disk/by-label/system system
fi

mount -o compress=zstd,subvol=root /dev/mapper/system /mnt
mkdir -p /mnt/{boot,home,nix,swap}
mount /dev/disk/by-label/boot /mnt/boot
mount -o compress=zstd,subvol=home /dev/mapper/system /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/mapper/system /mnt/nix
mount -o subvol=swap /dev/mapper/system /mnt/swap
