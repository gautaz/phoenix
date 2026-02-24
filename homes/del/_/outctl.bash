function notifyVolume() {
	local volume="$1"
	local icon=muted
	local label=MUTED
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
	local cmd="$1"
	local current
	local muted=0

	if [[ "$cmd" == "toggle" ]]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	else
		wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ "$cmd"
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
	fi

	# Get updated volume & mute status
	current="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
	percentage="$(awk '{print int($2*100)}' <<< "$current")"
	grep -q MUTED <<< "$current" && muted=1

	[[ $muted -eq 1 ]] && percentage=0
	notifyVolume "$percentage"
}

function updateDdcBusFile() {
	local ddcBusFile="$1"
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
	local ddcBusFile="$1"
	local brightness="$2"
	for bus in $(<"$ddcBusFile"); do
		ddcutil -b "$bus" setvcp 10 "$brightness"
	done
}

function setDisplaysBrightness() {
	local brightness="$1"
	local ddcBusFile="$XDG_RUNTIME_DIR/outctl-ddcbus.list"
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
	local brightness; brightness="$(xbacklight -get)"
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
		setMasterVolume "3%+"
		;;
	audio-down)
		setMasterVolume "3%-"
		;;
	audio-toggle)
		setMasterVolume "toggle"
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
