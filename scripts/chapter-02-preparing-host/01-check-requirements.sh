#!/bin/bash
# Chapter 2 — Check host system requirements for LFS 12.4
# Reference: https://www.linuxfromscratch.org/lfs/view/12.4/chapter02/hostversioncheck.html
# Run as: root or any user

set -e

echo "========================================"
echo " LFS 12.4 — Host System Requirements"
echo "========================================"
echo ""

echo "Bash:       $(bash --version | head -n1)"
echo "Binutils:   $(ld --version | head -n1)"
echo "Bison:      $(bison --version | head -n1)"
echo "Bzip2:      $(bzip2 --version 2>&1 | head -n1)"
echo "Coreutils:  $(chown --version | head -n1)"
echo "Diffutils:  $(diff --version | head -n1)"
echo "Findutils:  $(find --version | head -n1)"
echo "Gawk:       $(gawk --version | head -n1)"
echo "GCC:        $(gcc --version | head -n1)"
echo "Libc:       $(ldd --version | head -n1)"
echo "Grep:       $(grep --version | head -n1)"
echo "Gzip:       $(gzip --version | head -n1)"
echo "M4:         $(m4 --version | head -n1)"
echo "Make:       $(make --version | head -n1)"
echo "Patch:      $(patch --version | head -n1)"
echo "Perl:       $(perl -v | grep "This is perl" | head -n1)"
echo "Sed:        $(sed --version | head -n1)"
echo "Tar:        $(tar --version | head -n1)"
echo "Texinfo:    $(texi2any --version | head -n1)"
echo "Xz:         $(xz --version | head -n1)"

echo ""
echo "========================================"
echo " Checking required symlinks"
echo "========================================"

echo -n "sh -> "
readlink -f /bin/sh

echo -n "awk -> "
readlink -f /usr/bin/awk

echo -n "yacc -> "
readlink -f /usr/bin/yacc 2>/dev/null || echo "NOT FOUND"

echo ""
echo "========================================"
echo " Check complete!"
echo "========================================"
