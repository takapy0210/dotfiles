#!/bin/bash

# VSCode Extensions Installer
# This script installs all extensions listed in extensions.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing VSCode extensions...${NC}\n"

# Check if VSCode is installed
if ! command -v code &> /dev/null; then
    echo -e "${YELLOW}Error: 'code' command not found.${NC}"
    echo "Please install VSCode and ensure 'code' is in your PATH."
    echo "To add 'code' to PATH: Open VSCode → Command Palette (Cmd+Shift+P) → 'Shell Command: Install code command in PATH'"
    exit 1
fi

# Check if extensions.txt exists
if [ ! -f "$EXTENSIONS_FILE" ]; then
    echo -e "${YELLOW}Error: extensions.txt not found at $EXTENSIONS_FILE${NC}"
    exit 1
fi

# Read extensions.txt and install each extension
installed_count=0
skipped_count=0

while IFS= read -r extension; do
    # Skip empty lines and comments
    if [[ -z "$extension" ]] || [[ "$extension" =~ ^#.* ]]; then
        continue
    fi

    # Trim whitespace
    extension=$(echo "$extension" | xargs)

    # Check if extension is already installed
    if code --list-extensions | grep -q "^${extension}$"; then
        echo -e "${YELLOW}⊘ Already installed: ${extension}${NC}"
        ((skipped_count++))
    else
        echo -e "${GREEN}↓ Installing: ${extension}${NC}"
        code --install-extension "$extension" --force
        ((installed_count++))
    fi
done < "$EXTENSIONS_FILE"

echo -e "\n${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Extension installation completed!  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo -e "\n${GREEN}Installed: ${installed_count}${NC}"
echo -e "${YELLOW}Skipped (already installed): ${skipped_count}${NC}\n"
