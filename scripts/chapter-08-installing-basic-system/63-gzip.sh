#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.65: Gzip-1.14
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    22 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gzip-1.14..."

cd /sources
tar -xf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr

make

make check

make install

cd /sources
rm -rf gzip-1.14

echo ">>> Gzip-1.14 — DONE"
