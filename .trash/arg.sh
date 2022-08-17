#!/bin/sh
#!/bin/bash --posix
#!/usr/bin/env -S zsh -c '"$@"' -- emulate bash -c

#!/bin/bash
#!/bin/env -S bb sh

[ -t 1 ] && [ -t 2 ] && {
	IFS=''
	i=$*
	printf '%i:%i ' "$#" "${#i}"
} >&2

# startspace=''
# for i; do
	# case $i in
		# *"'"*) printf %s "$i" | sed "s/'/'\\\\''/g; 1s/^/${startspace}'/; \$s/\$/'/";;
		# *) printf %s "${startspace}'$i'";;
	# esac
	# startspace=' '
# done
# echo
# 
# exit


# IF SUPPORTS NULL CHAR

[ $# -eq 0 ] && {
	echo
	exit
}

printf %s "'" 
{
	printf %s "$1"
	shift
	[ $# -ne 0 ] && printf '\0%s' "$@"
} | {
	sed "s/'/'\\\\''/g; s/\\x0/' '/g"
}
printf %s\\n "'"
