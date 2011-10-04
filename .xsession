#!/bin/zsh -l

# Merge resources with defaults for xterm, etc.
xrdb -merge .Xresources

# NOTE: May need to explicitly set SSH_ASKPASS
# Load up my SSH key
ssh-add ~/.ssh/id_dsa

# Set up an icon tray
#trayion &
# trayer, tint is tuned to match default dzen2 background in appearance
trayer --heighttype pixel --height 20 --widthtype pixel --width 128 --align right --transparent true --tint 0x222222 --edge top --SetDockType true --SetPartialStrut true &

# wicd client for network conf
if [ -x /usr/bin/wicd-client ] ; then
    wicd-client &
fi

# Set up scroll emulation
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2

export XAUTHORITY=/home/dyfrgi/.Xauthority

# start the window manager
exec xmonad
