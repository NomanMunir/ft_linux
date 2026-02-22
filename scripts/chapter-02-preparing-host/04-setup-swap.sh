#!/bin/bash
# Chapter 2 — Setup swap partition
# Usage: bash 04-setup-swap.sh /dev/sdb2
# Run as: root

set -e
SWAP="${1:-/dev/sdb2}"
echo "Initializing swap: $SWAP"
mkswap "$SWAP"
swapon "$SWAP"
echo "Done!"
swapon --show
