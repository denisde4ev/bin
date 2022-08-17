#!/bin/sh

# poorly writen script!
# consider rewrite?
# 

set -eu

set -f;IFS='
'

case $1 in [!-]*) set -- -- "$@"; esac # self fix it


mv_args=''
while :; do
	case $# in 0)
		printf %s\\n >&2 "due to poorly writen script, this script requires to have '--' end of options to be working"
		exit 2
	esac

	case $1 in
		--) mv_args="$mv_args$IFS--"; shift; break;;
		*) mv_args="$mv_args$IFS$1";;
	esac

	shift
done


case $# in
1)
	printf %s\\n >&2 "only 1 file specifyed, nothing to do"
	exit 1
	;;
esac


# reverse the arguments:
. /\^/\ https://github.com/denisde4ev/shrc/raw/master/__sourceable/reverse_args.sh


tmp_file1=$1.mv-swap~$$~
mv $mv_args "$1" "$tmp_file1"

trap errfor_file1 1 2 3 6 15
errfor_file1() {
	printf %s\\n >&2 "${0##*/}: script is terminated!" "  warning leftover file is: '$tmp_file1', stoped at (arg $#): $1"
	exit 3
}


while case $# in 0|1) false; esac; do
	mv $mv_args "$2" "$1"
	shift
done

mv $mv_args "$tmp_file1" "$1"
