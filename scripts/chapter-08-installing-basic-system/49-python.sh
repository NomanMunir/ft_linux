#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.51: Python-3.13.7
# Run as: root (inside chroot)
# Approximate build time: 1.6 SBU
# Required disk space:    490 MB
# ============================================================
set -euo pipefail

echo ">>> Building Python-3.13.7..."

cd /sources
tar -xf Python-3.13.7.tar.xz
cd Python-3.13.7

./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --enable-optimizations
make
make install

cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF

install -v -dm755 /usr/share/doc/python-3.13.7/html

cd /sources
rm -rf Python-3.13.7

echo ">>> Python-3.13.7 — DONE"
