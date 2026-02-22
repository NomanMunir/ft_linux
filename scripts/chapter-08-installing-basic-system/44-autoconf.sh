#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.46: Autoconf-2.72
# Run as: root (inside chroot)
# Approximate build time: 0.8 SBU (with tests)
# Required disk space:    25 MB
# ============================================================
set -euo pipefail

echo ">>> Building Autoconf-2.72..."

cd /sources
tar -xf autoconf-2.72.tar.xz
cd autoconf-2.72

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf autoconf-2.72

echo ">>> Autoconf-2.72 — DONE"
