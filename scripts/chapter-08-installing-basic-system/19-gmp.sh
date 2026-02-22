#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.21: GMP-6.3.0
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    54 MB
# ============================================================
set -euo pipefail

echo ">>> Building GMP-6.3.0..."

cd /sources
tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0

make
make html
make check 2>&1 | tee gmp-check-log

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log

make install
make install-html

cd /sources
rm -rf gmp-6.3.0

echo ">>> GMP-6.3.0 — DONE"
