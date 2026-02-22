#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.8: Findutils-4.10.0
# Run as: lfs user
# Approximate build time: 0.2 SBU
# Required disk space:    48 MB
# ============================================================
set -euo pipefail

echo ">>> Building Findutils-4.10.0..."

cd $LFS/sources
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf findutils-4.10.0

echo ">>> Findutils-4.10.0 — DONE"
