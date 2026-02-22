#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.82: SysVinit-3.14
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    2.6 MB
# ============================================================
set -euo pipefail

echo ">>> Building SysVinit-3.14..."

cd /sources
tar -xf sysvinit-3.14.tar.xz
cd sysvinit-3.14

patch -Np1 -i ../sysvinit-3.14-consolidated-1.patch

make

make install

cd /sources
rm -rf sysvinit-3.14

echo ">>> SysVinit-3.14 — DONE"
