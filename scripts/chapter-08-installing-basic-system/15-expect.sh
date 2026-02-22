#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.17: Expect-5.45.4
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    4.1 MB
# ============================================================
set -euo pipefail

echo ">>> Building Expect-5.45.4..."

cd /sources
tar -xf expect5.45.4.tar.gz
cd expect5.45.4

python3 -c 'from pty import spawn; spawn(["echo","ok"])'

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make
make test
make install

ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib

cd /sources
rm -rf expect5.45.4

echo ">>> Expect-5.45.4 — DONE"
