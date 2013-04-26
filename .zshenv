# LaTeX class dir
export TEXINPUTS=".:~/.latex/:"

# Unicode: makes text happy
export LANG="en_US.UTF-8"
export LC_TIME="en_DK.UTF-8"

# Paths contain unique items; no duplicates
typeset -U path
path=(~/.cabal/bin ~/.rbenv/bin ~/bin /usr/local/sbin /usr/sbin /sbin $path /usr/local/bin /usr/bin /bin /usr/lib/vpnc /opt/HipChat/bin)

# Add a custom directory for completion scripts
fpath=(~/.zsh/Completion $fpath)

export EDITOR=vim
export VISUAL=vim
export MAILER=icedove

export PAGER="less -R"
export LESS="-iM"

export MPD_HOST=fnord:@goose
export MPD_PORT=6600
export VNC_VIA_CMD="/usr/bin/ssh -o 'ControlPath=/dev/nonexistant' -o 'ControlMaster=no' -f -L %L:%H:%R %G sleep 20"

# make -j3 by default, for make-kpkg (others?)
export CONCURRENCY_LEVEL=3

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
DIRSTACKSIZE=8

ulimit -c 50000
