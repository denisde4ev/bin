#!/usr/bin/env bash

# set -eu
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD
if [[ ! $ANDROID_ROOT ]]
then export PROOT_NO_SECCOMP=1
else :
fi
	

if [[ $1 = @(-r|--rootfs) ]]; then
	nroot=$2
	shift 2
	[[ -d "$nroot" ]] || {
		echo >&2 new_root specified but not found
		exit 127
	}
elif [[ $1 = --rootfs=* ]]; then
	nroot=$1
	shift
	[[ -d "$nroot" ]] || {
		echo >&2 new_root specified but not found
		exit 127
	}
else
	#nroot=${0##*/start-}
	#nroot=${nroot%.sh}-fs # expected to end in "<nroot-name>-fs"
	#
	#if [[ -d ${0##/*}$nroot ]]; then
	#	nroot=${0##/*}$nroot
	#elif [[ -d ~/$nrootnroot ]]; then
	#	nroot=~/$nroot
	#elif [[ -d ./$nroot ]]; then
	#	echo >&2 WARNING: found in ./"$nroot" # \!\!\!
	#	nroot=./"$nroot"
	#else
		nroot=
		echo new_root directory not found by script name
		exit 127
	# fi
fi

# [[ $nroot = /* ]] && cd / && nroot=${nroot#/} # fix 1 error I had


parg=()
# parg+=(--link2symlink)
parg+=(-0)
parg+=(-r "$nroot")

parg+=(-b /dev)
parg+=(-b /proc)
parg+=(-b "$nroot"/root:/dev/shm)
while [[ $1 = -* ]]; do
	parg+=("$1")
	shift
done

# [[ ! -e $nroot/etc/localtime && -e $nroot/usr/share/zoneinfo/Europe/Sofia ]] && \ln -sr -vi -- "$nroot/usr/share/zoneinfo/Europe/Sofia" "$nroot/etc/localtime"

# [[ -e $nroot/usr/share/zoneinfo/Europe/Sofia && ! -e $nroot/etc/localtime ]] && \
# parg+=(-b "$nroot/etc/localtime:$nroot/usr/share/zoneinfo/Europe/Sofia")

# parg+=(-b /data/data/com.termux/files/home:/root)
parg+=(-w /) # this is the default chroot behaibur
# parg+=(-b /data/data/com.termux/files/home)
# parg+=(-b /sdcard)
[ $# = 0 ] && exec proot "${parg[@]}" /usr/bin/su -
exec proot "${parg[@]}" /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games "TERM=$TERM" LANG=C.UTF-8 "$@"

#PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
#     /usr/local/sbin:/usr/local/bin:     /usr/bin
