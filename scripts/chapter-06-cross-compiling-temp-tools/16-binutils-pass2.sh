#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.17: Binutils-2.45 — Pass 2
# Run as: lfs user
# Approximate build time: 0.4 SBU
# Required disk space:    548 MB
# ============================================================
set -euo pipefail

echo ">>> Building Binutils-2.45 — Pass 2..."

cd $LFS/sources
tar -xf binutils-2.45.tar.xz
cd binutils-2.45

# Fix libtool linking issue
sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build
cd build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu

make
make DESTDIR=$LFS install

# Remove libtool archives and static libs
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd $LFS/sources
rm -rf binutils-2.45

echo ">>> Binutils-2.45 Pass 2 — DONE"
