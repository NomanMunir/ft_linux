# Chapter 3 — Packages and Patches

> **LFS Version:** 12.4
> **Run as:** root
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter03/chapter03.html

---

## 3.1 Overview

Download all source packages and patches needed for the LFS build.
Everything is stored in `$LFS/sources/`.

---

## 3.2 Create Sources Directory

```bash
export LFS=/mnt/lfs

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
```

- `mkdir` — creates the directory
- `chmod a+wt` — makes it writable by all, sticky bit prevents others from deleting your files

---

## 3.3 Download All Packages

### Option A: From LFS Mirror (Easiest)
```bash
cd $LFS/sources
wget -r --no-parent -nd https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/
```

### Option B: Using wget-list
```bash
wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
```

---

## 3.4 Verify Downloads

```bash
cd $LFS/sources
wget https://mirror.proximity-bg.com/LFS/lfs-packages/12.4/md5sums -O md5sums
md5sum -c md5sums
```

---

## 3.5 Download Required Patches

```bash
cd $LFS/sources

wget https://www.linuxfromscratch.org/patches/lfs/12.4/bzip2-1.0.8-install_docs-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/coreutils-9.7-upstream_fix-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/coreutils-9.7-i18n-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/expect-5.45.4-gcc15-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/glibc-2.42-fhs-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/kbd-2.8.0-backspace-1.patch
wget https://www.linuxfromscratch.org/patches/lfs/12.4/sysvinit-3.14-consolidated-1.patch
```

### Verify patches downloaded:
```bash
ls -lh $LFS/sources/*.patch
```

---

## 3.6 Change Ownership (if downloaded as non-root)

```bash
chown root:root $LFS/sources/*
```

---

## Scripts

```bash
bash scripts/chapter-03-packages-and-patches/01-download-sources.sh
bash scripts/chapter-03-packages-and-patches/02-download-patches.sh
```
