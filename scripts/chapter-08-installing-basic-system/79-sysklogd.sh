#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.81: Sysklogd-2.7.0
# Run as: root (inside chroot)
# Approximate build time: <0.1 SBU
# Required disk space:    2.4 MB
# ============================================================
set -euo pipefail

echo ">>> Building Sysklogd-2.7.0..."

cd /sources
tar -xf sysklogd-2.7.0.tar.gz
cd sysklogd-2.7.0

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --runstatedir=/run \
            --without-logger

make

make install

cat > /etc/syslog.conf << "SYSLOG_EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
SYSLOG_EOF

cd /sources
rm -rf sysklogd-2.7.0

echo ">>> Sysklogd-2.7.0 — DONE"
