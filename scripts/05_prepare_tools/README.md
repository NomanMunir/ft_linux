# 05_prepare_tools

## Purpose
Create the lfs user and prepare the build environment.

## Create lfs user
```bash
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
```

## Ownership
```bash
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
```

## Switch user
```bash
su - lfs
```
