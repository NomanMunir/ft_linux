#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.41: Inetutils-2.6
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    35 MB
# ============================================================
set -euo pipefail

echo ">>> Building Inetutils-2.6..."

cd /sources
tar -xf inetutils-2.6.tar.xz
cd inetutils-2.6

sed -i 's/def HAVE_DECL_GETLINE/def HAVE_GETLINE/' lib/replacement.h

./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers

make
make check
make install

mv -v /usr/{,s}bin/ifconfig

cd /sources
rm -rf inetutils-2.6

echo ">>> Inetutils-2.6 — DONE"
