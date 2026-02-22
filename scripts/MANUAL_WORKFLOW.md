# ft_linux — Manual LFS 12.4 Build Workflow

> **Username:** nmunir | **Init:** SysVinit | **Host:** Debian 12 in VirtualBox
> **Disk:** /dev/sdb → sdb1 (boot 200MB), sdb2 (swap 4GB), sdb3 (root ~16GB)
> **LFS mount:** /mnt/lfs

---

## ft_linux Subject Requirements Checklist

- [ ] Kernel version includes login: `-nmunir`
- [ ] Kernel sources located at `/usr/src/kernel-<version>`
- [ ] Hostname set to `nmunir`
- [ ] Kernel image name in `/boot`: `vmlinuz-<linux_version>-nmunir`
- [ ] At least 3 partitions: `/`, `/boot`, swap
- [ ] Bootloader configured (GRUB or LILO)
- [ ] Service manager installed (SysVinit)
- [ ] Kernel module loader installed

---

## Directory Structure

Each chapter has its own directory with a README.md (full documentation with all
commands) and individual `.sh` scripts for each step:

```
scripts/
├── MANUAL_WORKFLOW.md          ← You are here
├── chapter-02-preparing-host/  ← Partitions, filesystems, mounting
├── chapter-03-packages-and-patches/ ← Download sources & patches
├── chapter-04-final-preparations/   ← Directory layout, lfs user, environment
├── chapter-05-cross-toolchain/      ← Binutils, GCC, Headers, Glibc, Libstdc++
├── chapter-06-cross-compiling-temp-tools/ ← M4 through GCC Pass 2 (17 packages)
├── chapter-07-entering-chroot/      ← Chroot setup, additional temp tools
├── chapter-08-installing-basic-system/ ← Final system packages
├── chapter-09-system-configuration/ ← Network, bootscripts, fstab, etc.
└── chapter-10-making-bootable/      ← Kernel, GRUB, reboot
```

---

## Build Order

### Phase 1 — Host Preparation (as root on host)

| Step | Chapter | What | Script Reference |
|------|---------|------|-----------------|
| 1 | Ch.2 | Check host requirements | `chapter-02-preparing-host/01-check-requirements.sh` |
| 2 | Ch.2 | Partition /dev/sdb (cfdisk) | `chapter-02-preparing-host/02-partition-disk.sh` |
| 3 | Ch.2 | Format boot (ext4) | `chapter-02-preparing-host/03-format-boot.sh` |
| 4 | Ch.2 | Setup swap | `chapter-02-preparing-host/04-setup-swap.sh` |
| 5 | Ch.2 | Format root (ext4) | `chapter-02-preparing-host/05-format-root.sh` |
| 6 | Ch.2 | Mount all partitions | `chapter-02-preparing-host/06-mount-all.sh` |
| 7 | Ch.3 | Download source packages | `chapter-03-packages-and-patches/01-download-sources.sh` |
| 8 | Ch.3 | Download patches | `chapter-03-packages-and-patches/02-download-patches.sh` |
| 9 | Ch.4 | Create directory layout | `chapter-04-final-preparations/01-create-directory-layout.sh` |
| 10 | Ch.4 | Create lfs user | `chapter-04-final-preparations/02-add-lfs-user.sh` |
| 11 | Ch.4 | Setup environment | `chapter-04-final-preparations/03-setup-lfs-environment.sh` |

### Phase 2 — Cross-Toolchain (as lfs user)

```bash
su - lfs
```

| Step | Chapter | Package | Script Reference |
|------|---------|---------|-----------------|
| 12 | Ch.5.2 | Binutils-2.45 Pass 1 | `chapter-05-cross-toolchain/01-binutils-pass1.sh` |
| 13 | Ch.5.3 | GCC-15.2.0 Pass 1 | `chapter-05-cross-toolchain/02-gcc-pass1.sh` |
| 14 | Ch.5.4 | Linux-6.16.1 API Headers | `chapter-05-cross-toolchain/03-linux-api-headers.sh` |
| 15 | Ch.5.5 | Glibc-2.42 | `chapter-05-cross-toolchain/04-glibc.sh` |
| 16 | Ch.5.6 | Libstdc++ from GCC-15.2.0 | `chapter-05-cross-toolchain/05-libstdcpp.sh` |

### Phase 3 — Cross-Compiling Temporary Tools (as lfs user)

| Step | Chapter | Package | Script Reference |
|------|---------|---------|-----------------|
| 17 | Ch.6.2 | M4-1.4.20 | `chapter-06.../01-m4.sh` |
| 18 | Ch.6.3 | Ncurses-6.5-20250809 | `chapter-06.../02-ncurses.sh` |
| 19 | Ch.6.4 | Bash-5.3 | `chapter-06.../03-bash.sh` |
| 20 | Ch.6.5 | Coreutils-9.7 | `chapter-06.../04-coreutils.sh` |
| 21 | Ch.6.6 | Diffutils-3.12 | `chapter-06.../05-diffutils.sh` |
| 22 | Ch.6.7 | File-5.46 | `chapter-06.../06-file.sh` |
| 23 | Ch.6.8 | Findutils-4.10.0 | `chapter-06.../07-findutils.sh` |
| 24 | Ch.6.9 | Gawk-5.3.2 | `chapter-06.../08-gawk.sh` |
| 25 | Ch.6.10 | Grep-3.12 | `chapter-06.../09-grep.sh` |
| 26 | Ch.6.11 | Gzip-1.14 | `chapter-06.../10-gzip.sh` |
| 27 | Ch.6.12 | Make-4.4.1 | `chapter-06.../11-make.sh` |
| 28 | Ch.6.13 | Patch-2.8 | `chapter-06.../12-patch.sh` |
| 29 | Ch.6.14 | Sed-4.9 | `chapter-06.../13-sed.sh` |
| 30 | Ch.6.15 | Tar-1.35 | `chapter-06.../14-tar.sh` |
| 31 | Ch.6.16 | Xz-5.8.1 | `chapter-06.../15-xz.sh` |
| 32 | Ch.6.17 | Binutils-2.45 Pass 2 | `chapter-06.../16-binutils-pass2.sh` |
| 33 | Ch.6.18 | GCC-15.2.0 Pass 2 | `chapter-06.../17-gcc-pass2.sh` |

### Phase 4 — Entering Chroot (as root → chroot)
See `chapter-07-entering-chroot/README.md`

### Phase 5 — Installing Basic System Software (inside chroot)
See `chapter-08-installing-basic-system/README.md`

### Phase 6 — System Configuration (inside chroot)
See `chapter-09-system-configuration/README.md`

### Phase 7 — Making the System Bootable (inside chroot)
See `chapter-10-making-bootable/README.md`

---

## After Reboot — Remount Commands

If the VM is rebooted before completing LFS, run:

```bash
export LFS=/mnt/lfs
mount -v -t ext4 /dev/sdb3 $LFS
mount -v -t ext4 /dev/sdb1 $LFS/boot
swapon /dev/sdb2
```

Then switch to the lfs user: `su - lfs`
- [ ] Kernel module loader present (udev/eudev)

## Cleanup (if needed)

Unmount all LFS filesystems:
```bash
bash scripts/03_mount_partitions/unmount_all.sh /mnt/lfs
swapoff /dev/sdb2
```

---

**Total Manual Build Time**: ~2-4 hours depending on your system speed.

**Reference**: Keep the [LFS Book](https://www.linuxfromscratch.org/lfs/view/stable/) open at all times.
