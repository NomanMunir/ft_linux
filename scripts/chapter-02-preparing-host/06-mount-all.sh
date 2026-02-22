#!/bin/bash
# Chapter 2 — Mount all LFS partitions
# Usage: bash 06-mount-all.sh
# Run as: root

set -e

export LFS=/mnt/lfs

echo "Mounting LFS partitions..."

mkdir -pv $LFS
mount /dev/sdb3 $LFS

mkdir -pv $LFS/boot
mount /dev/sdb1 $LFS/boot

swapon /dev/sdb2

echo ""
echo "Done! Mounted filesystems:"
df -h | grep "$LFS"
swapon --show
