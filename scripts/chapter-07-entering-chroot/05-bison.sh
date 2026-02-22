#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.8: Bison-3.8.2 (Temporary Tools)
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    58 MB
# ============================================================
set -euo pipefail

echo ">>> Building Bison-3.8.2..."

cd /sources
tar -xf bison-3.8.2.tar.xz
cd bison-3.8.2

./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2

make

make install

cd /sources
rm -rf bison-3.8.2

echo ">>> Bison-3.8.2 — DONE"
