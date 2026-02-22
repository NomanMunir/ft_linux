#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.5: Coreutils-9.7
# Run as: lfs user
# Approximate build time: 0.3 SBU
# Required disk space:    181 MB
# ============================================================
set -euo pipefail

echo ">>> Building Coreutils-9.7..."

cd $LFS/sources
tar -xf coreutils-9.7.tar.xz
cd coreutils-9.7

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime

make
make DESTDIR=$LFS install

# Move chroot to /usr/sbin (hardcoded paths expect this)
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

cd $LFS/sources
rm -rf coreutils-9.7

echo ">>> Coreutils-9.7 — DONE"
