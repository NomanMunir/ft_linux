#!/bin/bash
# Chapter 2 — Format boot partition
# Usage: bash 03-format-boot.sh /dev/sdb1
# Run as: root

set -e
BOOT="${1:-/dev/sdb1}"
echo "Formatting boot partition: $BOOT"
mkfs -v -t ext4 "$BOOT"
echo "Done!"
