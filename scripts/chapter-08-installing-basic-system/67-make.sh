#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.69: Make-4.4.1
# Run as: root (inside chroot)
# Approximate build time: 0.5 SBU
# Required disk space:    16 MB
# ============================================================
set -euo pipefail

echo ">>> Building Make-4.4.1..."

cd /sources
tar -xf make-4.4.1.tar.gz
cd make-4.4.1

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install

cd /sources
rm -rf make-4.4.1

echo ">>> Make-4.4.1 — DONE"
