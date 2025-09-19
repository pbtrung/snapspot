#!/bin/ash

snapserver --config "$1" &

mkdir -p /music/oauth
librespot --cache /music/oauth --enable-oauth \
    --backend pipe --enable-volume-normalisation \
    --device /tmp/snapfifo --bitrate 320 \
    --autoplay on --initial-volume 100 \
    --cache-size-limit 100M --name music \
    --normalisation-gain-type track
