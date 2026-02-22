#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.7: Gettext-0.26 (Temporary Tools)
# Run as: root (inside chroot)
# Approximate build time: 1.5 SBU
# Required disk space:    463 MB
# ============================================================
set -euo pipefail

echo ">>> Building Gettext-0.26..."

cd /sources
tar -xf gettext-0.26.tar.xz
cd gettext-0.26

./configure --disable-shared

make

# Install only the three needed programs
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

cd /sources
rm -rf gettext-0.26

echo ">>> Gettext-0.26 — DONE"
