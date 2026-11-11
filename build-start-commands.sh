#!/bin/sh
# Prints the Railway start command for each service, built from the files in this repo.
set -e
cd "$(dirname "$0")"
b64() { base64 -w0 "$1" 2>/dev/null || base64 "$1" | tr -d '\n'; }
gw=$(sed "s|<base64 of ../Caddyfile>|$(b64 Caddyfile)|" scripts/gateway-start.sh)
echo "== Firecrawl (gateway)"; printf '/bin/sh -c "echo %s | base64 -d > /tmp/start.sh && exec sh /tmp/start.sh"\n\n' "$(printf '%s\n' "$gw" | b64 /dev/stdin)"
echo "== API"; printf '/bin/sh -c "echo %s | base64 -d > /tmp/start.sh && exec sh /tmp/start.sh"\n\n' "$(b64 scripts/api-start.sh)"
for s in playwright rabbitmq nuq-postgres; do echo "== $s"; printf "/bin/sh -c '%s'\n\n" "$(cat scripts/$s-start.sh)"; done
