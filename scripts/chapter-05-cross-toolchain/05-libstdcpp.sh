#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 5.6: Libstdc++ from GCC-15.2.0
# Run as: lfs user
# Approximate build time: 0.2 SBU
# Required disk space:    1.3 GB
# ============================================================
set -euo pipefail

echo ">>> Building Libstdc++ from GCC-15.2.0..."

cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

mkdir -v build
cd build

time { ../libstdc++-v3/configure      \
          --host=$LFS_TGT            \
          --build=$(../config.guess) \
          --prefix=/usr              \
          --disable-multilib         \
          --disable-nls              \
          --disable-libstdcxx-pch    \
          --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0 \
      && make \
      && make DESTDIR=$LFS install; }

# Remove harmful libtool archive files
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

cd $LFS/sources
rm -rf gcc-15.2.0

echo ">>> Libstdc++ — DONE"
