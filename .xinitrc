#!/bin/bash
#nitrogen --restore &
urxvtd -q -o -f
#zeitgeist-daemon --replace &
export BROWSER=firefox
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#export DE=xfce
#exec ck-launch-session dbus-launch openbox-session
exec ck-launch-session dbus-launch awesome  >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr
