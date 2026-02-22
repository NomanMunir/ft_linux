# Building LFS System

This directory is for reference during the build process.

## ft_linux Subject Requirements (nmunir)

- Kernel version must include your login: `-nmunir`
- Kernel sources must be in `/usr/src/kernel-<version>`
- Hostname must be `nmunir`
- Boot kernel name in `/boot`:
   - `vmlinuz-<linux_version>-nmunir`
- Must have at least 3 partitions: `/`, `/boot`, swap
- Must use a bootloader (GRUB or LILO)
- Must use a service manager (SysVinit or systemd)
- Must include a kernel module loader (udev/eudev)

## Manual Steps

The actual build process in LFS involves many individual package compilations. Rather than scripting this (which could be error-prone), follow the official LFS book:

https://www.linuxfromscratch.org/lfs/view/stable/

## Chapter 4 Commands (Setup)

### 4.2 Create Directory Layout (as root)
```bash
export LFS=/mnt/lfs

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/tools
```

### 4.3 Add lfs User (as root)
```bash
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs

chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

su - lfs
```

### 4.4 Set Up lfs Environment (as user lfs)
```bash
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

source ~/.bash_profile
```

### Disable Host bashrc (as root)
```bash
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
```

## Key Phases

1. **Chapter 4**: Building the LFS System
   - Mount virtual filesystems
   - Create essential directories
   - Add essential files

2. **Chapter 5**: Installing Compiling Tools
   - Cross-compiler
   - libc headers
   - libc
   - libstdc++

3. **Chapter 6**: Cross Compiling Temporary Tools
   - Various build tools

4. **Chapter 7**: Entering Chroot
   - Create virtual filesystems in chroot
   - Prepare for building final system

5. **Chapter 8**: Installing Basic System Software
   - ~30 required packages from subject.txt

6. **Chapter 9**: System Configuration
   - Bootloader
   - Hostname
   - Network
   - Services

7. **Chapter 10**: Making the LFS System Bootable
   - Linux kernel build
   - Grub configuration

## Chapter 5 Commands (Reference)

### Binutils-2.45 - Pass 1 (as user lfs)
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

### GCC-15.2.0 - Pass 1 (as user lfs)
```bash
cd $LFS/sources
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0

tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc

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

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
   `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h

cd $LFS/sources
rm -rf gcc-15.2.0
```

### Linux-6.16.1 API Headers (as user lfs)
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

## Quick Reference: Virtual Filesystems (Chroot)

```bash
# Mount virtual filesystems
mount -v --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

# Enter chroot
chroot "$LFS" /usr/bin/env -i \
   HOME=/root TERM="$TERM" \
   PS1='(lfs chroot) \u:\w\$ ' \
   PATH=/usr/bin:/usr/sbin \
   /bin/bash --login
```

## Post-Build

After building, you'll need to:
1. Build the Linux kernel
2. Install Grub bootloader
3. Configure /etc/fstab
4. Configure bootloader

Refer to the LFS book chapters 9-10 for detailed instructions.
