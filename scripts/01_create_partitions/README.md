# 01_create_partitions

## Purpose
Identify disks and create partitions for LFS (boot, swap, root).

## Usage
```bash
bash scripts/01_create_partitions/01_view_disks.sh
bash scripts/01_create_partitions/02_partition_disk.sh /dev/sdb
```

## Suggested Layout (20GB disk)
- /dev/sdb1: 200MB (boot) — type: Linux filesystem
- /dev/sdb2: 4GB (swap) — type: Linux swap
- /dev/sdb3: rest (root) — type: Linux root (x86-64)
