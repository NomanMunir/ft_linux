#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.72: Texinfo-7.2
# Run as: root (inside chroot)
# Approximate build time: 0.3 SBU
# Required disk space:    130 MB
# ============================================================
set -euo pipefail

echo ">>> Building Texinfo-7.2..."

cd /sources
tar -xf texinfo-7.2.tar.xz
cd texinfo-7.2

./configure --prefix=/usr

make

make check

make install

make TEXMF=/usr/share/texmf install-tex

pushd /usr/share/info
  rm -v dir
  for f in *; do
    install-info $f dir 2>/dev/null
  done
popd

cd /sources
rm -rf texinfo-7.2

echo ">>> Texinfo-7.2 — DONE"
