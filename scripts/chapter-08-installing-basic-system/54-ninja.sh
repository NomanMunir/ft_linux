#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.56: Ninja-1.13.1
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    79 MB
# ============================================================
set -euo pipefail

echo ">>> Building Ninja-1.13.1..."

cd /sources
tar -xf ninja-1.13.1.tar.gz
cd ninja-1.13.1

python3 configure.py --bootstrap --verbose

install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion /usr/share/zsh/site-functions/_ninja

cd /sources
rm -rf ninja-1.13.1

echo ">>> Ninja-1.13.1 — DONE"
