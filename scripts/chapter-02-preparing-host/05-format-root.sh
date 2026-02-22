#!/bin/bash
# Chapter 2 — Format root partition
# Usage: bash 05-format-root.sh /dev/sdb3
# Run as: root

set -e
ROOT="${1:-/dev/sdb3}"
echo "Formatting root partition: $ROOT"
mkfs -v -t ext4 "$ROOT"
echo "Done!"
