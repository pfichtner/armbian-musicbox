#!/bin/sh
set -e

TMP=`mktemp -d`

mkdir "$TMP/sbin/"
echo <<EOF >>"$TMP/sbin/sudo"
#!/bin/sh
exec $@
EOF
chmod +x "$TMP/sbin/sudo"
export PATH="$TMP/sbin/:$PATH"

curl -sL https://raw.githubusercontent.com/billz/raspap-webgui/master/installers/raspbian.sh | bash -s -- --openvpn 0 --adblock 0 --yes
rm -rf "$TMP"

