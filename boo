#!/bin/sh

if [ "${EUID:-$(id -u)}" = 0 ]; then
	echo AHHHH\!\!\!
else
	echo '. .'
fi

# https://www.reddit.com/r/ProgrammerHumor/923bhq/sudo_boo/
