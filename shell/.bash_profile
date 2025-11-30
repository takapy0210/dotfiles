# ============================================
# Bash Profile
# ============================================

# Load .bashrc if it exists
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# ============================================
# macOS Specific Settings
# ============================================

# Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
