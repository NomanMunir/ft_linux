#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.50: Libffi-3.4.8
# Run as: root (inside chroot)
# Approximate build time: 0.8 SBU
# Required disk space:    12 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libffi-3.4.8..."

cd /sources
tar -xf libffi-3.4.8.tar.gz
cd libffi-3.4.8

./configure --prefix=/usr --disable-static --with-gcc-arch=native
make
make check
make install

cd /sources
rm -rf libffi-3.4.8

echo ">>> Libffi-3.4.8 — DONE"
