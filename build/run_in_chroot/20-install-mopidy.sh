#!/bin/sh
set -e

apt-get install -y gnupg2
wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add -
wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/buster.list
apt-get update
apt-get install -y gstreamer1.0-alsa mopidy mopidy-mpd python3-pip usbmount

#########
# wheel # 
#########
python3 -m pip install wheel

#################
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




#####################
# Mopidy-PiDi START #
#####################
apt-get install -y zlib1g-dev libjpeg-dev
python3 -m pip install Mopidy-PiDi
python3 -m pip install raspi-python-st7735
apt-get purge -y zlib1g-dev libjpeg-dev

cat <<EOF >>/etc/mopidy/mopidy.conf 
[pidi]
enabled = true
display = st7735
EOF
###################
# Mopidy-PiDi END #
###################


###############################
# Mopidy-Raspberry-GPIO START #
###############################
# python3 -m pip install Mopidy-Raspberry-GPIO

# cat <<EOF >>/etc/mopidy/mopidy.conf 
# [raspberry-gpio]
# enabled = true
# bcm5 = play_pause,active_low,250
# bcm6 = volume_down,active_low,250
# bcm16 = next,active_low,250
# bcm20 = volume_up,active_low,250
# EOF
#############################
# Mopidy-Raspberry-GPIO END #
#############################



echo "mopidy" >/etc/hostname
# TODO passwords?

