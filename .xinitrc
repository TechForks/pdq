#!/bin/bash

# if [[ $1 == "razor" ]]
# then
#   urxvtd -q -o -f
#   export BROWSER=luakit
#   export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#   #exec ck-launch-session razor-session
#   exec razor-session
# elif [[ $1 == "kde" ]]
# then
#   urxvtd -q -o -f
#   export BROWSER=luakit
#   export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#   #exec ck-launch-session startkde
#   exec startkde
# elif [[ $1 == "awesome" ]]
# then
#   urxvtd -q -o -f
#   export BROWSER=luakit
#   export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#   #exec ck-launch-session dbus-launch awesome  >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr
#   exec awesome  >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr
# else
#   echo "Choose a window manager $USER"
# fi
urxvtd -q -o -f
export BROWSER=firefox
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
ogg123 -q "${HOME}/.config/awesome/sounds/voice-system-activated.ogg"
ogg123 -q "${HOME}/.config/awesome/sounds/desktop-login.ogg"
exec awesome >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr