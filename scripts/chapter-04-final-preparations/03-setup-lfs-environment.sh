#!/bin/bash
# Chapter 4.4 — Setup lfs user environment
# Run as: lfs user

echo "========================================"
echo " Setting up lfs environment"
echo "========================================"

cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF

cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF

echo "Done! Run: source ~/.bash_profile"
echo ""
echo "Then verify:"
echo "  echo \$LFS       # /mnt/lfs"
echo "  echo \$LFS_TGT   # x86_64-lfs-linux-gnu"
echo "  echo \$MAKEFLAGS  # -j<cores>"
