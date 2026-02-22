#!/bin/bash
# Check software requirements for LFS building
# Based on: https://www.linuxfromscratch.org/lfs/view/stable/chapter02/hostversioncheck.html

set -e

echo "========================================"
echo "Checking LFS Host System Requirements"
echo "========================================"
echo ""

# Check bash version
echo "Checking Bash..."
bash --version | head -n1

# Check binutils
echo -n "Checking Binutils... "
ld --version | head -n1

# Check bison
echo -n "Checking Bison... "
bison --version | head -n1

# Check bzip2
echo -n "Checking Bzip2... "
bzip2 --version 2>&1 | head -n1

# Check coreutils
echo -n "Checking Coreutils... "
chown --version | head -n1

# Check diff
echo -n "Checking Diffutils... "
diff --version | head -n1

# Check find
echo -n "Checking Findutils... "
find --version | head -n1

# Check gawk
echo -n "Checking Gawk... "
gawk --version | head -n1

# Check gcc
echo -n "Checking GCC... "
gcc --version | head -n1

# Check libc version
echo -n "Checking Libc... "
ldd --version | head -n1

# Check grep
echo -n "Checking Grep... "
grep --version | head -n1

# Check gzip
echo -n "Checking Gzip... "
gzip --version | head -n1

# Check m4
echo -n "Checking M4... "
m4 --version | head -n1

# Check make
echo -n "Checking Make... "
make --version | head -n1

# Check patch
echo -n "Checking Patch... "
patch --version | head -n1

# Check perl
echo -n "Checking Perl... "
perl -v | grep "This is perl" | head -n1

# Check sed
echo -n "Checking Sed... "
sed --version | head -n1

# Check tar
echo -n "Checking Tar... "
tar --version | head -n1

# Check texinfo
echo -n "Checking Texinfo... "
texi2any --version | head -n1

# Check xz
echo -n "Checking Xz... "
xz --version

echo ""
echo "========================================"
echo "Version check complete!"
echo "========================================"
