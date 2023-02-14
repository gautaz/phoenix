blocks=( "" "▏" "▍" "▋" )

function progressBar() {
	case "$1" in
		VOLUME)
			read -r state percentage
			if [[ "$state" = "off" ]]; then
				echo "$1<----------MUTED---------->"
				return
			fi
			;;
		*)
			;;
	esac

	if ! test "$percentage" -eq "$percentage" 2>/dev/null; then
		echo "$1<?????????????????????????>"
		return
	fi

	if [[ "$percentage" -lt 0 ]]; then percentage=0; fi
	if [[ "$percentage" -gt 100 ]]; then percentage=100; fi

	local blockIndex=$((percentage % 4))
	local plainSize=$((percentage / 4))

	printf "$1<%${plainSize}s${blocks[$blockIndex]}" | sed 's/ /▉/g'
	printf "%$((25 - plainSize - (blockIndex + 3) / 4))s>\n" | sed 's/ /-/g'
}

function masterVolume() {
	amixer sset Master "$@" | awk -F'[] %[]+' '/  Mono: /{print $7 " " $5}' | progressBar VOLUME | nc -NU ~/.outctl-osd.socket
}

case "$1" in
	audio-up)
		masterVolume "3%+" unmute
		;;
	audio-down)
		masterVolume "3%-" unmute
		;;
	audio-toggle)
		masterVolume toggle
		;;
	*)
		echo "unknown command: $1" 1>&2
		exit 10
		;;
esac

