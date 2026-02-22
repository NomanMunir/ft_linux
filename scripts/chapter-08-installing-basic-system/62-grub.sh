#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.64: GRUB-2.12
# Run as: root (inside chroot)
# Approximate build time: 0.5 SBU
# Required disk space:    166 MB
# ============================================================
set -euo pipefail

echo ">>> Building GRUB-2.12..."

cd /sources
tar -xf grub-2.12.tar.xz
cd grub-2.12

unset {C,CPP,CXX,LD}FLAGS

echo depends bli part_gpt > grub-core/extra_deps.lst

./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror

make

make install

mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

cd /sources
rm -rf grub-2.12

echo ">>> GRUB-2.12 — DONE"
