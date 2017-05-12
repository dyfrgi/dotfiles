# LaTeX class dir
export TEXINPUTS=".:~/.latex/:"

# Unicode: makes text happy
export LANG="en_US.UTF-8"
export LC_TIME="en_DK.UTF-8"

# Paths contain unique items; no duplicates
typeset -U path
path=(~/.cabal/bin ~/bin ~/perl5/bin ~/.pyenv/bin ~/serverfarm /usr/local/sbin /usr/sbin /sbin $path /usr/local/bin /usr/bin /bin /usr/lib/vpnc /opt/HipChat/bin)

export CC="ccache gcc-4.9"
export CXX="ccache g++-4.9"

export EDITOR=vim
export VISUAL=vim
export MAILER=icedove

export PAGER="less -R"
export LESS="-iM"

export EMAIL="michael.leuchtenburg@hpe.com"

export MPD_HOST=fnord:@goose
export MPD_PORT=6600
export VNC_VIA_CMD="/usr/bin/ssh -o 'ControlPath=/dev/nonexistant' -o 'ControlMaster=no' -f -L %L:%H:%R %G sleep 20"

export SVNROOT="svn+ssh://svn/repos/"

# make -j3 by default, for make-kpkg (others?)
export CONCURRENCY_LEVEL=3

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
DIRSTACKSIZE=8

ulimit -c 50000

export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local
