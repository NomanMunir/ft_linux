#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.5: Creating Directories
# Run as: root (inside chroot)
# ============================================================
set -euo pipefail

echo ">>> Creating directory layout..."

# Root-level directories
mkdir -pv /{boot,home,mnt,opt,srv}

# Sub-directories under /etc
mkdir -pv /etc/{opt,sysconfig}

# Firmware
mkdir -pv /lib/firmware

# Media mount points
mkdir -pv /media/{floppy,cdrom}

# /usr hierarchy
mkdir -pv /usr/{,local/}{include,src}
mkdir -pv /usr/lib/locale
mkdir -pv /usr/local/{bin,lib,sbin}
mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
mkdir -pv /usr/{,local/}share/man/man{1..8}

# /var hierarchy
mkdir -pv /var/{cache,local,log,mail,opt,spool}
mkdir -pv /var/lib/{color,misc,locate}

# Compat symlinks
ln -sfv /run /var/run
ln -sfv /run/lock /var/lock

# Restricted directories
install -dv -m 0750 /root
install -dv -m 1777 /tmp /var/tmp

echo ">>> Creating directories — DONE"
