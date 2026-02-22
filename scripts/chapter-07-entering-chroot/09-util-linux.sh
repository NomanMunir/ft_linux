#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.12: Util-linux-2.41.1 (Temporary Tools)
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    192 MB
# ============================================================
set -euo pipefail

echo ">>> Building Util-linux-2.41.1..."

cd /sources
tar -xf util-linux-2.41.1.tar.xz
cd util-linux-2.41.1

# Create the hwclock adjtime directory
mkdir -pv /var/lib/hwclock

./configure --libdir=/usr/lib          \
            --runstatedir=/run         \
            --disable-chfn-chsh       \
            --disable-login           \
            --disable-nologin         \
            --disable-su              \
            --disable-setpriv         \
            --disable-runuser         \
            --disable-pylibmount      \
            --disable-static          \
            --disable-liblastlog2     \
            --without-python          \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.1

make

make install

cd /sources
rm -rf util-linux-2.41.1

echo ">>> Util-linux-2.41.1 — DONE"
