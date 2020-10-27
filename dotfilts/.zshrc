# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_UPDATE_PROMPT="true"
# export UPDATE_ZSH_DAYS=13
# DISABLE_MAGIC_FUNCTIONS=true
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="yyyy-mm-dd"

# ZSH_CUSTOM=/path/to/new-custom-folder
plugins=(
  git
  httpie
  git-flow
  zsh-autosuggestions
  zsh-syntax-highlighting
  # autojump
  # history-substring-search
  # zsh-navigation-tools
)

PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$fg[white]%}@ \
%{$fg[green]%}%M \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"


# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish


source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
# export ARCHFLAGS="-arch x86_64"
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# -----------------------------------------------------------------------------

# proxy
# export http_proxy=http://127.0.0.1:1087
# export https_proxy=http://127.0.0.1:1087
# export ALL_PROXY=socks5://127.0.0.1:1086

# locale
export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# homebrew
export HOMEBREW_NO_AUTO_UPDATE=true

# nvm
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# rvm
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# node
_nodePath=`which node`
export NODE_PATH=${_nodePath/%bin\/node/lib\/node_modules}

# android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# flutter
export FLUTTER_HOME="$HOME/Library/flutter"
export PATH="$PATH:$FLUTTER_HOME/bin"
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# depot_tools
export DEPOT_TOOLS_HOME="$HOME/Library/depot_tools"
export PATH=$PATH:$DEPOT_TOOLS_HOME

# python
export PATH="$HOME/bin:/usr/local/bin:$PATH"
# export PATH="/usr/local/opt/python/libexec/bin:$PATH"

# java
#jenv
# eval "$(jenv init -)"
# export PATH="$HOME/.jenv/bin:$PATH"
export JAVA_8_HOME='/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home'
export JAVA_11_HOME='/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home'
# 默认 jdk11
export JAVA_HOME=$JAVA_8_HOME

# 动态切换版本
alias jdk8="export JAVA_HOME=$JAVA_8_HOME"
alias jdk11="export JAVA_HOME=$JAVA_11_HOME"

# alias
alias shs='cat ~/.zsh_history | ag '
alias ip='curl ip.cn'
alias pc='proxychains4'
alias karabiner_cli="'/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'"

# chrome
_chromePath='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome'
alias chrome=$_chromePath
alias google-chrome=$_chromePath
alias chromex="chrome --disable-web-security"

# git
alias gbr='git branch -r --sort=-committerdate --format "%(creatordate:relative);%(committerdate:short);%(committername);%(refname:lstrip=-2)" | grep -v ";HEAD$" | column -s ";" -t'

alias gdr='git diff @{1}..'
alias gdc='git diff --cached'

alias gc1='git clone --depth=1'

alias gdl='f() { \
  git filter-branch --force --index-filter \
    "git rm --cached --ignore-unmatch $1" \
    --prune-empty --tag-name-filter cat -- --all
}; f'

# exec
# history
export HISTCONTROL=ignoreboth:erasedups
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh   # zsh
# [ -f ~/.fzf.bash ] && source ~/.fzf.bash # bash
bindkey \^U backward-kill-line

bindkey '^[^[[D' emacs-backward-word   # Alt-Left
bindkey '^[^[[C' emacs-forward-word    # Alt-Right

# custom function
gssl() {
  if [ ! -n "$1" ];then
    echo 'Parameter 1 is file name'
    return
  fi
  if  [ ! -n "$2" ]; then
    echo 'Parameter 2 is domain name'
    return
  fi

  local SSL_PATH="${HOME}/ssl"
  if [ ! -d $SSL_PATH ]; then
    mkdir -p $SSL_PATH
  fi
  openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout "$SSL_PATH/$1.key" \
    -new \
    -out "$SSL_PATH/$1.crt" \
    -subj /CN=$2 \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /System/Library/OpenSSL/openssl.cnf \
        <(printf "[SAN]\nsubjectAltName=DNS:$2")) \
    -sha256 \
    -days 3650
  open $SSL_PATH
}

source ~/.bash_profile

# other
# show Mac info
# archey
# eval $(thefuck --alias)

# export PATH=$PATH:/Applications/Visual" "Studio" "Code.app/Contents/Resources/app/bin
# export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
# set -o emacs
# set -o vi

# alias vim='/usr/local/bin/vim'
# alias vi='/usr/local/bin/vim'

# alias dex2jar='~/Library/Application\ Support/dex-tools-2.1-SNAPSHOT/d2j-dex2jar.sh'

# alias python2='python'
# alias git='LANG=en_GB git'

# alias -s html=mate   # 在命令行直接输入后缀为 html 的文件名，会在 TextMate 中打开
# alias -s rb=mate     # 在命令行直接输入 ruby 文件，会在 TextMate 中打开
# alias -s py=vi       # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
# alias -s js=vi
# alias -s c=vi
# alias -s java=vi
# alias -s txt=vi
# alias -s gz='tar -xzvf'
# alias -s tgz='tar -xzvf'
# alias -s zip='unzip'
# alias -s bz2='tar -xjvf'
# alias -s html='vim'   # 在命令行直接输入后缀为 html 的文件名，会在 Vim 中打开
# alias -s rb='vim'     # 在命令行直接输入 ruby 文件，会在 Vim 中打开
# alias -s py='vim'      # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
# alias -s js='vim'
# alias -s c='vim'
# alias -s java='vim'
# alias -s txt='vim'
# alias -s gz='tar -xzvf' # 在命令行直接输入后缀为 gz 的文件名，会自动解压打开
# alias -s tgz='tar -xzvf'
# alias -s zip='unzip'
# alias -s bz2='tar -xjvf'

# alias atom='/Applications/Atom.app/Contents/MacOS/Atom'
# alias subl='/Applications/SublimeText.app/Contents/SharedSupport/bin/subl'
# alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code'

