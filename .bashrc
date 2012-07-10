[ ! "$UID" = "0" ] && archey3 -c blue
[  "$UID" = "0" ] && archey3 -c red
#command cowsay $(fortune)
#PS1="\[\e[01;31m\]┌─[\[\e[01;35m\u\e[01;31m\]]──[\[\e[00;37m\]${HOSTNAME%%.*}\[\e[01;32m\]]:\w$\[\e[01;31m\]\n\[\e[01;31m\]└──\[\e[01;36m\]>>\[\e[0m\]"
PS1="\n${DGRAY}╭─[${LBLUE}\w${DGRAY}]\n${DGRAY}╰─[${WHITE}\T${DGRAY}]${DGRAY}>${BLUE}>${LBLUE}> ${RESET_COLOR}"
export EDITOR="nano"
export PATH=$PATH:/usr/local/bin
#complete -cf sudo
#complete -cf man
function ii()   # Get current host related info.
{
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Memory stats :$NC " ; free
    my_ip 2>&- ;
    echo -e "\n${RED}Local IP Address :$NC" ; echo ${MY_IP:-"Not connected"}
    echo -e "\n${RED}ISP Address :$NC" ; echo ${MY_ISP:-"Not connected"}
    echo -e "\n${RED}Open connections :$NC "; netstat -pan --inet;
    echo
}
alias ls='ls --color=auto'
alias ping='ping -c 5'
# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
#fun stuffs
alias matrix='cmatrix -C magenta'
alias ..='cd ..'
alias ...='cd ../..'
alias builds='cd ~/builds'
alias dotfiles='cd ~/Development/dotfiles'
alias dev='cd ~/Development'
alias backup=' sh ~/Development/dotfiles/backup.sh'
alias pkgs='sudo pacman -Qq > ~/Development/dotfiles/installed-packages'
alias nc='ncmpcpp'
#alias clock='sudo ntpd -qg'
alias grep='grep --color=auto'
alias mounthdd='sudo udisks --mount /dev/sdb4'
alias mounthdd3='sudo udisks --mount /dev/sdb3'
#alias sploit='/opt/metasploit-4.2.0/msfconsole'
alias kdeicons='rm /home/pdq/.kde4/cache-linux/icon-cache.kcache'
alias deltrash1='sudo rm -rv /media/truecrypt1/.Trash-1000/'
alias deltrash2='sudo rm -rv /media/truecrypt2/.Trash-1000/'
alias deltrash='rm -rv /home/pdq/.local/share/Trash/'
alias sdeltrash1='sudo srm -rv /media/truecrypt1/.Trash-1000/'
alias sdeltrash2='sudo srm -rv /media/truecrypt2/.Trash-1000/'
alias sdeltrash='srm -rv /home/pdq/.local/share/Trash/'
alias delthumbs='srm -rv /home/pdq/.thumbnails/'
alias reload='source ~/.bashrc'
alias xdef='xrdb -merge ~/.Xdefaults' 
alias flushdns="sudo /etc/rc.d/nscd restart"
alias delfonts='fc-cache -vf'
alias cclean='sudo cacheclean -v 1'
#alias irssi='urxvt -e irssi &'
#alias finch='urxvt -e finch &'
alias mirror='sudo reflector -c "Canada United States" -f 6 > mirrorlist'
alias tor='/home/pdq/.tor-browser_en-US/start-tor-browser'
#alias scripts='cd /home/pdq/scripts'
# control hardware
#alias cdo='eject /dev/cdrecorder'
#alias cdc='eject -t /dev/cdrecorder'
#alias dvdo='eject /dev/dvd'
#alias dvdc='eject -t /dev/dvd'
# modified commands
alias home='cd ~'
#alias pg='ps aux | grep'  #requires an argument
#alias ping='ping -c 10'
# chmod commands
#alias mx='chmod a+x'
#alias 000='chmod 000'
#alias 644='chmod 644'
#alias 755='chmod 755'
#alias tl='tail -f /var/log/syslog.log'
#alias tk='tail -f /var/log/kernel.log'
#alias th='tail -f /var/log/httpd/error_log'
#alias te='tail -f /var/log/errors.log'
# local server
#alias counter='ssh 192.168.2.107 -l root'
# scripts and folders
# pacman aur stuffs
alias update='sudo pacman-color -Syu'
alias supdate='sudo powerpill-light -yu'
alias pacinstall="sudo pacman-color -S"      # default action     - install one or more packages
alias pacsearch="pacman-color -Ss"           # '[s]earch'         - search for a package using one or more keywords
alias pacupdate="sudo pacman-color -Syu"     # '[u]pdate'         - upgrade all packages to their newest version
alias pacremove="sudo pacman-color -R"       # '[r]emove'         - uninstall one or more packages
alias pacdremove="sudo pacman-color -Rs"     # '[r]emove'         - uninstall one or more packages and its dependencies 
# remote server
source ~/.bash_ssh
