#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.53: Packaging-25.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    2 MB
# ============================================================
set -euo pipefail

echo ">>> Building Packaging-25.0..."

cd /sources
tar -xf packaging-25.0.tar.gz
cd packaging-25.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist packaging

cd /sources
rm -rf packaging-25.0

echo ">>> Packaging-25.0 — DONE"
