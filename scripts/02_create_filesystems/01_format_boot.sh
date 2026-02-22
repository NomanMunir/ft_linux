#!/bin/bash
# Format boot partition

set -e

BOOT_PART="${1:-/dev/sdb1}"

if [ ! -b "$BOOT_PART" ]; then
    echo "Error: Boot partition $BOOT_PART does not exist!"
    echo "Usage: $0 /dev/sdb1"
    exit 1
fi

echo "========================================"
echo "Formatting Boot Partition: $BOOT_PART"
echo "========================================"
echo ""
echo "WARNING: This will erase all data on $BOOT_PART"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

mkfs.ext4 "$BOOT_PART"

echo ""
echo "========================================"
echo "Boot partition formatted successfully!"
echo "========================================"
