usage() {
	echo "Set a device up for a further NixOS installation."
	echo "Usage: $(basename "$0") <device>"
	echo ""
	echo "device: The path of a block device file where the setup will occur"
	echo "WARNING: The process will entirely discard any data present on the device"
}

waitfor() {
	while [ ! -e "$1" ]; do sleep 0.5; done
}

if [ $# -lt 1 ]; then
	echo "Missing block device argument."
	echo ""
	usage "$0"
	exit 10
fi

BLKDEV="$1"

if ! BLKDEV_SIZE="$(lsblk --bytes --json --paths "$BLKDEV" | jq ".blockdevices[] | select(.name == \"$BLKDEV\") | .size")"; then
	echo ""
	usage "$0"
	exit 11
fi

if [ -z "$BLKDEV_SIZE" ]; then
	echo "Unable to retrieve $BLKDEV size"
	exit 11
fi

# NixOS minimal disk requirement is currently 8 GiB
# (actually 8GB but as 8 Gib > 8 GB, it also fits the bill)
DEVICE_MIN_SIZE_GiB=8
if [ "$BLKDEV_SIZE" -lt "$((DEVICE_MIN_SIZE_GiB*1024*1024*1024))" ]; then
	echo "Not enough space on $BLKDEV (at least $DEVICE_MIN_SIZE_GiB GiB are needed)."
	exit 11
fi

# Create a GPT partition table
parted "$BLKDEV" -- mklabel gpt

# Create the EFI boot partition
parted "$BLKDEV" -- mkpart ESP fat32 1MiB 512MiB
parted "$BLKDEV" -- set 1 esp on
mkfs.fat -F 32 -n boot "${BLKDEV}1"

# Create the encrypted system partition and open it (hence verify the password)
parted "$BLKDEV" -- mkpart primary 512MiB 100%
cryptsetup --batch-mode --label=system luksFormat "${BLKDEV}2"
waitfor /dev/disk/by-label/system
cryptsetup open /dev/disk/by-label/system system

# Create the Btrfs layout
mkfs.btrfs /dev/mapper/system
mount /dev/mapper/system /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/swap

# Create the swap file
SWAPFILE=/mnt/swap/swapfile
truncate -s 0 "$SWAPFILE"
chattr +C "$SWAPFILE"
btrfs property set "$SWAPFILE" compression none
# /proc/meminfo kB is in fact kibibytes
# https://lore.kernel.org/lkml/CAHp75Vf__Cb2=TDQRF4R5q8bfAQev2-smcdEMWz32MvYjGnT0Q@mail.gmail.com/
dd if=/dev/zero of="$SWAPFILE" bs=1K count="$(awk '/MemTotal/{print $2}' /proc/meminfo)"
chmod 0600 "$SWAPFILE"
mkswap "$SWAPFILE"


# Mount the target filesystems layout
umount /mnt
mountStorage
swapon "$SWAPFILE"
