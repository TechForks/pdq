#
# ~/.bash_profile
#

#export WEBKIT_IGNORE_SSL_ERRORS="1" midori
export MOZ_PLUGIN_PATH="/usr/lib/mozilla/plugins"
export XDG_CACHE_HOME=/dev/shm/$HOME/.cache
if [ ! -f $XDG_CACHE_HOME ];
then
    mkdir -p -m 0700 $XDG_CACHE_HOME
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
