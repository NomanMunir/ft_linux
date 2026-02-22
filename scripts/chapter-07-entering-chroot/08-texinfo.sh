#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.11: Texinfo-7.2 (Temporary Tools)
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    152 MB
# ============================================================
set -euo pipefail

echo ">>> Building Texinfo-7.2..."

cd /sources
tar -xf texinfo-7.2.tar.xz
cd texinfo-7.2

./configure --prefix=/usr

make

make install

cd /sources
rm -rf texinfo-7.2

echo ">>> Texinfo-7.2 — DONE"
