#!/bin/sh

vagrant_up() {
	if [ -z "$PROVIDER" ]; then
		vagrant up
	else	
		vagrant up --provider="$PROVIDER"
	fi
}

vagrant_copy() {
	TMPFILE=`mktemp vagrant-ssh-config.XXXXXXXXXX`
	vagrant ssh-config >$TMPFILE
	scp -F $TMPFILE "$@"
	rm $TMPFILE
}

vagrant_up
#vagrant ssh -c "git clone https://github.com/volumio/Build build && cd build/ && sudo -E bash build.sh -b $ARCH -d $DEVICE -v $VERSION && sudo bzip2 -9 Volumio$VERSION-*-$DEVICE.img && ls -lh"
vagrant ssh -c "cp -ax /vagrant/build . && cd build/ && sudo -E bash make-armbian-mopidy.sh && ls -lh"
vagrant_copy default:build/*.img.bz2 default:build/*.img.md5 .
vagrant destroy -f
