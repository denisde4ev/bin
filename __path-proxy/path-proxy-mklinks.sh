#!/bin/sh



for i in /usr/bin/*; do
	[ -x "$i" ] || {
		printf %s\\n >&2 "note: ignoring '$i'"
		continue
	}
	i=${i##*/}

	ln -snvT path-proxy.sh "$i"
done
