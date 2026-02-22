#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.11: Gzip-1.14
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    12 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gzip-1.14..."

cd $LFS/sources
tar -xf gzip-1.14.tar.xz
cd gzip-1.14

./configure --prefix=/usr --host=$LFS_TGT

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf gzip-1.14

echo ">>> Gzip-1.14 — DONE"
