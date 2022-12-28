nixos-generate-config --root /mnt

cd /mnt/etc/nixos

WITH_HW_CONF="with import ./hardware-configuration.nix { config={}; lib={}; pkgs={}; modulesPath={}; }"
BOOT_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; fileSystems.\"/boot\".device")"
BTRFS_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; fileSystems.\"/\".device")"
SWAP_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; (builtins.head swapDevices).device")"

sed -i \
	-e '0,/^\s*boot\./{s#^\(\s*\)\(boot\..*\)$#\1boot.initrd.luks.devices.pv.device = "/dev/disk/by-label/pv";\n\1\2#}' \
	-e "s#$BOOT_DEVICE#\"/dev/disk/by-label/boot\"#g" \
	-e "s#$BTRFS_DEVICE#\"/dev/mapper/vg-system\"#g" \
	-e "s#$SWAP_DEVICE#\"/dev/mapper/vg-swap\"#g" \
	./hardware-configuration.nix
