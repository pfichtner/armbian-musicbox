#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

apt install -y gnupg2
wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
apt update
apt install -y mopidy gstreamer1.0-alsa mopidy-mpd python3-pip
python3 -m pip install Mopidy-MusicBox-Webclient


####################
# Mopidy-AlsaMixer #
####################
apt install -y python3-dev libasound2-dev python3-pyalsa
python3 -m pip install Mopidy-AlsaMixer
apt purge -y python3-dev libasound2-dev


cat <<EOF >>/etc/mopidy/mopidy.conf 
[http]
hostname = 0.0.0.0

[file]
media_dirs = /media

[audio]
output = alsasink
mixer = alsamixer

[alsamixer]
control = Line Out
EOF

systemctl enable mopidy



echo "mopidy" >/etc/hostname
# TODO passwords?

