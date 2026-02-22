#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.38: GDBM-1.25
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    14 MB
# ============================================================
set -euo pipefail

echo ">>> Building GDBM-1.25..."

cd /sources
tar -xf gdbm-1.25.tar.gz
cd gdbm-1.25

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make
make check
make install

cd /sources
rm -rf gdbm-1.25

echo ">>> GDBM-1.25 — DONE"
