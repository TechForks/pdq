#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

## start urxvt daemon
[ -z "$(pidof urxvtd)" ] && [ -f /usr/bin/urxvtd ] && urxvtd -q -o -f

## start clipboard manager
if [ -f /usr/bin/autocutsel ]; then
    killall -q autocutsel
    autocutsel -fork &
    autocutsel -selection PRIMARY -fork &
fi

## export some variables
[ -z "$EDITOR" ] && export EDITOR=nano      # if not set default to nano
[ -z "$BROWSER" ] && export BROWSER=firefox # if not set default to firefox
[ -f "$HOME/.gtkrc-2.0" ] && export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

## truecrypt mounted success file
#if [ $USE_SOUNDS = 1 ] && [ -f "/media/truecrypt1/test" ] ; then
    ogg123 -q "${wm_path}desktop-login.ogg"
#fi

case $1 in
    e17) exec enlightenment_start;;
    awesome) exec awesome >> "$HOME"/.cache/awesome/stdout 2>> "$HOME"/.cache/awesome/stderr;;
    kde) exec startkde;;
    gnome) exec gnome-session;;
    razor) exec razor-session;;
    xfce) exec startxfce4;;
    lxde) exec startlxde;;
    wmii) exec wmii;;
    i3) exec i3;;
    spectrwm) exec spectrwm;;
    wmaker) exec wmaker;;
    icewm) exec icewm;;
    blackbox) exec blackbox;;
    fluxbox) exec fluxbox;;
    openbox) exec openbox-session;;
    cinnamon) exec gnome-session-cinnamon;;
    mate) exec mate-session;;
    xterm) exec xterm;;
    *) exec enlightenment_start;;
esac
