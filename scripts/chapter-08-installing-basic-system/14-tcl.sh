#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.16: Tcl-8.6.16
# Run as: root (inside chroot)
# Approximate build time: 2.6 SBU
# Required disk space:    92 MB
# ============================================================
set -euo pipefail

echo ">>> Building Tcl-8.6.16..."

cd /sources
tar -xf tcl8.6.16-src.tar.gz
cd tcl8.6.16

SRCDIR=$(pwd)
cd unix

./configure --prefix=/usr \
            --mandir=/usr/share/man

make

sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|" \
    -i tclConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.10|/usr/lib/tdbc1.1.10|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.10|/usr/include|"            \
    -i pkgs/tdbc1.1.10/tdbcConfig.sh

sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.2|/usr/lib/itcl4.3.2|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.2/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/itcl4.3.2|/usr/include|"             \
    -i pkgs/itcl4.3.2/itclConfig.sh

unset SRCDIR

make test
make install

chmod -v u+w /usr/lib/libtcl8.6.so

make install-private-headers

ln -sfv tclsh8.6 /usr/bin/tclsh
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3

cd /sources
rm -rf tcl8.6.16

echo ">>> Tcl-8.6.16 — DONE"
