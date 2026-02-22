#!/bin/bash
# ============================================================
# LFS 12.4 — Chapter 8.73: Vim-9.1.1166
# Run as: root (inside chroot)
# Approximate build time: 2.0 SBU
# Required disk space:    236 MB
# ============================================================
set -euo pipefail

echo ">>> Building Vim-9.1.1166..."

cd /sources
tar -xf vim-9.1.1166.tar.gz
cd vim-9.1.1166

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

./configure --prefix=/usr

make

chown -R tester .
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" &> vim-test.log || true

make install

ln -sv vim /usr/bin/vi

for L in /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done

ln -sv ../vim/vim91/doc /usr/share/doc/vim-9.1.1166

cat > /etc/vimrc << "VIMRC_EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not
" having this line gives problems with some default fonts.
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
VIMRC_EOF

cd /sources
rm -rf vim-9.1.1166

echo ">>> Vim-9.1.1166 — DONE"
