#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.84: Stripping
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    Frees ~2 GB
# ============================================================
set -euo pipefail

echo ">>> Stripping debug symbols..."

save_usrlib="$(cd /usr/lib; ls ld-linux*)"
save_usrlib="$save_usrlib libc.so.6"
save_usrlib="$save_usrlib libthread_db.so.1"
save_usrlib="$save_usrlib libquadmath.so.0.0.0"
save_usrlib="$save_usrlib libstdc++.so.6.0.34"
save_usrlib="$save_usrlib libitm.so.1.0.0"
save_usrlib="$save_usrlib libatomic.so.1.2.0"

cd /usr/lib

for LIB in $save_usrlib; do
    objcopy --only-keep-debug --compress-debug-sections=zlib $LIB $LIB.dbg
    cp $LIB /tmp/$LIB
    strip --strip-unneeded /tmp/$LIB
    objcopy --add-gnu-debuglink=$LIB.dbg /tmp/$LIB
    install -vm755 /tmp/$LIB /usr/lib
    rm /tmp/$LIB
done

online_usrbin="bash find strip"
online_usrbin="$online_usrbin dd gawk"

for BIN in $online_usrbin; do
    cp /usr/bin/$BIN /tmp/$BIN
    strip --strip-unneeded /tmp/$BIN
    install -vm755 /tmp/$BIN /usr/bin
    rm /tmp/$BIN
done

find /usr/lib -type f -name \*.a \
   -exec strip --strip-debug {} ';'

find /usr/lib -type f -name \*.so* ! -name \*dbg \
   -exec strip --strip-unneeded {} ';'

find /usr/{bin,sbin,libexec} -type f \
    -exec strip --strip-unneeded {} ';'

echo ">>> Stripping — DONE"
