#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.11: File-5.46
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    19 MB
# ============================================================
set -euo pipefail

echo ">>> Building File-5.46..."

cd /sources
tar -xf file-5.46.tar.gz
cd file-5.46

./configure --prefix=/usr
make
make check
make install

cd /sources
rm -rf file-5.46

echo ">>> File-5.46 — DONE"
