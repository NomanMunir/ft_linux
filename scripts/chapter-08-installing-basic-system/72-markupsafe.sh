#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.74: MarkupSafe-3.0.2
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    0.5 MB
# ============================================================
set -euo pipefail

echo ">>> Building MarkupSafe-3.0.2..."

cd /sources
tar -xf markupsafe-3.0.2.tar.gz
cd markupsafe-3.0.2

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Markupsafe

cd /sources
rm -rf markupsafe-3.0.2

echo ">>> MarkupSafe-3.0.2 — DONE"
