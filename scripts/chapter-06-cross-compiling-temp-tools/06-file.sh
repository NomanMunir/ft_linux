#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.7: File-5.46
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    42 MB
# ============================================================
set -euo pipefail

echo ">>> Building File-5.46..."

cd $LFS/sources
tar -xf file-5.46.tar.gz
cd file-5.46

# Build file for the host first (needed for magic signature file)
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

# Cross-compile file
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install

# Remove harmful libtool archive
rm -v $LFS/usr/lib/libmagic.la

cd $LFS/sources
rm -rf file-5.46

echo ">>> File-5.46 — DONE"
