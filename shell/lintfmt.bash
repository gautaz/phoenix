cd "$(git rev-parse --show-toplevel)"
statix fix .
find . -name '*.nix' -exec nix-fmt {} \;
