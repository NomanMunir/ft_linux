#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.42: Less-668
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    12 MB
# ============================================================
set -euo pipefail

echo ">>> Building Less-668..."

cd /sources
tar -xf less-668.tar.gz
cd less-668

./configure --prefix=/usr --sysconfdir=/etc

make
make check
make install

cd /sources
rm -rf less-668

echo ">>> Less-668 — DONE"
