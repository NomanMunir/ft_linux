# ft_linux — Build Your Own Linux Distribution 🐧

> 42 Project | _how_to_train_your_kernel_

Build a minimal, functional Linux distribution from scratch following
[Linux From Scratch (LFS)](https://www.linuxfromscratch.org/lfs/view/stable/).

## Requirements

- Linux Kernel **≥ 4.0** with custom version string containing your login
- **3+ partitions**: `/boot`, root `/`, and swap
- Bootloader (GRUB), init system (SysVinit/SystemD), module loader (Eudev)
- Filesystem Hierarchy Standard compliant
- Internet connectivity
- **70+ packages** compiled from source

## Quick Start

```bash
# 1. Create a Debian 12 VM in VirtualBox with a second disk (~20GB)

# 2. Inside the VM, clone and provision:
git clone https://github.com/NomanMunir/ft_linux.git /tmp/ft_linux
sudo bash /tmp/ft_linux/scripts/provision_host.sh /dev/sdb

# 3. Switch to the build user and start LFS:
su - lfs
```

See [docs/SETUP.md](docs/SETUP.md) for detailed setup instructions (Vagrant, manual, portable OVA).

## Project Structure

```
ft_linux/
├── README.md                    # This file
├── Vagrantfile                  # Automated VM setup (optional, needs Vagrant)
├── .gitignore
├── docs/
│   ├── SETUP.md                 # Environment setup guide
│   └── resources/
│       ├── en.subject.pdf       # Project subject (PDF)
│       └── subject.txt          # Project subject (text)
└── scripts/
    └── provision_host.sh        # Host provisioning script
```

## Submission

The VM disk image is not pushed. Only the checksum:

```bash
shasum < ft_linux.vdi > checksum.sha
```

## Resources

- [Linux From Scratch (LFS) Book](https://www.linuxfromscratch.org/lfs/view/stable/)
- [Filesystem Hierarchy Standard](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html)
- [GNU Autotools](https://www.gnu.org/software/automake/manual/html_node/Autotools-Introduction.html)
