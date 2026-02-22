#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.77: Man-DB-2.13.0
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    42 MB
# ============================================================
set -euo pipefail

echo ">>> Building Man-DB-2.13.0..."

cd /sources
tar -xf man-db-2.13.0.tar.xz
cd man-db-2.13.0

./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.0 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap

make

make check

make install

cd /sources
rm -rf man-db-2.13.0

echo ">>> Man-DB-2.13.0 — DONE"
