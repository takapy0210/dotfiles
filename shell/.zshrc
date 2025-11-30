# ============================================
# Oh My Zsh Configuration
# ============================================

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# Options: "robbyrussell", "agnoster", "powerlevel10k/powerlevel10k", etc.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    docker
    kubectl
    aws
)

source $ZSH/oh-my-zsh.sh

# ============================================
# Environment Variables
# ============================================

# Language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Preferred editor
export EDITOR='vim'
export VISUAL='vim'

# ============================================
# PATH Configuration
# ============================================

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# User local bin
export PATH="$HOME/.local/bin:$PATH"

# ============================================
# pyenv Configuration (if installed)
# ============================================
if command -v pyenv 1>/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# ============================================
# Node Version Manager (if installed)
# ============================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ============================================
# peco - Interactive Filtering
# ============================================
if command -v peco &> /dev/null; then
    # History search with peco (Ctrl+R)
    function peco-history-selection() {
        BUFFER=`history -n 1 | tail -r | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection

    # Git branch selection with peco
    function peco-git-branch() {
        local branch=$(git branch -a | grep -v -e '->' -e '*' | perl -pe 's/^\h+//g' | perl -pe 's#^remotes/origin/##' | perl -nle 'print if !$c{$_}++' | peco | perl -pe 's/\n//g')
        if [ -n "$branch" ]; then
            if [ -n "$LBUFFER" ]; then
                BUFFER="$LBUFFER$branch"
            else
                BUFFER="git checkout $branch"
            fi
            CURSOR=$#BUFFER
        fi
        zle reset-prompt
    }
    zle -N peco-git-branch
    bindkey '^G' peco-git-branch
fi

# ============================================
# fzf - Fuzzy Finder (if installed)
# ============================================
if command -v fzf &> /dev/null; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

# ============================================
# AWS CLI Configuration
# ============================================
if command -v aws &> /dev/null; then
    # AWS CLI completion
    autoload bashcompinit && bashcompinit
    complete -C '/opt/homebrew/bin/aws_completer' aws
fi

# ============================================
# Aliases
# ============================================

# General
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Modern Unix tools (if installed)
if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -alh'
    alias tree='exa --tree'
fi

if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias dimg='docker images'

# Safe file operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Reload zsh config
alias reload='source ~/.zshrc'

# ============================================
# Custom Functions
# ============================================

# Create a directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extract various archive formats
extract() {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ============================================
# Local Configuration (Private)
# ============================================

# Source local configuration file if it exists
# Use this for machine-specific or private settings
# DO NOT commit .zshrc.local to git
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

# ============================================
# History Configuration
# ============================================

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
