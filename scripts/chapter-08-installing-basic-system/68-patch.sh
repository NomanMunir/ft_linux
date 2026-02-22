#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.70: Patch-2.8
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    13 MB
# ============================================================
set -euo pipefail

echo ">>> Building Patch-2.8..."

cd /sources
tar -xf patch-2.8.tar.xz
cd patch-2.8

./configure --prefix=/usr

make

make check

make install

cd /sources
rm -rf patch-2.8

echo ">>> Patch-2.8 — DONE"
