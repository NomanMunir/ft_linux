#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.66: IPRoute2-6.14.0
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    18 MB
# ============================================================
set -euo pipefail

echo ">>> Building IPRoute2-6.14.0..."

cd /sources
tar -xf iproute2-6.14.0.tar.xz
cd iproute2-6.14.0

sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make NETNS_RUN_DIR=/run/netns

make SBINDIR=/usr/sbin install

mkdir -pv /usr/share/doc/iproute2-6.14.0
cp -v COPYING README* /usr/share/doc/iproute2-6.14.0

cd /sources
rm -rf iproute2-6.14.0

echo ">>> IPRoute2-6.14.0 — DONE"
