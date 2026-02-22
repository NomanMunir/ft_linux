#!/bin/bash
# View available disks and partitions

echo "========================================"
echo "Available Disks and Partitions"
echo "========================================"
echo ""

echo "Using lsblk:"
lsblk
echo ""

echo "Using fdisk:"
fdisk -l
echo ""

echo "========================================"
echo "Identify your disk (e.g., /dev/sdb)"
echo "========================================"
