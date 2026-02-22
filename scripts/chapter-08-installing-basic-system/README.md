# Chapter 8 — Installing Basic System Software

This chapter installs the final versions of all software packages that make up
the LFS system. Every script must be run **inside the chroot** as **root**.

## Prerequisites

- Chapters 5–7 completed (cross-toolchain, temp tools, chroot entered)
- All source tarballs downloaded to `/sources`
- Chroot environment active

## Package Build Order

| # | Script | Package | Section |
|---|--------|---------|---------|
| 01 | 01-man-pages.sh | Man-pages-6.12 | 8.3 |
| 02 | 02-iana-etc.sh | Iana-Etc-20250407 | 8.4 |
| 03 | 03-glibc.sh | Glibc-2.41 | 8.5 |
| 04 | 04-zlib.sh | Zlib-1.3.1 | 8.6 |
| 05 | 05-bzip2.sh | Bzip2-1.0.8 | 8.7 |
| 06 | 06-xz.sh | Xz-5.8.1 | 8.8 |
| 07 | 07-lz4.sh | Lz4-1.10.0 | 8.9 |
| 08 | 08-zstd.sh | Zstd-1.5.7 | 8.10 |
| 09 | 09-file.sh | File-5.46 | 8.11 |
| 10 | 10-readline.sh | Readline-8.2.13 | 8.12 |
| 11 | 11-m4.sh | M4-1.4.19 | 8.13 |
| 12 | 12-bc.sh | Bc-7.0.3 | 8.14 |
| 13 | 13-flex.sh | Flex-2.6.4 | 8.15 |
| 14 | 14-tcl.sh | Tcl-8.6.16 | 8.16 |
| 15 | 15-expect.sh | Expect-5.45.4 | 8.17 |
| 16 | 16-dejagnu.sh | DejaGNU-1.6.3 | 8.18 |
| 17 | 17-pkgconf.sh | Pkgconf-2.4.3 | 8.19 |
| 18 | 18-binutils.sh | Binutils-2.44 | 8.20 |
| 19 | 19-gmp.sh | GMP-6.3.0 | 8.21 |
| 20 | 20-mpfr.sh | MPFR-4.2.2 | 8.22 |
| 21 | 21-mpc.sh | MPC-1.3.1 | 8.23 |
| 22 | 22-attr.sh | Attr-2.5.2 | 8.24 |
| 23 | 23-acl.sh | Acl-2.3.2 | 8.25 |
| 24 | 24-libcap.sh | Libcap-2.76 | 8.26 |
| 25 | 25-libxcrypt.sh | Libxcrypt-4.4.38 | 8.27 |
| 26 | 26-shadow.sh | Shadow-4.17.4 | 8.28 |
| 27 | 27-gcc.sh | GCC-14.2.0 | 8.29 |
| 28 | 28-ncurses.sh | Ncurses-6.5 | 8.30 |
| 29 | 29-sed.sh | Sed-4.9 | 8.31 |
| 30 | 30-psmisc.sh | Psmisc-23.7 | 8.32 |
| 31 | 31-gettext.sh | Gettext-0.23.1 | 8.33 |
| 32 | 32-bison.sh | Bison-3.8.2 | 8.34 |
| 33 | 33-grep.sh | Grep-3.11 | 8.35 |
| 34 | 34-bash.sh | Bash-5.2.37 | 8.36 |
| 35 | 35-libtool.sh | Libtool-2.5.4 | 8.37 |
| 36 | 36-gdbm.sh | GDBM-1.24 | 8.38 |
| 37 | 37-gperf.sh | Gperf-3.1 | 8.39 |
| 38 | 38-expat.sh | Expat-2.7.1 | 8.40 |
| 39 | 39-inetutils.sh | Inetutils-2.5 | 8.41 |
| 40 | 40-less.sh | Less-668 | 8.42 |
| 41 | 41-perl.sh | Perl-5.40.2 | 8.43 |
| 42 | 42-xml-parser.sh | XML::Parser-2.47 | 8.44 |
| 43 | 43-intltool.sh | Intltool-0.51.0 | 8.45 |
| 44 | 44-autoconf.sh | Autoconf-2.72 | 8.46 |
| 45 | 45-automake.sh | Automake-1.17 | 8.47 |
| 46 | 46-openssl.sh | OpenSSL-3.4.1 | 8.48 |
| 47 | 47-libelf.sh | Libelf (elfutils-0.192) | 8.49 |
| 48 | 48-libffi.sh | Libffi-3.4.8 | 8.50 |
| 49 | 49-python.sh | Python-3.13.3 | 8.51 |
| 50 | 50-flit-core.sh | Flit-Core-3.12.0 | 8.52 |
| 51 | 51-packaging.sh | Packaging-25.0 | 8.53 |
| 52 | 52-wheel.sh | Wheel-0.46.1 | 8.54 |
| 53 | 53-setuptools.sh | Setuptools-80.9.0 | 8.55 |
| 54 | 54-ninja.sh | Ninja-1.13.1 | 8.56 |
| 55 | 55-meson.sh | Meson-1.8.3 | 8.57 |
| 56 | 56-kmod.sh | Kmod-34.2 | 8.58 |
| 57 | 57-coreutils.sh | Coreutils-9.7 | 8.59 |
| 58 | 58-diffutils.sh | Diffutils-3.12 | 8.60 |
| 59 | 59-gawk.sh | Gawk-5.3.2 | 8.61 |
| 60 | 60-findutils.sh | Findutils-4.10.0 | 8.62 |
| 61 | 61-groff.sh | Groff-1.23.0 | 8.63 |
| 62 | 62-grub.sh | GRUB-2.12 | 8.64 |
| 63 | 63-gzip.sh | Gzip-1.14 | 8.65 |
| 64 | 64-iproute2.sh | IPRoute2-6.14.0 | 8.66 |
| 65 | 65-kbd.sh | Kbd-2.7.1 | 8.67 |
| 66 | 66-libpipeline.sh | Libpipeline-1.5.8 | 8.68 |
| 67 | 67-make.sh | Make-4.4.1 | 8.69 |
| 68 | 68-patch.sh | Patch-2.8 | 8.70 |
| 69 | 69-tar.sh | Tar-1.35 | 8.71 |
| 70 | 70-texinfo.sh | Texinfo-7.2 | 8.72 |
| 71 | 71-vim.sh | Vim-9.1.1166 | 8.73 |
| 72 | 72-markupsafe.sh | MarkupSafe-3.0.2 | 8.74 |
| 73 | 73-jinja2.sh | Jinja2-3.1.6 | 8.75 |
| 74 | 74-udev.sh | Udev (Systemd-257.4) | 8.76 |
| 75 | 75-man-db.sh | Man-DB-2.13.0 | 8.77 |
| 76 | 76-procps-ng.sh | Procps-ng-4.0.5 | 8.78 |
| 77 | 77-util-linux.sh | Util-linux-2.41 | 8.79 |
| 78 | 78-e2fsprogs.sh | E2fsprogs-1.47.3 | 8.80 |
| 79 | 79-sysklogd.sh | Sysklogd-2.7.0 | 8.81 |
| 80 | 80-sysvinit.sh | SysVinit-3.14 | 8.82 |
| 81 | 81-stripping.sh | Stripping | 8.84 |
| 82 | 82-cleanup.sh | Cleanup | 8.85 |

## Usage

Each script is self-contained and intended for reference/documentation.
To run a script manually:

```bash
bash /path/to/XX-package.sh
```

> ⚠️ **Important:** These scripts are meant to be run in build order.
> Each package may depend on packages built before it.

## Notes

- All scripts use `set -euo pipefail` for strict error handling
- Source tarballs must be in `/sources`
- Build directories are cleaned up at the end of each script
- Tests are included where applicable (some may be skipped in practice)
- The `tester` user is used for running test suites as non-root
