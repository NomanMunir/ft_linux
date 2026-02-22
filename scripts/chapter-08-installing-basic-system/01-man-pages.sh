#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.3: Man-pages-6.15
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    33 MB
# ============================================================
set -euo pipefail

echo ">>> Building Man-pages-6.15..."

cd /sources
tar -xf man-pages-6.15.tar.xz
cd man-pages-6.15

make -R install

cd /sources
rm -rf man-pages-6.15

echo ">>> Man-pages-6.15 — DONE"
