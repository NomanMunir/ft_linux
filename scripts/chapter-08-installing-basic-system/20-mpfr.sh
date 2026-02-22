#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.22: MPFR-4.2.2
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    45 MB
# ============================================================
set -euo pipefail

echo ">>> Building MPFR-4.2.2..."

cd /sources
tar -xf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2

make
make html
make check
make install
make install-html

cd /sources
rm -rf mpfr-4.2.2

echo ">>> MPFR-4.2.2 — DONE"
