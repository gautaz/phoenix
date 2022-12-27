usage() {
	echo "Mount the shared host filesystem on a mount point."
	echo "Usage: $(basename "$0") <mount point>"
	echo ""
	echo "mount point: A path of the local filesystem where to mount the shared host filesystem on"
}

if [ $# -lt 1 ]; then
	echo "Missing mount point."
	echo ""
	usage "$0"
	exit 10
fi

mount -t 9p -o trans=virtio hostmnt "$1"
