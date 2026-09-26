#!/bin/bash
set -euo pipefail

mkdir -p /opt/data/nginx

ttyd -W -i 127.0.0.1 -p 7681 -b /terminal bash -l &
terminal_pid=$!
nginx -c /etc/nginx/hermes-ingress.conf -g 'daemon off;' &
nginx_pid=$!

cleanup() {
  kill "$terminal_pid" "$nginx_pid" 2>/dev/null || true
  wait "$terminal_pid" "$nginx_pid" 2>/dev/null || true
}
trap cleanup EXIT
wait -n "$terminal_pid" "$nginx_pid"
