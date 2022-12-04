cd "$(git rev-parse --show-toplevel)"
nix build .#nixosConfigurations.installMedia.config.system.build.isoImage
