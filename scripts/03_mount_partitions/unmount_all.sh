#!/bin/bash
# Unmount all LFS partitions

set -e

LFS_MOUNT="${1:-/mnt/lfs}"

echo "========================================"
echo "Unmounting LFS Partitions"
echo "========================================"
echo ""

# Unmount recursively
umount -R "$LFS_MOUNT" 2>/dev/null || true

# Turn off swap
swapoff -a 2>/dev/null || true

echo "Unmount complete!"
echo ""
echo "Current mounts:"
mount | grep "$LFS_MOUNT" || echo "No LFS mounts found"
