# Chapter 7 — Entering Chroot and Building Additional Temporary Tools

> **LFS Version:** 12.4
> **Run as:** root (host for 7.2–7.4, chroot for 7.5–7.13)
> **Reference:** https://www.linuxfromscratch.org/lfs/view/12.4/chapter07/chapter07.html

---

## 7.1 Overview

This chapter enters the chroot environment and builds the remaining temporary
tools needed before the final system packages are compiled in Chapter 8.

Scripts 01–03 prepare the environment (ownership, virtual kernel FS, chroot
entry, directory layout, and essential files). Scripts 04–09 build temporary
tool packages inside chroot. Script 10 cleans up and optionally backs up the
temporary system.

---

## Script List

| # | Sections | Script | Description |
|---|----------|--------|-------------|
| 01 | 7.2–7.4 | `01-chroot-preparation.sh` | Change ownership, mount virtual kernel FS, enter chroot |
| 02 | 7.5 | `02-creating-directories.sh` | Create the full directory layout |
| 03 | 7.6 | `03-creating-essential-files.sh` | Create essential files and symlinks |
| 04 | 7.7 | `04-gettext.sh` | Gettext-0.26 (temp tools) |
| 05 | 7.8 | `05-bison.sh` | Bison-3.8.2 (temp tools) |
| 06 | 7.9 | `06-perl.sh` | Perl-5.42.0 (temp tools) |
| 07 | 7.10 | `07-python.sh` | Python-3.13.7 (temp tools) |
| 08 | 7.11 | `08-texinfo.sh` | Texinfo-7.2 (temp tools) |
| 09 | 7.12 | `09-util-linux.sh` | Util-linux-2.41.1 (temp tools) |
| 10 | 7.13 | `10-cleanup-backup.sh` | Clean up and (optionally) back up |

---

## Package Build Summary

| # | Package | Build Time | Disk |
|---|---------|------------|------|
| 04 | Gettext-0.26 | 1.5 SBU | 463 MB |
| 05 | Bison-3.8.2 | 0.2 SBU | 58 MB |
| 06 | Perl-5.42.0 | 0.6 SBU | 295 MB |
| 07 | Python-3.13.7 | 0.5 SBU | 546 MB |
| 08 | Texinfo-7.2 | 0.2 SBU | 152 MB |
| 09 | Util-linux-2.41.1 | 0.2 SBU | 192 MB |

**Total estimated disk:** ~1.7 GB
**Total estimated time:** ~3.2 SBU

---

## Workflow

### 1. Prepare and enter chroot (run on host as root)

```bash
# Ensure $LFS is set
export LFS=/mnt/lfs

bash 01-chroot-preparation.sh

# Then manually enter chroot:
chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin     \
    MAKEFLAGS="-j$(nproc)"      \
    TESTSUITEFLAGS="-j$(nproc)" \
    /bin/bash --login
```

### 2. Create directories and essential files (inside chroot)

```bash
bash /scripts/chapter-07-entering-chroot/02-creating-directories.sh
bash /scripts/chapter-07-entering-chroot/03-creating-essential-files.sh

# Re-login to pick up /etc/passwd
exec /usr/bin/bash --login
```

### 3. Build temporary tool packages (inside chroot)

```bash
for script in 04-gettext.sh 05-bison.sh 06-perl.sh \
              07-python.sh 08-texinfo.sh 09-util-linux.sh; do
    bash /scripts/chapter-07-entering-chroot/$script
done
```

### 4. Clean up

```bash
bash /scripts/chapter-07-entering-chroot/10-cleanup-backup.sh
```

---

## Notes

- **Script 01** must be run on the **host system** as `root` (not inside chroot).
- **Scripts 02–10** must be run **inside the chroot** environment.
- After running script 03, run `exec /usr/bin/bash --login` to resolve
  the "I have no name!" prompt.
- The backup step in script 10 is **optional** but highly recommended.
- If you leave chroot at any point, re-mount virtual kernel FS (7.3)
  and re-enter chroot (7.4) before continuing.
