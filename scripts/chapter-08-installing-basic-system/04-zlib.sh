#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.6: Zlib-1.3.1
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    6.5 MB
# ============================================================
set -euo pipefail

echo ">>> Building Zlib-1.3.1..."

cd /sources
tar -xf zlib-1.3.1.tar.xz
cd zlib-1.3.1

./configure --prefix=/usr
make
make check
make install

rm -fv /usr/lib/libz.a

cd /sources
rm -rf zlib-1.3.1

echo ">>> Zlib-1.3.1 — DONE"
