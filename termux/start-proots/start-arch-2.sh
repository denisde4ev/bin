#!/data/data/com.termux/files/usr/bin/bash
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD


if [[ $1 = -r ]]; then
	nroot=$2
	shift 2
	[[ -d "$nroot" ]] || {
		echo >&2 new_root specified but not found
		exit 127
	}
else
	nroot=${0##*/start-}
	nroot=${nroot%.sh}-fs # expected to end in "<nroot-name>-fs"

	if [[ -d ${0##/*}$nroot ]]; then
		nroot=${0##/*}$nroot
	elif [[ -d ~/$nrootnroot ]]; then
		nroot=~/$nroot
	elif [[ -d ./$nroot ]]; then
		echo >&2 WARNING: found in ./"$nroot" # \!\!\!
		nroot=./"$nroot"
	else
		nroot=
		echo new_root directory not found by script name
		exit 127
	fi
fi
# [[ $nroot = /* ]] && cd / && nroot=${nroot#/} # fix 1 error I had


command=(proot)
command+=(--link2symlink)
command+=(-0)
command+=(-r "$nroot")

command+=(-b /dev)
command+=(-b /proc)
command+=(-b "$nroot"/root:/dev/shm)
# [[ ! -e $nroot/etc/localtime && -e $nroot/usr/share/zoneinfo/Europe/Sofia ]] && \ln -sr -vi -- "$nroot/usr/share/zoneinfo/Europe/Sofia" "$nroot/etc/localtime"
# [[ -e $nroot/usr/share/zoneinfo/Europe/Sofia && ! -e $nroot/etc/localtime ]] && \
# command+=(-b "$nroot/etc/localtime:$nroot/usr/share/zoneinfo/Europe/Sofia")

# command+=(-b /data/data/com.termux/files/home:/root)
command+=(-w /) # this is the default chroot behaibur
# command+=(-b /data/data/com.termux/files/home)
# command+=(-b /sdcard)
[ $# = 0 ] && exec "${command[@]}" /bin/su -
echo exec "${command[@]}" /usr/bin/env -i HOME=/root PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games "TERM=$TERM" LANG=C.UTF-8 "$@"

#PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games
#     /usr/local/sbin:/usr/local/bin:     /usr/bin





