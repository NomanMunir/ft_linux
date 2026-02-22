#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.39: Gperf-3.3
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    5.9 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gperf-3.3..."

cd /sources
tar -xf gperf-3.3.tar.gz
cd gperf-3.3

./configure --prefix=/usr \
            --docdir=/usr/share/doc/gperf-3.3

make
make -j1 check
make install

cd /sources
rm -rf gperf-3.3

echo ">>> Gperf-3.3 — DONE"
