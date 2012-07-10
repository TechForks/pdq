#!/bin/bash
## reinstall from github backup! =)
## 03-22-2012 pdq
## 07-10-2012 pdq

my_home="$HOME/"
#my_home="/home/pdq/test/"
dev_directory="Development"
dotfiles="${dev_directory}/pdq/"
dotfiles_main="${my_home}${dotfiles}main.lst"
dotfiles_local="${my_home}${dotfiles}local.lst"
dotfiles_repo="git://github.com/idk/pdq.git"
awesome_repo="git://github.com/idk/awesomewm-X.git"
conky_repo="git://github.com/idk/conky-X.git"
done_format="========================================="
choice_count=10
root_choice_count=6
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset

if [ `id -u` -eq 0 ]; then
   function root_menulist() { 
      if [ $root_highlight -eq 1 ] ; then
         echo "${bldgreen}1. Pacman-key initialization -- done!${txtrst}"
      else
         echo "1. Pacman-key initialization"
      fi
      if [ $root_highlight -eq 2 ] ; then
         echo "${bldgreen}2. Create a USER and /home/USER and generate locale -- done!${txtrst}"
      else
         echo "2. Create a USER and /home/USER and generate locale"
      fi
      if [ $root_highlight -eq 3 ] ; then
         echo "${bldgreen}3. Edit /etc/pacman.conf${txtrst}"
      else
         echo "3. Edit /etc/pacman.conf"
      fi
      if [ $root_highlight -eq 4 ] ; then
         echo "${bldgreen}4. Add USER to sudoers -- done!${txtrst}"
      else
         echo "4. Add USER to sudoers "
      fi
      if [ $root_highlight -eq 5 ] ; then
         echo "${bldgreen}5. Switch to your newly created USER${txtrst}" 
      else
         echo "5. Switch to your newly created USER" 
      fi
      if [ $root_highlight -eq 6 ] ; then
         echo "${bldred}6. Exit root Installer${txtrst}"
      else
         echo "6. Exit root Installer"
      fi
   echo -n "${bldred}Please choose [1,2,3,4,5 or 6 ? (HINT: start at 1)${txtrst}"

      # Loop while the variable choice is equal $choice_count
   }

# Declare variable choice and assign value $choice_count
   root_choice=$root_choice_count
   root_highlight=11
   # Print to stdout
   #menulist
   # bash while loop
   while [ $root_choice -eq $root_choice_count ]; do
      root_menulist
      # read user input
      read root_choice
      # bash nested if/else
       if [ $root_choice -eq 1 ] ; then
         echo "${bldgreen} ==> pacman-key initialization starting ...${txtrst}"
         echo "HINT: Mash on the keyboard keys and move mouse to make entropy process go faster! :D"
         sleep 5s
         pacman-key --init
         pacman-key --populate archlinux
         echo "done ..."
         root_choice=$root_choice_count
         echo $done_format
         root_highlight=1
      elif [ $root_choice -eq 2 ] ; then
         echo "${bldblue} ==> Creating user...${txtrst}"
         sleep 3s
         read -p "Enter username : " username
         read -s -p "Enter password : " password
         egrep "^$username" /etc/passwd >/dev/null
         if [ $? -eq 0 ]; then
            echo "$username exists already!"
         else
            pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
            useradd -m -p $pass -g users -G audio,video,wheel,storage,optical,power,games,network,log -s /bin/bash $username
            [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
         fi
         root_choice=$root_choice_count
         root_highlight=2
         echo $done_format
      elif [ $root_choice -eq 3 ] ; then
         echo "cp /etc/pacman.conf /etc/pacman.conf.orig"
         cp /etc/pacman.conf /etc/pacman.conf.orig
         echo "${bldgreen} ==> Adding repo to /etc/pacman.conf${txtrst}"
         echo '[archlinuxfr]
Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
         echo "
echo '[archlinuxfr]
Server = http://repo.archlinux.fr/$arch >> /etc/pacman.conf"
         pacman -Syu
         pacman -S yaourt fakeroot git
         root_choice=$root_choice_count
         echo $done_format
         root_highlight=3
      elif [ $root_choice -eq 4 ] ; then
         echo "${bldgreen}Edit sudoers, UNCOMMENT wheel...${txtrst}

${bldblue}% wheel ALL=(ALL) ALL${txtrst}

"
         sleep 3s
         EDITOR=nano visudo
         echo "done..."
         root_choice=$root_choice_count
         echo $done_format 
         root_highlight=4
      elif [ $root_choice -eq 5 ] ; then
         echo "${bldgreen}Switch to USER${txtrst}"
         read -p "Username : " username
         egrep "^$username" /etc/passwd >/dev/null
         if [ $? -eq 0 ]; then
            echo "cp /root/reinstaller.sh /home/$username/reinstaller.sh"
            cp /root/reinstaller.sh /home/$username/reinstaller.sh
            cd /home/$username
            pwd
            echo "when script exits to prompt run: 'sh reinstaller.sh'"
            sleep 5s
            su $username
            cd
         fi
         root_choice=$root_choice_count
         echo $done_format
         root_highlight=5
      elif [ $root_choice -eq 6 ] ; then
         echo $done_format
         sleep 2s
         root_highlight=6
         echo "${bldgreen} ==> Exiting root install script...${txtrst}"
         sleep 3s
         echo "${bldgreen}To start Awesome as user type: 'startx' ...${txtrst}"
         sleep 3s
         echo "${bldgreen}Re-Run install script: 'sh reinstaller.sh'${txtrst} | ${bldred}Remove install script 'rm reinstaller.sh'${txtrst}"
         sleep 3s
         exit
      else
         echo "${bldred}Please make a choice between 1-6! (HINT: start at 1)${txtrst}"
         root_highlight=${root_highlight}
         root_menulist
         choice=$root_choice_count
      fi
   done
else
   function menulist() { 
      if [ $highlight -eq 1 ] ; then
         echo "${bldgreen}1. Create ${my_home}${dotfiles} and ${my_home}vital/ -- done!${txtrst}"
      else
         echo "1. Create ${my_home}${dotfiles} and ${my_home}vital/"
      fi
      if [ $highlight -eq 2 ] ; then
         echo "${bldgreen}2. Git clone backup to ${dotfiles}-- done!${txtrst}"
      else
         echo "2. Git clone backup to ${dotfiles}"
      fi
      if [ $highlight -eq 3 ] ; then
         echo "${bldgreen}3. Backup mirrorlist and write/rank/sort new mirrorlist -- done!${txtrst}"
      else
         echo "3. Backup mirrorlist and write/rank/sort new mirrorlist"
      fi
      if [ $highlight -eq 4 ] ; then
         echo "${bldgreen}4. Install main packages -- done!${txtrst}" 
      else
         echo "4. Install main packages" 
      fi
      if [ $highlight -eq 5 ] ; then
         echo "${bldgreen}5. Install AUR packages --noconfirm -- done!${txtrst}" 
      else
         echo "5. Install AUR packages --noconfirm" 
      fi
      if [ $highlight -eq 6 ] ; then
         echo "${bldgreen}6. Install AUR packages  (If Step 5 fails) -- done!${txtrst}" 
      else
         echo "6. Install AUR packages  (If Step 5 fails)" 
      fi
      if [ $highlight -eq 7 ] ; then
         echo "${bldgreen}7. Backup and copy user configs -- done!${txtrst}" 
      else
         echo "7. Backup and copy user configs" 
      fi
      if [ $highlight -eq 8 ] ; then
         echo "${bldgreen}8. Backup and copy root configs -- done!${txtrst}" 
      else
         echo "8. Backup and copy root configs" 
      fi
      if [ $highlight -eq 9 ] ; then
         echo "${bldgreen}9. Install Awesome Window Manager (awesomewm-X) and Conky (conky-X) -- done!${txtrst}" 
      else
         echo "9. Install Awesome Window Manager (awesomewm-X) and Conky (conky-X)" 
      fi
      if [ $highlight -eq 10 ] ; then
         echo "${bldred}10. Exit Installer${txtrst}"
      else
         echo "10. Exit Installer"
      fi
   echo -n "${bldred}Please choose [1,2,3,4,5,7,8,9 or 10] ? (HINT: start at 1)${txtrst}"

      # Loop while the variable choice is equal $choice_count
   }

   # Declare variable choice and assign value $choice_count
   choice=$choice_count
   highlight=11
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
         echo "${bldblue} ==> Creating ${my_home}vital/${txtrst}"
         cd ${my_home}
         mkdir vital
         cd ${my_home}vital
         pwd
         echo "${bldblue} ==> Creating ${my_home}vital/pkg/${txtrst}"
         cd ${my_home}vital
         mkdir pkg
         cd ${my_home}vital/pkg
         pwd
         echo "${bldblue} ==> Creating ${my_home}vital/tmp/${txtrst}"
         cd ${my_home}vital
         mkdir tmp
         cd ${my_home}vital/tmp
         pwd
         choice=$choice_count
         highlight=1
         echo $done_format
      elif [ $choice -eq 2 ] ; then
         echo "${bldgreen} ==> Git clone backup to ${dotfiles}${txtrst}"
         ## my backups repo
         cd ${my_home}${dev_directory}
         git clone $dotfiles_repo
         cd ${my_home}${dotfiles}
         pwd
         ls --color=auto -a
         choice=$choice_count
         echo $done_format
         highlight=2
      elif [ $choice -eq 3 ] ; then
         echo "${bldgreen} ==> Backing up mirrorlist and write/rank/sort new mirrorlist${txtrst}"
         sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
         sudo cp ${my_home}${dotfiles}etc/mirrorlist /etc/pacman.d/mirrorlist
         echo "sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
   sudo cp ${my_home}${dotfiles}etc/mirrorlist /etc/pacman.d/mirrorlist"
         choice=$choice_count
         echo $done_format 
         highlight=3
      elif [ $choice -eq 4 ] ; then
         echo "${bldgreen} ==> Installing main packages${txtrst}"
         ## Installing backups on guest
         ## Install offical packages
         sudo pacman -S --needed $(cat $dotfiles_main)
         choice=$choice_count
         echo $done_format
         highlight=4
      elif [ $choice -eq 5 ] ; then
         echo "${bldgreen} ==> Installing AUR packages${txtrst}"
         ## Install non-official (local) packages
         yaourt --noconfirm -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
         choice=$choice_count
         echo $done_format
         highlight=5
      elif [ $choice -eq 6 ] ; then
         echo "${bldgreen} ==> Installing AUR packages${txtrst}"
         ## Install non-official (local) packages
         yaourt -S $(cat $dotfiles_local | grep -vx "$(pacman -Qqm)")
         choice=$choice_count
         echo $done_format
         highlight=6
      elif [ $choice -eq 7 ] ; then
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
         highlight=7
       elif [ $choice -eq 8 ] ; then
         echo "${bldgreen} ==> Backing up and copying root configs${txtrst}"
         sudo mv /etc/rc.conf /etc/rc.conf.bak
         sudo cp ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
         sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
         ln -s /etc/mpd.conf ${my_home}.mpdconf
         sudo mv /etc/pacman.conf /etc/pacman.conf.bak
         sudo cp ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
         sudo cp ${my_home}${dotfiles}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf

         echo "${bldblue}sudo mv /etc/rc.conf /etc/rc.conf.bak
   sudo cp ${my_home}${dotfiles}etc/rc.conf /etc/rc.conf
   sudo cp ${my_home}${dotfiles}etc/mpd.conf /etc/mpd.conf
   ln -s /etc/mpd.conf ${my_home}.mpdconf
   sudo mv /etc/pacman.conf /etc/pacman.conf.bak
   sudo cp ${my_home}${dotfiles}etc/pacman.conf /etc/pacman.conf
   sudo cp ${my_home}${dotfiles}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf${txtrst}"
         cd /etc
         pwd
         choice=$choice_count
         echo $done_format
         highlight=8
      elif [ $choice -eq 9 ] ; then
         echo "${bldgreen} ==> Git clone awesomewm-X and conky-X... Installing...${txtrst}"
         mkdir ${my_home}.config
         cd ${my_home}.config/
         git clone ${awesome_repo}
         git clone ${conky_repo}
         sh awesomewm-X/install.sh
         pwd
         ls --color=auto -a
         choice=$choice_count
         echo $done_format
         highlight=9
      elif [ $choice -eq 10 ] ; then
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
         echo "${bldgreen} ==> Exiting install script...${txtrst}"
         sleep 3s
         echo "${bldgreen}Re-Run install script: 'sh reinstaller.sh'${txtrst} | ${bldred}Remove install script 'rm reinstaller.sh'${txtrst}"
         sleep 3s
         echo "${bldgreen}Rebooting ...


Log back in as USER, then type: 'startx'${txtrst}"
         sleep 3s
         sudo reboot
         sleep 60s
      else
         echo "${bldred}Please make a choice between 1-10! (HINT: start at 1)${txtrst}"
         highlight=${highlight}
         menulist
         choice=$choice_count
      fi
   done
fi

## As root right after fresh install:
# wget http://is.gd/reinstaller -O reinstaller.sh
# sh reinstaller.sh

## Reinstalling backups on guest OS (Archlinux)
# sh ~/Development/dotfiles/reinstaller.sh

## Creating backups on host OS (Archlinux)
# sh ~/Development/dotfiles/backup.sh