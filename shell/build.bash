cd "$(git rev-parse --show-toplevel)"
nix build --out-link result.iso .#installMedia.config.system.build.isoImage
