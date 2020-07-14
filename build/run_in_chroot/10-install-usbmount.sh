#!/bin/sh
set -e

### build usbmount apt-get purge -y debhelper build-essential fakeroot
# apt-get install debhelper build-essential fakeroot
# git clone https://github.com/rbrito/usbmount
# cd usbmount
# dpkg-buildpackage -us -uc -b
dpkg -i debs/usbmount_*.deb || true
apt-get --fix-broken -y install

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

