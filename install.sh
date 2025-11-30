#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${GREEN}Starting dotfiles installation...${NC}"
echo -e "Dotfiles directory: ${DOTFILES_DIR}"

# Create backup directory
mkdir -p "$BACKUP_DIR"
echo -e "${YELLOW}Backup directory created: ${BACKUP_DIR}${NC}"

# Function to create symlink safely
create_symlink() {
    local source="$1"
    local target="$2"

    # Create target directory if it doesn't exist
    local target_dir=$(dirname "$target")
    mkdir -p "$target_dir"

    # Backup existing file/directory if it exists and is not a symlink
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo -e "${YELLOW}Backing up existing file: $target${NC}"
        cp -r "$target" "$BACKUP_DIR/"
        rm -rf "$target"
    elif [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    fi

    # Create symlink
    ln -s "$source" "$target"
    echo -e "${GREEN}✓ Created symlink: $target -> $source${NC}"
}

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo -e "${GREEN}✓ Homebrew is already installed${NC}"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo -e "${GREEN}Installing packages from Brewfile...${NC}"
    brew bundle --file="$DOTFILES_DIR/Brewfile"
else
    echo -e "${YELLOW}Warning: Brewfile not found${NC}"
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}✓ Oh My Zsh is already installed${NC}"
fi

# Create symlinks for shell configuration
echo -e "\n${GREEN}Creating symlinks for shell configuration...${NC}"
create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/shell/.bashrc" "$HOME/.bashrc"
create_symlink "$DOTFILES_DIR/shell/.bash_profile" "$HOME/.bash_profile"

# Create symlinks for Git configuration
echo -e "\n${GREEN}Creating symlinks for Git configuration...${NC}"
create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

# Create symlinks for SSH configuration
echo -e "\n${GREEN}Creating symlinks for SSH configuration...${NC}"
create_symlink "$DOTFILES_DIR/config/ssh/config" "$HOME/.ssh/config"

# Set proper permissions for SSH config
chmod 600 "$HOME/.ssh/config"

# Create symlinks for VSCode configuration
echo -e "\n${GREEN}Creating symlinks for VSCode configuration...${NC}"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_USER_DIR" ]; then
    create_symlink "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_USER_DIR/settings.json"
    create_symlink "$DOTFILES_DIR/config/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

    # Install VSCode extensions
    if command -v code &> /dev/null; then
        echo -e "\n${GREEN}Installing VSCode extensions...${NC}"
        if [ -f "$DOTFILES_DIR/config/vscode/install-extensions.sh" ]; then
            bash "$DOTFILES_DIR/config/vscode/install-extensions.sh"
        fi
    else
        echo -e "${YELLOW}VSCode 'code' command not found. Skipping extension installation.${NC}"
        echo -e "${YELLOW}To install extensions later, run: $DOTFILES_DIR/config/vscode/install-extensions.sh${NC}"
    fi
else
    echo -e "${YELLOW}VSCode user directory not found. Skipping VSCode configuration.${NC}"
fi

echo -e "\n${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Dotfiles installation completed!   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Restart your terminal or run: ${GREEN}source ~/.zshrc${NC}"
echo -e "2. Review your backed up files in: ${YELLOW}${BACKUP_DIR}${NC}"
echo -e "3. Customize your dotfiles as needed\n"
