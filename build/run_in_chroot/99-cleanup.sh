#!/bin/sh
set -e

# https://github.com/pimusicbox/pimusicbox / https://github.com/Drewsif/PiShrink
rm -rf /var/cache/apt/* /var/lib/apt/* /var/lib/dhcpcd5/* /etc/dropbear/*key /etc/ssh/*_host_* /tmp/* /var/tmp/* /usr/share/man/* /usr/share/doc /boot.bak
find /home -maxdepth 1 -type d -not -name 'mopidy' -print0 | xargs -0 -I {} rm -rf {}
find /var/log -type f -delete || true
find /home/ -type f -name "*.log" -delete || true
find /home/ -type f -name "*_history" -delete || true

# Clean up
apt-get autoremove --yes
apt-get clean
apt-get autoclean

