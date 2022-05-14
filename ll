#!/bin/sh

case ${LSLONG_COMMAND:+x} in x)
	exec "${LSLONG_COMMAND}" "$@";
esac

if command -v >/dev/null 2>&1 exa; then
	exec exa -aalF --time-style iso --group-directories-first "$@"
fi

exec ls -alF --group-directories-first "$@"
