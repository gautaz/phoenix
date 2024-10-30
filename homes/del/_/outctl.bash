function notifyVolume() {
	local volume; volume="$1"
	local icon; icon=muted
	local label; label=MUTED
	[[ "$volume" -gt 0 ]] && icon=low && label="$volume%"
	[[ "$volume" -gt 33 ]] && icon=medium
	[[ "$volume" -gt 66 ]] && icon=high
	dunstify \
		-t 2000 \
		-a changeVolume \
		-u low \
		-i "audio-volume-$icon" \
		-h string:x-dunst-stack-tag:master-volume \
		-h int:value:"$volume" \
		"Volume: $label"
}

function setMasterVolume() {
	local volume; volume="$(
		amixer sset Master "$@" \
			| awk -F'[] %[]+' '/  Front Left: /{print $7 "\t" $6}'
	)"
	local state; state="$(cut -f 1 <<< "$volume")"
	local percentage; percentage="$(cut -f 2 <<< "$volume")"
	[[ "$state" == "off" ]] && percentage=0
	notifyVolume "$percentage"
}

function updateDdcBusFile() {
	local ddcBusFile; ddcBusFile="$1"
	ddcutil -t detect \
		| tr '\n' '|' \
		| sed -e 's/||/\n/g' \
		| grep -G '^Display [0-9]*|' \
		| tr '|' '\n' \
		| grep 'I2C bus:' \
		| sed -e 's/.*-\([0-9]*\)$/\1/' \
		| tr -s '\n' ' ' \
		> "$ddcBusFile"
}

function unsafeSetDisplaysBrightness() {
	local ddcBusFile; ddcBusFile="$1"
	local brightness; brightness="$2"
	for bus in $(<"$ddcBusFile"); do
		ddcutil -b "$bus" setvcp 10 "$brightness"
	done
}

function setDisplaysBrightness() {
	local brightness; brightness="$1"
	local ddcBusFile; ddcBusFile="$XDG_RUNTIME_DIR/outctl-ddcbus.list"
	if [[ -r "$ddcBusFile" ]]; then
		local monitorCount; monitorCount="$(
			cat /sys/class/drm/card*-DP-*/status \
				| grep -c -v disconnected || true
		)"
		local ddcBusCount; ddcBusCount="$(wc -w < "$ddcBusFile")"
		if [[ $monitorCount -ne $ddcBusCount ]] || \
			! unsafeSetDisplaysBrightness "$ddcBusFile" "$brightness"
		then
			updateDdcBusFile "$ddcBusFile"
			unsafeSetDisplaysBrightness "$ddcBusFile" "$brightness" || true
		fi
	else
		updateDdcBusFile "$ddcBusFile"
		unsafeSetDisplaysBrightness "$ddcBusFile" "$brightness" || true
	fi
}

function setBrightness() {
	xbacklight "$@"
	local brightness
	brightness="$(xbacklight -get)"
	setDisplaysBrightness "$brightness"
	dunstify \
		-t 2000 \
		-a changeBrightness \
		-u low \
		-i weather-clear \
		-h string:x-dunst-stack-tag:display-brightness \
		-h int:value:"$brightness" \
		"Brightness: $brightness%"
}

case "$1" in
	audio-up)
		setMasterVolume "3%+" unmute
		;;
	audio-down)
		setMasterVolume "3%-" unmute
		;;
	audio-toggle)
		setMasterVolume toggle
		;;
	brightness-up)
		setBrightness -inc 3
		;;
	brightness-down)
		setBrightness -dec 3
		;;
	*)
		echo "unknown command: $1" 1>&2
		exit 10
		;;
esac
