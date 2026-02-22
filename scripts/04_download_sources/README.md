# 04_download_sources

## Purpose
Prepare the sources directory and download LFS packages/patches.

## Manual Steps (LFS Chapter 3)
```bash
export LFS=/mnt/lfs
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
```

## Example: Download from LFS mirror
```bash
cd $LFS/sources
wget -r --no-parent -nd https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/
wget https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/md5sums -O $LFS/sources/md5sums
md5sum -c md5sums
```

## Notes
Keep all tarballs and patches in $LFS/sources.
