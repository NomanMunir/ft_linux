#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.25: Acl-2.3.2
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    6.4 MB
# ============================================================
set -euo pipefail

echo ">>> Building Acl-2.3.2..."

cd /sources
tar -xf acl-2.3.2.tar.xz
cd acl-2.3.2

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.3.2

make

make install

cd /sources
rm -rf acl-2.3.2

echo ">>> Acl-2.3.2 — DONE"
