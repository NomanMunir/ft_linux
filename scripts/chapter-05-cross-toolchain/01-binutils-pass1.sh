#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 5.2: Binutils-2.45 — Pass 1
# Run as: lfs user
# Approximate build time: 1 SBU
# Required disk space:    678 MB
# ============================================================
set -euo pipefail

echo ">>> Building Binutils-2.45 — Pass 1..."

cd $LFS/sources
tar -xf binutils-2.45.tar.xz
cd binutils-2.45

mkdir -v build
cd build

time { ../configure --prefix=$LFS/tools \
                    --with-sysroot=$LFS \
                    --target=$LFS_TGT   \
                    --disable-nls       \
                    --enable-gprofng=no \
                    --disable-werror    \
                    --enable-new-dtags  \
                    --enable-default-hash-style=gnu \
      && make \
      && make install; }

cd $LFS/sources
rm -rf binutils-2.45

echo ">>> Binutils-2.45 Pass 1 — DONE"
