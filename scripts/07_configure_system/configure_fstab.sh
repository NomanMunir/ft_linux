#!/bin/bash
# Configure /etc/fstab

set -e

ROOT_PART="${1:-/dev/sdb3}"
BOOT_PART="${2:-/dev/sdb1}"
LFS="${3:-/mnt/lfs}"

echo "========================================"
echo "Configuring /etc/fstab"
echo "========================================"
echo ""

# Get UUIDs
ROOT_UUID=$(blkid -s UUID -o value "$ROOT_PART")
BOOT_UUID=$(blkid -s UUID -o value "$BOOT_PART")

echo "Root partition UUID: $ROOT_UUID"
echo "Boot partition UUID: $BOOT_UUID"
echo ""

# Create /etc/fstab
cat > "$LFS/etc/fstab" <<EOF
# /etc/fstab: static file system information

UUID=$ROOT_UUID  /           ext4   defaults            1   1
UUID=$BOOT_UUID  /boot       ext4   defaults            1   2
proc             /proc       proc   nosuid,noexec,nodev 0   0
sysfs            /sys        sysfs  nosuid,noexec,nodev 0   0
devpts           /dev/pts    devpts gid=5,mode=620      0   0
tmpfs            /run        tmpfs  defaults            0   0
devtmpfs         /dev        devtmpfs mode=0755,nosuid  0   0
EOF

echo "========================================"
echo "/etc/fstab created successfully!"
echo "========================================"
echo ""
echo "File location: $LFS/etc/fstab"
echo ""
cat "$LFS/etc/fstab"
