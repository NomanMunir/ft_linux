#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.67: Kbd-2.7.1
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    20 MB
# ============================================================
set -euo pipefail

echo ">>> Building Kbd-2.7.1..."

cd /sources
tar -xf kbd-2.7.1.tar.xz
cd kbd-2.7.1

patch -Np1 -i ../kbd-2.7.1-backspace-1.patch

sed -i '/RESIZECONS_PROGS=/s/444/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

./configure --prefix=/usr --disable-vlock

make

make check

make install

mkdir -pv /usr/share/doc/kbd-2.7.1
cp -R -v docs/doc/* /usr/share/doc/kbd-2.7.1

cd /sources
rm -rf kbd-2.7.1

echo ">>> Kbd-2.7.1 — DONE"
