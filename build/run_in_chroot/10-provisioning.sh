#!/bin/sh
set -e

apt-get install -y gnupg2
wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
apt-get update
apt-get install -y mopidy gstreamer1.0-alsa mopidy-mpd python3-pip

################
# Mopidy-Local # 
################
python3 -m pip install Mopidy-Local

####################
# Mopidy-AlsaMixer #
####################
apt-get install -y python3-dev libasound2-dev python3-pyalsa
python3 -m pip install Mopidy-AlsaMixer
apt-get purge -y python3-dev libasound2-dev

#############################
# Mopidy-MusicBox-Webclient #
#############################
#python3 -m pip install Mopidy-MusicBox-Webclient

###############
# Mopidy-Iris #
###############
python3 -m pip install Mopidy-Iris


cat <<EOF >>/etc/mopidy/mopidy.conf 
[http]
hostname = 0.0.0.0

[audio]
output = alsasink
mixer = alsamixer

[alsamixer]
control = Line Out

[file]
media_dirs = /media

[local]
media_dir = /media
scan_follow_symlinks = true
EOF

systemctl enable mopidy



echo "mopidy" >/etc/hostname
# TODO passwords?

