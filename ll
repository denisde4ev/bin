#!/bin/sh

case ${LSLONG_COMMAND:+x} in
	x) exec "${LSLONG_COMMAND}" "$@";;
*)
	if command -v >/dev/null 2>&1 exa; then
		exec exa -alF --time-style iso --group-directories-first "$@"
	else
		exec ls -alhF --group-directories-first "$@"
	fi
esac
