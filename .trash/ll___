#!/bin/sh

if command -v >/dev/null 2>&1 exa; then
	exec exa -alF --time-style iso --group-directories-first "$@"
else
	exec ls -alF --group-directories-first "$@"
fi
