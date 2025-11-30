# ============================================
# Bash Configuration
# ============================================

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# ============================================
# Environment Variables
# ============================================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='vim'

# ============================================
# PATH Configuration
# ============================================

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# User local bin
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# History Configuration
# ============================================

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# ============================================
# Bash Options
# ============================================

# Check window size after each command
shopt -s checkwinsize

# Enable programmable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ============================================
# Aliases
# ============================================

alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'

# Safe operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================
# Prompt
# ============================================

# Set a colorful prompt
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# ============================================
# Local Configuration
# ============================================

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi
