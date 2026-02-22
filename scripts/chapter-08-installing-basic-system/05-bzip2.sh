#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.7: Bzip2-1.0.8
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    7.7 MB
# ============================================================
set -euo pipefail

echo ">>> Building Bzip2-1.0.8..."

cd /sources
tar -xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.1.0.8 /usr/lib/libbz2.so

cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
    ln -sfv bzip2 $i
done

rm -fv /usr/lib/libbz2.a

cd /sources
rm -rf bzip2-1.0.8

echo ">>> Bzip2-1.0.8 — DONE"
