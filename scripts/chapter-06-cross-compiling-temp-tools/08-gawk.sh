#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.9: Gawk-5.3.2
# Run as: lfs user
# Approximate build time: 0.1 SBU
# Required disk space:    49 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gawk-5.3.2..."

cd $LFS/sources
tar -xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

# Remove unneeded extras
sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make
make DESTDIR=$LFS install

cd $LFS/sources
rm -rf gawk-5.3.2

echo ">>> Gawk-5.3.2 — DONE"
