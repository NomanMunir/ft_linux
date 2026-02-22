#!/bin/bash
# Configure system hostname

set -e

HOSTNAME="${1:-ft_linux}"
LFS="${2:-/mnt/lfs}"

echo "========================================"
echo "Setting Hostname"
echo "========================================"
echo ""

echo "Hostname will be set to: $HOSTNAME"
echo ""

# Create /etc/hostname in the LFS system
cat > "$LFS/etc/hostname" <<EOF
$HOSTNAME
EOF

# Create /etc/hosts
cat > "$LFS/etc/hosts" <<EOF
127.0.0.1   localhost
::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters
EOF

echo "========================================"
echo "Hostname configuration complete!"
echo "========================================"
echo ""
echo "Files created:"
echo "  $LFS/etc/hostname"
echo "  $LFS/etc/hosts"
