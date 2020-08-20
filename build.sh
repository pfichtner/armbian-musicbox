#!/bin/sh

vagrant_up() {
	if [ -z "$PROVIDER" ]; then
		vagrant up
	else	
		vagrant up --provider="$PROVIDER"
	fi
}

vagrant_copy() {
	TMPFILE=`mktemp -p '' vagrant-ssh-config.XXXXXXXXXX`
	vagrant ssh-config >$TMPFILE
	scp -F $TMPFILE "$@"
	rm $TMPFILE
}

vagrant_up
vagrant_copy -pr build default:
vagrant ssh -c "cd build/ && sudo -E bash make-armbian-mopidy.sh && ls -lh"
vagrant_copy -pr default:build/*.xz .
vagrant destroy -f
