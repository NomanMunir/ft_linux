#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.32: Psmisc-23.7
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    6.6 MB
# ============================================================
set -euo pipefail

echo ">>> Building Psmisc-23.7..."

cd /sources
tar -xf psmisc-23.7.tar.xz
cd psmisc-23.7

./configure --prefix=/usr

make

make check

make install

cd /sources
rm -rf psmisc-23.7

echo ">>> Psmisc-23.7 — DONE"
