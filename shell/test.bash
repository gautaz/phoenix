cd "$(git rev-parse --show-toplevel)"

TARGET="${1:-}"

case "$TARGET" in

	echidna)
		function loopmount() {
			local image="$1"
			local index="$2"
			fdisk -l -o device,start,sectors "$image" | awk "/^.*-aarch64-linux.img$index"'/{print $2 * 512 " " $3 * 512}' | (
					read -r PSTART PSIZE
					udisksctl loop-setup -f "$image" -r -o "$PSTART" -s "$PSIZE"
				) | awk -F'([ ]*|.$)' '/Mapped file/{print $5}'
		}

		function loopunmount () {
			local device="$1"
			if [[ -n "$device" ]]; then
				if findmnt "$device" >& /dev/null; then
					udisksctl unmount -b "$device"
				fi
				if losetup --list --noheadings --output NAME | grep --quiet --fixed-strings "$device"; then
					udisksctl loop-delete -b "$device"
				fi
			fi
		}

		function clean() {
			loopunmount "${SDLOOP_NIXOS:-}"
			loopunmount "${SDLOOP_FIRMWARE:-}"
			if [[ -d "${TMPDIR:-}" ]]; then
				rm -rf "$TMPDIR"
			fi
		}
		trap clean EXIT
		TMPDIR="$(mktemp -d)"

		COMPRESSED_SDIMG="$(find -L result.sd.echidna -type f -name "nixos-sd-image-*-aarch64-linux.img.zst" -print -quit)"
		zstd -d --output-dir-flat "$TMPDIR" "$COMPRESSED_SDIMG"

		SDIMG="$(find -L "$TMPDIR" -type f -name "nixos-sd-image-*-aarch64-linux.img" -print -quit)"
		echo "SD card image located at $SDIMG"
		chmod u+w "$SDIMG"
		qemu-img resize -f raw "$SDIMG" 4G

		UBOOT_FILENAME="u-boot-rpi3.bin"
		DTB_FILENAME="bcm2837-rpi-3-b.dtb"

		SDLOOP_FIRMWARE="$(loopmount "$SDIMG" 1)"
		SDLOOP_NIXOS="$(loopmount "$SDIMG" 2)"
		sleep 1
		SDMNT_FIRMWARE="$(findmnt -n -o TARGET -S LABEL=FIRMWARE)"
		SDMNT_NIXOS="$(findmnt -n -o TARGET -S LABEL=NIXOS_SD)"
		cp "$(find "$SDMNT_FIRMWARE" -type f -name "$UBOOT_FILENAME" -print -quit)" "$TMPDIR"
		cp "$(find "$SDMNT_NIXOS/boot" -type f -name "$DTB_FILENAME" -print -quit)" "$TMPDIR"
		loopunmount "$SDLOOP_NIXOS"
		loopunmount "$SDLOOP_FIRMWARE"

		UBOOT="$TMPDIR/$UBOOT_FILENAME"
		DTB="$TMPDIR/$DTB_FILENAME"

		qemu-system-aarch64 \
			-echr 0x11 \
			-machine raspi3b \
			-cpu cortex-a72 \
			-dtb "$DTB" \
			-m 1G -smp 4 \
			-nographic \
			-kernel "$UBOOT" -append "earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 rw rootwait" \
			-device sd-card,drive=sdcard -drive id=sdcard,if=none,format=raw,file="$SDIMG" \
			-device usb-net,netdev=net0 \
			-netdev user,id=net0,hostfwd=tcp::2222-:22
		;;

	*)
		BUILD_INPUTS="${nativeBuildInputs:?nativeBuildInputs is unavailable}"
		OVMF_PATH="$(nix-store -q --references "$(echo "$BUILD_INPUTS" | tr ' ' '\n' | grep OVMF)" | grep 'OVMF-.*-fd')"

		cd "$(git rev-parse --show-toplevel)"

		if [ ! -f disk.qcow2 ]; then
			qemu-img create -f qcow2 disk.qcow2 20G
		fi

		qemu-system-x86_64 -enable-kvm -m 2048 -bios "$OVMF_PATH/FV/OVMF.fd" -cdrom result.iso/iso/nixos-*-x86_64-linux.iso -drive file=disk.qcow2,media=disk,if=virtio -fsdev local,path="$(pwd)",security_model=mapped-xattr,id=ninep,readonly=on -device virtio-9p-pci,fsdev=ninep,mount_tag=hostmnt -nic user,hostfwd=tcp::5511-:22
		;;

esac
