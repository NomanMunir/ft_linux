#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.49: Libelf from Elfutils-0.192
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    125 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libelf from Elfutils-0.192..."

cd /sources
tar -xf elfutils-0.192.tar.bz2
cd elfutils-0.192

./configure --prefix=/usr --disable-debuginfod --enable-libdebuginfod=dummy
make
make check
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

cd /sources
rm -rf elfutils-0.192

echo ">>> Libelf from Elfutils-0.192 — DONE"
