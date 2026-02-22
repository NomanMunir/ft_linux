#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.54: Wheel-0.46.1
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    1 MB
# ============================================================
set -euo pipefail

echo ">>> Building Wheel-0.46.1..."

cd /sources
tar -xf wheel-0.46.1.tar.gz
cd wheel-0.46.1

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist wheel

cd /sources
rm -rf wheel-0.46.1

echo ">>> Wheel-0.46.1 — DONE"
