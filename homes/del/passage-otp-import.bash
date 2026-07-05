urldecode() {
	local url_encoded="${1//+/ }"
	printf '%b' "${url_encoded//%/\\x}"
}

sanitize() {
	echo "${1// /_}"
}

dry_run=0
if [[ "${1:-}" == "--dry-run" ]]; then
	dry_run=1
	shift
fi

OTP_FILE="${1:-}"
if [[ -z "$OTP_FILE" ]]; then
	echo "Usage: passage-otp-import [--dry-run] <otp-entries-file>"
	exit 1
fi

if [[ ! -f "$OTP_FILE" ]]; then
	echo "Error: file not found: $OTP_FILE"
	exit 1
fi

while IFS= read -r line || [[ -n "$line" ]]; do
	[[ -z "$line" ]] && continue

	path_part="${line#*://}"
	path_part="${path_part#*/}"
	path_part="${path_part%%\?*}"

	issuerEncoded="${path_part%%%3A*}"
	labelEncoded="${path_part#*%3A}"

	issuer=$(urldecode "$issuerEncoded")
	label=$(urldecode "$labelEncoded")

	issuer=$(sanitize "$issuer")
	label=$(sanitize "$label")

	entry="otp/$issuer/$label"
	if [[ "$dry_run" -eq 1 ]]; then
		echo "Would import: $entry"
	else
		if passage show "$entry" &>/dev/null; then
			echo "Skip (already exists): $entry"
		else
			echo "Importing: $entry"
			echo "$line" | passage otp insert --force "$entry"
		fi
	fi
done < "$OTP_FILE"
