#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.10: Grep-3.12
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    32 MB
# ============================================================
set -euo pipefail

echo ">>> Building Grep-3.12..."

cd $LFS/sources
tar -xf grep-3.12.tar.xz
cd grep-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf grep-3.12

echo ">>> Grep-3.12 — DONE"
