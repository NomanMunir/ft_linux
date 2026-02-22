#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.52: Flit-Core-3.12.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    2 MB
# ============================================================
set -euo pipefail

echo ">>> Building Flit-Core-3.12.0..."

cd /sources
tar -xf flit_core-3.12.0.tar.gz
cd flit_core-3.12.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist flit_core

cd /sources
rm -rf flit_core-3.12.0

echo ">>> Flit-Core-3.12.0 — DONE"
