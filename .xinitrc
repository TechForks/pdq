#!/bin/bash

if [[ $1 == "razor" ]]
then
  urxvtd -q -o -f
  export BROWSER=luakit
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
  exec ck-launch-session razor-session
elif [[ $1 == "kde" ]]
then
  urxvtd -q -o -f
  export BROWSER=luakit
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
  exec ck-launch-session startkde
elif [[ $1 == "awesome" ]]
then
  urxvtd -q -o -f
  export BROWSER=luakit
  export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
  exec ck-launch-session dbus-launch awesome  >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr
else
  echo "Choose a window manager $USER"
fi