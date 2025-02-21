#!/bin/sh

# Check .config folder exists
# If not, create it

if [ ! -d ~/.config ]; then
    mkdir ~/.config
fi

echo "Linking Configuration File"
echo "ln -s ${PWD}/.config/nvim ~/.config/nvim "
ln -sf "${PWD}"/.config/nvim ~/.config
ln -sf "${PWD}"/.config/starship.toml ~/.config/starship.toml

# Link Tmux Configuration
# If .tmux.conf exists, remove it

ln -sf "${PWD}"/.config/tmux/tmux.conf ~/.tmux.conf

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

echo "Downloading LazyGit"
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_${ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit

echo "Installing LazyGit"
if [ $(id -u) -ne 0 ]; then
    sudo install lazygit /usr/local/bin
else
    install lazygit /usr/local/bin
fi

echo "Remove the redundant lazygit.tar.gz and lazygit"
rm lazygit.tar.gz lazygit

NVIM_ZIP="nvim.tar.gz"
shell_name="$(basename "$SHELL")"

case "$_oss" in
Linux)
    case "$_cpu" in
    x86_64)
        echo "Downlaoding Neovim"
        curl -Lo $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
        ;;
    *)
        echo "Install Neovim using make"
        git clone https://github.com/neovim/neovim
        git checkout stable
        cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install u
        ;;
    esac
    ;;
Darwin)
    case "$_cpu" in
    arm64)
        echo "Downlaoding Neovim"
        curl -Lo $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
        ;;
    x86_64)
        echo "Downlaoding Neovim"
        curl -Lo $NVIM_ZIP https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf $NVIM_ZIP
        ;;
    *)
        p
        echo "Install Neovim using make"
        git clone https://github.com/neovim/neovim
        git checkout stable
        cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
        sudo make install
        ;;
    esac
    ;;
Windows)
    echo "Install Neovim using make"
    git clone https://github.com/neovim/neovim
    git checkout stable
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    ;;
*) err "Error: unsupport OS or CPU architecture for nvim" ;;
esac

rm $NVIM_ZIP

case "$shell_name" in
bash)
    config_file=".bashrc"
    ;;
zsh)
    config_file=".zshrc"
    ;;
*)
    echo "Unsupported shell: $shell_name"
    exit 1
    ;;
esac

# Export the current path to the configuration file
echo "export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"" >>~/"$config_file"

# Source the configuration file to apply the changes immediately
source ~/$config_file

curl -sS https://starship.rs/install.sh | sh

echo "Install Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#echo "Download and Install GCM"
#curl -L https://aka.ms/gcm/linux-install-source.sh | sh
#git-credential-manager configure
#git config --global credential.credentialStore gpg
#rm -rf git-credential-manager
