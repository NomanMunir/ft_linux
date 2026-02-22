#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.33: Gettext-0.24
# Run as: root (inside chroot)
# Approximate build time: 1.0 SBU
# Required disk space:    320 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gettext-0.24..."

cd /sources
tar -xf gettext-0.24.tar.xz
cd gettext-0.24

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.24

make
make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

cd /sources
rm -rf gettext-0.24

echo ">>> Gettext-0.24 — DONE"
