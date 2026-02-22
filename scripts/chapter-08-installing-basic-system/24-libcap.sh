#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.26: Libcap-2.76
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    3.1 MB
# ============================================================
set -euo pipefail

echo ">>> Building Libcap-2.76..."

cd /sources
tar -xf libcap-2.76.tar.xz
cd libcap-2.76

sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib

make test

make prefix=/usr lib=lib install

cd /sources
rm -rf libcap-2.76

echo ">>> Libcap-2.76 — DONE"
