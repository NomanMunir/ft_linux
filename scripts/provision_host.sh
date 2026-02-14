#!/bin/bash
# =============================================================================
# ft_linux — LFS Host Provisioning Script
# =============================================================================
# This script prepares a Debian 12 (Bookworm) system to be an LFS build host.
# It installs all required packages, creates the LFS user, partitions the
# second disk, creates filesystems, and sets up the $LFS environment.
#
# Usage:
#   sudo bash provision_host.sh [LFS_DISK]
#
# Arguments:
#   LFS_DISK  — the device for the LFS build (default: /dev/sdb)
#
# Run this as root (or with sudo) inside a fresh Debian 12 VM.
# =============================================================================
set -euo pipefail

# ── Configuration ──────────────────────────────────────────────────────────────
LFS_DISK="${1:-/dev/sdb}"
LFS="/mnt/lfs"
BOOT_SIZE="+200M"
SWAP_SIZE="+2G"
# Root partition gets the rest of the disk

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
err()   { echo -e "${RED}[✗]${NC} $1" >&2; }
info()  { echo -e "${CYAN}[i]${NC} $1"; }

# ── Pre-flight checks ─────────────────────────────────────────────────────────
if [[ $EUID -ne 0 ]]; then
    err "This script must be run as root. Use:  sudo bash $0"
    exit 1
fi

if [[ ! -b "$LFS_DISK" ]]; then
    err "Disk $LFS_DISK not found. Available disks:"
    lsblk -d -o NAME,SIZE,TYPE | grep disk
    echo ""
    err "Usage: sudo bash $0 /dev/sdX"
    exit 1
fi

echo ""
echo "=============================================="
echo "   ft_linux — LFS Host Provisioning"
echo "=============================================="
echo ""
info "LFS disk:       $LFS_DISK"
info "LFS mount:      $LFS"
echo ""

# ── Step 1: Install all required packages ──────────────────────────────────────
log "Installing LFS host build dependencies..."
apt-get update -qq
apt-get install -y -qq \
    bash \
    binutils \
    bison \
    coreutils \
    diffutils \
    findutils \
    gawk \
    gcc \
    g++ \
    grep \
    gzip \
    m4 \
    make \
    patch \
    perl \
    python3 \
    sed \
    tar \
    texinfo \
    xz-utils \
    bc \
    bzip2 \
    file \
    flex \
    libncurses-dev \
    wget \
    curl \
    git \
    vim \
    nano \
    parted \
    e2fsprogs \
    dosfstools \
    > /dev/null 2>&1

log "All build dependencies installed."

# ── Step 2: Fix symlinks required by LFS ───────────────────────────────────────
log "Setting up required symlinks..."

# /bin/sh must point to bash (Debian defaults to dash)
if [[ "$(readlink -f /bin/sh)" != *"bash"* ]]; then
    ln -sf /bin/bash /bin/sh
    log "  /bin/sh -> bash (was dash)"
else
    log "  /bin/sh -> bash (already correct)"
fi

# /usr/bin/yacc must point to bison
if [[ ! -e /usr/bin/yacc ]]; then
    ln -sf /usr/bin/bison /usr/bin/yacc
    log "  /usr/bin/yacc -> bison"
fi

# /usr/bin/awk must point to gawk
if [[ "$(readlink -f /usr/bin/awk)" != *"gawk"* ]]; then
    ln -sf /usr/bin/gawk /usr/bin/awk
    log "  /usr/bin/awk -> gawk"
fi

# ── Step 3: Run the LFS version-check script ──────────────────────────────────
log "Running LFS version-check..."
echo ""
cat > /tmp/version-check.sh << "VEOF"
#!/bin/bash
LC_ALL=C
PATH=/usr/bin:/bin

bail() { echo "FATAL: $1"; exit 1; }
grep --version > /dev/null 2> /dev/null || bail "grep does not work"
sed '' /dev/null || bail "sed does not work"
sort /dev/null || bail "sort does not work"

ver_check() {
    if ! type -p $2 &>/dev/null; then
        echo "ERROR: Cannot find $2 ($1)"; return 1
    fi
    v=$($2 --version 2>&1 | grep -E -o '[0-9]+\.[0-9\.]+[a-z]*' | head -n1)
    if printf '%s\n' $3 $v | sort --version-sort --check &>/dev/null; then
        printf "OK:    %-9s %-6s >= $3\n" "$1" "$v"; return 0
    else
        printf "ERROR: %-9s is TOO OLD ($3 or later required)\n" "$1"; return 1
    fi
}

ver_kernel() {
    kver=$(uname -r | grep -E -o '^[0-9\.]+')
    if printf '%s\n' $1 $kver | sort --version-sort --check &>/dev/null; then
        printf "OK:    Linux Kernel $kver >= $1\n"; return 0
    else
        printf "ERROR: Linux Kernel ($kver) is TOO OLD ($1 or later required)\n"; return 1
    fi
}

ver_check Coreutils sort    8.1  || bail "Coreutils too old, stop"
ver_check Bash      bash    3.2
ver_check Binutils  ld      2.13.1
ver_check Bison     bison   2.7
ver_check Diffutils diff    2.8.1
ver_check Findutils find    4.2.31
ver_check Gawk      gawk    4.0.1
ver_check GCC       gcc     5.4
ver_check "GCC(C++)" g++    5.4
ver_check Grep      grep    2.5.1a
ver_check Gzip      gzip    1.3.12
ver_check M4        m4      1.4.10
ver_check Make      make    4.0
ver_check Patch     patch   2.5.4
ver_check Perl      perl    5.8.8
ver_check Python    python3 3.4
ver_check Sed       sed     4.1.5
ver_check Tar       tar     1.22
ver_check Texinfo   texi2any 5.0
ver_check Xz        xz      5.0.0
ver_kernel 5.4

if mount | grep -q 'devpts on /dev/pts' && [ -e /dev/ptmx ]; then
    echo "OK:    Linux Kernel supports UNIX 98 PTY"
else
    echo "ERROR: Linux Kernel does NOT support UNIX 98 PTY"
fi

echo ""
echo "Aliases:"
for tool_pair in "awk:GNU" "yacc:Bison" "sh:Bash"; do
    tool="${tool_pair%%:*}"
    expected="${tool_pair##*:}"
    if $tool --version 2>&1 | grep -qi "$expected"; then
        printf "OK:    %-4s is %s\n" "$tool" "$expected"
    else
        printf "ERROR: %-4s is NOT %s\n" "$tool" "$expected"
    fi
done

echo ""
echo "Compiler check:"
if printf "int main(){}" | g++ -x c++ - 2>/dev/null; then
    echo "OK:    g++ works"
else
    echo "ERROR: g++ does NOT work"
fi
rm -f a.out

echo ""
echo "OK:    nproc reports $(nproc) logical cores are available"
VEOF
bash /tmp/version-check.sh
echo ""

# ── Step 4: Partition the LFS disk ────────────────────────────────────────────
warn "About to partition $LFS_DISK. This will ERASE all data on it."
info "Layout: sdb1=/boot (200MB, ext2) | sdb2=root (rest, ext4) | sdb3=swap (2GB)"
echo ""

# Wipe existing partition table
wipefs -a "$LFS_DISK" > /dev/null 2>&1 || true

# Create partitions with sfdisk (non-interactive)
sfdisk "$LFS_DISK" << PEOF
label: dos
,${BOOT_SIZE},L,*
,,L
PEOF

# We need to handle swap differently since sfdisk above created 2 partitions
# Let's redo with 3 partitions properly
wipefs -a "$LFS_DISK" > /dev/null 2>&1 || true

sfdisk "$LFS_DISK" << PEOF
label: dos
,200M,L,*
,+,L
PEOF

# Actually let's use parted for cleaner 3-partition layout
wipefs -a "$LFS_DISK" > /dev/null 2>&1 || true
parted -s "$LFS_DISK" mklabel msdos
parted -s "$LFS_DISK" mkpart primary ext2 1MiB 201MiB
parted -s "$LFS_DISK" set 1 boot on
parted -s "$LFS_DISK" mkpart primary linux-swap 201MiB 2249MiB
parted -s "$LFS_DISK" mkpart primary ext4 2249MiB 100%

log "Partitions created:"
lsblk "$LFS_DISK" -o NAME,SIZE,TYPE,FSTYPE

PART1="${LFS_DISK}1"  # /boot
PART2="${LFS_DISK}2"  # swap
PART3="${LFS_DISK}3"  # root /

# ── Step 5: Create filesystems ─────────────────────────────────────────────────
log "Creating filesystems..."
mkfs.ext2 -F -L LFS_BOOT "$PART1" > /dev/null 2>&1
mkswap -L LFS_SWAP "$PART2" > /dev/null 2>&1
mkfs.ext4 -F -L LFS_ROOT "$PART3" > /dev/null 2>&1
log "Filesystems created: ext2 (/boot), swap, ext4 (/)"

# ── Step 6: Mount the LFS filesystem ──────────────────────────────────────────
log "Mounting LFS filesystem at $LFS..."
mkdir -pv "$LFS"
mount "$PART3" "$LFS"
mkdir -pv "$LFS/boot"
mount "$PART1" "$LFS/boot"
swapon "$PART2"
log "Mounted: $PART3 -> $LFS, $PART1 -> $LFS/boot, swap on"

# ── Step 7: Create the lfs user ───────────────────────────────────────────────
log "Creating 'lfs' user for building..."
if id lfs &>/dev/null; then
    warn "User 'lfs' already exists, skipping creation"
else
    groupadd lfs 2>/dev/null || true
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    echo "lfs:lfs" | chpasswd
    log "User 'lfs' created (password: lfs)"
fi

# Give lfs ownership of $LFS
mkdir -pv "$LFS/tools"
mkdir -pv "$LFS/sources"
chmod -v a+wt "$LFS/sources"
chown -v lfs:lfs "$LFS/tools"
chown -v lfs:lfs "$LFS/sources"

# ── Step 8: Set up lfs user environment ───────────────────────────────────────
log "Configuring lfs user environment..."

cat > /home/lfs/.bash_profile << "EOF"
exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
EOF

cat > /home/lfs/.bashrc << "BEOF"
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
export MAKEFLAGS="-j$(nproc)"
BEOF

chown lfs:lfs /home/lfs/.bash_profile /home/lfs/.bashrc

# ── Step 9: Create persistent mount in fstab ──────────────────────────────────
log "Adding LFS mounts to /etc/fstab..."
if ! grep -q "LFS_ROOT" /etc/fstab; then
    cat >> /etc/fstab << FEOF

# ft_linux — LFS partitions
LABEL=LFS_ROOT  /mnt/lfs       ext4  defaults  0 2
LABEL=LFS_BOOT  /mnt/lfs/boot  ext2  defaults  0 2
LABEL=LFS_SWAP  none           swap  sw        0 0
FEOF
    log "fstab entries added"
else
    warn "LFS entries already in fstab, skipping"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "=============================================="
echo "   ✅  LFS Host Environment Ready!"
echo "=============================================="
echo ""
info "LFS root:     $LFS        ($PART3)"
info "LFS boot:     $LFS/boot   ($PART1)"
info "LFS swap:     $PART2"
info "LFS sources:  $LFS/sources"
info "LFS tools:    $LFS/tools"
info "Build user:   lfs (password: lfs)"
echo ""
info "Next steps:"
echo "  1. Switch to the lfs user:  su - lfs"
echo "  2. Verify environment:      echo \$LFS  (should print /mnt/lfs)"
echo "  3. Download LFS packages:   wget the package list from the LFS book"
echo "  4. Start building:          Follow LFS Chapter 5"
echo ""
