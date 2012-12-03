#!/bin/bash
## 07-10-2012 pdq, 07-18-2012

# -V print version number
# -b backup [-b]
# -c clone github repo [-c user/repo]
# -r create github repo [-r user/repo]
# -s create submodule [-s user/submodule -r /user/repo]
# -q quiet backup

dev_directory="$HOME/github/"       # $HOME/github

# color formatting
txtbld=$(tput bold)                # Bold
bldred=${txtbld}$(tput setaf 1)    # Red Colored
bldgreen=${txtbld}$(tput setaf 2)  # Green Colored
bldblue=${txtbld}$(tput setaf 6)   # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)                # Reset

# commit message arg
commit_msg=$1

# sanity check
if [ `id -u` -eq 0 ]; then
   echo "${bldred}Do not run me as root!${txtrst} =)"
   exit 1
fi

## Creating backups/github directory on host
mkdir -p ${dev_directory}

# number of your github repos (default 9)
_repo_count=9

# github repo Number 1
_repo1[1]="idk"  # user
_repo1[2]="pdq"  # repository
# custom commands
_repo1[3]="$(cp $HOME/.xinitrc ${dev_directory}${_repo1[2]}/.xinitrc;cp $HOME/.bashrc ${dev_directory}${_repo1[2]}/.bashrc;cp $HOME/.bash_profile ${dev_directory}${_repo1[2]}/.bash_profile;cp $HOME/.dmenu_cache ${dev_directory}${_repo1[2]}/.dmenu_cache;cp $HOME/.nanorc ${dev_directory}${_repo1[2]}/.nanorc;cp $HOME/.gtkrc-2.0 ${dev_directory}${_repo1[2]}/.gtkrc-2.0;cp $HOME/.config/spacefm/bookmarks ${dev_directory}${_repo1[2]}/.config/spacefm/bookmarks;cp $HOME/.config/fontconfig/fonts.conf ${dev_directory}${_repo1[2]}/.config/fontconfig/fonts.conf;cp $HOME/.config/htop/htoprc ${dev_directory}${_repo1[2]}/.config/htop/htoprc;cp $HOME/.config/pacaur/config ${dev_directory}${_repo1[2]}/.config/pacaur/config;cp $HOME/.config/parcellite/parcelliterc ${dev_directory}${_repo1[2]}/.config/parcellite/parcelliterc;cp $HOME/.config/transmission-daemon/settings.json ${dev_directory}${_repo1[2]}/.config/transmission-daemon/settings.json;pacman -Qqe | grep -vx \"$(pacman -Qqg base)\" | grep -vx \"$(pacman -Qqm)\" > ${dev_directory}${_repo1[2]}/main.lst;pacman -Qqm > ${dev_directory}${_repo1[2]}/local.lst)"

# github repo Number 2
_repo2[1]="idk"  # user
_repo2[2]="eggdrop-scripts"  # repository
# custom commands
_repo2[3]="$(cp -r $HOME/.eggdrop/scripts/custom/ ${dev_directory}${_repo2[2]})"

# github repo Number 3
_repo3[1]="idk"  # user
_repo3[2]="zsh"  # repository
# custom commands
_repo3[3]="$(cp $HOME/.zshrc ${dev_directory}${_repo3[2]}/.zshrc;cp $HOME/.zprofile ${dev_directory}${_repo3[2]}/.zprofile;cp -r $HOME/.zsh ${dev_directory}${_repo3[2]})"

# github repo Number 4
_repo4[1]="idk"  # user
_repo4[2]="awesomewm-X"  # repository
# custom commands
_repo4[3]="$(cp -r $HOME/.config/awesome/. ${dev_directory}${_repo4[2]})"

# github repo Number 5
_repo5[1]="idk"  # user
_repo5[2]="conky-X"  # repository
# custom commands
_repo5[3]="$(cp -r $HOME/.config/conky/. ${dev_directory}${_repo5[2]})"

# github repo Number 6
_repo6[1]="idk"  # user
_repo6[2]="bin"  # repository
# custom commands
_repo6[3]="$(cp -r $HOME/bin/. ${dev_directory}${_repo6[2]};cp /usr/bin/screenfetch ${dev_directory}${_repo6[2]}/screenfetch)"

# github repo Number 7
_repo7[1]="idk"  # user
_repo7[2]="etc"  # repository
# custom commands
_repo7[3]="$(cp /etc/modules-load.d/my_modules.conf ${dev_directory}${_repo7[2]}/my_modules.conf;cp /etc/php/php.ini ${dev_directory}${_repo7[2]}/php.ini;cp /etc/tor/torrc ${dev_directory}${_repo7[2]}/torrc;cp /etc/pacman.conf ${dev_directory}${_repo7[2]}/pacman.conf;cp /etc/pacman.d/mirrorlist ${dev_directory}${_repo7[2]}/mirrorlist;cp /etc/X11/xorg.conf.d/custom.conf ${dev_directory}${_repo7[2]}/custom.conf)"

# github repo Number 8
_repo8[1]="idk"  # user
_repo8[2]="systemd"  # repository
# custom commands
_repo8[3]="$(cp -r /etc/systemd/system/* ${dev_directory}${_repo8[2]})"

# github repo Number 9
_repo9[1]="idk"  # user
_repo9[2]="php"  # repository
# custom commands
_repo9[3]="$(cp -r $HOME/php/* ${dev_directory}${_repo9[2]})"

# github repo Number 10
#_repo10[1]="idk"  # user
#_repo10[2]="luakit-X"  # repository
# custom commands
#_repo10[3]="$(cp -r $HOME/.config/luakit/. ${dev_directory}${_repo10[2]})"


### @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ###


## initalize options
backup=no; clone=; create_repo=; create_submodule=; quiet=

## functions
git_installed_check() {
	if [ ! -f /usr/bin/git ]; then
		echo "FATAL ERROR - git is not installed";
		exit 0
	fi
	if [ ! -f /usr/bin/hub ]; then
		echo "FATAL ERROR: hub is not installed"
		exit 0
	fi
}

git_backup(){
	for i in $(eval echo {1..$_repo_count})
	do
		__user=$(eval echo $(echo '${'_repo$i[1]'}'))
		__repo=$(eval echo $(echo '{'_repo$i[2]'}'))
		#docommands=$(eval echo $(echo '${'_repo$i[3]'}'))
		#$docommands
		cd ${dev_directory}${__repo}
		#git add -A
		if [ "$commit_msg" == "" ]; then
			_commit_msg="updated ${__repo} to current working copy"
		fi
		#git commit -m "${_commit_msg}"
		#git push origin master
		_commit_msg=""
		echo "${bldgreen} ==> ${__repo} repo pushed to Github.${txtrst}"
	done
	echo "${bldgreen} ==> All repos pushed to Github. Goodbye!${txtrst}"
}

## start script execution
git_installed_check

while getopts ":b:c:r:s:q:V:" opt
do
    case $opt in
    V)  echo "`basename $0 `: gh Version $Revision: 0.1 $ ($Date: 2012/12/02 #Author: pdq)"
        exit 0;;
    b)  _backup=yes;;
    c)  _clone=$OPTARG;;
    r)  _create_repo=$OPTARG;;
    s)  _create_submodule=$OPTARG;;
    q)  _quiet=-q;;
    *)  echo "Usage: `basename $0 ` [-{b|V|q}][-{c|r|s}] [user/{repo|submodule}]" 1>&2
        exit 1;;
    esac
done

# getopts
if [ ! -n "${_create_submodule}" ]; then
	git submodule add ${_create_submodule} ${_quiet}
fi

if [ ! -n "${_create_repo}" ]; then
	git create "${_create_repo}" ${_quiet}
fi

if [ ! -n "${_clone}" ]; then
	git create "${_clone}" ${_quiet}
fi

if [ ! -n "${_backup}" ]; then
	git_backup
fi

if [ ! -n "${_clone}" ]; then
	hub clone $_clone ${_quiet}
fi

exit 1