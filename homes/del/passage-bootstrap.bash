PASSAGE_DIR="$HOME/.passage"

if [ ! -e "$PASSAGE_DIR/store" ]; then
	mkdir -p "$PASSAGE_DIR"
	cd "$PASSAGE_DIR"
	git clone "https://gautaz:$(</run/secrets/github/tokens/psclone)@github.com/gautaz/password-store.git" store
	cd store
	git remote set-url origin "https://github.com/gautaz/password-store.git"
fi
