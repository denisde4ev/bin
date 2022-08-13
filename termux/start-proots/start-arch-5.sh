#!/usr/bin/env bash

HOME=/data/data/com.termux/files/home


[ "$1" != "--help" ] || {
	printf %s\\n
		'usage: @<distro> [command]' \
		"       ${0##*/} --rootfs=<root to chroot> [command]" \
	;
	exit	
}

unset LD_PRELOAD # in case termux-exec is installed
# [[ ! $ANDROID_ROOT ]] && export PROOT_NO_SECCOMP=1
unset nroot

case $1 in
	-r|--rootfs)
		nroot=$2
		shift 2
	;;
	--rootfs=*)	nroot=$1;shift;;
	*)
		nroot=${0##*/}
		nroot=${nroot#@}
		nroot=${nroot##start-}
		nroot=${nroot%.sh}-fs # expected to end in "<nroot-name>-fs"

		if [ -d "${0%/*}/$nroot" ]; then nroot=${0%/*}/$nroot
		elif [ -d ~/"$nroot" ]; then    nroot=~/$nroot
		else
			echo new_root directory not found by script name
			exit 2
		fi
	;;
esac

[ -d "$nroot" ] || {
	echo >&2 new_root specified but not found
	exit 2
}

# [[ $nroot = /* ]] && cd / && nroot=${nroot#/} # fix 1 error I had

ncmd() { # search in nroot for cmd
	a=$(
		set -eu
		cd "$nroot"
		PATH=usr/local/sbin:usr/local/bin:bin:usr/bin:/sbin:usr/sbin:usr/games:usr/local/games \
		which -- "$1" 2>&-
	) && \
	[ -x "$a" ] && \
	echo "$a" || \
	echo "/usr/bin/$1"
	# last one is fallback to show error command not found in "/usr/bin/..."
}

parg=() # requirest bash?
# parg+=(--link2symlink)
parg+=(--kill-on-exit)
parg+=(-0)
parg+=(-r "$nroot")

parg+=(-b /dev)
parg+=(-b /proc)
parg+=(-b "$nroot"/root:/dev/shm)
# parg+=(-b /data/data/com.termux/files/home:/root)
# parg+=(-b /data/data/com.termux/files/home)
# parg+=(-b /sdcard)
while [ "$1" = -* ]; do
	parg+=("$1")
	shift
done

# mine timezone, :-P pls dont come home
[ ! -e "$nroot/etc/localtime" -a -e "$nroot/usr/share/zoneinfo/Europe/Sofia" ] && \
	\ln -sn -v -- '../usr/share/zoneinfo/Europe/Sofia' "$nroot/etc/localtime"


parg+=(-w /) # this is the default chroot behaibur
if [ $# = 0 ];then
	exec ${proot:-proot} "${parg[@]}" "$(ncmd su)" -
fi

exec ${proot:-proot} "${parg[@]}" "$(ncmd env)" -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games "TERM=$TERM" LANG=C.UTF-8 "$@"

#PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
#     /usr/local/sbin:/usr/local/bin:     /usr/bin




