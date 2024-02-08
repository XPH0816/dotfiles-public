@echo off

cls

Rem Check Link Exists
if not exist %LOCALAPPDATA%\nvim\ (
    echo "Configuring Neovim"
    echo "Creating Symbolic Link"
    echo "Linking %LOCALAPPDATA%\nvim to %cd%\.config\nvim"
    mklink /d %LOCALAPPDATA%\nvim %cd%\.config\nvim

    echo "Neovim Configured"
) else (
    echo "Link already exists"
)

