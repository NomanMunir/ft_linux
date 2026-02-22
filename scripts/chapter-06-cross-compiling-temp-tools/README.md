# Chapter 6 — Cross Compiling Temporary Tools

> **LFS Version:** 12.4
> **Run as:** lfs user
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter06/chapter06.html

---

## 6.1 Overview

Cross-compile a minimal set of tools using the cross-toolchain from Chapter 5.
These temporary tools let us enter a chroot and build the final system.

All packages follow the same pattern:
```
cd $LFS/sources
tar -xf <package>.tar.xz
cd <package>
./configure --prefix=/usr --host=$LFS_TGT --build=$(...)
make
make DESTDIR=$LFS install
cd $LFS/sources && rm -rf <package>
```

---

## Package List

| # | Section | Package | Build Time | Disk |
|---|---------|---------|------------|------|
| 01 | 6.2 | M4-1.4.20 | 0.1 SBU | 38 MB |
| 02 | 6.3 | Ncurses-6.5-20250809 | 0.4 SBU | 54 MB |
| 03 | 6.4 | Bash-5.3 | 0.2 SBU | 72 MB |
| 04 | 6.5 | Coreutils-9.7 | 0.3 SBU | 181 MB |
| 05 | 6.6 | Diffutils-3.12 | 0.1 SBU | 35 MB |
| 06 | 6.7 | File-5.46 | 0.1 SBU | 42 MB |
| 07 | 6.8 | Findutils-4.10.0 | 0.2 SBU | 48 MB |
| 08 | 6.9 | Gawk-5.3.2 | 0.1 SBU | 49 MB |
| 09 | 6.10 | Grep-3.12 | 0.1 SBU | 32 MB |
| 10 | 6.11 | Gzip-1.14 | 0.1 SBU | 12 MB |
| 11 | 6.12 | Make-4.4.1 | < 0.1 SBU | 15 MB |
| 12 | 6.13 | Patch-2.8 | 0.1 SBU | 14 MB |
| 13 | 6.14 | Sed-4.9 | 0.1 SBU | 21 MB |
| 14 | 6.15 | Tar-1.35 | 0.1 SBU | 42 MB |
| 15 | 6.16 | Xz-5.8.1 | 0.1 SBU | 23 MB |
| 16 | 6.17 | Binutils-2.45 — Pass 2 | 0.4 SBU | 548 MB |
| 17 | 6.18 | GCC-15.2.0 — Pass 2 | 4.5 SBU | 6.0 GB |

**Total estimated disk:** ~7.2 GB  
**Total estimated time:** ~7 SBU

---

## 6.2 M4-1.4.20

A macro processor used by many other tools.

```bash
cd $LFS/sources
tar -xf m4-1.4.20.tar.xz && cd m4-1.4.20

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf m4-1.4.20
```

---

## 6.3 Ncurses-6.5-20250809

Terminal-independent character screen handling library.

```bash
cd $LFS/sources
tar -xf ncurses-6.5-20250809.tar.xz && cd ncurses-6.5-20250809

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

ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i $LFS/usr/include/curses.h

cd $LFS/sources && rm -rf ncurses-6.5-20250809
```

---

## 6.4 Bash-5.3

The Bourne-Again Shell.

```bash
cd $LFS/sources
tar -xf bash-5.3.tar.gz && cd bash-5.3

./configure --prefix=/usr                      \
            --build=$(sh support/config.guess) \
            --host=$LFS_TGT                    \
            --without-bash-malloc
make
make DESTDIR=$LFS install

ln -sv bash $LFS/bin/sh

cd $LFS/sources && rm -rf bash-5.3
```

---

## 6.5 Coreutils-9.7

Basic utility programs (ls, cp, mv, etc.).

```bash
cd $LFS/sources
tar -xf coreutils-9.7.tar.xz && cd coreutils-9.7

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime
make
make DESTDIR=$LFS install

# Move chroot to /usr/sbin
mv -v $LFS/usr/bin/chroot              $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/'                    $LFS/usr/share/man/man8/chroot.8

cd $LFS/sources && rm -rf coreutils-9.7
```

---

## 6.6 Diffutils-3.12

Programs for showing differences between files.

```bash
cd $LFS/sources
tar -xf diffutils-3.12.tar.xz && cd diffutils-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf diffutils-3.12
```

---

## 6.7 File-5.46

Utility for determining file types.

```bash
cd $LFS/sources
tar -xf file-5.46.tar.gz && cd file-5.46

# Build file for the host first (needed for signature file)
mkdir build
pushd build
  ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/libmagic.la

cd $LFS/sources && rm -rf file-5.46
```

---

## 6.8 Findutils-4.10.0

Programs for finding files (find, xargs, locate).

```bash
cd $LFS/sources
tar -xf findutils-4.10.0.tar.xz && cd findutils-4.10.0

./configure --prefix=/usr                   \
            --localstatedir=/var/lib/locate \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf findutils-4.10.0
```

---

## 6.9 Gawk-5.3.2

Programs for manipulating text files.

```bash
cd $LFS/sources
tar -xf gawk-5.3.2.tar.xz && cd gawk-5.3.2

sed -i 's/extras//' Makefile.in

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf gawk-5.3.2
```

---

## 6.10 Grep-3.12

Programs for searching through file contents.

```bash
cd $LFS/sources
tar -xf grep-3.12.tar.xz && cd grep-3.12

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf grep-3.12
```

---

## 6.11 Gzip-1.14

Programs for compressing/decompressing files.

```bash
cd $LFS/sources
tar -xf gzip-1.14.tar.xz && cd gzip-1.14

./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf gzip-1.14
```

---

## 6.12 Make-4.4.1

Program for controlling compilation of executables.

```bash
cd $LFS/sources
tar -xf make-4.4.1.tar.gz && cd make-4.4.1

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf make-4.4.1
```

---

## 6.13 Patch-2.8

Program for modifying files using diff output.

```bash
cd $LFS/sources
tar -xf patch-2.8.tar.xz && cd patch-2.8

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf patch-2.8
```

---

## 6.14 Sed-4.9

Stream editor.

```bash
cd $LFS/sources
tar -xf sed-4.9.tar.xz && cd sed-4.9

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf sed-4.9
```

---

## 6.15 Tar-1.35

Archiving utility.

```bash
cd $LFS/sources
tar -xf tar-1.35.tar.xz && cd tar-1.35

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

cd $LFS/sources && rm -rf tar-1.35
```

---

## 6.16 Xz-5.8.1

Programs for LZMA/XZ compression.

```bash
cd $LFS/sources
tar -xf xz-5.8.1.tar.xz && cd xz-5.8.1

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.8.1
make
make DESTDIR=$LFS install

rm -v $LFS/usr/lib/liblzma.la

cd $LFS/sources && rm -rf xz-5.8.1
```

---

## 6.17 Binutils-2.45 — Pass 2

Rebuilding the assembler and linker to link against the new Glibc.

```bash
cd $LFS/sources
tar -xf binutils-2.45.tar.xz && cd binutils-2.45

# Fix libtool issue
sed '6031s/$add_dir//' -i ltmain.sh

mkdir -v build && cd build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --enable-gprofng=no        \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-new-dtags         \
    --enable-default-hash-style=gnu
make
make DESTDIR=$LFS install

# Remove libtool archives and static libs
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

cd $LFS/sources && rm -rf binutils-2.45
```

---

## 6.18 GCC-15.2.0 — Pass 2

Rebuilding the full C/C++ compiler for the target system.

```bash
cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz && cd gcc-15.2.0

# Extract dependencies
tar -xf ../mpfr-4.2.2.tar.xz && mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz  && mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz  && mv -v mpc-1.3.1 mpc

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

mkdir -v build && cd build

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

cd $LFS/sources && rm -rf gcc-15.2.0
```

---

## Chapter 6 Complete! ✅

Next: [Chapter 7 — Entering Chroot and Building Additional Temporary Tools](../chapter-07-entering-chroot/README.md)
