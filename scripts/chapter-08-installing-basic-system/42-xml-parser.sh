#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.44: XML::Parser-2.47
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    2.4 MB
# ============================================================
set -euo pipefail

echo ">>> Building XML::Parser-2.47..."

cd /sources
tar -xf XML-Parser-2.47.tar.gz
cd XML-Parser-2.47

perl Makefile.PL
make
make test
make install

cd /sources
rm -rf XML-Parser-2.47

echo ">>> XML::Parser-2.47 — DONE"
