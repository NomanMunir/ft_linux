# ft_linux — Environment Setup Guide

## Quick Start (Any Machine with VirtualBox)

This is the **no-Vagrant** approach. Works anywhere VirtualBox is installed.

### 1. Create a Debian 12 VM in VirtualBox

| Setting | Value                                            |
| ------- | ------------------------------------------------ |
| Name    | `ft_linux-host`                                  |
| Type    | Linux → Debian (64-bit)                          |
| RAM     | 4096 MB (minimum 2048)                           |
| CPUs    | 4 (minimum 2)                                    |
| Disk 1  | 20 GB (host system)                              |
| Disk 2  | 20 GB (LFS build — **add via Storage settings**) |
| Network | NAT (default)                                    |

> **How to add Disk 2**: VM Settings → Storage → SATA Controller →
> Click the "Add hard disk" icon → Create new → VDI → 20GB

### 2. Install Debian 12 Minimal

1. Download: https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/
   - Get the `netinst` ISO (~600MB)
2. Mount the ISO, boot the VM, install Debian
   - Choose **minimal install** (no desktop environment)
   - Set `root` password and create a regular user
   - Only select **SSH server** and **standard system utilities**

### 3. Run the Provisioning Script

After Debian boots, login as root and run:

```bash
# Install git (if not present)
apt-get install -y git

# Clone your ft_linux repo
git clone https://github.com/NomanMunir/ft_linux.git /tmp/ft_linux

# Run the provisioning script
# /dev/sdb is the second disk you added
bash /tmp/ft_linux/scripts/provision_host.sh /dev/sdb
```

That's it. The script handles everything:

- ✅ Installs all ~30 build packages
- ✅ Fixes symlinks (`sh→bash`, `yacc→bison`, `awk→gawk`)
- ✅ Runs the LFS version-check
- ✅ Partitions the second disk (boot + swap + root)
- ✅ Creates filesystems
- ✅ Mounts at `/mnt/lfs`
- ✅ Creates `lfs` user with proper environment
- ✅ Adds persistent mounts to `/etc/fstab`

### 4. Start Building LFS

```bash
su - lfs
echo $LFS          # Should print /mnt/lfs
echo $MAKEFLAGS    # Should print -j<num_cores>
```

---

## Portable VM (USB Transfer Between Home ↔ School)

### Export (do once)

```
File → Export Appliance → OVA format → Save to USB
```

### Import (on any other machine)

```
File → Import Appliance → Select the .ova file → Import
```

> The OVA contains the full VM state. You can resume exactly where you left off.

---

## Alternative: Home with Vagrant

If you have Vagrant installed:

```bash
cd ft_linux
vagrant up       # Creates VM + runs provision script automatically
vagrant ssh      # SSH into the VM
```

---

## File Structure

```
ft_linux/
├── Vagrantfile                  # Automated VM setup (needs Vagrant)
├── scripts/
│   └── provision_host.sh        # Standalone provisioning (works anywhere)
├── resources/
│   ├── en.subject.pdf
│   └── subject.txt
└── README.md
```
