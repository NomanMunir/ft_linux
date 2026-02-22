#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.79: Util-linux-2.41
# Run as: root (inside chroot)
# Approximate build time: 0.5 SBU
# Required disk space:    362 MB
# ============================================================
set -euo pipefail

echo ">>> Building Util-linux-2.41..."

cd /sources
tar -xf util-linux-2.41.tar.xz
cd util-linux-2.41

./configure --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --runstatedir=/run   \
            --sbindir=/usr/sbin  \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-liblastlog2 \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41

make

touch /etc/fstab
chown -R tester .
su tester -c "make -k check"

make install

cd /sources
rm -rf util-linux-2.41

echo ">>> Util-linux-2.41 — DONE"
