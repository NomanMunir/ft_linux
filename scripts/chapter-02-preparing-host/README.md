# Chapter 2 — Preparing the Host System

> **LFS Version:** 12.4
> **Run as:** root
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter02/chapter02.html

---

## 2.1 Overview

Before building LFS, the host system must be prepared:
- Check software requirements
- Create partitions on the LFS disk
- Create filesystems
- Mount partitions
- Set the `$LFS` variable

---

## 2.2 Host System Requirements

Verify your host has the required tools:

```bash
bash scripts/chapter-02-preparing-host/01-check-requirements.sh
```

Required symlinks:
- `sh` → `bash`
- `awk` → `gawk`
- `yacc` → `bison`

---

## 2.3 Creating Partitions

### View available disks
```bash
lsblk
fdisk -l
```

### Partition the second disk (`/dev/sdb`)
Using `cfdisk /dev/sdb`, create:

| Partition   | Size     | Type                  | Purpose |
|-------------|----------|-----------------------|---------|
| `/dev/sdb1` | 200 MB   | Linux filesystem      | `/boot` |
| `/dev/sdb2` | 4 GB     | Linux swap            | swap    |
| `/dev/sdb3` | Remaining| Linux root (x86-64)   | `/`     |

Or use the script:
```bash
bash scripts/chapter-02-preparing-host/02-partition-disk.sh /dev/sdb
```

---

## 2.4 Creating Filesystems

Format each partition:

```bash
# Boot partition (ext4)
mkfs -v -t ext4 /dev/sdb1

# Swap partition
mkswap /dev/sdb2

# Root partition (ext4)
mkfs -v -t ext4 /dev/sdb3
```

Or use the scripts:
```bash
bash scripts/chapter-02-preparing-host/03-format-boot.sh /dev/sdb1
bash scripts/chapter-02-preparing-host/04-setup-swap.sh /dev/sdb2
bash scripts/chapter-02-preparing-host/05-format-root.sh /dev/sdb3
```

---

## 2.5 Setting the $LFS Variable

```bash
export LFS=/mnt/lfs
umask 022
echo $LFS    # Should print: /mnt/lfs
```

To make persistent, add to `~/.bashrc` and `/root/.bash_profile`:
```bash
export LFS=/mnt/lfs
umask 022
```

---

## 2.6 Mounting Partitions

```bash
# Create mount point
mkdir -pv /mnt/lfs

# Mount root partition
mount /dev/sdb3 /mnt/lfs

# Mount boot partition
mkdir -pv /mnt/lfs/boot
mount /dev/sdb1 /mnt/lfs/boot

# Enable swap
swapon /dev/sdb2
```

Or use the script:
```bash
bash scripts/chapter-02-preparing-host/06-mount-all.sh
```

### Make mounts persistent (add to `/etc/fstab`):
```
/dev/sdb3  /mnt/lfs       ext4  defaults  1 1
/dev/sdb1  /mnt/lfs/boot  ext4  defaults  1 2
/dev/sdb2  none           swap  sw        0 0
```

---

## After Reboot Checklist

If you reboot, you must redo:
1. Mount partitions (or use fstab)
2. `export LFS=/mnt/lfs`
3. `umask 022`
4. `swapon /dev/sdb2` (or use fstab)

Downloaded files in `$LFS/sources/` are safe on disk.
