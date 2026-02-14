# shellcheck source=/dev/null
FILETYPE="$(file --brief --mime "$1")"
case "$FILETYPE" in
	application/pdf\;*)
		TMPDIR="$(mktemp -d)"
		pdftoppm -singlefile "$1" "$TMPDIR/preview"
		chafa --view-size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$TMPDIR/preview.ppm"
		rm -rf "$TMPDIR"
		;;
	image/*)
		chafa --view-size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$1"
		;;
	inode/directory\;*)
		tree -C -d -L 2 "$1"
		;;
	inode/symlink\;*)
		interview "$(readlink -f "$1")"
		;;
	text/* | application/javascript\;*)
		bat --theme="Catppuccin Latte" --color=always --style=numbers --line-range=:500 "$1"
		;;
	video/*)
		TMPDIR="$(mktemp -d)"
		mpv --terminal=no --vo=image --vo-image-format=png --vo-image-outdir="$TMPDIR" --frames=1 --start=50% --no-audio "$1"
		chafa --view-size="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" "$TMPDIR/00000001.png"
		rm -rf "$TMPDIR"
		;;
	*)
		echo "No preview for $FILETYPE"
		;;
esac
