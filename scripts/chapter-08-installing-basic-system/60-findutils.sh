#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.62: Findutils-4.10.0
# Run as: root (inside chroot)
# Approximate build time: 0.7 SBU
# Required disk space:    61 MB
# ============================================================
set -euo pipefail

echo ">>> Building Findutils-4.10.0..."

cd /sources
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0

./configure --prefix=/usr --localstatedir=/var/lib/locate

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install

cd /sources
rm -rf findutils-4.10.0

echo ">>> Findutils-4.10.0 — DONE"
