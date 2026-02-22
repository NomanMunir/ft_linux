#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.14: Bc-7.0.3
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    7.8 MB
# ============================================================
set -euo pipefail

echo ">>> Building Bc-7.0.3..."

cd /sources
tar -xf bc-7.0.3.tar.xz
cd bc-7.0.3

CC=gcc ./configure --prefix=/usr -G -O3 -r

make
make test
make install

cd /sources
rm -rf bc-7.0.3

echo ">>> Bc-7.0.3 — DONE"
