# ~/.zshrc
# Michael Leuchtenburg
# Some parts taken from http://dev.gentoo.org/~slarti/conf/zshrc.html

setopt auto_pushd pushd_silent pushd_ignore_dups pushd_to_home pushd_minus
setopt auto_continue nobeep no_check_jobs no_hup extended_glob nomatch
setopt histignoredups append_history hist_save_no_dups inc_append_history

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
DIRSTACKSIZE=8
HOSTV=`uname -s`

bindkey -e
bindkey "^[[H" beginning-of-line
bindkey "^[[7~" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[3~" delete-char

case $HOSTV in 
    SunOS)
        alias ls="ls -F"
        ;;
    *BSD*)
        alias ls="ls -G"
        ;;
    *)
        alias ls="ls --color=auto"
        ;;
esac

alias dh="dirs -v"
alias ll="ls -l"
alias la="ls -a"
alias lla="ls -la"
alias rs="rsync -essh -rtpvz"
alias mmv='noglob zmv -W'
alias alsamixer='alsamixer -V all'
alias mtr='mtr --curses'

# Show the size of the arguments, sorted by size
function ss {
    du -s ${*:-*} | sort -n
}

autoload -U zmv
autoload -U zcalc

# Like xargs, but instead of reading lines of arguments from standard input,
# it takes them from the command line. This is possible/useful because,
# especially with recursive glob operators, zsh often can construct a command
# line for a shell function that is longer than can be accepted by an external
# command. This is what's often referred to as the "shitty Linux exec limit" ;)
# The limitation is on the number of characters or arguments.
# 
# slarti@pohl % echo {1..30000}
# zsh: argument list too long: /bin/echo
# zsh: exit 127   /bin/echo {1..30000}
autoload -U zargs

# Makes it easy to type URLs as command line arguments. As you type, the
# input character is analyzed and, if it mayn eed quoting, the current
# word is checked for a URI scheme. If one is found and the current word
# is not already quoted, a blackslash is inserted before the input
# caracter.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Set up completion
zmodload zsh/complist

zstyle ':completion:*' completer _complete 
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-grouped true
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '+m:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original false
zstyle ':completion:*' select-prompt %SSelected: %l%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute false
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' use-perl true

# ignore backup files when completing commands
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:descriptions' format "%B---- %d%b"
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters 
zstyle ':completion:*:kill:*' force-list always


: ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
if [ -f $HOME/.ssh/known_hosts ]; then
    _ssh_known_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*})
fi

zstyle ':completion:*:*:*:users' ignored-patterns \
	adm alias apache at bin cron cyrus daemon ftp games gdm guest halt ident junkbust ldap lp mail mailnull man mysql \
	named news nfsnobody nobody nscd ntp nut operator pcap portage postfix postgres postmaster qmaild qmaill qmailp qmailq qmailr qmails radvd \
	rpc rpcuser rpm shutdown mmsp vpopmail quid sshd sync uucp vcsa xfs

zstyle '*' single-ignored show

hosts=(
	$_etc_hosts[@]
	$_ssh_known_hosts[@]
	localhost
      )
zstyle ':completion:*' hosts $hosts

autoload -U compinit
compinit

setprompt () {
    autoload -U colors
    colors

    red="%{$fg[red]%}"
    blue="%{$fg[blue]%}"
    bblue="%{$fg_bold[blue]%}"
    green="%{$fg[green]%}"
    magenta="%{$fg[magenta]%}"
    cyan="%{$fg[cyan]%}"
    default="%{$reset_color%}"

    PROMPT="%B${blue}[%b$cyan%(!.ROOT.%n)$green@$cyan%m$green:$cyan%~%B$blue]%b%(0#.$red#$default.$default%%) "
    PROMPT="${blue}[$cyan%(!.ROOT.%n)$green@$cyan%m$green:$cyan%~$blue]%(0#.$red#$default.$default%%) "
    RPROMPT="%(?..[$red%?$default])[$cyan%*$default]"
}

setprompt

function title () {
    local CMD=$1
    local ARGS=$2

    case $TERM in
	xterm*) ;&
	rxvt*)
        print -nP "\e]2;"
        print -nP "${CMD:+ $CMD $ARGS : }"
        print -nP "%n@%m:%~"
        print -nP "\a"
    ;;
	screen)
        print -nP "\e\"${CMD:-%~}\e\\"
        print -nP "\e_"
        print -nP "#$WINDOW : ${CMD:+ $CMD : }%n@%m:%~"
        print -nP "\e\\"
    ;;
	*)
	    TITLEBAR=''
    ;;
    esac
}

function preexec() {
    local -a cmd
    cmd=(${(z)1})

    title $cmd[1] "$cmd[2,-1]"
}

function precmd() {
    title
}

function ssenv() {
   path=(/home/dyfrgi/work/hampshire/code/build/bin $path)
   export CC=sslittle-na-sstrix-gcc
   export BUILD_CC=gcc
   export AR=sslittle-na-sstrix-ar
   export RANLIB=sslittle-na-sstrix-ranlib
}
