# Building LFS System

This directory is for reference during the build process.

## Manual Steps

The actual build process in LFS involves many individual package compilations. Rather than scripting this (which could be error-prone), follow the official LFS book:

https://www.linuxfromscratch.org/lfs/view/stable/

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
