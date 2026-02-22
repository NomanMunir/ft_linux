#!/bin/bash
# Chapter 2 — Partition disk for LFS
# Usage: bash 02-partition-disk.sh /dev/sdb
# Run as: root
# Creates: 200MB boot, 4GB swap, rest for root

set -e
DISK="${1:-/dev/sdb}"

if [ ! -b "$DISK" ]; then
    echo "Error: Disk $DISK not found!"
    echo "Usage: $0 /dev/sdb"
    exit 1
fi

echo "========================================"
echo " Partitioning: $DISK"
echo "========================================"
echo ""
echo "  Partition 1: 200MB  /boot  (Linux filesystem)"
echo "  Partition 2: 4GB    swap   (Linux swap)"
echo "  Partition 3: rest   /      (Linux root)"
echo ""
echo "WARNING: All data on $DISK will be erased!"
read -p "Continue? (yes/no): " confirm
[ "$confirm" = "yes" ] || exit 0

fdisk "$DISK" <<EOF
o
n
p
1

+200M
n
p
2

+4G
n
p
3


t
1
83
t
2
82
t
3
83
w
EOF

echo ""
echo "Done! Partitions:"
fdisk -l "$DISK" | grep "^${DISK}[0-9]"
