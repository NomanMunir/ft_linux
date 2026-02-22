#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.63: Groff-1.23.0
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    108 MB
# ============================================================
set -euo pipefail

echo ">>> Building Groff-1.23.0..."

cd /sources
tar -xf groff-1.23.0.tar.gz
cd groff-1.23.0

PAGE=A4 ./configure --prefix=/usr

make

make install

cd /sources
rm -rf groff-1.23.0

echo ">>> Groff-1.23.0 — DONE"
