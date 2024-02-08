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
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
