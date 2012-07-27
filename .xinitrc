#!/bin/bash
urxvtd -q -o -f
export BROWSER=firefox
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
exec ck-launch-session dbus-launch awesome  >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr
