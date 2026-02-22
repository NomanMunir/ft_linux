#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.13: M4-1.4.20
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    49 MB
# ============================================================
set -euo pipefail

echo ">>> Building M4-1.4.20..."

cd /sources
tar -xf m4-1.4.20.tar.xz
cd m4-1.4.20

./configure --prefix=/usr

make
make check
make install

cd /sources
rm -rf m4-1.4.20

echo ">>> M4-1.4.20 — DONE"
