#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.10: Python-3.13.7 (Temporary Tools)
# Run as: root (inside chroot)
# Approximate build time: 0.5 SBU
# Required disk space:    546 MB
# ============================================================
set -euo pipefail

echo ">>> Building Python-3.13.7..."

cd /sources
tar -xf Python-3.13.7.tar.xz
cd Python-3.13.7

./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython

make

make install

cd /sources
rm -rf Python-3.13.7

echo ">>> Python-3.13.7 — DONE"
