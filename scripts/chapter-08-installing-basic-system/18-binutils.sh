#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.20: Binutils-2.45
# Run as: root (inside chroot)
# Approximate build time: 2.2 SBU
# Required disk space:    2.8 GB
# ============================================================
set -euo pipefail

echo ">>> Building Binutils-2.45..."

cd /sources
tar -xf binutils-2.45.tar.xz
cd binutils-2.45

mkdir -v build
cd build

../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu

make tooldir=/usr
make -k check
make tooldir=/usr install

rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a

cd /sources
rm -rf binutils-2.45

echo ">>> Binutils-2.45 — DONE"
