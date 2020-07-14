#!/bin/sh
set -e

# add "analog-codec" at "overlays=" in file /boot/armbianEnv.txt
if ! grep -q '^overlays=.*analog-codec.*$' /boot/armbianEnv.txt; then
	sed -i '/^overlays=/ s/$/ analog-codec/' /boot/armbianEnv.txt
	if ! grep -q '^overlays=.*analog-codec.*$' /boot/armbianEnv.txt; then
		echo 'overlays=analog-codec' >>/boot/armbianEnv.txt
	fi
fi


