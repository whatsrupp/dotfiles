#!/bin/bash

# profiler
#zmodload zsh/zprof

antibody bundle <~/.zsh_plugins.txt >~/.zsh_plugins

### oh-my-zsh plugins pre-reqs
export ZSH_CACHE_DIR=~/.zsh/cache
mkdir -p $ZSH_CACHE_DIR
autoload -Uz compinit
compinit

autoload -U add-zsh-hook
add-zsh-hook chpwd node-version

### sources
source ~/.zsh_plugins
source ~/.sh_aliases
source ~/.sh_functions
source ~/.sh_settings
source ~/.sh_work
[ -f ~/.reformrc ] && source ~/.reformrc

### completions
if [ ! -f "/usr/local/share/zsh/site-functions/_gopass" ]; then
    gopass completion zsh | sudo tee /usr/local/share/zsh/site-functions/_gopass
fi

### key bindings
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "${terminfo[kdch1]}" delete-char

### history
HISTFILE=~/.zsh_history
HISTSIZE=1000
setopt appendhistory
setopt share_history
setopt incappendhistory

if [ -x "$(command -v pyenv)" ]; then
    eval "$(pyenv init -)"
fi

if [ -x "$(command -v fnm)" ]; then
    eval "$(fnm env --multi)"
fi

### lazy loading

kubectl() {
    if ! type __start_kubectl >/dev/null 2>&1; then
        source <(command kubectl completion zsh)
    fi

    command kubectl "$@"
}

kops() {
    if ! type __start_kops >/dev/null 2>&1; then
        source <(command kops completion zsh)
    fi

    command kops "$@"
}

node-version() {
    if [ -f "$(pwd)/.node-version" ]; then
        fnm use
    fi
}

### spaceship

export SPACESHIP_PROMPT_ORDER=(
    user # Username section
    host # Hostname section
    dir # Current directory section
    git # Git section (git_branch + git_status)
    node # Node.js section
    pyenv # Pyenv section
    aws # Amazon Web Services section
    exec_time # Execution time
    line_sep # Line break
    exit_code # Exit code section
    char # Prompt character
)

# prompt
export SPACESHIP_CHAR_SYMBOL="❯"
export SPACESHIP_CHAR_SUFFIX=" "
export SPACESHIP_PROMPT_PREFIXES_SHOW=false

# symbols
export SPACESHIP_NODE_SYMBOL="node:"
export SPACESHIP_PYENV_SYMBOL="python:"
export SPACESHIP_AWS_SYMBOL="aws:"

# git
export SPACESHIP_GIT_PREFIX=""
export SPACESHIP_GIT_SYMBOL=""
export SPACESHIP_GIT_BRANCH_PREFIX=""
export SPACESHIP_GIT_STATUS_PREFIX="["
export SPACESHIP_GIT_STATUS_SUFFIX="]"

# colours
export SPACESHIP_GIT_BRANCH_COLOR="#424242"
export SPACESHIP_GIT_STATUS_COLOR="#424242"
export SPACESHIP_NODE_COLOR="#424242"
export SPACESHIP_RUBY_COLOR="#424242"
export SPACESHIP_PYENV_COLOR="#424242"
export SPACESHIP_AWS_COLOR=red

# profiler
#zprof