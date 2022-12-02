usage() {
	echo "Set a device up for a further NixOS installation."
	echo "Usage: $(basename "$0") <device>"
	echo ""
	echo "device: The path of a block device file where the setup will occur"
	echo "WARNING: The process will entirely discard any data present on the device"
}

if [ $# -lt 1 ]; then
	echo "Missing block device argument."
	echo ""
	usage "$0"
	exit 10
fi

BLKDEV="$1"

if ! BLKENV="$(lsblk --bytes --pairs --paths "$BLKDEV" | grep -F "$BLKDEV")"; then
	echo ""
	usage "$0"
	exit 11
fi

eval "$BLKENV"

if [ "$NAME" != "$BLKDEV" ]; then
	echo "Targetting the wrong device ($NAME instead of $BLKDEV)."
	exit 20
fi

# NixOS minimal disk requirement is currently 8 GB
DEVICE_MIN_SIZE_GB=8
if [ "$SIZE" -lt "$((DEVICE_MIN_SIZE_GB*1024*1024*1024))" ]; then
	echo "Not enough space on $BLKDEV (at least $DEVICE_MIN_SIZE_GB GB are needed)."
	exit 11
fi

# Create a GPT partition table
parted "$BLKDEV" -- mklabel gpt

# Create the EFI boot partition
parted "$BLKDEV" -- mkpart ESP fat32 1MB 512MB
parted "$BLKDEV" -- set 1 esp on
mkfs.fat -F 32 -n boot "${BLKDEV}1"

# Create the encrypted system partition and open it (hence verify the password)
parted "$BLKDEV" -- mkpart primary 512MB 100%
cryptsetup --batch-mode --label=system luksFormat "${BLKDEV}2"
cryptsetup luksOpen /dev/disk/by-label/system system

# Create the Btrfs layout
mkfs.btrfs /dev/mapper/system
mount /dev/mapper/system /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/swap
umount /mnt

# Mount the target filesystems layout
mount -o compress=zstd,subvol=root /dev/mapper/system /mnt
mkdir /mnt/{boot,home,nix,swap}
mount /dev/disk/by-label/boot /mnt/boot
mount -o compress=zstd,subvol=home /dev/mapper/system /mnt/home
mount -o compress=zstd,noatime,subvol=nix /dev/mapper/system /mnt/nix
mount -o subvol=swap /dev/mapper/system /mnt/swap

# Create the swap file and enable swap
SWAPFILE=/mnt/swap/swapfile
truncate -s 0 "$SWAPFILE"
chattr +C "$SWAPFILE"
btrfs property set "$SWAPFILE" compression none
# /proc/meminfo kB is in fact kibibytes
# https://lore.kernel.org/lkml/CAHp75Vf__Cb2=TDQRF4R5q8bfAQev2-smcdEMWz32MvYjGnT0Q@mail.gmail.com/
dd if=/dev/zero of="$SWAPFILE" bs=1K count="$(awk '/MemTotal/{print $2}' /proc/meminfo)"
chmod 0600 "$SWAPFILE"
mkswap "$SWAPFILE"
swapon "$SWAPFILE"
