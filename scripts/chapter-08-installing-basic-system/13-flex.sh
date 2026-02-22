#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.15: Flex-2.6.4
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    33 MB
# ============================================================
set -euo pipefail

echo ">>> Building Flex-2.6.4..."

cd /sources
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4

./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static

make
make check
make install

ln -sv flex /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1

cd /sources
rm -rf flex-2.6.4

echo ">>> Flex-2.6.4 — DONE"
