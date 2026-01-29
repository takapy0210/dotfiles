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
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64-nvidia
export PROMPT_COMMAND="history -a"
export HISTFILE=/root/.zsh-history
export HISTSIZE=10000
export SAVEHIST=10000
export PYTHONDONTWRITEBYTECODE=1
export TF_CPP_MIN_LOG_LEVEL=2
