screenfetch -D "Arch Linux - pdq"

# usage: remind <time> <text>
# e.g.: remind 10m "omg, the pizza"
function remind() {
    sleep $1 && notify-send "$2" &
}

#PS1="\[\e[01;31m\]┌─[\[\e[01;35m\u\e[01;31m\]]──[\[\e[00;37m\]${HOSTNAME%%.*}\[\e[01;32m\]]:\w$\[\e[01;31m\]\n\[\e[01;31m\]└──\[\e[01;36m\]>>\[\e[0m\]"
PS1="\n${DGRAY}╭─[${LBLUE}\w${DGRAY}]\n${DGRAY}╰─[${WHITE}\T${DGRAY}]${DGRAY}>${BLUE}>${LBLUE}> ${RESET_COLOR}"

alias c='clear'
alias f='file'
alias ls='ls --color=auto'
alias ping='ping -c 5'
alias pong='tsocks ping -c 5'
# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
# fun stuffs
#alias bender='cowsay -f bender $(fortune -so)'
alias matrix='cmatrix -C magenta'
# useful stuffs
alias ..='cd ..'
alias home='cd ~'
alias conf='cd ~/.config'
alias dev='cd ~/Development'
alias down='cd ~/Downloads'
alias backup='sh ~/github/pdq/backup.sh'
alias nc='ncmpcpp'
alias grep='grep --color=auto'
alias mounthdd='sudo udisks --mount /dev/sdb4'
alias mounthdd3='sudo udisks --mount /dev/sdb3'
alias sploit='/opt/metasploit-4.2.0/msfconsole'
alias kdeicons='rm ~/.kde4/cache-linux/icon-cache.kcache'
alias deltrash1='sudo rm -rv /media/truecrypt1/.Trash-1000/'
alias deltrash2='sudo rm -rv /media/truecrypt2/.Trash-1000/'
alias deltrash='rm -rv ~/.local/share/Trash/'
alias sdeltrash1='sudo srm -rv /media/truecrypt1/.Trash-1000/'
alias sdeltrash2='sudo srm -rv /media/truecrypt2/.Trash-1000/'
alias sdeltrash='srm -rv ~/.local/share/Trash/'
alias delthumbs='rm -rv ~/.thumbnails/ && rm ~/.kde4/cache-linux/icon-cache.kcache'
alias reload='source ~/.bashrc'
alias xdef='xrdb -merge ~/.Xdefaults' 
alias delfonts='fc-cache -vf'
alias cclean='sudo pkgcacheclean -v'
alias sd='systemctl'
alias md5='md5sum'
alias mirror='sudo reflector -c "Canada United States" -f 6 > mirrorlist'
# control hardware
#alias cdo='eject /dev/cdrecorder'
#alias cdc='eject -t /dev/cdrecorder'
#alias dvdo='eject /dev/dvd'
#alias dvdc='eject -t /dev/dvd'
# modified commands
alias psg='ps aux | grep'  #requires an argument
# chmod commands
#alias mx='chmod a+x' 
#alias 000='chmod 000'
#alias 644='chmod 644'
#alias 755='chmod 755'
# pacman
alias p="sudo pacman-color -S"         # install one or more packages
alias pp="pacman-color -Ss"            # search for a package using one or more keywords
alias syu="sudo pacman-color -Syu"     # upgrade all packages to their newest version
alias pacremove="sudo pacman-color -R" # uninstall one or more packages
alias rs="sudo pacman-color -Rs"       # uninstall one or more packages and its dependencies 
# packer
# alias a="packer-color"
# alias sa="packer-color -S"
# alias syua="packer-color -Syu --auronly"
# powerpill
alias pillu="sudo powerpill -Syu"
alias pill="sudo powerpill -S"
alias a="pacaur -S"               # search packages
alias aa="pacaur -s"              # install package
alias syua="pacaur -Syua"         # update aur packages
alias syud="pacaur -Syua --devel" # update devel packages
# cower
alias cow="cower -u -v"
# git hub
alias git=hub
alias commit="git commit -m"
alias push="git push origin master"
# systemd services
alias trstart='sudo systemctl start transmission'
alias trstop='sudo systemctl stop transmission'
alias lampstart='sudo lamp start'
alias lampstop='sudo lamp stop'
alias scripts='sh ~/.config/awesome/global_script.sh'
alias steam='export STEAM_RUNTIME=0 && export SDL_AUDIODRIVER=alsa && steam'