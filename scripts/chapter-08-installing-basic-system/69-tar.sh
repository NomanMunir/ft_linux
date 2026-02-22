#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.71: Tar-1.35
# Run as: root (inside chroot)
# Approximate build time: 1.3 SBU
# Required disk space:    45 MB
# ============================================================
set -euo pipefail

echo ">>> Building Tar-1.35..."

cd /sources
tar -xf tar-1.35.tar.xz
cd tar-1.35

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

make

make check

make install

make -C doc install-html docdir=/usr/share/doc/tar-1.35

cd /sources
rm -rf tar-1.35

echo ">>> Tar-1.35 — DONE"
