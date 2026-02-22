#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.60: Diffutils-3.12
# Run as: root (inside chroot)
# Approximate build time: 0.5 SBU
# Required disk space:    51 MB
# ============================================================
set -euo pipefail

echo ">>> Building Diffutils-3.12..."

cd /sources
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12

./configure --prefix=/usr

make
make check
make install

cd /sources
rm -rf diffutils-3.12

echo ">>> Diffutils-3.12 — DONE"
