#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.12: Make-4.4.1
# Run as: lfs user
# Approximate build time: < 0.1 SBU
# Required disk space:    15 MB
# ============================================================
set -euo pipefail

echo ">>> Building Make-4.4.1..."

cd $LFS/sources
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf make-4.4.1

echo ">>> Make-4.4.1 — DONE"
