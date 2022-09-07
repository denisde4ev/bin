#!/bin/sh

PATH=/usr/bin/:$PATH

printf %s\\n "[$(date -Is)]: ${0##*/}" "$@" '' '' >> "$0.log"
printf %s\\n "[$(date -Is)]: ${0##*/}" "$@" '' '' >> "${0%/*}/_LOG_"

exec "${0##*/}" "$@"
