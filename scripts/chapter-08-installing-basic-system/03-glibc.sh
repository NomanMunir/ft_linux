#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.5: Glibc-2.42
# Run as: root (inside chroot)
# Approximate build time: 12 SBU
# Required disk space:    3.6 GB
# ============================================================
set -euo pipefail

echo ">>> Building Glibc-2.42..."

cd /sources
tar -xf glibc-2.42.tar.xz
cd glibc-2.42

patch -Np1 -i ../glibc-2.42-fhs-1.patch

mkdir -v build
cd build

echo "rootsbindir=/usr/sbin" > configparms

../configure                       \
    --prefix=/usr                  \
    --disable-werror               \
    --enable-kernel=4.19           \
    --enable-stack-protector=strong \
    --disable-nscd                 \
    libc_cv_slibdir=/usr/lib

make

# make check (optional, long)

touch /etc/ld.so.conf
sed '/test-hierarchical-cleanup/d' -i ../Makefile
make install

sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

mkdir -pv /usr/lib/locale
localedef -i C -f UTF-8 C.UTF-8
localedef -i en_US -f UTF-8 en_US.UTF-8

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

tar -xf ../../tzdata2025b.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done

cp -v zone.{tab,1970.tab} zone-1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO

ln -sfv /usr/share/zoneinfo/UTC /etc/localtime

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

# Add an include directory
include /etc/ld.so.conf.d/*.conf
EOF
mkdir -pv /etc/ld.so.conf.d

cd /sources
rm -rf glibc-2.42

echo ">>> Glibc-2.42 — DONE"
