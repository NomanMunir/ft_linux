# Chapter 5 — Compiling a Cross-Toolchain

> **LFS Version:** 12.4
> **Run as:** lfs user
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter05/chapter05.html

---

## 5.1 Overview

Build a cross-compiler and associated tools. These are installed in `$LFS/tools/`
to keep them separate from the final system. Libraries go to their final locations.

**Build order matters!** Binutils first, then GCC, then Linux headers, then Glibc, then Libstdc++.

### What is a cross-toolchain?
A set of tools (compiler, linker, libraries) that build programs for the LFS system
without depending on the host system.

---

## 5.2 Binutils-2.45 — Pass 1

**What:** Assembler, linker, and other binary tools.
**Why first:** GCC and Glibc test the linker/assembler to decide which features to enable.
**Build time:** ~1 SBU | **Disk:** 678 MB

```bash
cd $LFS/sources
tar -xf binutils-2.45.tar.xz
cd binutils-2.45
mkdir -v build
cd build

time { ../configure --prefix=$LFS/tools \
                    --with-sysroot=$LFS \
                    --target=$LFS_TGT   \
                    --disable-nls       \
                    --enable-gprofng=no \
                    --disable-werror    \
                    --enable-new-dtags  \
                    --enable-default-hash-style=gnu \
      && make \
      && make install; }

cd $LFS/sources
rm -rf binutils-2.45
```

**Script:** `bash scripts/chapter-05-cross-toolchain/01-binutils-pass1.sh`

---

## 5.3 GCC-15.2.0 — Pass 1

**What:** The GNU C and C++ compiler.
**Why:** Needed to compile everything else.
**Build time:** ~3.8 SBU | **Disk:** 5.4 GB

GCC requires GMP, MPFR, and MPC — extract them inside the GCC source tree.

```bash
cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

# Extract required dependencies into GCC source tree
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

# Create full limits.h header
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

cd $LFS/sources
rm -rf gcc-15.2.0
```

**Script:** `bash scripts/chapter-05-cross-toolchain/02-gcc-pass1.sh`

---

## 5.4 Linux-6.16.1 API Headers

**What:** Sanitized kernel headers for Glibc to build against.
**Why:** Glibc needs to know the kernel's API to interface with it.
**Build time:** < 0.1 SBU | **Disk:** 1.7 GB

```bash
cd $LFS/sources
tar -xf linux-6.16.1.tar.xz
cd linux-6.16.1

make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

cd $LFS/sources
rm -rf linux-6.16.1
```

**Script:** `bash scripts/chapter-05-cross-toolchain/03-linux-api-headers.sh`

---

## 5.5 Glibc-2.42

**What:** The main C library — provides memory allocation, file I/O, string handling, etc.
**Why:** Every C program links against Glibc. It's the foundation of the system.
**Build time:** ~1.4 SBU | **Disk:** 870 MB

```bash
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

# === SANITY CHECKS (important!) ===
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# Expected: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
# Expected: 3 lines ending with "succeeded"

grep -B3 "^ $LFS/usr/include" dummy.log
# Expected: shows $LFS/usr/include in search path

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
# Expected: paths starting with =

grep "/lib.*/libc.so.6 " dummy.log
# Expected: attempt to open /mnt/lfs/usr/lib/libc.so.6 succeeded

grep found dummy.log
# Expected: found ld-linux-x86-64.so.2 at /mnt/lfs/usr/lib/...

rm -v a.out dummy.log

cd $LFS/sources
rm -rf glibc-2.42
```

**Script:** `bash scripts/chapter-05-cross-toolchain/04-glibc.sh`

---

## 5.6 Libstdc++ from GCC-15.2.0

**What:** The standard C++ library.
**Why:** GCC is partly written in C++, so it needs this library. Was deferred because it depends on Glibc.
**Build time:** ~0.2 SBU | **Disk:** 1.3 GB

```bash
cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

mkdir -v build
cd build

time { ../libstdc++-v3/configure      \
          --host=$LFS_TGT            \
          --build=$(../config.guess) \
          --prefix=/usr              \
          --disable-multilib         \
          --disable-nls              \
          --disable-libstdcxx-pch    \
          --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0 \
      && make \
      && make DESTDIR=$LFS install; }

# Remove harmful libtool archive files
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la

cd $LFS/sources
rm -rf gcc-15.2.0
```

**Script:** `bash scripts/chapter-05-cross-toolchain/05-libstdcpp.sh`

---

## Chapter 5 Complete! ✅

Next: [Chapter 6 — Cross Compiling Temporary Tools](../chapter-06-cross-compiling-temp-tools/README.md)
