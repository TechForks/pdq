#!/bin/sh
## reinstall from github backup! =)
## 03-22-2012 pdq
## 07-10-2012 pdq
## 11-04-2012 pdq
## 12-05-2012 pdq

## Instructions
## from within existing arch linux
        # sudo pacman -S arch-install-scripts

        # ### change sde to what's required (be careful to chose installation drive as will erase it!)
        # sudo mount /dev/sde1 /mnt
        # sudo mkdir /mnt/home
        # sudo mount /dev/sde2 /mnt/home
        # sudo pacstrap /mnt base base-devel sudo wget rxvt-unicode

        # ### become root
        # su -l
        # genfstab -U -p /mnt >> /mnt/etc/fstab
        # nano /mnt/etc/fstab

        # ### chroot into /mnt
        # arch-chroot /mnt
        # nano /etc/locale.gen 
        # locale-gen                 
        # ln -s /usr/share/zoneinfo/America/Winnipeg /etc/localtime
        # echo archusb > /etc/hostname
        # systemctl enable dhcpcd@eth0.service

        # ### add usb to HOOKS if needed
        # nano etc/mkinitcpio.conf
        # mkinitcpio -p linux

        # ### enable multilib if needed
        # nano /etc/pacman.conf 
        # passwd
        # adduser
        # pacman -S grub-bios
        # grub-install --target=i386-pc --recheck /dev/sde
        # cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
        # grub-mkconfig -o /boot/grub/grub.cfg

        # ### add YOURUSER to sudoers
        # EDITOR=nano visudo

        # ### become YOURUSER and change directory to your home
        # su YOURUSER
        # cd

        # wget http://is.gd/reinstaller -O installer.sh

        # ### run all options except final option
        # sh installer.sh

        # ### exit chroot
        # exit

        # umount /mnt/home
        # umount /mnt

        # ### done!

        # ### reboot into usb

        # ### run final option
        # sh installer.sh

        # ### reboot into usb
        # sudo reboot

my_home="$HOME/"
#my_home="/home/pdq/test/"
dev_directory="${my_home}github/"

## create pacman pkg dir and packer tmp dir
mkdir -p ${my_home}vital/pkg
mkdir -p ${my_home}vital/tmp
export TMPDIR=${my_home}vital/tmp

## color formatting
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset

mkdir -p ${dev_directory}
cd ${dev_directory}

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

grep -q "^flags.*\blm\b" /proc/cpuinfo && archtype="yes" || archtype="no"
if [ "$archtype" = "no" ]; then
    echo "Sorry this is for x86_64 only! =)"
    exit 1
fi

if [ $(id -u) -eq 0 ]; then
    echo "Do not run me as root! =)"
    exit 1
fi

if [ ! -f /usr/bin/git ]; then
    sudo pacman -S git
fi

if [ ! -f /usr/bin/hub ]; then
    sudo pacman -S hub
fi

if [ ! -f /usr/bin/packer ]; then
    echo "${bldblue} ==> Installing packer${txtrst}"
    wget https://aur.archlinux.org/packages/pa/packer/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman -U packer* && cd ${dev_directory} && sudo pacman -S hub
fi

if [ ! -d "${dev_directory}pdq" ]; then
    echo "${bldgreen} ==> Cloning initial repo to ${dev_directory}pdq/${txtrst}"
    hub clone idk/pdq
    hub clone idk/etc
    sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
    sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
    sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
fi

question="Install main packages (Y/N)?\n"
if ask_something; then
    sudo pacman -Syy
    sudo pacman -S --needed $(cat ${dev_directory}pdq/main.lst)
fi

question="Install AUR packages (Y/N)?\n"
if ask_something; then
    sudo pacman -Syy
    echo "${bldgreen} ==> Installing AUR packages (no confirm)${txtrst}"
    packer --noconfirm -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
fi

question="Install AUR packages (with confirm) (Y/N)?\n"
if ask_something; then
    sudo pacman -Syy
    echo "${bldgreen} ==> Installing AUR packages (with confirm)${txtrst}"
    packer -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
fi

question="Clone all repos (Y/N)?\n"
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

question="Install all repos (Y/N) [Cannot do in chroot]?\n"
if ask_something; then
    echo "${bldgreen} ==> Backing up mirrorlist and write/rank/sort new mirrorlist${txtrst}"
    sudo mv -v /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
    sudo cp -v ${dev_directory}etc/mirrorlist /etc/pacman.d/mirrorlist
    echo "${bldgreen} ==> Backing up and copying root configs${txtrst}"
    # sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
    # sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
    # sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
    sudo cp -v ${dev_directory}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf

    sudo pacman -Syy

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
    mkdir -p .moc
    cp -v ${dev_directory}pdq/moc.config ${my_home}.moc/config
    cp -v ${dev_directory}pdq/.excludes-usb ${my_home}.excludes-usb
    cp -v ${dev_directory}pdq/.excludes-crypt ${my_home}.excludes-crypt

    echo "${bldgreen} ==> awesomewm-X, zsh, eggdrop-scripts, php, etc, bin, gh and conky-X... Installing...${txtrst}"

    mkdir -p ${my_home}.config
    cd ${my_home}.config/

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
    nano ${my_home}.zprofile
    cp -rv ${dev_directory}php ${my_home}php
    sudo cp -rv ${dev_directory}systemd/* /etc/systemd/system
    sudo sed -i "s/pdq/$USER/g" /etc/systemd/system/autologin@.service

    sudo systemctl enable dhcpcd@eth0.service
    sudo systemctl enable NetworkManager.service
    sudo systemctl enable ntpd.service
    sudo systemctl enable tor.service
    sudo systemctl enable privoxy.service
    sudo systemctl enable preload.service
    sudo systemctl enable polipo.service
    sudo systemctl enable vnstat.sevice
    sudo systemctl enable cronie.service

    echo "${bldgreen} ==> Installing Apache/MySQL/PHP/PHPMyAdmin/mpd/tor/privoxy configuration files${txtrst}"
    sudo mv -v /etc/tor/torrc /etc/tor/torrc.bak
    sudo cp -v ${dev_directory}etc/torrc /etc/tor/torrc
    sudo mkdir -p /etc/privoxy
    sudo sh -c "echo 'forward-socks5 / localhost:9050 .' >> /etc/privoxy/config"
    sudo mv -v /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
    sudo cp -v ${dev_directory}etc/httpd.conf /etc/httpd/conf/httpd.conf
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
        sleep 5s
        echo "If you want to change/update the above root password (AT A LATER TIME), then you need to use the following command:
        $ mysqladmin -u root -p'$USER-$rand' password newpasswordhere

        For example, you can set the new password to 123456, enter:

        $ mysqladmin -u root -p'$USER-$rand' password '123456'"
        sleep 3s 
    sudo ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpmyadmin.$USER.c0m
    sudo ln -s /srv/http ${my_home}localhost
    cd ${my_home}localhost
    pwd
    chsh -s $(which zsh)
    cd
    echo "${bldgreen} ==> Exiting install script...${txtrst}"
    echo "${bldgreen}If complete, reboot!"
fi