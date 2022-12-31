cd "$(git rev-parse --show-toplevel)"
nix build .#installMedia.config.system.build.isoImage
