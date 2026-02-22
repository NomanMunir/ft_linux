#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 7.13: Cleaning up and Saving the
#             Temporary System
# Run as: root (inside chroot for cleanup,
#               host system for backup/restore)
# ============================================================
set -euo pipefail

echo ">>> Chapter 7.13.1: Cleaning up..."

# Remove documentation installed by temporary tools
rm -rf /usr/share/{info,man,doc}/*

# Remove libtool .la files (not needed; can break BLFS builds)
find /usr/{lib,libexec} -name \*.la -delete

# Remove the cross-compilation toolchain (no longer needed, ~1 GB)
rm -rf /tools

echo ">>> Cleanup — DONE"
echo ""
echo "============================================================"
echo " Optional: Backup the temporary system"
echo "============================================================"
echo ""
echo " 1. Exit chroot:  exit"
echo ""
echo " 2. Unmount virtual filesystems:"
echo "    mountpoint -q \$LFS/dev/shm && umount \$LFS/dev/shm"
echo "    umount \$LFS/dev/pts"
echo "    umount \$LFS/{sys,proc,run,dev}"
echo ""
echo " 3. Create the backup archive:"
echo "    cd \$LFS"
echo "    tar -cJpf \$HOME/lfs-temp-tools-12.4.tar.xz ."
echo ""
echo " 4. To restore (if needed):"
echo "    cd \$LFS"
echo "    rm -rf ./*"
echo "    tar -xpf \$HOME/lfs-temp-tools-12.4.tar.xz"
echo ""
echo " 5. Re-enter chroot (remount virtual FS first — see 7.3/7.4)"
echo "============================================================"
