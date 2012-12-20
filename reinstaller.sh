#!/bin/sh
## reinstall from github backup! =)
## 03-22-2012 pdq
## 07-10-2012 pdq
## 11-04-2012 pdq
## 12-05-2012 pdq
## 12-15-2012 pdq

exit 1

## Instructions

## from livecd/liveusb
# wget http://is.gd/reinstaller -O rs.sh
# sh rs.sh

## when it askes if install 1) phonon-gstreamer or 2) phonon-vlc
## chose 2
## when it asks if replace foo with bar chose y for everyone


## color formatting
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset

MOUNT_POINT="/mnt"

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

ask_something() {
    echo -ne $question
    while read -r -n 1 -s yn; do
        if [[ $yn = [YyNn] ]]; then
           [[ $yn = [Yy] ]] && return=0
            [[ $yn = [Nn] ]] && return=1
            break
        fi
    done
    return $return
}

if [ $(id -u) -eq 0 ]; then

    clr="\Zb\Z0"

    # temporary file
    _TEMP=/tmp/answer$$

    _PROCEED=0

    # FUNCTIONS
    exiting() {
        clear
        rm -f $_TEMP
        exit
    }

    what_do() {
        if [ ! $_PROCEED -eq 1 ] ; then
            echo -n "${bldblue}Go back to main menu?${txtrst} ${bldgreen}<Enter>${txtrst} ${bldblue}or hit${txtrst} ${bldred}n${txtrst} ${bldblue}to EXIT:${txtrst} "
            read choice
            if [ $choice = "n" ] ; then
                exiting
            else
                initialize_start
                main_menu
            fi
        else
            echo "${bldgreen}[GO] Proceeding...${txtrst}"
        fi
    }

    main_menu() {
        dialog \
            --colors --title "pdqOS Installer for Arch Linux x86_64" \
            --menu "\ZbSelect action: (Do them in order)" 20 60 12 \
            1 $clr"List linux partitions" \
            2 $clr"Partition editor (cfdisk)" \
            3 $clr"Create filesystems" \
            4 $clr"Create internet connection" \
            5 $clr"Mount root partition" \
            6 $clr"Mount home partition" \
            7 $clr"Initial install" \
            8 $clr"Generate fstab" \
            9 $clr"Configure" \
            10 $clr"Unmount install partitions" \
            11 $clr"Finish up and reboot to complete. (remove livecd after poweroff)" \
            12 $clr"Exit" 2>$_TEMP

        choice=$(cat $_TEMP)
        case $choice in
            1) list_partitions;;
            2) part_editor;;
            3) make_fs;;
            4) make_internet;;
            5) mount_root;;
            6) mount_home;;
            7) init_install;;
            8) gen_fstab;;
            9) chroot_conf;;
            10) unmount_part;;
            11) finish_up;;
            12) exiting;;
        esac
    }

    list_partitions() {
        partition_list=`blkid | grep -i 'TYPE="ext[234]"' | cut -d ' ' -f 1 | grep -i '^/dev/' | grep -v '/dev/loop' | sed "s/://g"`
        if [ "$partition_list" = "" ] ; then
            echo "It appears you have no linux partitions yet."
        else
            echo "$partition_list"
        fi
    }

    part_editor() {
        echo "${bldblue}Create a / (primary, bootable and recommended 6GB in size) and a /home (primary and remaining size) partition${txtrst}"
        cfdisk
        what_do
    }

    make_fs() {
        mkfs -t ext4 /dev/sda1
        mkfs -t ext4 /dev/sda2
        what_do
    }

    make_internet() {
        ping -c 3 www.google.com
        what_do
    }

    mount_root() {
        error=0
        MOUNT_DEV="$1"

        [[  $# =  1  ]] || {  echo "no device added. Rerun" ;  error=1 ; }
        [[ -b $1 ]] ||  { echo "not a valid block device. Rerun " ;  error=1 ; }
        [[ -d "$MOUNT_POINT" ]] || { echo "no $MOUNT_POINT ?" ; error=1 ; }
        echo

        { mount "$MOUNT_DEV" "$MOUNT_POINT" && echo "root successfully mounted at $MOUNT_POINT" ;  } || { echo "mounting of root failed. Exit" ; error=1 ; }

        echo "here is the actual content of the mounted device $MOUNT_DEV on $MOUNT_POINT"
        ls "$MOUNT_POINT"
        what_do
    }

    mount_home() {
        error=0
        MOUNT_DEV="$1"
        mkdir -p $MOUNT_POINT/home
        [[  $# =  1  ]] || {  echo "no device added. Rerun" ;  error=1 ; }
        [[ -b $1 ]] ||  { echo "not a valid block device. Rerun " ;  error=1 ; }
        [[ -d "$MOUNT_POINT/home" ]] || { echo "no $MOUNT_POINT/home ?" ; error=1 ; }
        echo

        { mount  "$MOUNT_DEV" "$MOUNT_POINT/home" && echo "home successfully mounted at $MOUNT_POINT/home" ;  } || { echo "mounting of home failed. Exit" ; error=1 ; }

        if [ $error -eq 1 ] ; then
            exit 1
        else
            echo "here is the actual content of the mounted device $MOUNT_DEV on $MOUNT_POINT"
            ls "$MOUNT_POINT/home"
        fi
        what_do
    }

    init_install() {
        pacstrap -i /mnt base base-devel sudo git hub rsync wget
        what_do
    }

    chroot_conf() {
        wget https://github.com/idk/pdq/blob/master/chroot-rs.sh -O chroot-rs.sh
        chmod +x chroot-rs.sh
        arch-chroot /mnt /bin/sh -c "./chroot-rs.sh"
        what_do
    }

    gen_fstab() {
        genfstab -U -p /mnt >> /mnt/etc/fstab
        nano /mnt/etc/fstab
        what_do
    }

    unmount_part() {
        umount /mnt/home
        umount /mnt
        what_do
    }

    finish_up() {
        systemctl enable dhcpcd@eth0.service
        pacman -Syy
        reboot
        what_do
    }

    # utility execution
    while true
    do
        main_menu
    done
fi

## user script

my_home="$HOME/"
#my_home="/home/pdq/test/"
dev_directory="${my_home}github/"

## create config, dev directory, pacman pkg dir and pacaur tmp dir
mkdir -p ${my_home}.config
mkdir -p ${dev_directory}
mkdir -p ${my_home}vital/pkg
mkdir -p ${my_home}vital/tmp
export TMPDIR=${my_home}vital/tmp

## code be `ere! ##
grep -q "^flags.*\blm\b" /proc/cpuinfo && archtype="yes" || archtype="no"
if [ "$archtype" = "no" ]; then
    echo "Sorry this is for x86_64 only! =)"
    exit 1
fi

if [ $(id -u) -eq 0 ]; then
    echo "Do not run me as root! =)"
    exit 1
fi

sudo locale-gen

if [ ! -f /usr/bin/pacaur ]; then
    echo "${bldblue} ==> Installing pacaur${txtrst}"
    wget https://aur.archlinux.org/packages/pa/pacaur/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman -U --noconfirm pacaur* && cd
fi

if [ ! -f /usr/bin/pacman-color ]; then
    echo "${bldblue} ==> Installing pacman-color${txtrst}"
    wget https://aur.archlinux.org/packages/pa/pacman-color/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman -U --noconfirm pacman-color* && cd
fi

if [ ! -f /usr/bin/powerpill ]; then
    echo "${bldblue} ==> Installing powerpill${txtrst}"
    wget https://aur.archlinux.org/packages/po/powerpill/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman -U --noconfirm powerpill* && cd
fi

if [ ! -f /usr/bin/git ]; then
    sudo pacman -S --noconfirm git
fi

if [ ! -f /usr/bin/hub ]; then
    sudo pacman -S --noconfirm --needed hub
fi

if [ ! -d "${dev_directory}pdq" ]; then
    echo "${bldgreen} ==> Cloning initial repo to ${dev_directory}pdq/${txtrst}"
    hub clone idk/pdq
    hub clone idk/etc
    sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
    sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
    sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
    sudo mv -v /etc/powerpill/powerpill.json /etc/powerpill/powerpill.json.bak
    sudo cp -v ${dev_directory}etc/powerpill.json /etc/powerpill/powerpill.json
    cp -rv ${dev_directory}pdq/.config/pacaur ${my_home}.config/pacaur
    sudo pacman-color -Syy
fi

if [ ! -f /usr/bin/rsync ]; then
    sudo powerpill -S --noconfirm rsync
fi

question="${bldgreen}Is this a VirtualBox install (Y/N)?${txtrst}\n"
if ask_something; then
    sudo powerpill -S --noconfirm --needed virtualbox-guest-utils
    sudo sh -c "echo 'vboxguest
vboxsf
vboxvideo' > /etc/modules-load.d/virtualbox.conf"
fi

question="${bldgreen}Install main packages (Y/N)?${txtrst}\n"
if ask_something; then
    sudo powerpill -Syy
    sudo powerpill -S --needed $(cat ${dev_directory}pdq/main.lst)
fi

question="${bldgreen}Install AUR packages (Y/N)?${txtrst}\n"
if ask_something; then
    sudo powerpill -Syy
    echo "${bldgreen} ==> Installing AUR packages (no confirm) [This may take a while]${txtrst}"
    pacaur --noconfirm -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
fi

question="${bldgreen}Install AUR packages (with confirm) [Use this option if the prior one failed, otherwise skip it] (Y/N)${txtrst}?\n"
if ask_something; then
    sudo powerpill -Syy
    echo "${bldgreen} ==> Installing AUR packages (with confirm)${txtrst}"
    pacaur -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
fi

question="${bldgreen}Clone all repos (Y/N)?${txtrst}\n"
if ask_something; then
    hub clone idk/awesomewm-X
    hub clone idk/conky-X
    hub clone idk/zsh
    hub clone idk/bin
    hub clone idk/php
    hub clone idk/systemd
    hub clone idk/eggdrop-scripts
    hub clone idk/gh
fi

question="${bldgreen}Install all repos (Y/N) [Cannot do in chroot]?${txtrst}\n"
if ask_something; then
    wget https://raw.github.com/idk/pdq-utils/master/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman --noconfirm -U pdq-utils* && cd
    wget https://raw.github.com/idk/gh/master/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman --noconfirm -U gh* && cd
    echo "${bldgreen} ==> Backing up mirrorlist and write/rank/sort new mirrorlist${txtrst}"
    sudo mv -v /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo cp -v ${dev_directory}etc/mirrorlist /etc/pacman.d/mirrorlist
    
    echo "${bldgreen} ==> Backing up and copying root configs${txtrst}"
    # sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
    # sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
    # sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
    sudo cp -v ${dev_directory}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf

    echo "${bldgreen} ==> Backing up and copying user configs${txtrst}"
    mv -v ${my_home}.gmail_symlink ${my_home}.gmail_symlink.bak
    cp -v ${dev_directory}pdq/.gmail_symlink ${my_home}.gmail_symlink
    mv -v ${my_home}.gtkrc-2.0 ${my_home}.gtkrc-2.0.bak
    cp -v ${dev_directory}pdq/.gtkrc-2.0 ${my_home}.gtkrc-2.0
    mv -v ${my_home}.bashrc ${my_home}.bashrc.bak
    cp -v ${dev_directory}pdq/.bashrc ${my_home}.bashrc
    mv -v ${my_home}.bash_profile ${my_home}.bash_profile.bak
    cp -v ${dev_directory}pdq/.bash_profile ${my_home}.bash_profile
    mv -v ${my_home}.xinitrc ${my_home}.xinitrc.bak
    cp -v ${dev_directory}pdq/.xinitrc ${my_home}.xinitrc
    cp -v ${dev_directory}pdq/.excludes-usb ${my_home}.excludes-usb
    cp -v ${dev_directory}pdq/.excludes-crypt ${my_home}.excludes-crypt
    cp -rv ${dev_directory}bin ${my_home}bin
    mkdir -p ${my_home}.vimperator
    cp -rv ${dev_directory}pdq/.vimperator/plugin ${my_home}.vimperator/plugin
    mkdir -p ${my_home}.moc
    cp -rv ${dev_directory}pdq/.moc/themes ${my_home}.moc/themes
    cp -v ${dev_directory}pdq/.moc/config ${my_home}.moc/config
    mkdir -p ${my_home}.kde4/share/config
    cp -v ${dev_directory}pdq/.kde4/dolphinrc ${my_home}.kde4/share/config/dolphinrc
    mkdir -p ${my_home}.kde4/share/apps/dolphin
    cp -v ${dev_directory}pdq/.kde4/dolphinui.rc ${my_home}.kde4/share/apps/dolphin/dolphinui.rc
    cp -rv ${dev_directory}pdq/.mozilla ${my_home}.mozilla

    echo "${bldgreen} ==> awesomewm-X, zsh, eggdrop-scripts, php, etc, bin, gh and conky-X... Installing...${txtrst}"
    mkdir -p ${my_home}.config/gh && cp /etc/xdg/gh/gh.conf ${my_home}.config/gh/gh.conf
    mv -v ${my_home}.config/nitrogen ${my_home}.config/nitrogen.bak
    cp -rv ${dev_directory}pdq/.config/nitrogen ${my_home}.config/nitrogen
    mv -v ${my_home}.config/conky ${my_home}.config/conky.original
    cp -rv ${dev_directory}conky-X ${my_home}.config/conky
    mv -v ${my_home}.config/awesome ${my_home}.config/awesome.original
    cp -rv ${dev_directory}awesomewm-X ${my_home}.config/awesome
    mkdir -p ${my_home}.config/awesome/Xdefaults/$USER
    mv -v ${my_home}.Xdefaults ${my_home}.config/awesome/Xdefaults/$USER/.Xdefaults
    ln -sfn ${my_home}.config/awesome/Xdefaults/default/.Xdefaults ${my_home}.Xdefaults
    ln -sfn ${my_home}.config/awesome/themes/dunzor ${my_home}.config/awesome/themes/current
    ln -sfn ${my_home}.config/awesome/icons/AwesomeLight.png ${my_home}.config/awesome/icons/menu_icon.png
    ln -sfn ${my_home}.config/awesome/themes/current/theme.lua ${my_home}.config/luakit/awesometheme.lua
    mkdir -p ${my_home}.cache/awesome
    touch ${my_home}.cache/awesome/stderr
    touch ${my_home}.cache/awesome/stdout
    mkdir -p ${my_home}.config/conky/arch/.cache
    cp -rv ${dev_directory}zsh/.zsh ${my_home}.zsh
    cp -v ${dev_directory}zsh/.zshrc ${my_home}.zshrc
    cp -v ${dev_directory}zsh/.zprofile ${my_home}.zprofile
    cp -rv ${dev_directory}php ${my_home}php
    mkdir -p ${my_home}Down
    mkdir -p ${my_home}Downloads/.torrents
    sed -i "s/pdq/$USER/g" ${my_home}.config/transmission-daemon/settings.json
    sed -i "s/pdq/$USER/g" ${my_home}.moc/config
    sed -i "s/pdq/$USER/g" ${my_home}.kde4/share/config/dolphinrc
    sed -i "s/pdq/$USER/g" ${my_home}.config/nitrogen/nitrogen.cfg
    sed -i "s/pdq/$USER/g" ${my_home}.config/nitrogen/bg-saved.cfg
    sudo cp -rv ${dev_directory}systemd/* /etc/systemd/system
    sudo sed -i "s/pdq/$USER/g" /etc/systemd/system/autologin@.service
    sudo sed -i "s/pdq/$USER/g" /etc/systemd/system/transmission.service
    sudo chmod -R 777 /run/transmission
    sudo chown -R $USER /run/transmission
    sudo mkdir -p /usr/share/tor/hidden_service1
    sudo mkdir -p /usr/share/tor/hidden_service2
    sudo mkdir -p /usr/share/tor/hidden_service3
    sudo mkdir -p /usr/share/tor/hidden_service4
    sudo chown -R tor:tor /usr/share/tor/hidden_service1
    sudo chown -R tor:tor /usr/share/tor/hidden_service2
    sudo chown -R tor:tor /usr/share/tor/hidden_service3
    sudo chown -R tor:tor /usr/share/tor/hidden_service4
    sudo systemctl enable dhcpcd@eth0.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable ntpd.service
    sudo systemctl enable tor.service
    sudo systemctl enable privoxy.service
    sudo systemctl enable preload.service
    sudo systemctl enable polipo.service
    sudo systemctl enable vnstat.sevice
    sudo systemctl enable cronie.service

    question="${bldgreen}Download Wallpapers (Y/N) [size: 260 MB]?${txtrst}\n"
    if ask_something; then
        mkdir -p ${my_home}Pictures
        cd ${my_home}Pictures
        wget https://dl.dropbox.com/u/9702684/wallpaper.tar.gz
        rm -v wallpaper.tar.gz
        cd
    fi

    echo "${bldgreen} ==> Installing Apache/MySQL/PHP/PHPMyAdmin/mpd/tor/privoxy configuration files${txtrst}"
    sudo mv -v /etc/tor/torrc /etc/tor/torrc.bak
    sudo cp -v ${dev_directory}etc/torrc /etc/tor/torrc
    sudo mkdir -p /etc/privoxy
    sudo sh -c "echo 'forward-socks5 / localhost:9050 .' >> /etc/privoxy/config"
    sudo mv -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
    sudo cp -v ${dev_directory}etc/httpd.conf /etc/httpd/conf/httpd.conf
    sudo cp -v ${dev_directory}etc/httpd-phpmyadmin.conf /etc/httpd/conf/extra/httpd-phpmyadmin.conf
    sudo mv -v /etc/php/php.ini /etc/php/php.ini.bak
    sudo cp -v ${dev_directory}etc/php.ini /etc/php/php.ini
    sudo systemctl daemon-reload
    sudo systemctl disable getty@tty1
    sudo systemctl enable autologin@tty1
    sudo systemctl start autologin@tty1

    sudo sh -c "echo '#
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

    # End of file' > /etc/hosts"

    sudo sh -c "echo 'NameVirtualHost *:80
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
    </VirtualHost>' > /etc/httpd/conf/extra/httpd-vhosts.conf"

    echo sh -c "sudo echo '#
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

    # End of file' > /etc/hosts"

    echo "Creating self-signed certificate (you can change key size and days of validity)"
        cd /etc/httpd/conf
        sudo openssl genrsa -des3 -out server.key 1024
        sudo openssl req -new -key server.key -out server.csr
        sudo cp -v server.key server.key.org
        sudo openssl rsa -in server.key.org -out server.key
        sudo openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

        sudo mkdir -p /srv/http/root/public_html
        sudo chmod g+xr-w /srv/http/root
        sudo chmod -R g+xr-w /srv/http/root/public_html

        sudo mkdir -p /srv/http/$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/$USER.c0m
        sudo chmod -R g+xr-w /srv/http/$USER.c0m/public_html

        sudo mkdir -p /srv/http/$USER.$HOSTNAME.c0m/public_html
        sudo chmod g+xr-w /srv/http/$USER.$HOSTNAME.c0m
        sudo chmod -R g+xr-w /srv/http/$USER.$HOSTNAME.c0m/public_html

        sudo mkdir -p /srv/http/phpmyadmin.$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/phpmyadmin.$USER.c0m
        sudo chmod -R g+xr-w /srv/http/phpmyadmin.$USER.c0m/public_html

        sudo mkdir -p /srv/http/torrent.$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/torrent.$USER.c0m
        sudo chmod -R g+xr-w /srv/http/torrent.$USER.c0m/public_html

        sudo mkdir -p /srv/http/admin.$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/admin.$USER.c0m
        sudo chmod -R g+xr-w /srv/http/admin.$USER.c0m/public_html

        sudo mkdir -p /srv/http/stats.$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/stats.$USER.c0m
        sudo chmod -R g+xr-w /srv/http/stats.$USER.c0m/public_html

        sudo mkdir -p /srv/http/mail.$USER.c0m/public_html
        sudo chmod g+xr-w /srv/http/mail.$USER.c0m
        sudo chmod -R g+xr-w /srv/http/mail.$USER.c0m/public_html

        sleep 2s
        echo "w00t!! You're just flying through this stuff you hacker you!! :p"
        sleep 1s
        echo "rah rah $USER rah rah $USER!!!"
        sleep 1s
        echo "Ok... let's continue on with this..."
        sudo systemctl start httpd
        sudo systemctl start mysqld
        sleep 1s
        echo "Ok... starting MySQL and setting a root password for MySQL...."
        rand=$RANDOM
        sudo mysqladmin -u root password $USER-$rand
        echo "${bldred}You're mysql root password is $USER-$rand Write this down before proceeding...${txtrst}
        "
        question="${bldgreen}Written it down (Y/N)?${txtrst}\n"
        if ask_something; then
            echo ":]"
        else
            echo ":O"
        fi
        echo "If you want to change/update the above root password (AT A LATER TIME), then you need to use the following command:
        $ mysqladmin -u root -p'$USER-$rand' password newpasswordhere

        For example, you can set the new password to 123456, enter:

        $ mysqladmin -u root -p'$USER-$rand' password '123456'"
        sleep 3s 
    sudo ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpmyadmin.$USER.c0m
    sudo ln -s /srv/http ${my_home}localhost
    sudo chown -R $USER /srv/http
    echo "Your LAMP setup is set to be started manually via the Awesome menu->Services-> LAMP On/Off"
    sleep 2s
    echo "If you want LAMP to start at boot, run these commands ay any time as root user:
systemctl enable httpd.service
systemctl enable mysqld.service
systemctl enable memcached.service"
    question="${bldgreen}Do you want this to be done now? (Y/N) [default=N]?${txtrst}\n"
    if ask_something; then
        sudo systemctl enable httpd.service
        sudo systemctl enable mysqld.service
        sudo systemctl enable memcached.service
    fi
    cd ${my_home}localhost
    pwd
    chsh -s $(which zsh)
    cd
    echo "${bldgreen} ==> Exiting install script...${txtrst}"
    echo "${bldgreen}If complete, type: sudo reboot (you may also want to search, chose and install a video driver now, ie:${txtrst}"
    echo "${bldgreen}pacaur intel [replacing 'intel' with your graphics card type])${txtrst}"
fi