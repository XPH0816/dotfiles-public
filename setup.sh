#!/bin/sh

# Check .config folder exists
# If not, create it

if [ ! -d ~/.config ]; then
	mkdir ~/.config
fi

ln -sf $PWD/.config/nvim ~/.config/nvim

# Link Tmux Configuration
# If .tmux.conf exists, remove it

ln -sf ${PWD}/.config/tmux/tmux.conf ~/.tmux.conf

if [ ! -d ~/.tmux/plugins/tpm ]; then
	mkdir -p ~/.tmux/plugins
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

echo "Fetching the host system architecture..."

local _oss
local _cpu
local _arc

_oss="$(uname -s)"
_cpu="$(uname -m)"

case "$_oss" in
    Linux) _oss=Linux;;
    Darwin) _oss=Darwin;;
    MINGW* | MSYS* | CYGWIN*) _oss=Windows;;
    *) err "Error: unsupported operating system: $_oss";;
esac

case "$_cpu" in
    arm64 | aarch64) _cpu=arm64;;
    x86_64 | x86-64 | x64 | amd64) _cpu=x86_64;;
    i686 | i386) _cpu=32-bit;;
    *) err "Error: unsupported CPU architecture: $_cpu";;
esac

ARCH="${_oss}_${_cpu}"

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit
if [ $(id -u) -ne 0 ]
  sudo install lazygit /usr/local/bin
  exit
else
  install lazygit /usr/local/bin
fi
rm lazygit.tar.gz lazygit
