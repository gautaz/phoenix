cd "$(git rev-parse --show-toplevel)"

if [ "${1:-x}" = "install" ]; then
	cat > .git/hooks/pre-commit <<- EOS
		#!/usr/bin/env nix-shell
		#!nix-shell -i bash ../../shell.nix
		phx-lint-fmt
	EOS
	chmod u+x .git/hooks/pre-commit
fi

# Nix auto lint and format
statix fix .
alejandra -q .

# Haskell lint, no auto because
# https://github.com/ndmitchell/hlint#why-are-hints-not-applied-recursively
hlint -q . || (echo "hlint failed" && exit 10)
# Haskell auto format
find . -name "*.hs" -exec ormolu --mode inplace {} \;
