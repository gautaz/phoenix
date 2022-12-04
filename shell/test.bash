cd "$(git rev-parse --show-toplevel)"

if [ ! -f disk.qcow2 ]; then
	qemu-img create -f qcow2 disk.qcow2 10G
fi

qemu-system-x86_64 -enable-kvm -m 2048 -bios OVMF.fd -cdrom result/iso/nixos-*-x86_64-linux.iso -drive file=disk.qcow2,media=disk,if=virtio
