#!/bin/bash
# Setup swap partition

set -e

SWAP_PART="${1:-/dev/sdb2}"

if [ ! -b "$SWAP_PART" ]; then
    echo "Error: Swap partition $SWAP_PART does not exist!"
    echo "Usage: $0 /dev/sdb2"
    exit 1
fi

echo "========================================"
echo "Setting Up Swap: $SWAP_PART"
echo "========================================"
echo ""
echo "WARNING: This will erase all data on $SWAP_PART"
read -p "Continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

mkswap "$SWAP_PART"
swapon "$SWAP_PART"

echo ""
echo "========================================"
echo "Swap setup complete!"
echo "========================================"
echo ""
swapon --show
