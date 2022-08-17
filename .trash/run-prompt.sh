#!/bin/sh

# popup run prompt and execute it
# something remotely simular to dmenu

case $1 in --help)
	printf %s\\n \
		"Usage: ${0##*/} [--asroot|--asuser] [command] [...command args]" \
		"" \
		"Description:" \
		"  prompt in basic shell IO  and esecute" \
		"  last external command in background." \
		"" \
		"Options:" \
		"  --asroot    set by default to asroot" \
		"  --asuser    set by default to asuser" \
		"" \
		"special commands are:" \
		"  (...most coreutils)    will just execute it without" \
		"  (shell buildins)        being in background and or root" \
		"" \
		"  asroot|asuser          when executing external command, use sudo" \
		"  'sudo *'               enable asroot, execute in background and exit" \
		"" \
	;
	exit
esac

if [ -t 2 -a -t 0 ]; then
	BB=nologin
	SH_VERSION='' . ~/B/_main
	prompt () { printf %s "$PWD ${asroot+"#"}> "; }
else
	prompt () { :; }
fi


unset asroot
while case $# in 0) false; esac; do
	case $1 in
		--asroot) asroot='';;
		--) shift; break;;
		-*) printf %s\\n "use --hepl for usage" >&2; exit 2;;
		*) break;;
	esac
	shift
done

case $1 in sudo)
	shift
	case $1 in -b) shift;; esac
	asroot=''
esac

case $# in 0) ;; *)
	case ${asroot+x} in
		x) exec sudo -b "$@";;
		*) exec "$@" &;;
	esac 0</dev/null 1>/dev/null 2>&1
	exit
esac


while :; do
	prompt; IFS= read -r comm || exit

	com=${comm%%["$IFS"]*}
	case $com in
		asroot) asroot=''; continue;;
		asuser) unset asroot; continue;;

		id|arch|ascii|ash|awk|base32|base64|basename|bc|blkdiscard|bzip2|cat|chgrp|chmod|chown|chroot|clear|cp|cpio|crc32|cttyhack|cut|dd|df|dirname|dmesg|du|echo|env|expr|fallocate|false|fatattr|free|fsfreeze|fstrim|fsync|getopt|grep|gzip|halt|head|hexdump|hexedit|i2ctransfer|ifconfig|init|install|ip|ipaddr|iplink|ipneigh|iproute|iprule|iptunnel|kbd_mode|kill|killall|less|link|ln|loadfont|loadkmap|losetup|ls|lsscsi|lzop|md5sum|mim|mkdir|mkfifo|mknod|mkpasswd|mktemp|mountpoint|mv|nc|netstat|nologin|nproc|nsenter|nslookup|nuke|openvt|partprobe|paste|pgrep|pidof|ping|ping6|poweroff|printf|ps|pwd|readlink|realpath|reboot|resume|rm|rmdir|route|run-init|sed|seq|setfattr|setfont|sh|sha1sum|sha256sum|sha512sum|shuf|sleep|sort|stat|strings|sync|tac|tail|tar|tcpsvd|tee|telnet|test|tftp|touch|true|truncate|ts|udhcpc|udhcpc6|umount|uname|uniq|unlink|unshare|unzip|uptime|vi|wc|wget|which|xxd|xz|yes)
			eval "$comm"
			continue
		;;
		sudo|doas) asroot=''; comm=${comm#*["$IFS"]}; com=${comm%%["$IFS"]*};;
	esac

	if
		
		case $com in
			exec) true;;
			*) false;;
		esac || \
		case $(\type "$com" 2>/dev/null) in
			*/*|'') true;;
			*) false;;
		esac # && alias #todo: consider more detects
	then
		case ${asroot+x} in
			x) eval "exec sudo -b $comm";;
			*) eval "exec $comm" & ;; # sclose io to be in background
		esac  0</dev/null 1>/dev/null 2>&1
		exit
	else
		eval "$comm"
	fi
done
