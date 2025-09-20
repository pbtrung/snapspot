#!/bin/ash

snapserver --config "$1" &

mkdir -p /music/oauth
librespot --name music \
    --cache /music/oauth \
    --enable-oauth \
    --backend pipe \
    --device /tmp/snapfifo \
    --bitrate 320 \
    --autoplay on \
    --initial-volume 100 \
    --cache-size-limit 100M \
    --enable-volume-normalisation \
    --normalisation-gain-type track
