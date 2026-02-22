#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.2: Changing Ownership
#           + Chapter 7.3: Preparing Virtual Kernel Filesystems
#           + Chapter 7.4: Entering the Chroot Environment
# Run as: root (on the host system)
# ============================================================
set -euo pipefail

echo ">>> Chapter 7.2: Changing ownership of \$LFS to root..."

chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
case $(uname -m) in
  x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
esac

echo ">>> Chapter 7.3: Preparing Virtual Kernel File Systems..."

# Create mount-point directories
mkdir -pv $LFS/{dev,proc,sys,run}

# 7.3.1 — Mounting and Populating /dev (bind mount from host)
mount -v --bind /dev $LFS/dev

# 7.3.2 — Mounting Virtual Kernel File Systems
mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

# Handle /dev/shm — symlink vs mount point
if [ -h $LFS/dev/shm ]; then
  install -v -d -m 1777 $LFS$(realpath /dev/shm)
else
  mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
fi

echo ">>> Chapter 7.4: Entering the Chroot Environment..."
echo ">>> Run the following command manually to enter chroot:"
echo ""
echo "chroot \"\$LFS\" /usr/bin/env -i   \\"
echo "    HOME=/root                  \\"
echo "    TERM=\"\$TERM\"                \\"
echo "    PS1='(lfs chroot) \\u:\\w\\\$ ' \\"
echo "    PATH=/usr/bin:/usr/sbin     \\"
echo "    MAKEFLAGS=\"-j\$(nproc)\"      \\"
echo "    TESTSUITEFLAGS=\"-j\$(nproc)\" \\"
echo "    /bin/bash --login"
echo ""

echo ">>> Chroot preparation — DONE"
