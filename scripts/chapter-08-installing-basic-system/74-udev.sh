#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.76: Udev from Systemd-257.4
# Run as: root (inside chroot)
# Approximate build time: 0.2 SBU
# Required disk space:    135 MB
# ============================================================
set -euo pipefail

echo ">>> Building Udev from Systemd-257.4..."

cd /sources
tar -xf systemd-257.4.tar.gz
cd systemd-257.4

sed -i -e 's/GROUP="render"/GROUP="video"/' \
       -e 's/GROUP="sgx", //' rules.d/50-udev-default.rules.in

sed '/systemd-hierarchical/s/true/false/' -i src/udev/udev-builtin-path_id.c

mkdir -p build && cd build

meson setup .. \
      --prefix=/usr                 \
      --buildtype=release           \
      -D mode=release               \
      -D dev-kvm-mode=0660          \
      -D link-udev-shared=false     \
      -D logind=false               \
      -D vconsole=false

export udev_helpers=$(grep "'name' :" ../src/udev/meson.build | \
    awk '{print $3}' | tr -d ",'" | sort)

ninja udevadm systemd-hwdb                                           \
      $(ninja -n | grep -Eo '(lib(udev|systemd)[^ ]*|[^ ]*determine-sleep-system-targets)') \
      $(ninja -n | grep -Eo src/udev/[^ ]*                         | grep -Ev 'iocost|lock-device-cgroups') \
      $udev_helpers

install -vm755 -d {/usr/lib,/etc}/udev/{hwdb.d,rules.d,network}
install -vm755 -d /usr/{lib,share}/pkgconfig
install -vm755 udevadm                             /usr/bin/
install -vm755 systemd-hwdb                        /usr/bin/udevadm
ln      -svfn  ../bin/udevadm                      /usr/sbin/udevd
cp      -av    libudev.so{,*[0-9]}                 /usr/lib/
cp      -av    libsystemd.so{,*[0-9]}              /usr/lib/
install -vm644 ../src/libudev/libudev.h             /usr/include/
install -vm644 src/libudev/*.pc                     /usr/lib/pkgconfig/
install -vm644 src/libsystemd/libsystemd.pc         /usr/lib/pkgconfig/
install -vm644 ../src/libsystemd/sd-*.h              /usr/include/
install -vm644 ../src/libsystemd/sd-*/sd-*.h         /usr/include/
install -vm755 $udev_helpers                        /usr/lib/udev
install -vm644 ../rules.d/50-udev-default.rules.in  /usr/lib/udev/rules.d/50-udev-default.rules
install -vm644 ../rules.d/60-persistent-storage.rules /usr/lib/udev/rules.d/
install -vm644 ../rules.d/64-btrfs.rules             /usr/lib/udev/rules.d/
install -vm644 src/udev/udevadm.completions.bash     /usr/share/bash-completion/completions/udevadm

cat > /usr/lib/udev/rules.d/49-lfs.rules << "UDEV_EOF"
# Rules for LFS

# /dev/cdrom for CD-ROM (remove if not needed)
SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", GROUP="cdrom"

# Firmware loading
SUBSYSTEM=="firmware", ACTION=="add", ATTR{loading}="-1"
UDEV_EOF

udevadm hwdb --update
unset udev_helpers

cd /sources
rm -rf systemd-257.4

echo ">>> Udev from Systemd-257.4 — DONE"
