#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 5.4: Linux-6.16.1 API Headers
# Run as: lfs user
# Approximate build time: < 0.1 SBU
# Required disk space:    1.7 GB
# ============================================================
set -euo pipefail

echo ">>> Installing Linux-6.16.1 API Headers..."

cd $LFS/sources
tar -xf linux-6.16.1.tar.xz
cd linux-6.16.1

make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

cd $LFS/sources
rm -rf linux-6.16.1

echo ">>> Linux API Headers — DONE"
