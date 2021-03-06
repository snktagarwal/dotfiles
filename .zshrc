# ---[ Environment ]---------------------------------------------------
export PS_PERSONALITY='linux'
[[ $TERM == eterm-color ]] && export TERM=xterm
if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  unfunction precmd
  unfunction preexec
  PS1='$ '
fi

# ---[ Keychain ]------------------------------------------------------
# keychain --nogui -q ~/.ssh/id_rsa
# source ~/.keychain/localhost-sh

# ---[ Autojump ]------------------------------------------------------
source ~/z/z.sh
function j () {
    z "$@" || return 0;
}
function _z_preexec () {
    z --add "$(pwd -P)";
}

preexec_functions=(_z_preexec $preexec_functions)

# ---[ Modules ]-------------------------------------------------------
zmodload zsh/complist
autoload -Uz compinit
compinit
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -ap zsh/mapfile mapfile

# ---[ Modules ]-------------------------------------------------------
. ~/.zshprompt
setprompt

# ---[ cdm function ]--------------------------------------------------
function cdm () {
    local tmp
    if [[ -z "${TMUX}" ]]; then
        echo 'fatal: Not inside tmux.'
        return 1
    fi
    if [[ -n "$1" ]]; then
        [[ "$1" == . ]] && tmp="${PWD}" || tmp="$1"
    else
        tmp="${HOME}"
    fi
    cd "${tmp}"
    tmp="${PWD}"
    tmux "set-option" "default-path" "${tmp}"
    [[ -n "${DISPLAY}" ]] && tmp=on || tmp=off
    tmux "set-option" "set-titles" "${tmp}"
    echo .
    return 0
}

# ---[ Autols ]--------------------------------------------------------
function chpwd() {
    case `pwd` in
	*'git'*|'/tmp') ;;
	*) ls --color -v ;;
    esac
}

# ---[ Shell exports ]-------------------------------------------------
export EDITOR="emacsclient"
export PATH=~/svn/prefix/svn-trunk/bin:~/bin:~/bin/depot_tools:~/.ruby/bin:~/.python/bin:~/.cabal/bin:$PATH
export PYTHONPATH=~/.python/lib
export GEM_HOME=~/.ruby
export PYTHONSTARTUP=~/.pythonrc
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
export ACK_PAGER='less -r'

# ---[ Amazon AWS ]-------------------------------------------------
export EC2_HOME=~/.ec2
export PATH=$PATH:$EC2_HOME/bin
export JAVA_HOME=/usr

# ---[ GPG Key ]-------------------------------------------------------
export GPGKEY=B8BB3FE9

# ---[ Debian Developer ]----------------------------------------------
export DEBFULLNAME="Ramkumar Ramachandra"
export DEBEMAIL="artagnon@gmail.com"

# ---[ Simple calculator ]---------------------------------------------
function calc () {
    awk "BEGIN { print $@ }"
}

# ---[ Aliases ]-------------------------------------------------------
# abbreviations
function l () {
    case "$1" in
	date|mtime)
	    shift
	    ls --color -vt "$@"
	    ;;
	atime)
	    shift
	    ls --color -vu "$@"
	    ;;
	recent)
	    shift
	    ls --color -vt "$@" | head -n 5
	    ;;
	size)
	    shift
	    ls --color -vS "$@"
	    ;;
	all)
	    shift
	    ls --color -vlha "$@"
	    ;;
	extension)
	    shift
	    ls --color -vX "$@"
	    ;;
	*)
	    ls --color -v "$@"
	    ;;
    esac
}
alias ll='ls -lha'
alias halt='sudo halt'
alias reboot='sudo reboot'
alias hibernate='sudo pm-hibernate'
alias grep='ack-grep -i'
alias diff='diff -u'
alias less='less -r'
alias ec='emacsclient'
alias ecr='emacsclient -n -c'
alias et='emacsclient -t'
alias fetch='git fetch'

# apt aliases
alias au='sudo aptitude update'
alias aup='sudo aptitude safe-upgrade'
alias ai='sudo aptitude install'
alias as='aptitude search'
alias ashow='aptitude show'
alias arp='sudo aptitude purge'
alias dl='dpkg -l | grep'
alias dL='dpkg -L'

# tiny helpers
alias rmdup='find . -name "*\ \(1\)*" -exec rm {} \;'
alias entertain='vlc "$(find . -type f -regextype posix-awk -iregex ".*\.(avi|mpg|mpeg|mkv|wmv|dat)$" | sort --random-sort | head -n 1)"'
alias sprunge='curl -F "sprunge=<-" http://sprunge.us'
alias xrandr-restore='xrandr --output CRT1 --auto; xrandr --output CRT2 --auto; xrandr --output CRT2 --left-of CRT1'
alias incognito='export HISTFILE=/dev/null'
alias git-prove='make -j 8 DEFAULT_TEST_TARGET=prove GIT_PROVE_OPTS="-j 15" test'

# suffix aliases
alias -s html=x-www-browser
alias -s org=$EDITOR
alias -s c=$EDITOR
alias -s cc=$EDITOR
alias -s hs=$EDITOR
alias -s pdf=evince
alias -s djvu=evince
alias -s avi=vlc
alias -s mpg=vlc
alias -s mpeg=vlc
alias -s mkv=vlc
alias -s wmv=vlc
alias -s dat=vlc
alias -s mp3=mpg321

# ---[ ZSH Options ]----------------------------------------------------
setopt   NO_GLOBAL_RCS NO_FLOW_CONTROL NO_BEEP MULTIOS
setopt   AUTO_LIST NO_LIST_AMBIGUOUS MENU_COMPLETE AUTO_REMOVE_SLASH
setopt   LIST_PACKED LIST_TYPES
setopt   INC_APPEND_HISTORY EXTENDED_HISTORY SHARE_HISTORY HIST_REDUCE_BLANKS
setopt   HIST_SAVE_NO_DUPS HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_EXPIRE_DUPS_FIRST
setopt   NO_NOTIFY LONG_LIST_JOBS
setopt   AUTO_CD AUTO_PUSHD PUSHD_SILENT

# ---[ History ]-------------------------------------------------------
HISTFILE=~/.zsh-history
HISTSIZE=30000
SAVEHIST=$HISTSIZE
# Save history across sessions and terminals
setopt append_history

# ---[ Completition system ]-------------------------------------------
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*' matcher-list '+' '+m:{|:lower:|}={|:upper:|}' '+l:|=* r:|=*' '+r:|[._-]=** r:|=**'
zstyle ':completion:*' list-colors no=00 fi=00 di=01\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32
zstyle ':completion:*' verbose yes
zstyle ':completion:*' insert-tab false
zstyle ':completion:*:*:git:*' verbose no
zstyle ':completion:*:files' ignored-patterns '*?.o' '*?~'
zstyle ':completion:*:files' file-sort 'date'
zstyle ':completion:*:default' list-prompt
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 5 )) )'
zstyle ':completion:*:functions' ignored-patterns '_*'

# ---[ ZLE ]------------------------------------------------------------
history-incremental-search-backward-initial() {
    zle history-incremental-search-backward $BUFFER
}
zle -N history-incremental-search-backward-initial
bindkey '^R' history-incremental-search-backward-initial
bindkey -M isearch '^R' history-incremental-search-backward

# ---[ System settings ]------------------------------------------------
limit -s coredumpsize 0
umask 0027
