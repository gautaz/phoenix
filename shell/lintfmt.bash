cd "$(git rev-parse --show-toplevel)"

if [ "${1:-x}" = "install" ]; then
	cat > .git/hooks/pre-commit <<- EOS
		#!/usr/bin/env nix-shell
		#!nix-shell -i bash ../../shell.nix
		nix-lint-fmt
	EOS
	chmod u+x .git/hooks/pre-commit
fi

statix fix .
alejandra -q .
