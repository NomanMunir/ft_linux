#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.75: Jinja2-3.1.6
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    3.4 MB
# ============================================================
set -euo pipefail

echo ">>> Building Jinja2-3.1.6..."

cd /sources
tar -xf jinja2-3.1.6.tar.gz
cd jinja2-3.1.6

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2

cd /sources
rm -rf jinja2-3.1.6

echo ">>> Jinja2-3.1.6 — DONE"
