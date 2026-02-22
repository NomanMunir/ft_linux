#!/bin/bash
# Mount all partitions for LFS build

set -e

ROOT_PART="${1:-/dev/sdb3}"
BOOT_PART="${2:-/dev/sdb1}"
LFS_MOUNT="${3:-/mnt/lfs}"

echo "========================================"
echo "Mounting Partitions for LFS"
echo "========================================"
echo ""
echo "Root Partition: $ROOT_PART"
echo "Boot Partition: $BOOT_PART"
echo "LFS Mount Point: $LFS_MOUNT"
echo ""

# Create mount point
mkdir -p "$LFS_MOUNT"

# Mount root
echo "Mounting root partition..."
mount "$ROOT_PART" "$LFS_MOUNT"

# Create and mount boot
echo "Mounting boot partition..."
mkdir -p "$LFS_MOUNT/boot"
mount "$BOOT_PART" "$LFS_MOUNT/boot"

echo ""
echo "========================================"
echo "Mount complete!"
echo "========================================"
echo ""

# Verify mounts
echo "Mounted filesystems:"
df -h | grep "$LFS_MOUNT"

echo ""
echo "========================================"
echo "Create fstab entries (manual step)"
echo "========================================"
echo ""
echo "You need to add these to /etc/fstab on the host system:"
echo ""
echo "$(blkid $ROOT_PART) $LFS_MOUNT ext4 defaults 1 1"
echo "$(blkid $BOOT_PART) $LFS_MOUNT/boot ext4 defaults 1 2"
echo "$(blkid /dev/sdb2) none swap sw 0 0"
echo ""
echo "Or run: sudo nano /etc/fstab"
