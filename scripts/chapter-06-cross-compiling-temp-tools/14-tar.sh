#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.15: Tar-1.35
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    42 MB
# ============================================================
set -euo pipefail

echo ">>> Building Tar-1.35..."

cd $LFS/sources
tar -xf tar-1.35.tar.xz
cd tar-1.35

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf tar-1.35

echo ">>> Tar-1.35 — DONE"
