#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.47: Automake-1.17
# Run as: root (inside chroot)
# Approximate build time: 0.7 SBU
# Required disk space:    116 MB
# ============================================================
set -euo pipefail

echo ">>> Building Automake-1.17..."

cd /sources
tar -xf automake-1.17.tar.xz
cd automake-1.17

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.17
make
make -j$(($(nproc)>4?$(nproc):4)) check
make install

cd /sources
rm -rf automake-1.17

echo ">>> Automake-1.17 — DONE"
