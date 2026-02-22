#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.28: Shadow-4.17.4
# Run as: root (inside chroot)
# Approximate build time: 0.1 SBU
# Required disk space:    46 MB
# ============================================================
set -euo pipefail

echo ">>> Building Shadow-4.17.4..."

cd /sources
tar -xf shadow-4.17.4.tar.xz
cd shadow-4.17.4

sed -i 's/groups$(EXEEXT) //' src/Makefile.in

find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                    \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                   \
    -i etc/login.defs

touch /usr/bin/passwd

./configure --sysconfdir=/etc  \
            --disable-static   \
            --with-{b,yes}crypt \
            --without-libbsd   \
            --with-group-name-max-length=32

make

make exec_prefix=/usr install
make -C man install-man

pwconv
grpconv

mkdir -p /etc/default
useradd -D --gid 999

# Note: root password should be set manually with: passwd root

cd /sources
rm -rf shadow-4.17.4

echo ">>> Shadow-4.17.4 — DONE"
