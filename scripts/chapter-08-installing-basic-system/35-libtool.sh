#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.37: Libtool-2.5.4
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    36 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libtool-2.5.4..."

cd /sources
tar -xf libtool-2.5.4.tar.xz
cd libtool-2.5.4

./configure --prefix=/usr

make
make -k check
make install

rm -fv /usr/lib/libltdl.a

cd /sources
rm -rf libtool-2.5.4

echo ">>> Libtool-2.5.4 — DONE"
