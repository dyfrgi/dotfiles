#!/bin/zsh -l

# Merge resources with defaults for xterm, etc.
xrdb -merge .Xresources

ssh-add
if [ -f ~/.ssh/id_rsa_vertica_2016-10-03 ]; then
    ssh-add ~/.ssh/id_rsa_vertica_2016-10-03
fi

# PolicyKit Authentication Agent (needed for network-manager)
# NOTE: May be replaceable with /usr/lib/policykit-1/polkitd; investigate
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
# Network manager
nm-applet &
#wicd-client &

# Notification popups
/usr/lib/notify-osd/notify-osd & # backgrounds itself, but background just in case this changes, etc.

# Set default cursor
xsetroot -cursor_name left_ptr

if [ -f ~/.Xauthority ]; then
  export XAUTHORITY=$HOME/.Xauthority
fi

# Set the repeat rate for the keyboard
# xset r rate [delay [repeats/second]]
xset r rate 250 50

# 1:1 mouse movement
xset m 1/1

# composition manager
compton -b

# taffybar
taffybar &

# start the window manager
exec xmonad
