#!/bin/sh
set -eu
export PATH=/app:/usr/local/bin:$PATH

if [ -e "/confd.yaml" ]; then
	if [ -z "${SKIP_CONFD:-}" ]; then
		confd -backend file -file /confd.yaml -onetime >&2
	fi
fi

if [ -z "${1:-}" ]; then
	exec php-fpm
else
	exec $@
fi
