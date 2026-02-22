#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.36: Bash-5.3
# Run as: root (inside chroot)
# Approximate build time: 0.8 SBU
# Required disk space:    85 MB
# ============================================================
set -euo pipefail

echo ">>> Building Bash-5.3..."

cd /sources
tar -xf bash-5.3.tar.gz
cd bash-5.3

./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            bash_cv_strtold_broken=no \
            --docdir=/usr/share/doc/bash-5.3

make

chown -R tester .
su tester -c "PATH=$PATH make tests < $(tty)"

make install

# NOTE: Run manually after this script completes:
#   exec /usr/bin/bash --login

cd /sources
rm -rf bash-5.3

echo ">>> Bash-5.3 — DONE"
