#!/bin/bash -il
x=${1#"{1%%[!"$IFS"]*}"} # try to fix $1
case $x in ["$IFS"]*|'') echo "${0##*/}: Missing command! Got: \$1='$1'"; exit 126; esac
shift
eval "$x ${@+"\"\$@\""}"
