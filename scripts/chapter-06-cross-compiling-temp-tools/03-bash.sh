#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.4: Bash-5.3
# Run as: lfs user
# Approximate build time: 0.2 SBU
# Required disk space:    72 MB
# ============================================================
set -euo pipefail

echo ">>> Building Bash-5.3..."

cd $LFS/sources
tar -xf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc

make
make DESTDIR=$LFS install

# Create sh → bash symlink
ln -sv bash $LFS/bin/sh

cd $LFS/sources
rm -rf bash-5.3

echo ">>> Bash-5.3 — DONE"
