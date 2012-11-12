#!/bin/bash
## 07-10-2012 pdq, 07-18-2012

my_home="$HOME/"
#me=$USER
#my_home="/home/pdq/test/"
dev_directory="Development"
dotfiles="${dev_directory}/pdq/"
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset
commit_msg=$1

if [ `id -u` -eq 0 ]; then
   echo "${bldred}Do not run me as root!${txtrst} =)"
   exit
fi

## Creating backups on host
mkdir ${my_home}${dev_directory}
mkdir ${my_home}${dotfiles}

# eggdrop-scripts repo
cd ${my_home}.eggdrop/scripts
cp -r custom/. ${my_home}${dev_directory}/eggdrop-scripts
cd ${my_home}${dev_directory}/eggdrop-scripts
git add .
if [ "$commit_msg" == "" ]; then
	commit_msg='updated eggdrop-scripts to current'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> eggdrop-scripts repo pushed to github!${txtrst}


"

# zsh repo
cp ${my_home}.zshrc ${my_home}${dev_directory}/zsh/.zshrc
cp ${my_home}.zprofile ${my_home}${dev_directory}/zsh/.zprofile
cd
cp -r .zsh ${my_home}${dev_directory}/zsh/
cd ${my_home}${dev_directory}/zsh
git add .
if [ "$commit_msg" == "" ]; then
	commit_msg='updated zsh to current'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> zsh repo pushed to github!${txtrst}


"

# awesomewm-X repo
cp ${my_home}.xinitrc ${my_home}${dev_directory}/awesomewm-X/skel/.xinitrc
cd ${my_home}.config
cp -r awesome/. ${my_home}${dev_directory}/awesomewm-X
cd ${my_home}${dev_directory}/awesomewm-X
git add .
if [ "$commit_msg" == "" ]; then
	commit_msg='updated awesomewm-X to current'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> awesomewm-X repo pushed to github!${txtrst}


"

# conky-X repo
cd ${my_home}.config
cp -r conky/. ${my_home}${dev_directory}/conky-X
cd ${my_home}${dev_directory}/conky-X
git add .
if [ "$commit_msg" == "" ] || [ "$commit_msg" == "updated awesomewm-X to current" ]; then
	commit_msg='updated conky-X to current'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> conky-X repo pushed to github!${txtrst}


"

# luakit-X repo
cd ${my_home}.config
cp -r luakit/. ${my_home}${dev_directory}/luakit-X
cd ${my_home}${dev_directory}/luakit-X
git add .
if [ "$commit_msg" == "" ] || [ "$commit_msg" == "updated conky-X to current" ]; then
	commit_msg='updated luakit-X to current'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> luakit-X repo pushed to github!${txtrst}


"
cp ${my_home}.xinitrc ${my_home}${dotfiles}.xinitrc
cp ${my_home}.bashrc ${my_home}${dotfiles}.bashrc
cp ${my_home}.bash_profile ${my_home}${dotfiles}.bash_profile
cp ${my_home}.colors ${my_home}${dotfiles}.colors
cp ${my_home}.gtkrc-2.0 ${my_home}${dotfiles}.gtkrc-2.0
cp ${my_home}run ${my_home}${dotfiles}run
cp ${my_home}motd.tcl ${my_home}${dotfiles}motd.tcl
cp ${my_home}.config/spacefm/bookmarks ${my_home}${dotfiles}.config/spacefm/bookmarks
cp ${my_home}.config/archey3.cfg ${my_home}${dotfiles}archey3.cfg
cp -r ${my_home}bin/* ${my_home}${dotfiles}bin
cp -r ${my_home}php/* ${my_home}${dotfiles}php
cp /etc/modules-load.d/my_modules.conf ${my_home}${dotfiles}etc/my_modules.conf
#cp /etc/rc.conf ${my_home}${dotfiles}etc/rc.conf
cp /etc/mpd.conf ${my_home}${dotfiles}etc/mpd.conf
cp /etc/php/php.ini ${my_home}${dotfiles}etc/php.ini
cp /etc/tor/torrc ${my_home}${dotfiles}etc/torrc
# sudo cp /etc/privoxy/config ${my_home}${dotfiles}etc/privoxy_config
# sudo chown $me:users ${my_home}${dotfiles}etc/privoxy_config
cp /etc/pacman.conf ${my_home}${dotfiles}etc/pacman.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/X11/xorg.conf.d/custom.conf ${my_home}${dotfiles}etc/custom.conf
cp /etc/systemd/system/autologin\@.service ${my_home}${dotfiles}etc/autologin\@.service

echo "${bldblue}cp ${my_home}.xinitrc ${my_home}${dotfiles}.xinitrc
cp ${my_home}.bashrc ${my_home}${dotfiles}.bashrc
cp ${my_home}.bash_profile ${my_home}${dotfiles}.bash_profile
cp ${my_home}.colors ${my_home}${dotfiles}.colors
cp ${my_home}.gtkrc-2.0 ${my_home}${dotfiles}.gtkrc-2.0
cp ${my_home}run ${my_home}${dotfiles}run
cp ${my_home}motd.tcl ${my_home}${dotfiles}motd.tcl
cp ${my_home}.moc/config ${my_home}${dotfiles}moc.config
cp ${my_home}.config/spacefm/bookmarks ${my_home}${dotfiles}.config/spacefm/bookmarks
cp ${my_home}.config/archey3.cfg ${my_home}${dotfiles}archey3.cfg
cp -r ${my_home}bin/* ${my_home}${dotfiles}bin
cp -r ${my_home}php/* ${my_home}${dotfiles}php
#cp /etc/rc.conf ${my_home}${dotfiles}etc/rc.conf
cp /etc/mpd.conf ${my_home}${dotfiles}etc/mpd.conf
cp /etc/php/php.ini ${my_home}${dotfiles}etc/php.ini
cp /etc/tor/torrc ${my_home}${dotfiles}etc/torrc
cp /etc/pacman.conf ${my_home}${dotfiles}etc/pacman.conf
cp /etc/locale.gen ${my_home}${dotfiles}etc/locale.gen
cp /etc/locale.conf ${my_home}${dotfiles}etc/locale.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/X11/xorg.conf.d/custom.conf ${my_home}${dotfiles}etc/custom.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/systemd/system/autologin\@.service ${my_home}${dotfiles}etc/autologin\@.service
${txtrst}

"

echo "${bldgreen} ==> copied files into ${dotfiles}${txtrst}

"

sleep 2s

echo "## Create main.lst remove local, base
## Create local.lst of local (includes AUR) packages installed
"

# dotfiles repo
cd ${my_home}${dotfiles}
## Create main.lst remove local, base
pacman -Qqe | grep -vx "$(pacman -Qqg base)" | grep -vx "$(pacman -Qqm)" > main.lst
## Create local.lst of local (includes AUR) packages installed
pacman -Qqm > local.lst
sleep 3s
git add .
if [ "$commit_msg" == "" ] || [ "$commit_msg" == "updated luakit-X to current" ]; then
	commit_msg='updated packages lists from source'
fi
git commit -m "$commit_msg"
git push origin master
echo "


${bldgreen} ==> ${dotfiles} repo pushed to github!${txtrst}


"
## end
sleep 2s

echo "${bldgreen}Everything backed up to github! =)${txtrst}"
