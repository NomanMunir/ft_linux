#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.4: Iana-Etc-20250807
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    5 MB
# ============================================================
set -euo pipefail

echo ">>> Building Iana-Etc-20250807..."

cd /sources
tar -xf iana-etc-20250807.tar.gz
cd iana-etc-20250807

cp services protocols /etc

cd /sources
rm -rf iana-etc-20250807

echo ">>> Iana-Etc-20250807 — DONE"
