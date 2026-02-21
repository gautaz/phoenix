# shellcheck source=/dev/null
source "$HOME/.config/user-dirs.dirs"

case "$ROFI_RETV" in
	0)
		echo -en "\0prompt\x1fSearch for\n"
		;;
	1)
		FILE="$(
			yt-dlp \
				--audio-format opus \
				--cookies "$HOME/.local/share/yt-dlp-cookies.txt" \
				--embed-metadata \
				--exec basename \
				--extract-audio \
				--output "$XDG_MUSIC_DIR/%(title)s.%(ext)s" \
				--quiet \
				"$ROFI_INFO"
		)"
		(
			mpc update
			mpc stop
			mpc clear
			mpc add "$FILE"
			mpc play
		) > /dev/null
		exit 0
		;;
	2)
		echo -en "\0prompt\x1fFilter\n"
		yt-dlp \
			--default-search ytsearch \
			--flat-playlist \
			--geo-bypass \
			--print '%(view_count)d - %(title)s [%(duration_string)s]\info|%(webpage_url)s' \
			--ignore-errors \
			--no-check-certificate \
			--no-playlist \
			--quiet \
			--skip-download \
			ytsearch50:"$*" \
		| sort -nr | tr '\\|' '\0\37'
		;;
	*)
		;;
esac
