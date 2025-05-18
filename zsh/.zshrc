# macos
if [[ -f "opt/homebrew/bin/brew" ]]; then
    eval "$(opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# starship theme
# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
          atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
          atpull"%atclone" src"init.zsh"
zinit light starship/starship

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias grep='grep --color=always'

# Man Page
if command -v nvim >/dev/null 2>&1; then
    export MANPAGER='nvim +Man!'
fi

# eza Aliases
if command -v eza >/dev/null 2>&1; then
    # general use aliases updated for eza
    alias ls='eza' # Basic replacement for ls with eza
    alias l='eza --long -bF' # Extended details with binary sizes and type indicators
    alias ll='eza --long -a' # Long format, including hidden files
    alias llm='eza --long -a --sort=modified' # Long format, including hidden files, sorted by modification date
    alias la='eza -a --group-directories-first' # Show all files, with directories listed first
    alias lx='eza -a --group-directories-first --extended' # Show all files and extended attributes, directories first
    alias tree='eza --tree' # Tree view
    alias lS='eza --oneline' # Display one entry per line

    # new aliases than exa-zsh
    alias lT='eza --tree --long' # Tree view with extended details
    alias lr='eza --recurse --all' # Recursively list all files, including hidden ones
    alias lg='eza --grid --color=always' # Display entries as a grid with color
    alias ld='eza --only-dirs' # List only directories
    alias lf='eza --only-files' # List only files
    alias lC='eza --color-scale=size --long' # Use color scale based on file size
    alias li='eza --icons=always --grid' # Display with icons in grid format
    alias lh='eza --hyperlink --all' # Display all entries as hyperlinks
    alias lX='eza --across' # Sort the grid across, rather than downwards
    alias lt='eza --long --sort=type' # Sort by file type in long format
    alias lsize='eza --long --sort=size' # Sort by size in long format
    alias lmod='eza --long --modified --sort=modified' # Sort by modification date in long format, using the modified timestamp

    # Advanced filtering and display options
    alias ldepth='eza --level=2' # Limit recursion depth to 2
    alias lignore='eza --git-ignore' # Ignore files mentioned in .gitignore
    alias lcontext='eza --long --context' # Show security context
fi

# Shell integrations
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# wsl2-ssh-agent
if ( [[ $(uname -r) == *"microsoft"* ]] || grep -qi "microsoft" /proc/version 2>/dev/null ) && [[ -f /usr/sbin/wsl2-ssh-agent ]]; then
    eval "$(/usr/sbin/wsl2-ssh-agent)"
fi
