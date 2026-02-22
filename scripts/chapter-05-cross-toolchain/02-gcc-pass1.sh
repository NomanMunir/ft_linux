#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 5.3: GCC-15.2.0 — Pass 1
# Run as: lfs user
# Approximate build time: 3.8 SBU
# Required disk space:    5.4 GB
# ============================================================
set -euo pipefail

echo ">>> Building GCC-15.2.0 — Pass 1..."

cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

# Extract required dependencies
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

# Fix lib64 → lib on x86_64
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir -v build
cd build

time { ../configure                  \
          --target=$LFS_TGT         \
          --prefix=$LFS/tools       \
          --with-glibc-version=2.42 \
          --with-sysroot=$LFS       \
          --with-newlib             \
          --without-headers         \
          --enable-default-pie      \
          --enable-default-ssp      \
          --disable-nls             \
          --disable-shared          \
          --disable-multilib        \
          --disable-threads         \
          --disable-libatomic       \
          --disable-libgomp         \
          --disable-libquadmath     \
          --disable-libssp          \
          --disable-libvtv          \
          --disable-libstdcxx       \
          --enable-languages=c,c++  \
      && make \
      && make install; }

# Create the full limits.h header
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  $(dirname $($LFS_TGT-gcc -print-libgcc-file-name))/include/limits.h

cd $LFS/sources
rm -rf gcc-15.2.0

echo ">>> GCC-15.2.0 Pass 1 — DONE"
