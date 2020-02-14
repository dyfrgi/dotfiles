#!/bin/bash -l

# Check if we're running inside VMware
if (lspci | grep -i vmware > /dev/null); then
    vmware-user-suid-wrapper        # copy and paste, guest resizing support
fi

# Merge resources with defaults for xterm, etc.
xrdb -merge .Xresources

ssh-add

# PolicyKit Authentication Agent (needed for network-manager)
# NOTE: May be replaceable with /usr/lib/policykit-1/polkitd; investigate
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
# Network manager
nm-applet &

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

# configure screensaver
xss-lock -n ~/bin/dim-screen2.sh -l -- env XSECURELOCK_SAVER=saver_blank /usr/share/goobuntu-desktop-files/xsecurelock.sh &
xset s 300 10   # 5 minutes, wait 10 seconds after dimming before locking

# taffybar
taffybar &

# dunst notifier
dunst &

test -x ~/.xsession-local && source ~/.xsession-local

# start the window manager
exec xmonad
