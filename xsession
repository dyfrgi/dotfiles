#!/bin/zsh -l

# Merge resources with defaults for xterm, etc.
xrdb -merge .Xresources

# NOTE: May need to explicitly set SSH_ASKPASS
# Load up my SSH keys
ssh_add_if_exists () {
  [[ -f $1 ]] && ssh-add $1
}
ssh_keys=(~/.ssh/id_dsa ~/.ec2_backupify/backupify.pem ~/.ec2_backupifydev/backupifydev.pem ~/.ec2_pegasus/pegasus.pem)
for key in $ssh_keys do
  ssh_add_if_exists $key
done

# Set up an icon tray
#trayion &
# trayer, tint is tuned to match default dzen2 background in appearance
trayer --heighttype pixel --height 20 --widthtype pixel --width 128 --align right --transparent true --tint 0x222222 --edge top --SetDockType true --SetPartialStrut true &

# Network manager
#nm-applet &
wicd-client &

# Notification daemon
/usr/lib/notification-daemon/notification-daemon & # backgrounds itself, but background just in case this changes, etc.
# PolicyKit Authentication Agent (needed for network-manager)
/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

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

# start the window manager
exec xmonad
