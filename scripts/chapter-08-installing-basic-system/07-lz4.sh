#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.9: Lz4-1.10.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    13 MB
# ============================================================
set -euo pipefail

echo ">>> Building Lz4-1.10.0..."

cd /sources
tar -xf lz4-1.10.0.tar.gz
cd lz4-1.10.0

make BUILD_STATIC=no PREFIX=/usr
make -j1 check
make BUILD_STATIC=no PREFIX=/usr install

cd /sources
rm -rf lz4-1.10.0

echo ">>> Lz4-1.10.0 — DONE"
