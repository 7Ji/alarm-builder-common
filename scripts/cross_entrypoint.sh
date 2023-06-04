#!/bin/bash -e
pacman -Syu --noconfirm
chown -R alarm: /home/alarm
cd /home/alarm/alarm-builder
export HOME=/home/alarm # because distcc will break with env kept
sudo --preserve-env=compressor,GOPROXY,http_proxy,https_proxy -u alarm alarm_builder_cross_building=yes ./build.sh