#!/data/data/com.termux/files/usr/bin/bash
## unset LD_PRELOAD in case termux-exec is installed
unset LD_PRELOAD


distro=${0##*/start-}
distro=${distro%.sh}

nroot=$1
[[ -d "$nroot" ]] && shift || {
cd -- "$(dirname $0)"
if [ -d "$distro-fs" ];then
	nroot=$distro-fs
elif [ -d ~/"$distro-fs" ];then
	nroot=~/$distro-fs
elif cd - && [ -d ~/"$distro-fs" ];then
	echo >&2 WARNING: found in ./"$distro-fs"
	nroot=./"$distro-fs"
else
	echo new_root directory not found
	exit 2
fi
}

command=(proot)
command+=(--link2symlink)
command+=(-0)
command+=(-r "$nroot")

command+=(-b /dev)
command+=(-b /proc)
command+=(-b "$nroot"/root:/dev/shm)
[[ ! -e $nroot/etc/localtime && -e $nroot/usr/share/zoneinfo/Europe/Sofia ]] && \ln -sr -vi -- "$nroot/usr/share/zoneinfo/Europe/Sofia" "$nroot/etc/localtime"
# [[ -e $nroot/usr/share/zoneinfo/Europe/Sofia && ! -e $nroot/etc/localtime ]] && \
# command+=(-b "$nroot/etc/localtime:$nroot/usr/share/zoneinfo/Europe/Sofia")


## uncomment the following line to have access to the home directory of termux
# command+=(-b /data/data/com.termux/files/home:/root)
# command+=(-b /data/data/com.termux/files/home)
## uncomment the following line to mount /sdcard directly to / 
#command+=(-b /sdcard)
[ 0 -eq $# ] && exec "${command[@]}" /bin/su -

command+=(-w /root)
command+=(/usr/bin/env -i)
command+=(HOME=/root)
command+=(PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/games:/usr/local/games)
command+=("TERM=$TERM")
command+=(LANG=C.UTF-8)
command+=(/bin/bash --login)
# com="$@"
# if [ -z "$1" ];then
    # exec $command
# else
    "${command[@]}" -c "${*@Q}"
# fi
