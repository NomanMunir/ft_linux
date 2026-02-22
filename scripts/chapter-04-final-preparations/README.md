# Chapter 4 — Final Preparations

> **LFS Version:** 12.4
> **Run as:** root (then switch to lfs)
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter04/chapter04.html

---

## 4.1 Overview

Prepare the LFS filesystem and build environment:
- Create directory layout in `$LFS`
- Create the `lfs` user
- Configure the `lfs` user's shell environment

---

## 4.2 Creating a Limited Directory Layout (as root)

Create the folder structure where temporary tools and the final system will live:

```bash
export LFS=/mnt/lfs

# Create basic directories
mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

# Create symlinks: /bin → /usr/bin, /lib → /usr/lib, /sbin → /usr/sbin
# This follows modern Linux convention where everything lives under /usr
for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

# Create lib64 for 64-bit systems (real directory, not a symlink)
case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

# Create tools directory for the cross-compiler
mkdir -pv $LFS/tools
```

**Why symlinks?** Modern Linux puts all binaries in `/usr`. Symlinks let old programs
that expect `/bin/bash` find it at `/usr/bin/bash`.

---

## 4.3 Adding the LFS User (as root)

Build as an unprivileged user to avoid accidentally breaking the host system:

```bash
# Create lfs group and user
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs

# Set password (needed if you want to log in directly as lfs)
passwd lfs

# Give lfs ownership of all LFS directories
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac

# Switch to lfs user
su - lfs
```

**Why a separate user?** Building as root = any mistake can destroy the host.
Building as `lfs` = mistakes only affect `/mnt/lfs`.

---

## 4.4 Setting Up the Environment (as user lfs)

Create a clean, isolated shell environment:

### Create `.bash_profile`
Clears all inherited environment variables from the host:
```bash
cat > ~/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF
```

### Create `.bashrc`
Sets up the LFS build environment:
```bash
cat > ~/.bashrc << "EOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
EOF
```

### Add parallel build support
Uses all CPU cores for faster compilation:
```bash
cat >> ~/.bashrc << "EOF"
export MAKEFLAGS=-j$(nproc)
EOF
```

### Reload environment
```bash
source ~/.bash_profile
```

### Disable host bashrc (as root, in a separate terminal)
Prevents host-specific settings from contaminating the build:
```bash
[ ! -e /etc/bash.bashrc ] || mv -v /etc/bash.bashrc /etc/bash.bashrc.NOUSE
```

---

## 4.5 Verify Environment (as user lfs)

```bash
whoami          # Should print: lfs
echo $LFS       # Should print: /mnt/lfs
echo $LFS_TGT   # Should print: x86_64-lfs-linux-gnu
echo $MAKEFLAGS  # Should print: -j<num_cores>
echo $PATH       # Should start with: /mnt/lfs/tools/bin
```

---

## Scripts

```bash
bash scripts/chapter-04-final-preparations/01-create-directory-layout.sh
bash scripts/chapter-04-final-preparations/02-add-lfs-user.sh
bash scripts/chapter-04-final-preparations/03-setup-lfs-environment.sh
```
