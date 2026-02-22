#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.78: Procps-ng-4.0.5
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    26 MB
# ============================================================
set -euo pipefail

echo ">>> Building Procps-ng-4.0.5..."

cd /sources
tar -xf procps-ng-4.0.5.tar.xz
cd procps-ng-4.0.5

./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.5 \
            --disable-static                        \
            --disable-kill

make

chown -R tester .
su tester -c "PATH=$PATH make check"

make install

cd /sources
rm -rf procps-ng-4.0.5

echo ">>> Procps-ng-4.0.5 — DONE"
