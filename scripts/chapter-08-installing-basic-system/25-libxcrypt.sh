#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.27: Libxcrypt-4.4.38
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    15 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libxcrypt-4.4.38..."

cd /sources
tar -xf libxcrypt-4.4.38.tar.xz
cd libxcrypt-4.4.38

./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens

make

make check

make install

cd /sources
rm -rf libxcrypt-4.4.38

echo ">>> Libxcrypt-4.4.38 — DONE"
