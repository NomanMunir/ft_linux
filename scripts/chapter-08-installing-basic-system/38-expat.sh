#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.40: Expat-2.7.1
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    13 MB
# ============================================================
set -euo pipefail

echo ">>> Building Expat-2.7.1..."

cd /sources
tar -xf expat-2.7.1.tar.xz
cd expat-2.7.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.1

make
make check
make install

install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.1

cd /sources
rm -rf expat-2.7.1

echo ">>> Expat-2.7.1 — DONE"
