# 03_mount_partitions

## Purpose
Mount LFS partitions and activate swap.

## Usage
```bash
bash scripts/03_mount_partitions/mount_all.sh /dev/sdb3 /dev/sdb1 /mnt/lfs
```

## Unmount
```bash
bash scripts/03_mount_partitions/unmount_all.sh /mnt/lfs
```

## Notes
After reboot, remount partitions and re-enable swap.
