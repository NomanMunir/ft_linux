#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.68: Libpipeline-1.5.8
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    11 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libpipeline-1.5.8..."

cd /sources
tar -xf libpipeline-1.5.8.tar.gz
cd libpipeline-1.5.8

./configure --prefix=/usr

make

make check

make install

cd /sources
rm -rf libpipeline-1.5.8

echo ">>> Libpipeline-1.5.8 — DONE"
