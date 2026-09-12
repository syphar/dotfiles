#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob
images=("$HOME"/Applications/Beeper-*.AppImage)

if ((${#images[@]} != 1)); then
	printf 'Expected exactly one Beeper AppImage in ~/Applications; found %d.\n' "${#images[@]}" >&2
	exit 1
fi

exec "${images[0]}"
