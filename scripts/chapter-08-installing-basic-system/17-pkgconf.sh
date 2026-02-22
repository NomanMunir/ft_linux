#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.19: Pkgconf-2.4.3
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    4.6 MB
# ============================================================
set -euo pipefail

echo ">>> Building Pkgconf-2.4.3..."

cd /sources
tar -xf pkgconf-2.4.3.tar.xz
cd pkgconf-2.4.3

./configure --prefix=/usr              \
            --disable-static           \
            --docdir=/usr/share/doc/pkgconf-2.4.3

make
make install

ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1

cd /sources
rm -rf pkgconf-2.4.3

echo ">>> Pkgconf-2.4.3 — DONE"
