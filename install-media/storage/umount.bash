swapoff /dev/mapper/vg-swap || true
umount --recursive /mnt
vgchange -a n vg
cryptsetup close pv
