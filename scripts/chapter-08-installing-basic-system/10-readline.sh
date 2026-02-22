#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.12: Readline-8.3
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    16 MB
# ============================================================
set -euo pipefail

echo ">>> Building Readline-8.3..."

cd /sources
tar -xf readline-8.3.tar.gz
cd readline-8.3

sed -i '/MV.*teleih/s/^/# /' shlib/Makefile.in
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf

./configure --prefix=/usr    \
    --disable-static         \
    --with-curses            \
    --docdir=/usr/share/doc/readline-8.3

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install

install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3

cd /sources
rm -rf readline-8.3

echo ">>> Readline-8.3 — DONE"
