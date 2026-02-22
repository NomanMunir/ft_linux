#!/bin/bash
# Chapter 3 — Download required patches for LFS 12.4
# Run as: root

set -e

export LFS=/mnt/lfs
cd $LFS/sources

echo "========================================"
echo " Downloading LFS 12.4 Patches"
echo "========================================"

wget https://www.linuxfromscratch.org/patches/lfs/12.4/bzip2-1.0.8-install_docs-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/coreutils-9.7-upstream_fix-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/coreutils-9.7-i18n-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/expect-5.45.4-gcc15-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/glibc-2.42-fhs-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/kbd-2.8.0-backspace-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/sysvinit-3.14-consolidated-1.patch

echo ""
echo "Done! Patches downloaded:"
ls -lh $LFS/sources/*.patch
