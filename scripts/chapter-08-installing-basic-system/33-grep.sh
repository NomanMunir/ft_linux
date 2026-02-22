#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.35: Grep-3.12
# Run as: root (inside chroot)
# Approximate build time: 0.4 SBU
# Required disk space:    42 MB
# ============================================================
set -euo pipefail

echo ">>> Building Grep-3.12..."

cd /sources
tar -xf grep-3.12.tar.xz
cd grep-3.12

sed -i "s/echo/#echo/" src/egrep.sh

./configure --prefix=/usr

make
make check
make install

cd /sources
rm -rf grep-3.12

echo ">>> Grep-3.12 — DONE"
