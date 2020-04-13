#!/bin/sh
set -e

# https://github.com/pimusicbox/pimusicbox / https://github.com/Drewsif/PiShrink
rm -rf imgroot/var/cache/apt/* imgroot/var/lib/apt/* imgroot/var/lib/dhcpcd5/* imgroot/etc/dropbear/*key imgroot/etc/ssh/*_host_* imgroot/tmp/* imgroot/var/tmp/* imgroot/usr/share/man/* imgroot/usr/share/doc imgroot/boot.bak
find imgroot/home -maxdepth 1 -type d -not -name 'mopidy' -print0 | xargs -0 -I {} rm -rf {}
find imgroot/var/log -type f -delete || true
find imgroot/home/ -type f -name "*.log" -delete || true
find imgroot/home/ -type f -name "*_history" -delete || true

# Clean up
apt-get autoremove --yes
apt-get clean
apt-get autoclean
