#!/bin/sh

set -e

export DEBIAN_FRONTEND=noninteractive

los() {
  dev="$(losetup --show -f -P "$1")"
  echo "$dev"
  for part in "$dev"?*; do
    [ "$part" = "${dev}p*" ] && part="${dev}"
    echo "$part"
  done
}

getLoop() {
  los $1 | head -2 | tail -1
}

freeLoop() {
  losetup -d `losetup -j $1 | cut -d':' -f1`
}

increase() {
	IMGFILE=$1
	INCREASE_MB=$2
	truncate -s +${INCREASE_MB}M $IMGFILE
	parted -s $IMGFILE -a optimal resizepart 1 '100%'
	LOOP=`getLoop $IMGFILE`
	partprobe $LOOP
	e2fsck -yf $LOOP
	resize2fs $LOOP
	freeLoop $IMGFILE
}

minimize() {
	IMGFILE=$1
	LOOP=`getLoop $IMGFILE`
	e2fsck -yf $LOOP
	resize2fs -M $LOOP
	NEWSIZE=`parted -ms $IMGFILE unit B print | tail -1 | cut -d':' -f3 | tr -d 'B'`
	truncate -s $NEWSIZE $IMGFILE
	freeLoop $IMGFILE
}

#######################################
#######################################
#######################################
### prepare from ready to use image ###
#######################################
#######################################
#######################################

############
# download #
############
ARCFILE=Armbian_20.02.1_Orangepizero_buster_current_5.4.20.7z 
[ -d dls ] || mkdir dls
(cd dls ; wget -c https://dl.armbian.com/orangepizero/archive/$ARCFILE)
7zr -aoa x dls/$ARCFILE

###############
# make bigger #
###############
IMGFILE=*.img
increase $IMGFILE 512


#########
# mount #
#########
LOOP=`getLoop $IMGFILE`
[ -d imgroot ] || mkdir imgroot
mount $LOOP imgroot

# strip to minimum before installing anything?
# https://gist.github.com/dcloud9/8918580

##############
### chroot ###
##############
cd imgroot
TMP=`mktemp -d -p tmp/`
cd ..
cp -ax run_in_chroot debs imgroot/$TMP

for f in `(cd imgroot/$TMP/run_in_chroot && ls *)`; do
	sh chroot.sh imgroot sh -c "cd /$TMP; sh -x run_in_chroot/$f"
done


##########
# umount #
##########
umount imgroot
freeLoop $IMGFILE




##################
# compress image #
##################
minimize $IMGFILE
increase $IMGFILE 32
7zr -sdel a mopidy-orangepi.7z $IMGFILE



# add script to resize partition to sd card size
# unneeded on raspian (already included)?
