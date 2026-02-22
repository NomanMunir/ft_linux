#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.13: Patch-2.8
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    14 MB
# ============================================================
set -euo pipefail

echo ">>> Building Patch-2.8..."

cd $LFS/sources
tar -xf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf patch-2.8

echo ">>> Patch-2.8 — DONE"
