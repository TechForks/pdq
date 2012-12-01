#!/bin/bash
## 07-10-2012 pdq, 07-18-2012

my_home="$HOME/"
#me=$USER
#my_home="/home/pdq/test/"
dev_directory="github"
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
echo "${bldblue} ==> Analyzing eggdrop-scripts repo!${txtrst}"
cd ${my_home}.eggdrop/scripts
cp -r custom/ ${my_home}${dev_directory}/eggdrop-scripts
echo "cp -r custom/. ${my_home}${dev_directory}/eggdrop-scripts"
cd ${my_home}${dev_directory}/eggdrop-scripts
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated eggdrop-scripts to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated eggdrop-scripts to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> eggdrop-scripts repo pushed to github!${txtrst}"

# zsh repo
echo "${bldblue} ==> Analyzing zsh repo!${txtrst}"
cp ${my_home}.zshrc ${my_home}${dev_directory}/zsh/.zshrc
cp ${my_home}.zprofile ${my_home}${dev_directory}/zsh/.zprofile
cd
cp -r .zsh ${my_home}${dev_directory}/zsh/
echo "cp ${my_home}.zshrc ${my_home}${dev_directory}/zsh/.zshrc
cp ${my_home}.zprofile ${my_home}${dev_directory}/zsh/.zprofile
cp -r .zsh ${my_home}${dev_directory}/zsh/"
cd ${my_home}${dev_directory}/zsh
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated zsh to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated zsh to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> zsh repo pushed to github!${txtrst}"

# awesomewm-X repo
echo "${bldblue} ==> Analyzing awesomewm-X repo!${txtrst}"
cd ${my_home}.config
cp -r awesome/. ${my_home}${dev_directory}/awesomewm-X
echo "cp -r ${my_home}.config/awesome/. ${my_home}${dev_directory}/awesomewm-X"
cd ${my_home}${dev_directory}/awesomewm-X
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated awesomewm-X to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated awesomewm-X to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> awesomewm-X repo pushed to github!${txtrst}"

# conky-X repo
echo "${bldblue} ==> Analyzing conky-X repo!${txtrst}"
cd ${my_home}.config
cp -r conky/. ${my_home}${dev_directory}/conky-X
echo "cp -r conky/. ${my_home}${dev_directory}/conky-X"
cd ${my_home}${dev_directory}/conky-X
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated conky-X to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated conky-X to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> conky-X repo pushed to github!${txtrst}"

#bin repo
echo "${bldblue} ==> Analyzing bin repo!${txtrst}"
cd ${my_home}
cp -r bin/. ${my_home}${dev_directory}/bin
cp /usr/bin/screenfetch ${my_home}${dotfiles}bin/screenfetch
echo "cp -r bin/. ${my_home}${dev_directory}/bin
cp /usr/bin/screenfetch ${my_home}${dotfiles}bin/screenfetch"
cd ${my_home}${dev_directory}/bin
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated bin to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated bin to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> bin repo pushed to github!${txtrst}"

#etc repo
echo "${bldblue} ==> Analyzing etc repo!${txtrst}"
cp /etc/modules-load.d/my_modules.conf ${my_home}${dotfiles}etc/my_modules.conf
cp /etc/php/php.ini ${my_home}${dotfiles}etc/php.ini
cp /etc/tor/torrc ${my_home}${dotfiles}etc/torrc
cp /etc/pacman.conf ${my_home}${dotfiles}etc/pacman.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/X11/xorg.conf.d/custom.conf ${my_home}${dotfiles}etc/custom.conf
cd ${my_home}${dev_directory}/etc
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated etc to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated etc to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> etc repo pushed to github!${txtrst}"

#systemd repo
echo "${bldblue} ==> Analyzing systemd repo!${txtrst}"
cp -r /etc/systemd/system/* ${my_home}${dotfiles}systemd
echo "cp -r /etc/systemd/system/* ${my_home}${dotfiles}systemd"
cd ${my_home}${dev_directory}/systemd
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated systemd to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated systemd to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> systemd repo pushed to github!${txtrst}"

#php repo
echo "${bldblue} ==> Analyzing php repo!${txtrst}"
cp -r ${my_home}php/* ${my_home}${dotfiles}php
echo "cp -r ${my_home}php/* ${my_home}${dotfiles}php"
cd ${my_home}${dev_directory}/php
git add -A
if [ "$commit_msg" == "" ]; then
	commit_msg='updated php to current'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated php to current" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> php repo pushed to github!${txtrst}"
# luakit-X repo
#echo "${bldblue} ==> Analyzing luakit-X repo!${txtrst}"
# cd ${my_home}.config
# cp -r luakit/. ${my_home}${dev_directory}/luakit-X
# cd ${my_home}${dev_directory}/luakit-X
# git add .
# if [ "$commit_msg" == "" ] || [ "$commit_msg" == "updated conky-X to current" ]; then
# 	commit_msg='updated luakit-X to current'
# fi
# git commit -m "$commit_msg"
# git push origin master
# echo "${bldgreen} ==> luakit-X repo pushed to github!${txtrst}"

echo "${bldblue} ==> Analyzing ${dotfiles} files!${txtrst}"
cp ${my_home}.xinitrc ${my_home}${dotfiles}.xinitrc
cp ${my_home}.bashrc ${my_home}${dotfiles}.bashrc
cp ${my_home}.bash_profile ${my_home}${dotfiles}.bash_profile
cp ${my_home}.dmenu_cache ${my_home}${dotfiles}.dmenu_cache
cp ${my_home}.nanorc ${my_home}${dotfiles}.nanorc
cp ${my_home}.gtkrc-2.0 ${my_home}${dotfiles}.gtkrc-2.0
cp ${my_home}.config/spacefm/bookmarks ${my_home}${dotfiles}.config/spacefm/bookmarks
cp ${my_home}.config/fontconfig/fonts.conf ${my_home}${dotfiles}.config/fontconfig/fonts.conf
cp ${my_home}.config/htop/htoprc ${my_home}${dotfiles}.config/htop/htoprc
cp ${my_home}.config/pacaur/config ${my_home}${dotfiles}.config/pacaur/config
cp ${my_home}.config/parcellite/parcelliterc ${my_home}${dotfiles}.config/parcellite/parcelliterc
cp ${my_home}.config/transmission-daemon/settings.json ${my_home}${dotfiles}.config/transmission-daemon/settings.json

echo "${bldblue}cp ${my_home}.xinitrc ${my_home}${dotfiles}.xinitrc
cp ${my_home}.bashrc ${my_home}${dotfiles}.bashrc
cp ${my_home}.bash_profile ${my_home}${dotfiles}.bash_profile
cp ${my_home}.dmenu_cache ${my_home}${dotfiles}.dmenu_cache
cp ${my_home}.nanorc ${my_home}${dotfiles}.nanorc
cp ${my_home}.gtkrc-2.0 ${my_home}${dotfiles}.gtkrc-2.0
cp ${my_home}.config/spacefm/bookmarks ${my_home}${dotfiles}.config/spacefm/bookmarks
cp ${my_home}.config/fontconfig/fonts.conf ${my_home}${dotfiles}.config/fontconfig/fonts.conf
cp ${my_home}.config/htop/htoprc ${my_home}${dotfiles}.config/htop/htoprc
cp ${my_home}.config/pacaur/config ${my_home}${dotfiles}.config/pacaur/config
cp ${my_home}.config/parcellite/parcelliterc ${my_home}${dotfiles}.config/parcellite/parcelliterc
cp ${my_home}.config/transmission-daemon/settings.json ${my_home}${dotfiles}.config/transmission-daemon/settings.json
${txtrst}"
echo "${bldgreen} ==> copied files into ${dotfiles}${txtrst}"
echo "## Create main.lst remove local, base
## Create local.lst of local (includes AUR) packages installed"

# dotfiles repo
echo "${bldblue} ==> Analyzing ${dotfiles} repo!${txtrst}"
cd ${my_home}${dotfiles}
## Create main.lst remove local, base
pacman -Qqe | grep -vx "$(pacman -Qqg base)" | grep -vx "$(pacman -Qqm)" > main.lst
## Create local.lst of local (includes AUR) packages installed
pacman -Qqm > local.lst
git add -A
if [ "$commit_msg" == "" ] || [ "$commit_msg" == "updated luakit-X to current" ]; then
	commit_msg='updated packages lists from source'
fi
git commit -m "$commit_msg"
git push origin master
if [ "$commit_msg" == "updated packages lists from source" ]; then
	commit_msg=''
fi
echo "${bldgreen} ==> ${dotfiles} repo pushed to github!${txtrst}"
## end
echo "${bldgreen}Everything backed up to github! =)${txtrst}"
