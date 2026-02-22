#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.85: Cleanup
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    Frees space
# ============================================================
set -euo pipefail

echo ">>> Cleaning up..."

# Remove libtool .la files
find /usr/lib /usr/libexec -name \*.la -delete

# Remove the temporary cross-compiler
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

# Remove the temporary tester user (if exists)
userdel -r tester 2>/dev/null || true

echo ">>> Cleanup — DONE"
