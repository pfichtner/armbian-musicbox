#!/bin/sh
set -e

# https://github.com/pimusicbox/pimusicbox
# Remove unrequired packages (#426)
apt-get remove --purge --yes xkb-data dpkg-dev groff-base man-db binutils gcc-8 gcc-8-base cpp libc-dev-bin libc6-dev make m4 autotools-dev git || true

