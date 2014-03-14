#!/bin/zsh -l

# Merge resources with defaults for xterm, etc.
xrdb -merge .Xresources

# NOTE: May need to explicitly set SSH_ASKPASS
# Load up my SSH keys
ssh_add_if_exists () {
  [[ -f $1 ]] && ssh-add $1
}
ssh_keys=(~/.ssh/id_rsa ~/.ssh/id_dsa ~/.ec2_backupify/backupify.pem ~/.ec2_backupifydev/backupifydev.pem ~/.ec2_pegasus/pegasus.pem)
for key in $ssh_keys; do
  ssh_add_if_exists $key
done

# PolicyKit Authentication Agent (needed for network-manager)
# NOTE: May be replaceable with /usr/lib/policykit-1/polkitd; investigate
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
# Network manager
nm-applet &
#wicd-client &

# Notification popups
/usr/lib/notify-osd/notify-osd & # backgrounds itself, but background just in case this changes, etc.

# Set up scroll emulation
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2

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

# start the window manager
exec xmonad
