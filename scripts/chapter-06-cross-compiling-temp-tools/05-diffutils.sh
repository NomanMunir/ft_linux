#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.6: Diffutils-3.12
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    35 MB
# ============================================================
set -euo pipefail

echo ">>> Building Diffutils-3.12..."

cd $LFS/sources
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf diffutils-3.12

echo ">>> Diffutils-3.12 — DONE"
