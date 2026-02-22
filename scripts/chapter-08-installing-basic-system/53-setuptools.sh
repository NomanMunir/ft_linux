#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.55: Setuptools-80.9.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    20 MB
# ============================================================
set -euo pipefail

echo ">>> Building Setuptools-80.9.0..."

cd /sources
tar -xf setuptools-80.9.0.tar.gz
cd setuptools-80.9.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools

cd /sources
rm -rf setuptools-80.9.0

echo ">>> Setuptools-80.9.0 — DONE"
