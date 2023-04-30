function notifyVolume() {
	local volume
	local icon
	local label
	volume="$1"
	icon=muted
	label=MUTED
	[[ "$volume" -gt 0 ]] && icon=low && label="$volume%"
	[[ "$volume" -gt 33 ]] && icon=medium
	[[ "$volume" -gt 66 ]] && icon=high
	dunstify -t 2000 -a changeVolume -u low -i "audio-volume-$icon" -h string:x-dunst-stack-tag:master-volume -h int:value:"$volume" "Volume: $label"
}

function masterVolume() {
	local volume
	local state
	local percentage
	volume="$(amixer sset Master "$@" | awk -F'[] %[]+' '/  Front Left: /{print $7 "\t" $6}')"
	state="$(cut -f 1 <<< "$volume")"
	percentage="$(cut -f 2 <<< "$volume")"
	[[ "$state" == "off" ]] && percentage=0
	notifyVolume "$percentage"
}

function backlightBrightness() {
	xbacklight "$@"
	local brightness
	brightness="$(xbacklight -get)"
	dunstify -t 2000 -a changeBrightness -u low -i weather-clear -h string:x-dunst-stack-tag:display-brightness -h int:value:"$brightness" "Brightness: $brightness%"
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
	brightness-up)
		backlightBrightness -inc 3
		;;
	brightness-down)
		backlightBrightness -dec 3
		;;
	*)
		echo "unknown command: $1" 1>&2
		exit 10
		;;
esac
