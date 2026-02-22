#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.31: Sed-4.9
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    31 MB
# ============================================================
set -euo pipefail

echo ">>> Building Sed-4.9..."

cd /sources
tar -xf sed-4.9.tar.xz
cd sed-4.9

./configure --prefix=/usr

make
make html

chown -R tester .
su tester -c "PATH=$PATH make check"

make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9

cd /sources
rm -rf sed-4.9

echo ">>> Sed-4.9 — DONE"
