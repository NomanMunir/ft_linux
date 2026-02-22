#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.48: OpenSSL-3.5.2
# Run as: root (inside chroot)
# Approximate build time: 1.0 SBU
# Required disk space:    248 MB
# ============================================================
set -euo pipefail

echo ">>> Building OpenSSL-3.5.2..."

cd /sources
tar -xf openssl-3.5.2.tar.gz
cd openssl-3.5.2

./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
make
HARNESS_JOBS=$(nproc) make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

cd /sources
rm -rf openssl-3.5.2

echo ">>> OpenSSL-3.5.2 — DONE"
