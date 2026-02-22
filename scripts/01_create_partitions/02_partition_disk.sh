#!/bin/bash
# Create partitions on disk
# Usage: ./02_partition_disk.sh /dev/sdb

set -e

DISK="${1:-/dev/sdb}"

if [ ! -b "$DISK" ]; then
    echo "Error: Disk $DISK does not exist!"
    echo "Usage: $0 /dev/sdb"
    exit 1
fi

echo "========================================"
echo "Partitioning Disk: $DISK"
echo "========================================"
echo ""
echo "This will create:"
echo "  - Partition 1: 200MB (/boot)"
echo "  - Partition 2: 4GB (Swap)"
echo "  - Partition 3: Remaining (Root /)"
echo ""
echo "WARNING: This will erase all data on $DISK"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

# Start fdisk
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
echo "========================================"
echo "Partitioning complete!"
echo "========================================"
echo ""
echo "Partitions created:"
fdisk -l "$DISK" | grep -E "^${DISK}[0-9]"
