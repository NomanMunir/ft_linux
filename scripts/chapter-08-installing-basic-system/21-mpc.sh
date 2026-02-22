#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.23: MPC-1.3.1
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    22 MB
# ============================================================
set -euo pipefail

echo ">>> Building MPC-1.3.1..."

cd /sources
tar -xf mpc-1.3.1.tar.gz
cd mpc-1.3.1

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1

make
make html

make check

make install
make install-html

cd /sources
rm -rf mpc-1.3.1

echo ">>> MPC-1.3.1 — DONE"
