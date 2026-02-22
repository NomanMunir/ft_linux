#!/bin/bash
# Chapter 3 — Download all LFS source packages
# Run as: root

set -e

export LFS=/mnt/lfs

echo "========================================"
echo " Downloading LFS 12.4 Source Packages"
echo "========================================"

mkdir -pv $LFS/sources
chmod -v a+wt $LFS/sources
cd $LFS/sources

echo "Downloading from mirror..."
wget -r --no-parent -nd https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/

echo ""
echo "Downloading md5sums..."
wget https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/md5sums -O md5sums

echo ""
echo "Verifying checksums..."
md5sum -c md5sums

echo ""
echo "Changing ownership to root..."
chown root:root $LFS/sources/*

echo ""
echo "Done! Files downloaded:"
ls $LFS/sources/ | wc -l
