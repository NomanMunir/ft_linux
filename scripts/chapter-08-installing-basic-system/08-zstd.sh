#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.10: Zstd-1.5.7
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    56 MB
# ============================================================
set -euo pipefail

echo ">>> Building Zstd-1.5.7..."

cd /sources
tar -xf zstd-1.5.7.tar.gz
cd zstd-1.5.7

make prefix=/usr
make check
make prefix=/usr install

rm -v /usr/lib/libzstd.a

cd /sources
rm -rf zstd-1.5.7

echo ">>> Zstd-1.5.7 — DONE"
