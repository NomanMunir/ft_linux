# Manual LFS Build Workflow

This document outlines the manual steps you need to follow, using these helper scripts as reference.

## Phase 1: Host System Preparation

### Step 1: Check Requirements
```bash
bash scripts/00_requirements/check_requirements.sh
```
Ensure your host system has all required tools.

### Step 2: View Available Disks
```bash
bash scripts/01_create_partitions/01_view_disks.sh
```
Identify your second disk (e.g., `/dev/sdb`)

### Step 3: Create Partitions
```bash
bash scripts/01_create_partitions/02_partition_disk.sh /dev/sdb
```
Creates:
- `/dev/sdb1` - 200MB (boot)
- `/dev/sdb2` - 4GB (swap)
- `/dev/sdb3` - Rest (root)

### Step 4: Format Boot Partition
```bash
bash scripts/02_create_filesystems/01_format_boot.sh /dev/sdb1
```

### Step 5: Setup Swap
```bash
bash scripts/02_create_filesystems/02_setup_swap.sh /dev/sdb2
```

### Step 6: Format Root Partition
```bash
bash scripts/02_create_filesystems/03_format_root.sh /dev/sdb3
```

### Step 7: Mount Partitions
```bash
bash scripts/03_mount_partitions/mount_all.sh /dev/sdb3 /dev/sdb1 /mnt/lfs
```

Add the fstab entries it suggests to your host's `/etc/fstab`.

### Step 8: Create LFS User
```bash
bash scripts/05_prepare_tools/create_lfs_user.sh /mnt/lfs
```

### Step 9: Switch to LFS User
```bash
su - lfs
```

Verify:
```bash
echo $LFS
echo $MAKEFLAGS
```

## Phase 2: Building LFS (Follow Official Book)

From here, follow the official LFS book:
https://www.linuxfromscratch.org/lfs/view/stable/

The script helpers below are for reference:

### Download Sources
```bash
bash scripts/04_download_sources/download_sources.sh /mnt/lfs
```

### Configure Hostname
```bash
bash scripts/07_configure_system/configure_hostname.sh ft_linux /mnt/lfs
```

### Configure /etc/fstab
```bash
bash scripts/07_configure_system/configure_fstab.sh /dev/sdb3 /dev/sdb1 /mnt/lfs
```

## Phase 3: Kernel & Bootloader

See `scripts/06_build_system/README.md` for guidance.

## Cleanup (if needed)

Unmount all LFS filesystems:
```bash
bash scripts/03_mount_partitions/unmount_all.sh /mnt/lfs
swapoff /dev/sdb2
```

---

**Total Manual Build Time**: ~2-4 hours depending on your system speed.

**Reference**: Keep the [LFS Book](https://www.linuxfromscratch.org/lfs/view/stable/) open at all times.
