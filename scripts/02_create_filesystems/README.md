# 02_create_filesystems

## Purpose
Format the LFS partitions and initialize swap.

## Usage
```bash
bash scripts/02_create_filesystems/01_format_boot.sh /dev/sdb1
bash scripts/02_create_filesystems/02_setup_swap.sh /dev/sdb2
bash scripts/02_create_filesystems/03_format_root.sh /dev/sdb3
```

## Notes
- /dev/sdb1 and /dev/sdb3 use ext4
- /dev/sdb2 uses mkswap
