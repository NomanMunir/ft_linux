#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 5.5: Glibc-2.42
# Run as: lfs user
# Approximate build time: 1.4 SBU
# Required disk space:    870 MB
# ============================================================
set -euo pipefail

echo ">>> Building Glibc-2.42..."

cd $LFS/sources
tar -xf glibc-2.42.tar.xz
cd glibc-2.42

# Create LSB compatibility symlinks
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac

# Apply FHS compliance patch
patch -Np1 -i ../glibc-2.42-fhs-1.patch

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

time { ../configure                             \
          --prefix=/usr                      \
          --host=$LFS_TGT                    \
          --build=$(../scripts/config.guess) \
          --disable-nscd                     \
          libc_cv_slibdir=/usr/lib           \
          --enable-kernel=5.4 \
      && make \
      && make DESTDIR=$LFS install; }

# Fix ldd script
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo ""
echo "=== SANITY CHECKS ==="
echo ""

echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log

echo "--- Program interpreter (expect: /lib64/ld-linux-x86-64.so.2):"
readelf -l a.out | grep ': /lib'

echo ""
echo "--- crt objects (expect 3 lines ending with 'succeeded'):"
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log

echo ""
echo "--- Include search path (expect $LFS/usr/include):"
grep -B3 "^ $LFS/usr/include" dummy.log

echo ""
echo "--- SEARCH directories:"
grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'

echo ""
echo "--- libc.so.6 (expect: attempt to open succeeded):"
grep "/lib.*/libc.so.6 " dummy.log

echo ""
echo "--- ld-linux found:"
grep found dummy.log

rm -v a.out dummy.log

cd $LFS/sources
rm -rf glibc-2.42

echo ""
echo ">>> Glibc-2.42 — DONE"
