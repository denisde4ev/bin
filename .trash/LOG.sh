#!/bin/bash

(
	arg "$0" "$@" 
	"$@" 2>&1
) >> /var/log/LOG.sh/"${0//"/"/"%"}".dstn


# attept to rewrite:
#
#arg '--> starting:' "$0" "$@" > /var/log/LOG.sh/"${0//"/"/"%"}".shout$$
#3>&2 2>&1 1>&3 { 3>&2 2>&1 1>&3 { "$@" | tee /var/log/LOG.sh/"${0//"/"/"%"}".shout$$; } | tee /var/log/LOG.sh/"${0//"/"/"%"}".shout$$_err; }
