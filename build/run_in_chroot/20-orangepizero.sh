#!/bin/sh
set -e

export DEBIAN_FRONTEND=noninteractive

# add "analog-codec" at "overlays=" in file /boot/armbianEnv.txt
if ! grep -q '^overlays=.*analog-codec.*$' /boot/armbianEnv.txt; then
	sed -i '/^overlays=/ s/$/ analog-codec/' /boot/armbianEnv.txt
	if ! grep -q '^overlays=.*analog-codec.*$' /boot/armbianEnv.txt; then
		echo 'overlays=analog-codec' >>/boot/armbianEnv.txt
	fi
fi


### build usbmount apt-get purge -y debhelper build-essential fakeroot
# apt install debhelper build-essential fakeroot
# git clone https://github.com/rbrito/usbmount
# cd usbmount
# dpkg-buildpackage -us -uc -b
dpkg -i debs/*.deb || true
apt --fix-broken -y install

cat <<EOF >/etc/usbmount/mount.d/10_mopidy_local_scan 
#!/bin/sh
/usr/sbin/mopidyctl local scan
EOF
chmod +x /etc/usbmount/mount.d/10_mopidy_local_scan 

cat <<EOF >/etc/usbmount/umount.d/10_mopidy_local_scan 
#!/bin/sh
/usr/sbin/mopidyctl local scan
EOF
chmod +x /etc/usbmount/umount.d/10_mopidy_local_scan 

