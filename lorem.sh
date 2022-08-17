#!/usr/bin/env bash
# initual SOURCE: https://github.com/npit/dotfiles/blob/1354b8c4f76e780b6a3d5bc4c746b8fb4451a2c4/scripts/lorem

case $@ in -h|--help)
echo "Usage: ${0##*/} [lines]"; exit 0
esac

#tr -dc a-z1-4 </dev/urandom | tr 1-2 ' \n' | awk 'length==0 || length>5' | tr 3-4 ' ' | sed 's/^ *//' | cat -s | sed 's/ / /g' |fmt | head -n $lines
printf 'Lorem '
dd if=/dev/urandom count=1k 2>/dev/null | tr -dc $'a-z \n' | sed -e 's/^  *|  *$//g' -e ' s/  */ /g' | fmt | head -n "${1:-5}"
