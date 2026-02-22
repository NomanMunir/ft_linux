#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.16: Xz-5.8.1
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    23 MB
# ============================================================
set -euo pipefail

echo ">>> Building Xz-5.8.1..."

cd $LFS/sources
tar -xf xz-5.8.1.tar.xz
cd xz-5.8.1

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.1

make
make DESTDIR=$LFS install

# Remove harmful libtool archive
rm -v $LFS/usr/lib/liblzma.la

cd $LFS/sources
rm -rf xz-5.8.1

echo ">>> Xz-5.8.1 — DONE"
