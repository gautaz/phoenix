cd "$(git rev-parse --show-toplevel)"

for hostdir in hosts/*; do
	host="$(basename "$hostdir")"
	if [ "$host" != "_" ] && [ "$host" != "default.nix" ]; then
		nixos-rebuild build --flake ".#$host"
	fi
done

for homedir in homes/*; do
	home="$(basename "$homedir")"
	if [ "$home" != "_" ]; then
		home-manager build --flake ".#$home"
	fi
done
