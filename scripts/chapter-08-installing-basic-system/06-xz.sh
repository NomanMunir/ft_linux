#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.8: Xz-5.8.1
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    26 MB
# ============================================================
set -euo pipefail

echo ">>> Building Xz-5.8.1..."

cd /sources
tar -xf xz-5.8.1.tar.xz
cd xz-5.8.1

./configure --prefix=/usr    \
    --disable-static         \
    --docdir=/usr/share/doc/xz-5.8.1

make
make check
make install

cd /sources
rm -rf xz-5.8.1

echo ">>> Xz-5.8.1 — DONE"
