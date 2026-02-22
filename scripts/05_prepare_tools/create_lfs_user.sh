#!/bin/bash
# Create LFS user and setup environment

set -e

LFS="${1:-/mnt/lfs}"

echo "========================================"
echo "Creating LFS User and Environment"
echo "========================================"
echo ""

# Create lfs group if it doesn't exist
if ! getent group lfs > /dev/null; then
    echo "Creating lfs group..."
    groupadd lfs
else
    echo "lfs group already exists"
fi

# Create lfs user if it doesn't exist
if ! id -u lfs > /dev/null 2>&1; then
    echo "Creating lfs user..."
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
else
    echo "lfs user already exists"
fi

# Set ownership
echo "Setting ownership of $LFS to lfs..."
chown -v lfs:lfs "$LFS"
chown -v lfs:lfs "$LFS/sources"

# Create .bashrc for lfs user
echo "Setting up lfs user environment..."
cat > /home/lfs/.bashrc <<'EOF'
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
if [ ! -L /sbin ]; then PATH=/sbin:$PATH; fi
if [ ! -L /usr/sbin ]; then PATH=/usr/sbin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS='-j4'
EOF

# Set ownership of .bashrc
chown lfs:lfs /home/lfs/.bashrc

echo ""
echo "========================================"
echo "LFS user setup complete!"
echo "========================================"
echo ""
echo "To switch to lfs user:"
echo "  su - lfs"
echo ""
echo "Verify environment:"
echo "  echo \$LFS"
echo "  echo \$MAKEFLAGS"
