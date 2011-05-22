# LaTeX class dir
export TEXINPUTS=".:~/.latex/:"

# Unicode: makes text happy
export LANG="en_US.UTF-8"
export LC_TIME="en_DK.UTF-8"

# Paths contain unique items; no duplicates
typeset -U path
path=(~/bin /usr/local/sbin /usr/sbin /sbin $path /usr/local/bin /usr/bin /bin)

# Add a custom directory for completion scripts
fpath=(~/.zsh/Completion $fpath)

export EDITOR=vim
export VISUAL=vim

export PAGER=less
export LESS="-iM"

export MPD_HOST=fnord:@goose
export MPD_PORT=6600
export VNC_VIA_CMD="/usr/bin/ssh -o 'ControlPath=/dev/nonexistant' -o 'ControlMaster=no' -f -L %L:%H:%R %G sleep 20"

# make -j3 by default, for make-kpkg (others?)
export CONCURRENCY_LEVEL=3

ulimit -c 50000
