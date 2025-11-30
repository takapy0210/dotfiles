#!/bin/bash

# VSCode Extensions Exporter
# This script exports currently installed extensions to extensions.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTENSIONS_FILE="$SCRIPT_DIR/extensions.txt"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Exporting VSCode extensions...${NC}\n"

# Check if VSCode is installed
if ! command -v code &> /dev/null; then
    echo -e "${YELLOW}Error: 'code' command not found.${NC}"
    echo "Please install VSCode and ensure 'code' is in your PATH."
    exit 1
fi

# Backup existing extensions.txt if it exists
if [ -f "$EXTENSIONS_FILE" ]; then
    backup_file="${EXTENSIONS_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$EXTENSIONS_FILE" "$backup_file"
    echo -e "${YELLOW}Backed up existing extensions.txt to: $backup_file${NC}\n"
fi

# Create header
cat > "$EXTENSIONS_FILE" << 'EOF'
# VSCode Extensions List
# This file contains all installed VSCode extensions
# Install all extensions: ./install-extensions.sh
# Or manually: cat extensions.txt | grep -v "^#" | xargs -L 1 code --install-extension

EOF

# Get all installed extensions
echo -e "${GREEN}Fetching installed extensions...${NC}"
extensions=$(code --list-extensions)

# Categorize extensions (basic categorization)
echo "" >> "$EXTENSIONS_FILE"
echo "# ============================================" >> "$EXTENSIONS_FILE"
echo "# Installed Extensions" >> "$EXTENSIONS_FILE"
echo "# ============================================" >> "$EXTENSIONS_FILE"

echo "$extensions" | while IFS= read -r ext; do
    echo "$ext" >> "$EXTENSIONS_FILE"
done

extension_count=$(echo "$extensions" | wc -l | xargs)

echo -e "\n${GREEN}╔══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  Extensions exported successfully!  ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════╝${NC}"
echo -e "\n${GREEN}Total extensions: ${extension_count}${NC}"
echo -e "${GREEN}Saved to: ${EXTENSIONS_FILE}${NC}\n"
echo -e "${YELLOW}Note: You can manually categorize the extensions in ${EXTENSIONS_FILE}${NC}\n"
