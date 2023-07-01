cd "$(git rev-parse --show-toplevel)"

TARGET="${1:-}"

case "$TARGET" in
	echidna)
		nix build --out-link result.sd.echidna .#nixosConfigurations.echidna.config.system.build.sdImage
		;;
	*)
		nix build --out-link result.iso .#nixosConfigurations.installMedia.config.system.build.isoImage
		;;
esac
