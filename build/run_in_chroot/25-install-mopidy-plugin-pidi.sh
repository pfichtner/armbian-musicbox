#!/bin/sh
set -e

apt-get install -y zlib1g-dev libjpeg-dev
python3 -m pip install Mopidy-PiDi
python3 -m pip install raspi-python-st7735
apt-get purge -y zlib1g-dev libjpeg-dev

cat <<EOF >>/etc/mopidy/mopidy.conf 
[pidi]
enabled = true
display = st7735
EOF

