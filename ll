#!/bin/sh

# for now this file is not executable 
# I'm trying to eleminate the need for this by using $LSLONG_COMMAND everywhere,
# I still keep it just in case

case ${LSLONG_COMMAND:+x} in x)
	exec "${LSLONG_COMMAND}" "$@";
esac

if command -v >/dev/null 2>&1 exa; then
	exec exa -aalF --time-style iso --group-directories-first "$@"
fi

exec ls -alF --group-directories-first "$@"
