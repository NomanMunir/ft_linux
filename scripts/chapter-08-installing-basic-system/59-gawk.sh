#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.61: Gawk-5.3.2
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    45 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gawk-5.3.2..."

cd /sources
tar -xf gawk-5.3.2.tar.xz
cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr

make

chown -R tester .
su tester -c "PATH=$PATH make check"

rm -f /usr/bin/gawk-5.3.2

make install

ln -sv gawk.1 /usr/share/man/man1/awk.1
install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2

cd /sources
rm -rf gawk-5.3.2

echo ">>> Gawk-5.3.2 — DONE"
