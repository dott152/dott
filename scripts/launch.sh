#!/usr/bin/env bash

if [[ $(uname -o 2>/dev/null) == *'Android'* ]]; then
	DOTT_ROOT="/data/data/com.termux/files/usr/opt/dott"
else
	DOTT_ROOT="/opt/dott"
fi

if [[ "${1:-}" == "-h" || "${1:-}" == "help" ]]; then
	printf 'Uso: dott\n\nSirve un sitio propio desde .sites localmente o mediante Cloudflare Tunnel.\n'
	exit 0
fi

cd "$DOTT_ROOT" || exit 1
exec bash ./dott.sh "$@"
