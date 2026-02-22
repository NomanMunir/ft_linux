#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.14: Sed-4.9
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    21 MB
# ============================================================
set -euo pipefail

echo ">>> Building Sed-4.9..."

cd $LFS/sources
tar -xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf sed-4.9

echo ">>> Sed-4.9 — DONE"
