#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.3: Ncurses-6.5-20250809
# Run as: lfs user
# Approximate build time: 0.4 SBU
# Required disk space:    54 MB
# ============================================================
set -euo pipefail

echo ">>> Building Ncurses-6.5-20250809..."

cd $LFS/sources
tar -xf ncurses-6.5-20250809.tar.xz
cd ncurses-6.5-20250809

# Build tic for the host first
mkdir build
pushd build
  ../configure --prefix=$LFS/tools AWK=gawk
  make -C include
  make -C progs tic
  install progs/tic $LFS/tools/bin
popd

# Cross-compile Ncurses
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-normal             \
            --with-cxx-shared            \
            --without-debug              \
            --without-ada                \
            --disable-stripping          \
            AWK=gawk

make
make DESTDIR=$LFS install

# Create libncurses.so symlink (some programs need it)
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so

# Fix curses.h to always use wide-character definition
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

cd $LFS/sources
rm -rf ncurses-6.5-20250809

echo ">>> Ncurses-6.5-20250809 — DONE"
