#!/bin/bash
## 07-10-2012 pdq, 07-18-2012

my_home="$HOME/"
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

# awesomewm-X repo
cp ${my_home}.xinitrc ${my_home}${dev_directory}/awesomewm-X/skel/.xinitrc
cd ${my_home}.config
cp -r awesome/* ${my_home}${dev_directory}/awesomewm-X
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
cp -r conky/* ${my_home}${dev_directory}/conky-X
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
cp -r luakit/* ${my_home}${dev_directory}/luakit-X
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
cp -r ${my_home}bin/* ${my_home}${dotfiles}/bin
cp -r ${my_home}php/* ${my_home}${dotfiles}/php
cp /etc/rc.conf ${my_home}${dotfiles}etc/rc.conf
cp /etc/mpd.conf ${my_home}${dotfiles}etc/mpd.conf
cp /etc/pacman.conf ${my_home}${dotfiles}etc/pacman.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/X11/xorg.conf.d/custom.conf ${my_home}${dotfiles}etc/custom.conf

echo "${bldblue}cp -r ${my_home}bin/* ${my_home}${dotfiles}/bin
cp -r ${my_home}php/* ${my_home}${dotfiles}/php
cp /etc/rc.conf ${my_home}${dotfiles}etc/rc.conf
cp /etc/mpd.conf ${my_home}${dotfiles}etc/mpd.conf
cp /etc/pacman.conf ${my_home}${dotfiles}etc/pacman.conf
cp /etc/pacman.d/mirrorlist ${my_home}${dotfiles}etc/mirrorlist
cp /etc/X11/xorg.conf.d/custom.conf ${my_home}${dotfiles}etc/custom.conf
${txtrst}

"

echo "${bldgreen} ==> copied files into ${dotfiles}${txtrst}

"

sleep 2s

echo "## Create main.lst remove local, base
## Create local.lst of local (includes AUR) packages installed
"

sleep 2s
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
