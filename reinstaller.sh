#!/bin/bash
## reinstall from github backup! =)
## 03-22-2012 pdq
## 07-10-2012 pdq

## As root right after fresh install:
# wget http://is.gd/reinstaller -O reinstaller.sh
# sh reinstaller.sh

## Reinstalling backups on guest OS (Archlinux)
# sh ~/Development/pdq/reinstaller.sh

## Creating backups on host OS (Archlinux)
# sh ~/Development/pdq/backup.sh



## THERE SHOULD BE NO NEED TO EDIT THE FOLLOWING 

my_home="$HOME/"
#my_home="/home/pdq/test/"
dev_directory="Development"
dotfiles="${dev_directory}/pdq/"
dotfiles_main="${my_home}${dotfiles}main.lst"
dotfiles_local="${my_home}${dotfiles}local.lst"
dotfiles_repo="git://github.com/idk/pdq.git"
awesome_repo="git://github.com/idk/awesomewm-X.git"
conky_repo="git://github.com/idk/conky-X.git"
luakit_repo="git://github.com/idk/luakit-X.git"
done_format="========================================="
choice_count=9
root_choice_count=5
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset

if [ `id -u` -eq 0 ]; then
   function root_menulist() { 
      # if [ $root_highlight -eq 1 ] ; then
      #    echo "${bldgreen}1. Pacman-key initialization -- done!${txtrst}"
      # else
      #    echo "1. Pacman-key initialization"
      # fi
      if [ $root_highlight -eq 1 ] ; then
         echo "${bldgreen}1. Create a USER and /home/USER and generate locale -- done!${txtrst}"
      else
         echo "1. Create a USER and /home/USER and generate locale"
      fi
      if [ $root_highlight -eq 2 ] ; then
         echo "${bldgreen}2. Edit /etc/pacman.conf${txtrst}"
      else
         echo "2. Edit /etc/pacman.conf"
      fi
      if [ $root_highlight -eq 3 ] ; then
         echo "${bldgreen}3. Add USER to sudoers -- done!${txtrst}"
      else
         echo "3. Add USER to sudoers "
      fi
      if [ $root_highlight -eq 4 ] ; then
         echo "${bldgreen}4. Switch to your newly created USER${txtrst}" 
      else
         echo "4. Switch to your newly created USER" 
      fi
      if [ $root_highlight -eq 5 ] ; then
         echo "${bldred}5. Exit root Installer${txtrst}"
      else
         echo "5. Exit root Installer"
      fi
   echo -n "${bldred}Please choose [1,2,3,4 or 5 ? (HINT: start at 1)${txtrst}"

      # Loop while the variable choice is equal $choice_count
   }

# Declare variable choice and assign value $choice_count
   root_choice=$root_choice_count
   root_highlight=6
   # Print to stdout
   #menulist
   # bash while loop
   while [ $root_choice -eq $root_choice_count ]; do
      root_menulist
      # read user input
      read root_choice
      # bash nested if/else
         # if [ $root_choice -eq 1 ] ; then
         # echo "${bldgreen} ==> pacman-key initialization starting ...${txtrst}"
         # echo "HINT: Mash on the keyboard keys and move mouse to make entropy process go faster! :D"
         # sleep 5s
         # pacman-key --init
         # pacman-key --populate archlinux
         # echo "done ..."
         # root_choice=$root_choice_count
         # echo $done_format
         # root_highlight=1
      if [ $root_choice -eq 1 ] ; then
         echo "${bldblue} ==> Creating user...${txtrst}"
         sleep 3s
         read -p "Enter username : " username
         read -s -p "Enter password : " password
         egrep "^$username" /etc/passwd >/dev/null
         if [ $? -eq 0 ]; then
            echo "$username exists already!"
         else
            pass=$(perl -e 'print crypt($ARGV[0], "password")' $pbaassword)
            useradd -m -p $pass -g users -G audio,video,wheel,storage,optical,power,games,network,log -s /bin/bash $username
            [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
         fi
         root_choice=$root_choice_count
         root_highlight=1
         echo $done_format
      elif [ $root_choice -eq 2 ] ; then
         echo "cp /etc/pacman.conf /etc/pacman.conf.orig"
         cp /etc/pacman.conf /etc/pacman.conf.orig
         echo "${bldgreen} ==> Adding repo to /etc/pacman.conf${txtrst}"
         echo '[archlinuxfr]
Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
         echo "
echo '[archlinuxfr]
Server = http://repo.archlinux.fr/\$arch >> /etc/pacman.conf'"
         pacman -Syu
         pacman -S yaourt fakeroot git
         root_choice=$root_choice_count
         echo $done_format
         root_highlight=2
      elif [ $root_choice -eq 3 ] ; then
         echo "${bldgreen}Edit sudoers, UNCOMMENT wheel...${txtrst}

${bldblue}% wheel ALL=(ALL) ALL${txtrst}

"
         sleep 3s
         EDITOR=nano visudo
         echo "done..."
         root_choice=$root_choice_count
         echo $done_format 
         root_highlight=3
      elif [ $root_choice -eq 4 ] ; then
         echo "${bldgreen}Switch to USER${txtrst}"
         read -p "Username : " username
         egrep "^$username" /etc/passwd >/dev/null
         if [ $? -eq 0 ]; then
            echo "mv /root/reinstaller.sh /home/$username/reinstaller.sh"
            mv /root/reinstaller.sh /home/$username/reinstaller.sh
            cd /home/$username
            chown -v $username/reinstaller.sh
            pwd
            echo "${bldgreen}when script exits to prompt run: 'sh reinstaller.sh'${txtrst}"
            sleep 5s
            su $username
            cd
         fi
         root_choice=$root_choice_count
         echo $done_format
         root_highlight=4
      elif [ $root_choice -eq 5 ] ; then
         echo $done_format
         sleep 2s
         root_highlight=5
         echo "${bldgreen} ==> Exiting root install script...${txtrst}"
         sleep 3s
         echo "${bldgreen}Re-Run install script: 'sh reinstaller.sh'${txtrst} | ${bldred}Remove install script 'rm reinstaller.sh'${txtrst}"
         sleep 3s
         exit
      else
         echo "${bldred}Please make a choice between 1-5! (HINT: start at 1)${txtrst}"
         root_highlight=${root_highlight}
         root_menulist
         choice=$root_choice_count
      fi
   done
else
   function menulist() { 
      if [ $highlight -eq 1 ] ; then
         echo "${bldgreen}1. Create ${my_home}${dotfiles} and ${my_home}vital and git clone backup to ${dotfiles} -- done!${txtrst}"
      else
         echo "1. Create ${my_home}${dotfiles} and ${my_home}vital and git clone backup to ${dotfiles}"
      fi
      if [ $highlight -eq 2 ] ; then
         echo "${bldgreen}2. Backup various configs, mirrorlist and write/rank/sort new mirrorlist -- done!${txtrst}"
      else
         echo "2. Backup various configs, mirrorlist and write/rank/sort new mirrorlist"
      fi
      if [ $highlight -eq 3 ] ; then
         echo "${bldgreen}3. Install main packages -- done!${txtrst}" 
      else
         echo "3. Install main packages" 
      fi
      if [ $highlight -eq 4 ] ; then
         echo "${bldgreen}4. Install AUR packages --noconfirm -- done!${txtrst}" 
      else
         echo "4. Install AUR packages --noconfirm" 
      fi
      if [ $highlight -eq 5 ] ; then
         echo "${bldgreen}5. Install AUR packages  (If Step 5 fails) -- done!${txtrst}" 
      else
         echo "5. Install AUR packages  (If Step 5 fails)" 
      fi
      if [ $highlight -eq 6 ] ; then
         echo "${bldgreen}6. Backup and copy user configs -- done!${txtrst}" 
      else
         echo "6. Backup and copy user configs" 
      fi

      if [ $highlight -eq 7 ] ; then
         echo "${bldgreen}7. Install Awesome Window Manager (awesomewm-X), luakit-X and Conky (conky-X) -- done!${txtrst}" 
      else
         echo "7. Install Awesome Window Manager (awesomewm-X), luakit-X and Conky (conky-X)" 
      fi
      if [ $highlight -eq 8 ] ; then
         echo "${bldgreen}8. Install LAMPP (Apache/MySQL/PHP/PHPMyAdmin) -- done!${txtrst}" 
      else
         echo "8. Install LAMPP (Apache/MySQL/PHP/PHPMyAdmin)" 
      fi
      if [ $highlight -eq 9] ; then
         echo "${bldred}9. Exit Installer${txtrst}"
      else
         echo "9. Exit Installer"
      fi
   echo -n "${bldred}Please choose [1,2,3,4,5,7,8 or 9] ? (HINT: start at 1)${txtrst}"

      # Loop while the variable choice is equal $choice_count
   }

   # Declare variable choice and assign value $choice_count
   choice=$choice_count
   highlight=10
   # Print to stdout
   #menulist
   # bash while loop
   while [ $choice -eq $choice_count ]; do
      menulist
      # read user input
      read choice
      # bash nested if/else
      if [ $choice -eq 1 ] ; then
         echo "${bldblue} ==> Creating ${my_home}${dotfiles}${txtrst}"
         cd ${my_home}
         mkdir ${dev_directory}
         cd ${my_home}${dev_directory}
         pwd
         sleep 1s
         echo "${bldblue} ==> Creating ${my_home}vital/pkg/${txtrst}"
         mkdir -p ${my_home}vital/pkg
         cd ${my_home}vital/pkg
         pwd
         sleep 1s
         echo "${bldblue} ==> Creating ${my_home}vital/tmp/${txtrst}"
         mkdir -p ${my_home}vital/tmp
         cd ${my_home}vital/tmp
         pwd
         sleep 2s
         echo "${bldgreen} ==> Git clone backup to ${dotfiles}${txtrst}"
         ## my backups repo
         cd ${my_home}${dev_directory}
         git clone $dotfiles_repo
         cd ${my_home}${dotfiles}
         pwd
         ls --color=auto -a
         choice=$choice_count
         echo $done_format
         highlight=1
      elif [ $choice -eq 2 ] ; then
         echo "${bldgreen} ==> Backing up mirrorlist and write/rank/sort new mirrorlist${txtrst}"
         sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
         sudo cp ${my_home}${dotfiles}etc/mirrorlist /etc/pacman.d/mirrorlist
         echo "sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo cp ${my_home}${dotfiles}etc/mirrorlist /etc/pacman.d/mirrorlist"
         sleep 2s
         echo "${bldgreen} ==> Backing up and copying root configs${txtrst}"
         sleep 1s
         sudo mv /etc/rc.conf /etc/rc.conf.bak
         sudo cp ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
         sudo mv /etc/pacman.conf /etc/pacman.conf.bak
         sudo cp ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
         sudo cp ${my_home}${dotfiles}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf
         echo "
sudo mv /etc/rc.conf /etc/rc.conf.bak
sudo cp ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
sudo mv /etc/pacman.conf /etc/pacman.conf.bak
sudo cp ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
sudo cp ${my_home}${dotfiles}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf
   "
         sleep 2s
         cd /etc
         pwd
         sudo pacman -Syy
         choice=$choice_count
         echo $done_format
         highlight=2
      elif [ $choice -eq 3 ] ; then
         echo "${bldgreen} ==> Installing main packages${txtrst}"
         ## Installing backups on guest
         ## Install offical packages
         sudo pacman -S --needed $(cat $dotfiles_main)
         choice=$choice_count
         echo $done_format
         highlight=3
      elif [ $choice -eq 4 ] ; then
         echo "${bldgreen} ==> Installing AUR packages (no confirm)${txtrst}"
         ## Install non-official (local) packages
         yaourt --noconfirm -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
         choice=$choice_count
         echo $done_format
         highlight=4
      elif [ $choice -eq 5 ] ; then
         echo "${bldgreen} ==> Installing AUR packages${txtrst}"
         ## Install non-official (local) packages
         yaourt -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
         choice=$choice_count
         echo $done_format
         highlight=5
      elif [ $choice -eq 6 ] ; then
         echo "${bldgreen} ==> Backing up and copying user configs${txtrst}"
         mv ${my_home}.gmail_symlink ${my_home}.gmail_symlink.bak
         cp ${my_home}${dotfiles}.gmail_symlink ${my_home}.gmail_symlink
         mv ${my_home}.gtkrc-2.0 ${my_home}.gtkrc-2.0.bak
         cp ${my_home}${dotfiles}.gtkrc-2.0 ${my_home}.gtkrc-2.0
         mv ${my_home}.ideskrc ${my_home}.ideskrc.bak
         cp ${my_home}${dotfiles}.ideskrc ${my_home}.ideskrc
         cp ${my_home}${dotfiles}.colors ${my_home}.colors
         mv ${my_home}.bashrc ${my_home}.bashrc.bak
         cp ${my_home}${dotfiles}.bashrc ${my_home}.bashrc
         mv ${my_home}.bash_profile ${my_home}.bash_profile.bak
         cp ${my_home}${dotfiles}.bash_profile ${my_home}.bash_profile
         #mv ${my_home}.Xdefaults ${my_home}.Xdefaults.bak
         #cp ${my_home}${dotfiles}.Xdefaults ${my_home}.Xdefaults
         mv ${my_home}.xinitrc ${my_home}.xinitrc.bak
         cp ${my_home}${dotfiles}.xinitrc ${my_home}.xinitrc
         cp ${my_home}${dotfiles}.excludes-usb ${my_home}.excludes-usb
         cp ${my_home}${dotfiles}.excludes-crypt ${my_home}.excludes-crypt
         echo "${bldblue}mv ${my_home}.gmail_symlink ${my_home}.gmail_symlink.bak
   cp ${my_home}${dotfiles}.gmail_symlink ${my_home}.gmail_symlink
   mv ${my_home}.gtkrc-2.0 ${my_home}.gtkrc-2.0.bak
   cp ${my_home}${dotfiles}.gtkrc-2.0 ${my_home}.gtkrc-2.0
   mv ${my_home}.ideskrc ${my_home}.ideskrc
   cp ${my_home}${dotfiles}.ideskrc ${my_home}.ideskrc
   cp ${my_home}${dotfiles}.colors ${my_home}.colors
   mv ${my_home}.bashrc ${my_home}.bashrc.bak
   cp ${my_home}${dotfiles}.bashrc ${my_home}.bashrc
   cp ${my_home}${dotfiles}.xinitrc ${my_home}.xinitrc
   cp ${my_home}${dotfiles}.excludes-usb ${my_home}.excludes-usb
   cp ${my_home}${dotfiles}.excludes-crypt ${my_home}.excludes-crypt${txtrst}"
         cd ${my_home}
         pwd
         ls --color=auto -a
         choice=$choice_count
         echo $done_format
         highlight=6
      elif [ $choice -eq 7 ] ; then
         echo "${bldgreen} ==> Git clone awesomewm-X, luakit-X and conky-X... Installing...${txtrst}"
         packer -S luakit
         mkdir ${my_home}.config
         cd ${my_home}.config/
         git clone ${awesome_repo}
         git clone ${conky_repo}
         git clone ${luakit_repo}
         #sh awesomewm-X/install.sh
         mv ${my_home}.config/conky ${my_home}.config/conky.original
         cp -r ${my_home}.config/conky-X ${my_home}.config/conky
         mv ${my_home}.config/awesome ${my_home}.config/awesome.original
         cp -r ${my_home}.config/awesomewm-X ${my_home}.config/awesome
         mv ${my_home}.config/luakit ${my_home}.config/luakit.original
         cp -r ${my_home}.config/luakit-X ${my_home}.config/luakit
         mkdir ${my_home}.config/awesome/Xdefaults/$USER
         mv ${my_home}.Xdefaults ${my_home}.config/awesome/Xdefaults/$USER/.Xdefaults
         ln -sfn ${my_home}.config/awesome/Xdefaults/default/.Xdefaults ${my_home}.Xdefaults
         ln -sfn ${my_home}.config/awesome/themes/pdq ${my_home}.config/awesome/themes/current
         ln -sfn ${my_home}.config/awesome/icons/AwesomeLight.png ${my_home}.config/awesome/icons/menu_icon.png
         ln -sfn ${my_home}.config/awesome/themes/current/theme.lua ${my_home}.config/luakit/awesometheme.lua
         cd ${my_home}Development
         #git clone git://github.com/LokiChaos/luakit-plugins.git LokiChaos-luakit-plugins
         #git clone git://github.com/mason-larobina/luakit-plugins.git
         #mkdir ${my_home}.config/luakit/plugins
         #cp -r luakit-plugins/adblock ${my_home}.config/luakit/plugins/adblock
         #cp -r LokiChaos-luakit-plugins/plugins/* ${my_home}.config/luakit/plugins/
         mkdir ${my_home}.local/share/luakit/adblock
         cd ${my_home}.local/share/luakit/adblock
         wget https://easylist-downloads.adblockplus.org/easylist.txt
         mkdir -p ${my_home}.cache/awesome
         touch ${my_home}.cache/awesome/stderr
         touch ${my_home}.cache/awesome/stdout
         mkdir ${my_home}.config/conky/arch/.cache
         mv ${my_home}.xinitrc ${my_home}.xinitrc.original
         cp ${my_home}.config/awesomewm-X/skel/.xinitrc ${my_home}.xinitrc
         sudo mv /etc/xdg/awesome/rc.lua /etc/xdg/awesome/rc.lua.bak
         sudo ln -s ${my_home}.config/awesome/default.rc.lua /etc/xdg/awesome/rc.lua
         cd
         echo "
         mv ${my_home}.config/conky ${my_home}.config/conky.original
         cp -r ${my_home}.config/conky-X ${my_home}.config/conky
         mv ${my_home}.config/awesome ${my_home}.config/awesome.original
         cp -r ${my_home}.config/awesomewm-X ${my_home}.config/awesome
         mv ${my_home}.config/luakit ${my_home}.config/luakit.original
         cp -r ${my_home}.config/luakit-X ${my_home}.config/luakit
         mkdir ${my_home}.config/awesome/Xdefaults/$USER
         mv ${my_home}.Xdefaults ${my_home}.config/awesome/Xdefaults/$USER/.Xdefaults
         ln -sfn ${my_home}.config/awesome/Xdefaults/default/.Xdefaults ${my_home}.Xdefaults
         ln -sfn ${my_home}.config/awesome/themes/pdq ${my_home}.config/awesome/themes/current
         ln -sfn ${my_home}.config/awesome/icons/AwesomeLight.png ${my_home}.config/awesome/icons/menu_icon.png
         ln -sfn ${my_home}.config/awesome/themes/current/theme.lua ${my_home}.config/luakit/awesometheme.lua
         cd ${my_home}Development
         #git clone git://github.com/LokiChaos/luakit-plugins.git LokiChaos-luakit-plugins
         #git clone git://github.com/mason-larobina/luakit-plugins.git
         #mkdir ${my_home}.config/luakit/plugins
         #cp -r luakit-plugins/adblock ${my_home}.config/luakit/plugins/adblock
         #cp -r LokiChaos-luakit-plugins/plugins/* ${my_home}.config/luakit/plugins/
         mkdir ${my_home}.local/share/luakit/adblock
         cd ${my_home}.local/share/luakit/adblock
         wget https://easylist-downloads.adblockplus.org/easylist.txt
         mkdir -p ${my_home}.cache/awesome
         touch ${my_home}.cache/awesome/stderr
         touch ${my_home}.cache/awesome/stdout
         mkdir ${my_home}.config/conky/arch/.cache
         mv ${my_home}.xinitrc ${my_home}.xinitrc.original
         cp ${my_home}.config/awesomewm-X/skel/.xinitrc ${my_home}.xinitrc
         sudo mv /etc/xdg/awesome/rc.lua /etc/xdg/awesome/rc.lua.bak
         sudo ln -s ${my_home}.config/awesome/default.rc.lua /etc/xdg/awesome/rc.lua
         "
         pwd
         ls --color=auto -a
         choice=$choice_count
         echo $done_format
         highlight=7
      elif [ $choice -eq 8 ] ; then
         echo "${bldgreen} ==> Installing Apache/MySQL/PHP/PHPMyAdmin/mpd/tor/privoxy configuration files${txtrst}"
         sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
         ln -s /etc/mpd.conf ${my_home}.mpdconf
         sudo mv /etc/tor/torrc /etc/tor/torrc.bak
         sudo cp ${my_home}${dotfiles}etc/torrc /etc/tor/torrc
         sudo echo 'forward-socks5 / localhost:9050 .' >> /etc/privoxy/config
         sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
         sudo cp ${my_home}${dotfiles}etc/httpd.conf /etc/httpd/conf/httpd.conf
         sudo mv /etc/httpd/conf/extra/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf.bak
         sudo cp ${my_home}${dotfiles}etc/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf
         sudo mv /etc/php/php.ini /etc/php/php.ini.bak
         sudo cp ${my_home}${dotfiles}etc/php.ini /etc/php/php.ini
         echo "sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
ln -s /etc/mpd.conf ${my_home}.mpdconf
sudo mv /etc/tor/torrc /etc/tor/torrc.bak
sudo cp ${my_home}${dotfiles}etc/torrc /etc/tor/torrc
sudo echo 'forward-socks5 / localhost:9050 .' >> /etc/privoxy/config
sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
sudo cp ${my_home}${dotfiles}etc/httpd.conf /etc/httpd/conf/httpd.conf
sudo mv /etc/httpd/conf/extra/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf.bak
sudo cp ${my_home}${dotfiles}etc/httpd-vhosts.conf /etc/httpd/conf/extra/httpd-vhosts.conf
sudo mv /etc/php/php.ini /etc/php/php.ini.bak
sudo cp ${my_home}${dotfiles}etc/php.ini /etc/php/php.ini"
           sudo echo "#
# /etc/hosts: static lookup table for host names
#

#<ip-address>  <hostname.domain.org>   <hostname>
127.0.0.1   localhost.localdomain   localhost $HOSTNAME
::1      localhost.localdomain   localhost
127.0.0.1 $USER.c0m www.$USER.c0m
127.0.0.1 $USER.$HOSTNAME.c0m www.$USER.$HOSTNAME.c0m
127.0.0.1 phpmyadmin.$USER.c0m www.phpmyadmin.$USER.c0m
127.0.0.1 torrent.$USER.c0m www.torrent.$USER.c0m
127.0.0.1 admin.$USER.c0m www.admin.$USER.c0m
127.0.0.1 stats.$USER.c0m www.stats.$USER.c0m
127.0.0.1 mail.$USER.c0m www.mail.$USER.c0m

# End of file" > /etc/hosts

sudo echo "NameVirtualHost *:80
NameVirtualHost *:444

#this first virtualhost enables: http://127.0.0.1, or: http://localhost, 
#to still go to /srv/http/*index.html(otherwise it will 404_error).
#the reason for this: once you tell httpd.conf to include extra/httpd-vhosts.conf, 
#ALL vhosts are handled in httpd-vhosts.conf(including the default one),
# E.G. the default virtualhost in httpd.conf is not used and must be included here, 
#otherwise, only domainname1.dom & domainname2.dom will be accessible
#from your web browser and NOT http://127.0.0.1, or: http://localhost, etc.
#

<VirtualHost *:80>
    DocumentRoot \"/srv/http/root\"
    ServerAdmin root@localhost
    #ErrorLog \"/var/log/httpd/127.0.0.1-error_log\"
    #CustomLog \"/var/log/httpd/127.0.0.1-access_log\" common
    <Directory /srv/http/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    DocumentRoot \"/srv/http/root\"
    ServerAdmin root@localhost
    #ErrorLog \"/var/log/httpd/127.0.0.1-error_log\"
    #CustomLog \"/var/log/httpd/127.0.0.1-access_log\" common
    <Directory /srv/http/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/$USER.c0m/public_html\"
    ServerName $USER.c0m
    ServerAlias $USER.c0m www.$USER.c0m
    <Directory /srv/http/$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/$USER.c0m/public_html\"
    ServerName $USER.c0m
    ServerAlias $USER.c0m www.$USER.c0m
    <Directory /srv/http/$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/$USER.$HOSTNAME.c0m/public_html\"
    ServerName $USER.$HOSTNAME.c0m
    ServerAlias $USER.$HOSTNAME.c0m www.$USER.$HOSTNAME.c0m
    <Directory /srv/http/$USER.$HOSTNAME.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/$USER.$HOSTNAME.c0m/public_html\"
    ServerName $USER.$HOSTNAME.c0m
    ServerAlias $USER.$HOSTNAME.c0m www.$USER.$HOSTNAME.c0m
    <Directory /srv/http/$USER.$HOSTNAME.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/usr/share/webapps/phpMyAdmin\"
    ServerName phpmyadmin.$USER.c0m
    ServerAlias phpmyadmin.$USER.c0m www.phpmyadmin.$USER.c0m
    <Directory /usr/share/webapps/phpMyAdmin/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/usr/share/webapps/phpMyAdmin\"
    ServerName phpmyadmin.$USER.c0m
    ServerAlias phpmyadmin.$USER.c0m www.phpmyadmin.$USER.c0m
    <Directory /usr/share/webapps/phpMyAdmin/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/torrent.$USER.c0m/public_html\"
    ServerName torrent.$USER.c0m
    ServerAlias torrent.$USER.c0m www.torrent.$USER.c0m
    <Directory /srv/http/torrent.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/torrent.$USER.c0m/public_html\"
    ServerName torrent.$USER.c0m
    ServerAlias torrent.$USER.c0m www.torrent.$USER.c0m
    <Directory /srv/http/torrent.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/admin.$USER.c0m/public_html\"
    ServerName admin.$USER.c0m
    ServerAlias admin.$USER.c0m www.admin.$USER.c0m
    <Directory /srv/http/admin.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/admin.$USER.c0m/public_html\"
    ServerName admin.$USER.c0m
    ServerAlias admin.$USER.c0m www.admin.$USER.c0m
    <Directory /srv/http/admin.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/stats.$USER.c0m/public_html\"
    ServerName stats.$USER.c0m
    ServerAlias stats.$USER.c0m www.stats.$USER.c0m
    <Directory /srv/http/stats.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/stats.$USER.c0m/public_html\"
    ServerName stats.$USER.c0m
    ServerAlias stats.$USER.c0m www.stats.$USER.c0m
    <Directory /srv/http/stats.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:80>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/mail.$USER.c0m/public_html\"
    ServerName mail.$USER.c0m
    ServerAlias mail.$USER.c0m www.mail.$USER.c0m
    <Directory /srv/http/mail.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>

<VirtualHost *:444>
    ServerAdmin $USER@$HOSTNAME
    DocumentRoot \"/srv/http/mail.$USER.c0m/public_html\"
    ServerName mail.$USER.c0m
    ServerAlias mail.$USER.c0m www.mail.$USER.c0m
    <Directory /srv/http/mail.$USER.c0m/public_html/>
          DirectoryIndex index.htm index.html
          AddHandler cgi-script .cgi .pl
          Options ExecCGI Indexes FollowSymLinks MultiViews +Includes
          AllowOverride None
          Order allow,deny
          allow from all
   </Directory>
</VirtualHost>" > /etc/httpd/conf/extra/httpd-vhosts.conf

         echo "sudo echo #
# /etc/hosts: static lookup table for host names
#

#<ip-address>  <hostname.domain.org>   <hostname>
127.0.0.1   localhost.localdomain   localhost $HOSTNAME
::1      localhost.localdomain   localhost
127.0.0.1 $USER.c0m www.$USER.c0m
127.0.0.1 $USER.$HOSTNAME.c0m www.$USER.$HOSTNAME.c0m
127.0.0.1 phpmyadmin.$USER.c0m www.phpmyadmin.$USER.c0m
127.0.0.1 torrent.$USER.c0m www.torrent.$USER.c0m
127.0.0.1 admin.$USER.c0m www.admin.$USER.c0m
127.0.0.1 stats.$USER.c0m www.stats.$USER.c0m
127.0.0.1 mail.$USER.c0m www.mail.$USER.c0m

# End of file > /etc/hosts"
         sleep 2s
         echo "Creating self-signed certificate (you can change key size and days of validity)"
         mkdir -p ${my_home}music
         sudo mkdir -p /var/lib/mpd/music
         ln -s ${my_home}music /var/lib/mpd/music
         sudo rc.d restart mpd
         su
         cd /etc/httpd/conf
         openssl genrsa -des3 -out server.key 1024
         openssl req -new -key server.key -out server.csr
         cp server.key server.key.org
         openssl rsa -in server.key.org -out server.key
         openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt
         #
         mkdir -p /srv/http/root/public_html
         chmod g+xr-w /srv/http/root
         chmod -R g+xr-w /srv/http/root/public_html
         #
         mkdir -p /srv/http/$USER.c0m/public_html
         chmod g+xr-w /srv/http/$USER.c0m
         chmod -R g+xr-w /srv/http/$USER.c0m/public_html
         #
         mkdir -p /srv/http/$USER.$HOSTNAME.c0m/public_html
         chmod g+xr-w /srv/http/$USER.$HOSTNAME.c0m
         chmod -R g+xr-w /srv/http/$USER.$HOSTNAME.c0m/public_html
         #
         mkdir -p /srv/http/phpmyadmin.$USER.c0m/public_html
         chmod g+xr-w /srv/http/phpmyadmin.$USER.c0m
         chmod -R g+xr-w /srv/http/phpmyadmin.$USER.c0m/public_html
         #
         mkdir -p /srv/http/torrent.$USER.c0m/public_html
         chmod g+xr-w /srv/http/torrent.$USER.c0m
         chmod -R g+xr-w /srv/http/torrent.$USER.c0m/public_html
         #
         mkdir -p /srv/http/admin.$USER.c0m/public_html
         chmod g+xr-w /srv/http/admin.$USER.c0m
         chmod -R g+xr-w /srv/http/admin.$USER.c0m/public_html
         #
         mkdir -p /srv/http/stats.$USER.c0m/public_html
         chmod g+xr-w /srv/http/stats.$USER.c0m
         chmod -R g+xr-w /srv/http/stats.$USER.c0m/public_html
         #
         mkdir -p /srv/http/mail.$USER.c0m/public_html
         chmod g+xr-w /srv/http/mail.$USER.c0m
         chmod -R g+xr-w /srv/http/mail.$USER.c0m/public_html


# Take Screenshot of entire Screen
if [ "$1" == "scr" ]; then scrot "${NAME}" || wput -m 644 -u :${name} "blah blah blah" || echo -n "{URL}" | xclip -selection c; fi





echo "mkdir -p /srv/http/root/public_html
chmod g+xr-w /srv/http/root
chmod -R g+xr-w /srv/http/root/public_html
#
mkdir -p /srv/http/$USER.c0m/public_html
chmod g+xr-w /srv/http/$USER.c0m
chmod -R g+xr-w /srv/http/$USER.c0m/public_html
#
mkdir -p /srv/http/$USER.$HOSTNAME.c0m/public_html
chmod g+xr-w /srv/http/$USER.$HOSTNAME.c0m
chmod -R g+xr-w /srv/http/$USER.$HOSTNAME.c0m/public_html
#
mkdir -p /srv/http/phpmyadmin.$USER.c0m/public_html
chmod g+xr-w /srv/http/phpmyadmin.$USER.c0m
chmod -R g+xr-w /srv/http/phpmyadmin.$USER.c0m/public_html
#
mkdir -p /srv/http/torrent.$USER.c0m/public_html
chmod g+xr-w /srv/http/torrent.$USER.c0m
chmod -R g+xr-w /srv/http/torrent.$USER.c0m/public_html
#
mkdir -p /srv/http/admin.$USER.c0m/public_html
chmod g+xr-w /srv/http/admin.$USER.c0m
chmod -R g+xr-w /srv/http/admin.$USER.c0m/public_html
#
mkdir -p /srv/http/stats.$USER.c0m/public_html
chmod g+xr-w /srv/http/stats.$USER.c0m
chmod -R g+xr-w /srv/http/stats.$USER.c0m/public_html
#
mkdir -p /srv/http/mail.$USER.c0m/public_html
chmod g+xr-w /srv/http/mail.$USER.c0m
chmod -R g+xr-w /srv/http/mail.$USER.c0m/public_html

"
         sleep 2s
         echo "w00t!! You're just flying through this stuff you hacker you!! :p"
         sleep 1s
         echo "rah rah $USER rah rah $USER!!!"
         sleep 1s
         echo "Ok... let's continue on with this..."
         rc.d start mysqld
         rc.d restart httpd
         sleep 1s
         echo "Ok... starting MySQL and setting a root password for MySQL...."
         rand=$RANDOM
         mysqladmin -u root password $USER-$rand
         echo "${bldred}You're mysql root password is $USER-$rand Write this down before proceeding...${txtrst}
         "
         sleep 5s
         echo "If you want to change/update the above root password (AT A LATER TIME), then you need to use the following command:
$ mysqladmin -u root -p'$USER-$rand' password newpasswordhere

For example, you can set the new password to 123456, enter:

$ mysqladmin -u root -p'$USER-$rand' password '123456'"
         sleep 3s 
         echo "Ok, trying to login to mysql and make sure it works..."
         sleep 2s 
         mysql -u root -p
         # exit from the CLI MySQL client
         exit
         echo "If it logged in then exited, it worked! En guarde! Touche! And all that :Please

Cool, well we are still root so let's drop down to $USER"
         # exit from root back to user
         exit
         echo "w00t success!"
         sleep 1s
         ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpmyadmin.$USER.c0m
         ln -s /srv/http ${my_home}localhost
         cd ${my_home}localhost
         pwd
         echo "These are your localhost domains:"
         sleep 1s
         ls --color=auto -a
         sleep 3s
         echo "You can access the files from this shortcut in your home folder and through web server in your favorite web browser. ie: http://$USER.c0m, http://phpmyadmin.$USER.c0m, etc."
         sleep 3s
         choice=$choice_count
         echo $done_format
         highlight=8
      elif [ $choice -eq 9 ] ; then
         echo $done_format
         echo "${bldgreen} ==> Installing VirtualBox guest additions...${txtrst}"
         sleep 3s
         sudo pacman -S virtualbox-archlinux-additions
         echo "${bldblue}edit /etc/rc.conf${txtrst}
add to DAEMONS array:

${bldgreen}dbus${txtrst}

If running Archlinux as VirtualBox Guest
add to MODULES array:

${bldgreen}vboxguest vboxsf vboxvideo${txtrst}"

         sleep 5s
         echo " ==> Opening file for edit in 5..."
         sleep 1s
         echo " ==> 4..."
         sleep 1s
         echo " ==> 3..."
         sleep 1s
         echo " ==> 2..."
         sleep 1s
         echo " ==> 1..."
         highlight=10
         sleep 1s
         sudo nano -w /etc/rc.conf
         echo "${bldgreen} ==> Exiting install script...${txtrst}
         "
         sleep 3s
         echo "${bldgreen}Re-Run install script: 'sh reinstaller.sh'${txtrst} | ${bldred}Remove install script 'rm reinstaller.sh'${txtrst}
         "
         sleep 3s
         echo "${bldred}Rebooting ...${txtrst}


${bldgreen}Log back in as $USER, then type: 'startx'${txtrst}"
         sleep 3s
         sudo reboot
         sleep 60s
      else
         echo "${bldred}Please make a choice between 1-9! (HINT: start at 1)${txtrst}"
         highlight=${highlight}
         menulist
         choice=$choice_count
      fi
   done
fi