#!/bin/bash
# Chapter 4.3 — Add lfs user and set ownership
# Run as: root

set -e

export LFS=/mnt/lfs

echo "========================================"
echo " Creating lfs User"
echo "========================================"

groupadd lfs 2>/dev/null || echo "Group lfs already exists"
useradd -s /bin/bash -g lfs -m -k /dev/null lfs 2>/dev/null || echo "User lfs already exists"

echo "Set password for lfs user:"
passwd lfs

echo ""
echo "Setting ownership..."
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

echo ""
echo "Done! Switch to lfs user with: su - lfs"
