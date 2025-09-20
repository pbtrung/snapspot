#!/bin/ash

snapserver --config "$1" &

mkdir -p /music/oauth
socket="/tmp/gwsocket"
librespot --name music \
    --cache /music/oauth \
    --enable-oauth \
    --backend pipe \
    --device "$socket" \
    --passthrough on \
    --bitrate 320 \
    --autoplay on \
    --initial-volume 100 \
    --cache-size-limit 100M \
    --enable-volume-normalisation \
    --normalisation-gain-type track &

music_pid=$!
gwsocket --port=9000 --addr=0.0.0.0 --std < "$socket" &
gwsocket_pid=$!

# Wait for music to exit
wait $music_pid
# Kill gwsocket when music exits
kill -TERM $gwsocket_pid 2>/dev/null
wait $gwsocket_pid 2>/dev/null
rm "$socket"
