nixos-generate-config --root /mnt

pushd /mnt/etc/nixos

WITH_HW_CONF="with import ./hardware-configuration.nix { config={}; lib={}; pkgs={}; modulesPath={}; }"
LUKS_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; boot.initrd.luks.devices.\"system\".device")"
BTRFS_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; fileSystems.\"/\".device")"
BOOT_DEVICE="$(nix-instantiate --eval -E "$WITH_HW_CONF; fileSystems.\"/boot\".device")"

sed -i \
	-e "s#$LUKS_DEVICE#\"/dev/disk/by-label/system\"#g" \
	-e "s#$BTRFS_DEVICE#\"/dev/mapper/system\"#g" \
	-e "s#$BOOT_DEVICE#\"/dev/disk/by-label/boot\"#g" \
	./hardware-configuration.nix

popd
