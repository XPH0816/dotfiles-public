#!/bin/sh

# Check .config folder exists
# If not, create it

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

ln -sf {$PWD}/.config/nvim ~/.config/nvim

# Link Tmux Configuration
# If .tmux.conf exists, remove it

ln -sf {$PWD}/.config/tmux/tmux.conf ~/.tmux.conf

if [ ! -d ~/.tmux/plugins/tpm ]; then
    mkdir -p ~/.tmux/plugins
fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

echo "Fetching the host system architecture..."

_oss="$(uname -s)"
_cpu="$(uname -m)"

case "$_oss" in
Linux) _oss=Linux ;;
Darwin) _oss=Darwin ;;
MINGW* | MSYS* | CYGWIN*) _oss=Windows ;;
*) err "Error: unsupported operating system: $_oss" ;;
esac

case "$_cpu" in
arm64 | aarch64) _cpu=arm64 ;;
x86_64 | x86-64 | x64 | amd64) _cpu=x86_64 ;;
i686 | i386) _cpu=32-bit ;;
*) err "Error: unsupported CPU architecture: $_cpu" ;;
esac

ARCH="${_oss}_${_cpu}"

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit
if [ $(id -u) -ne 0 ]; then
    sudo install lazygit /usr/local/bin
else
    install lazygit /usr/local/bin
fi

rm lazygit.tar.gz lazygit

NVIM_ZIP="nvim.tar.gz"

case "$_oss" in
Linux)
    if [[ "$_cpu" == "x86_64" ]]; then
        curl -LO $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
    else
        git clone https://github.com/neovim/neovim
        git checkout stable
        cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
    fi
    ;;
Darwin)
    if [[ "$_cpu" == "arm64" ]]; then
        curl -Lo $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
    elif [[ "$_cpu" == "x86_64" ]]; then
        curl -Lo $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
    else
        git clone https://github.com/neovim/neovim
        git checkout stable
        cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
    fi
    ;;
Windows)
    git clone https://github.com/neovim/neovim
    git checkout stable
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    ;;
*) err "Error: unsupport nvim" ;;
esac
