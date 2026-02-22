#!/bin/bash
# Format root partition

set -e

ROOT_PART="${1:-/dev/sdb3}"

if [ ! -b "$ROOT_PART" ]; then
    echo "Error: Root partition $ROOT_PART does not exist!"
    echo "Usage: $0 /dev/sdb3"
    exit 1
fi

echo "========================================"
echo "Formatting Root Partition: $ROOT_PART"
echo "========================================"
echo ""
echo "WARNING: This will erase all data on $ROOT_PART"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

mkfs.ext4 "$ROOT_PART"

echo ""
echo "========================================"
echo "Root partition formatted successfully!"
echo "========================================"
