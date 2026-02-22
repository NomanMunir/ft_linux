#!/bin/bash
# Chapter 4.2 — Create limited directory layout in LFS
# Run as: root

set -e

export LFS=/mnt/lfs

echo "========================================"
echo " Creating LFS Directory Layout"
echo "========================================"

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools

echo ""
echo "Done! Layout:"
ls -la $LFS/
