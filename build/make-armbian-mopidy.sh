#!/bin/sh

set -e

export DEBIAN_FRONTEND=noninteractive

getLoop() {
	IMGFILE=$1
	SIMPLENAME=`kpartx -av $IMGFILE | egrep -o 'loop[0-9]+p[0-9]+'`
find /dev -name $SIMPLENAME
	echo "/dev/mapper/$SIMPLENAME"
}

freeLoop() {
	IMGFILE=$1
	kpartx -dv $IMGFILE
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

los() {
  img="$1"
  dev="$(losetup --show -f -P "$img")"
  echo "$dev"
  for part in "$dev"?*; do
    if [ "$part" = "${dev}p*" ]; then
      part="${dev}"
    fi
    dst="/mnt/$(basename "$part")"
    echo "$dst"
    mkdir -p "$dst"
    mount "$part" "$dst"
  done
}

losd() {
  dev="/dev/loop$1"
  for part in "$dev"?*; do
    if [ "$part" = "${dev}p*" ]; then
      part="${dev}"
    fi
    dst="/mnt/$(basename "$part")"
    umount "$dst"
  done
  losetup -d "$dev"
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

IMGFILE=*.img


# **********************
# **********************
los $IMGFILE
find /mnt
losd $IMGFILE
# **********************
# **********************


###############
# make bigger #
###############
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
