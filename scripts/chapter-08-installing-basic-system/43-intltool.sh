#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.45: Intltool-0.51.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    1.5 MB
# ============================================================
set -euo pipefail

echo ">>> Building Intltool-0.51.0..."

cd /sources
tar -xf intltool-0.51.0.tar.gz
cd intltool-0.51.0

sed -i 's:\\\${:\$\\{:' intltool-update.in

./configure --prefix=/usr
make
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

cd /sources
rm -rf intltool-0.51.0

echo ">>> Intltool-0.51.0 — DONE"
