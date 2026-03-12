#!/bin/sh


# use with:  ps-get-childprocess--get-leaf.sh $(abduco -l  | tail -n+2 | cut -d $'\t' -f 3)

case $1 in
	--help)
		printf %s\\n "Usage: $0 <pid...>"
		exit
	;;

esac

for pid in "$@"; do
	# Check if process exists
	if ! kill -0 "$pid" 2>/dev/null; then
		echo "PID $pid does not exist" >&2
		continue
	fi

	# Look for children of this PID
	children=$(ps -o pid= --ppid "$pid")

	printf %s\\n "$pid:	${children# }"
done
