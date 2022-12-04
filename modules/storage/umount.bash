swapoff /mnt/swap/swapfile || true
umount --recursive /mnt
cryptsetup close system
