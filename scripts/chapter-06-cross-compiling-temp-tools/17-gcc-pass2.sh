#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 6.18: GCC-15.2.0 — Pass 2
# Run as: lfs user
# Approximate build time: 4.5 SBU
# Required disk space:    6.0 GB
# ============================================================
set -euo pipefail

echo ">>> Building GCC-15.2.0 — Pass 2..."

cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

# Extract dependencies
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

# Fix lib64 → lib on x86_64
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

# Enable POSIX threads for libgcc and libstdc++
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build
cd build

../configure                                     \
    --build=$(../config.guess)                   \
    --host=$LFS_TGT                              \
    --target=$LFS_TGT                            \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc   \
    --prefix=/usr                                \
    --with-build-sysroot=$LFS                    \
    --enable-default-pie                         \
    --enable-default-ssp                         \
    --disable-nls                                \
    --disable-multilib                           \
    --disable-libatomic                          \
    --disable-libgomp                            \
    --disable-libquadmath                        \
    --disable-libsanitizer                       \
    --disable-libssp                             \
    --disable-libvtv                             \
    --enable-languages=c,c++

make
make DESTDIR=$LFS install

# Create cc → gcc symlink
ln -sv gcc $LFS/usr/bin/cc

cd $LFS/sources
rm -rf gcc-15.2.0

echo ">>> GCC-15.2.0 Pass 2 — DONE"
