#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.2: M4-1.4.20
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    38 MB
# ============================================================
set -euo pipefail

echo ">>> Building M4-1.4.20..."

cd $LFS/sources
tar -xf m4-1.4.20.tar.xz
cd m4-1.4.20

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf m4-1.4.20

echo ">>> M4-1.4.20 — DONE"
