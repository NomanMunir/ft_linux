#!/bin/bash
# Download LFS source files
# Reference: https://www.linuxfromscratch.org/lfs/view/stable/chapter03/packages.html

set -e

LFS="${1:-/mnt/lfs}"
SOURCES_DIR="$LFS/sources"

echo "========================================"
echo "Downloading LFS Source Files"
echo "========================================"
echo ""

mkdir -p "$SOURCES_DIR"
cd "$SOURCES_DIR"

# Download all required sources
# This is a reference - you can also download them manually or use wget -i

echo "Downloading LFS sources..."
echo "(This may take a while)"
echo ""

# Create sources list file
cat > /tmp/lfs-sources.txt <<'EOF'
https://www.iana.org/assignments/port-numbers/port-numbers.xhtml
https://github.com/mirrors/autoconf/releases/download/v2.71/autoconf-2.71.tar.xz
https://github.com/mirrors/automake/releases/download/v1.16.5/automake-1.16.5.tar.xz
https://github.com/mirror/bash/archive/bash-5.2-release.tar.gz
https://www.kernel.org/pub/linux/utils/boot/grub/grub-2.12.tar.xz
EOF

echo "Source list created at /tmp/lfs-sources.txt"
echo ""
echo "To download all sources, run:"
echo "  cd $SOURCES_DIR"
echo "  wget -i /tmp/lfs-sources.txt"
echo ""
echo "Or manually download from:"
echo "  https://www.linuxfromscratch.org/lfs/view/stable/chapter03/packages.html"
echo ""

echo "========================================"
echo "Sources directory ready"
echo "========================================"
