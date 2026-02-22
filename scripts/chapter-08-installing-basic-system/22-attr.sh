#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.24: Attr-2.5.2
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    4.2 MB
# ============================================================
set -euo pipefail

echo ">>> Building Attr-2.5.2..."

cd /sources
tar -xf attr-2.5.2.tar.gz
cd attr-2.5.2

./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2

make

make check

make install

cd /sources
rm -rf attr-2.5.2

echo ">>> Attr-2.5.2 — DONE"
