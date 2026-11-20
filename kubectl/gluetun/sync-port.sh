#!/bin/sh
# sync-port.sh - keeps qBittorrent's listening port equal to ProtonVPN's current
# forwarded port, so the port announced to trackers/peers is actually reachable.
# Spawned detached by gluetun's VPN_PORT_FORWARDING_UP_COMMAND on every connect;
# self-guards via pidfile so only one instance ever runs.
# Requires qBittorrent WebUI "Bypass authentication for clients on localhost".

PIDFILE=/tmp/sync-port.pid
LOG=/tmp/sync-port.log
PORTFILE=/tmp/gluetun/forwarded_port

if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    exit 0
fi
echo $$ > "$PIDFILE"

last=""
while true; do
    E=$(head -n1 "$PORTFILE" 2>/dev/null | tr -cd '0-9')
    if [ -n "$E" ] && [ "$E" != "0" ] && [ "$E" != "$last" ]; then
        RESP=$(wget -qO- --timeout=5 \
            --post-data 'json={"listen_port":'"$E"'}' \
            http://127.0.0.1:8080/api/v2/app/setPreferences 2>/dev/null)
        if [ "$RESP" = "Ok." ]; then
            last="$E"
            echo "$(date -u +%FT%TZ) synced qBittorrent listen_port to $E" >> "$LOG"
        fi
    fi
    sleep 15
done
