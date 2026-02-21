function display_help() {
	cat >&2 <<-EOH
		Usage: $(basename "$0") track-number file

		  track-number  A track number between 1 and 99
		  file          The file path whose name is to normalize
	EOH
}

is_valid_track() {
    local track="$1"
    [[ "$track" =~ ^[0-9]+$ ]] && (( track >= 1 && track <= 99 ))
}


if [[ $# -lt 2 ]]; then
	display_help
	exit 1
fi

TRACK_NUMBER="$1"; shift
FILE="$1"; shift

if ! is_valid_track "$TRACK_NUMBER"; then
	echo "Error: The track number must be between 1 and 99." >&2
	echo
	display_help
	exit 1
fi

if [[ ! -f "$FILE" ]]; then
	echo "Error: File '$FILE' does not exist" >&2
	echo
	display_help
	exit 1
fi

DIRECTORY="$(dirname "$FILE")"
FILENAME="$(basename "$FILE")"
NAME="${FILENAME%.*}"
EXTENSION="${FILENAME##*.}"

NEW_FILENAME=$(printf "%02d.%s.%s" "$TRACK_NUMBER" "${NAME// /_}" "$EXTENSION")
NEW_FILE="${DIRECTORY:+$DIRECTORY/}${NEW_FILENAME}"

mv "$FILE" "$NEW_FILE"
