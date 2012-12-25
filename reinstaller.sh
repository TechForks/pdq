#!/bin/sh
## pdqOS Installer for Arch Linux x86_64 =)
## 03-22-2012 pdq
## 12-25-2012 pdq

## Instructions

## from livecd/liveusb
# wget http://is.gd/reinstaller -O rs.sh
# sh rs.sh

## when it asks if install 1) phonon-gstreamer or 2) phonon-vlc
## chose 2
## when it asks if replace foo with bar chose y for everyone

upper_title="pdqOS Installer for Arch Linux x86_64"

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

## code be `ere! ##
grep -q "^flags.*\blm\b" /proc/cpuinfo && archtype="yes" || archtype="no"
if [ "$archtype" = "no" ]; then
    dialog --title "$upper_title" --msgbox "Sorry this is for x86_64 only!" 20 70
    exit 1
fi

## root script
if [ $(id -u) -eq 0 ]; then

    # styling
    clr="\Zb\Z0"

    # temporary files
    _TEMP=/tmp/answer$$
    mkdir -p /tmp/tmp 2>/dev/null
    TMP=/tmp/tmp 2>/dev/null

    # functions
    exiting_installer() {
        clear
        rm -f $_TEMP
        dialog --clear --title "$upper_title" --msgbox "exiting_installer... type: rs.sh to re-run" 10 30
        exit 0
    }

    exit_installer() {
        dialog --clear --title "$upper_title" --yesno "Exit Installer?" 10 40
        if [ $? = 0 ] ; then
            exiting_installer
        else
            installer_menu
        fi
    }

    installer_menu() {
        dialog \
            --colors --title "$upper_title" \
            --menu "\ZbSelect action: (Do them in order)" 20 60 10 \
            1 $clr"List linux partitions" \
            2 $clr"Partition editor (cfdisk)" \
            3 $clr"Format and mount filesystems" \
            4 $clr"Create internet connection" \
            5 $clr"Initial install" \
            6 $clr"Generate fstab" \
            7 $clr"Configure" \
            8 $clr"Unmount install partitions" \
            9 $clr"Finish and reboot. (Remove livecd after poweroff)" \
            10 $clr"Exit" 2>$_TEMP

        choice=$(cat $_TEMP)
        case $choice in
            1) list_partitions;;
            2) partition_editor;;
            3) make_filesystems;;
            4) make_internet;;
            5) initial_install;;
            6) generate_fstab;;
            7) chroot_configuration;;
            8) cleanup;;
            9) finishup;;
            10) exiting_installer;;
        esac
    }

    list_partitions() {
        partition_list=`blkid | grep -i 'TYPE="ext[234]"' | cut -d ' ' -f 1 | grep -i '^/dev/' | grep -v '/dev/loop' | sed "s/://g"`
        if [ "$partition_list" = "" ] ; then
            partition_list="It appears you have no linux partitions yet."
        fi

        dialog --clear --title "$upper_title" --msgbox "$partition_list \n\n Hit enter to return to menu" 10 30
    }

    partition_editor() {
        dialog --clear --title "$upper_title" --cancel-label "Cancel" --msgbox "pdq is not responsible for loss of data or anything else. When in doubt, cancel and read the code.\n\nIf you accept this, you can start cfdisk now!\n\nYou can return to the main menu at any time by hitting <ESC> key." 20 70
        
        if [ $? = 1 ] ; then
            exit_installer
        fi

        dialog --clear --title "$upper_title" --yesno "Create a / (primary, bootable* and recommended minimum 6GB in size) and a /home (primary and remaining size) partition.\n\n* Optionally create a /swap (primary and recommended twice the size of your onboard RAM) and /boot (primary, bootable and recommended minimum 1GB in size) partition.\n\nJust follow the menu, store your changes and quit cfdisk to go on!\n\nIMPORTANT: Read the instructions and the output of cfdisk carefully.\n\nProceed?" 20 70
        if [ $? = 0 ] ; then
            umount /mnt/* 2>/dev/null
            cfdisk
        fi
    }

    make_filesystems() {
        fdisk -l | grep Linux | sed -e '/swap/d' | cut -b 1-9 > $TMP/pout 2>/dev/null

        dialog --clear --title "ROOT PARTITION DETECTED" --exit-label OK --msgbox "Installer has detected\n\n `cat /tmp/tmp/pout` \n\n as your linux partition(s).\n\nIn the next box you can choose the linux filesystem for your root partition or choose the partition if you have more linux partitions!" 20 70
        if [ $? = 1 ] ; then
            exit_installer
        fi

        # choose root partition
        dialog --clear --title "CHOOSE ROOT PARTITION" --inputbox "Please choose your preferred root partition in this way:\n\n/dev/hdaX --- X = number of the partition, e. g. 1 for /dev/hda1!" 10 70 2> $TMP/pout

        dialog --clear --title "FORMAT ROOT PARTITION" --radiolist "Now you can choose the filesystem for your root partition.\n\next4 is the recommended filesystem." 20 70 30 \
        "1" "ext2" on \
        "2" "ext3" off \
        "3" "ext4" off \
        2> $TMP/part
        if [ $? = 1 ] ; then
            exit_installer
        fi

        pout=$(cat $TMP/pout)
        part=$(cat $TMP/part)
        fs_type=

        if [ "$part" == "2" ] ; then
            fs_type="ext3"
        elif [ "$part" == "3" ] ; then
            fs_type="ext4"
        else
            fs_type="ext2"
        fi

        mkfs -t $fs_type $pout
        mount $pout /mnt

        dialog --clear --title "ROOT PARTITION MOUNTED" --msgbox "Your $pout partition has been mounted at /mnt as $fs_type" 10 70

        # choose home partition
        dialog --clear --title "CHOOSE HOME PARTITION" --inputbox "Please choose your preferred home partition in this way:\n\n/dev/hdaX --- X = number of the partition, e. g. 2 for /dev/hda2!" 10 70 2> $TMP/plout

        dialog --clear --title "FORMAT HOME PARTITION" --radiolist "Now you can choose the filesystem for your home partition.\n\next4 is the recommended filesystem." 20 70 30 \
        "1" "ext2" on \
        "2" "ext3" off \
        "3" "ext4" off \
        2> $TMP/plart
        if [ $? = 1 ] ; then
            exit_installer
        fi

        plout=$(cat $TMP/plout)
        plart=$(cat $TMP/plart)
        fs_type=

        if [ "$plart" == "2" ] ; then
            fs_type="ext3"
        elif [ "$plart" == "3" ] ; then
            fs_type="ext4"
        else
            fs_type="ext2"
        fi

        mkdir -vp /mnt/home
        mkfs -t $fs_type $plout
        mount $plout /mnt/home

        dialog --clear --title "HOME PARTITION MOUNTED" --msgbox "Your $plout partition has been mounted at /mnt/home as $fs_type" 10 70
    

        dialog --clear --title "BOOT PARTITION" --defaultno --yesno "Create the boot filesystem?" 20 70
        if [ $? = 0 ] ; then
            # choose boot partition
            dialog --clear --title "CHOOSE BOOT PARTITION" --inputbox "Please choose your preferred boot partition in this way:\n\n/dev/hdaX --- X = number of the partition, e. g. 3 for /dev/hda3!" 10 70 2> $TMP/pbout
            
            dialog --clear --title "FORMAT BOOT PARTITION" --radiolist "Now you can choose the filesystem for your boot partition.\n\next4 is the recommended filesystem." 20 70 30 \
            "1" "ext2" on \
            "2" "ext3" off \
            "3" "ext4" off \
            2> $TMP/pbart
            if [ $? = 1 ] ; then
                exit_installer
            fi

            pbout=$(cat $TMP/pbout)
            pbart=$(cat $TMP/pbart)
            fs_type=

            if [ "$pbart" == "2" ] ; then
            fs_type="ext3"
            elif [ "$pbart" == "3" ] ; then
            fs_type="ext4"
            else
            fs_type="ext2"
            fi

            mkdir -vp /mnt/boot
            mkfs -t $fs_type $pbout
            mount $pbout /mnt/boot

            dialog --clear --title "BOOT PARTITION MOUNTED" --msgbox "Your $pbout partition has been mounted at /mnt/boot as $fs_type" 10 70
        fi

        dialog --clear --title "SWAP PARTITION" --defaultno --yesno "Create the swap filesystem?" 20 70
        if [ $? = 0 ] ; then
            # choose home partition
            dialog --clear --title "CHOOSE SWAP PARTITION" --inputbox "Please choose your preferred swap partition in this way:\n\n/dev/hdaX --- X = number of the partition, e. g. 4 for /dev/hda4!" 10 70 2> $TMP/psout
            psout=$(cat $TMP/psout)
            mkswap $psout
            swapon $psout
        fi
    }

    make_internet() {
        dialog --clear --title "$upper_title" --msgbox "Test/configure internet connection" 10 30
        
        if [ $? = 1 ] ; then
            exit_installer
        fi

        dialog --clear --title "$upper_title" --yesno "Do you have a wired connection?" 20 70
        if [ $? = 0 ] ; then
            dhcpcd eth0
            wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
            if [ ! -s /tmp/index.google ] ; then
                dialog --clear --title "$upper_title" --msgbox "It appears you have no internet connection, refer to for instructions on loading your required wireless kernel modules.\n\nhttps://wiki.archlinux.org/index.php/Wireless_Setup" 10 30
            else
                dialog --clear --title "$upper_title" --msgbox "It appears you have an internet connection, huzzah for small miracles. :p" 10 30
            fi
        else
            dialog --clear --title "" --radiolist "Choose your preferred wireless setup tool" 20 70 30 \
            "1" "wifi-menu" on \
            "2" "wpa_supplicant" off \
            2> $TMP/pwifi
            if [ $? = 1 ] ; then
                exit_installer
            fi

            pwifi=$(cat $TMP/pwifi)
            if [ "$pwifi" == "1" ] ; then
                wifi-menu
            else
                dialog --clear --title "$upper_title" --inputbox "Please enter your SSID" 10 70 2> $TMP/pssid
                pssid=$(cat $TMP/pssid)

                dialog --clear --title "$upper_title" --passwordbox "Please enter your wireless passphrase" 10 70 2> $TMP/ppassphrase
                ppassphrase=$(cat $TMP/ppassphrase)
                wpa_passphrase "$pssid" "$ppassphrase" >> /etc/wpa_supplicant.conf
                wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant.conf & >/dev/null
            fi

            dhcpcd wlan0
            wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
            if [ ! -s /tmp/index.google ] ; then
                dialog --clear --title "$upper_title" --msgbox "It appears you have no internet connection, refer to for instructions on loading your required wireless kernel modules.\n\nhttps://wiki.archlinux.org/index.php/Wireless_Setup" 20 30
            else
                dialog --clear --title "$upper_title" --msgbox "It appears you have an internet connection, huzzah for small miracles. :p" 10 30
            fi
        fi

        dialog --clear --title "$upper_title" --msgbox "Internet configuration complete.\n\n Hit enter to return to menu" 10 30
    }

    cleanup() {
        dialog --clear --title "$upper_title" --msgbox "Unmount /mnt/*" 10 30
        
        if [ $? = 1 ] ; then
            exit_installer
        fi
     
        umount /mnt/* 2>/dev/null

        dialog --clear --title "$upper_title" --msgbox "Unmounted /mnt/*.\n\nHit enter to return to menu" 10 30
    }

    initial_install() {
        dialog --clear --title "$upper_title" --msgbox "Install base base-devel sudo git hub rsync wget" 10 30
       
        if [ $? = 1 ] ; then
            exit_installer
        fi
       
        dialog --clear --title "$upper_title" --inputbox "Please enter any packages you would like added to the initial base system installation.\n\nSeperate multiple packages with a space.\n\nIf you do not wish to add any packages beyond the default:\nbase base-devel sudo git hub rsync wget\nleave input blank and continue." 10 70 2> $TMP/ppkgs
        ppkgs=$(cat $TMP/ppkgs)
        pacstrap /mnt base base-devel sudo git hub rsync wget $ppkgs
        
        dialog --clear --title "$upper_title" --msgbox "Installed base base-devel sudo git hub rsync wget $ppkgs to /mnt.\n\n Hit enter to return to menu" 10 30
    }

    chroot_configuration() {
        dialog --clear --title "$upper_title" --msgbox "Chroot into mounted filesystem" 10 30
        
        if [ $? = 1 ] ; then
            exit_installer
        fi
       
        wget https://raw.github.com/idk/pdq/master/chroot-rs.sh -O chroot-rs.sh
        chmod +x chroot-rs.sh
        mv chroot-rs.sh /mnt/chroot-rs.sh
        arch-chroot /mnt /bin/sh -c "./chroot-rs.sh"
        dialog --clear --title "$upper_title" --msgbox "Hit enter to return to menu" 10 30
    }

    generate_fstab() {
        dialog --clear --title "$upper_title" --msgbox "Generate fstab" 10 30
       
        if [ $? = 1 ] ; then
            exit_installer
        fi
       
        genfstab -U -p /mnt >> /mnt/etc/fstab
        dialog --clear --title "$upper_title" --yesno "Do you wish to view/edit this file?" 10 30
       
        if [ $? = 0 ] ; then
            nano /mnt/etc/fstab
        fi
        
        dialog --clear --title "$upper_title" --msgbox "Hit enter to return to menu" 10 30
    }

    finishup() {
        dialog --clear --title "$upper_title" --msgbox "Finish install and reboot" 10 30

        if [ $? = 1 ] ; then
            exit_installer
        fi
        
        dialog --clear --title "$upper_title" --msgbox "After reboot, to complete install:\n\nlogin as your created user and run: sh rs.sh" 10 30
        echo "Now rebooting..."
        reboot
    }

    # utility execution
    while true
    do
        installer_menu
    echo "end of root function"
    done
else
    ## user script

    if [ $(id -u) -eq 0 ]; then
        dialog --title "$upper_title" --msgbox "Do not run me as root!" 10 30
        exit 1
    fi

    my_home="$HOME/"
    #my_home="/home/pdq/test/"
    dev_directory="${my_home}github/"

    ## create config, dev directory, pacman pkg dir and pacaur tmp dir
    mkdir -p ${my_home}.config
    mkdir -p ${dev_directory}
    mkdir -p ${my_home}vital/pkg
    mkdir -p ${my_home}vital/tmp
    export TMPDIR=${my_home}vital/tmp

    sudo locale-gen
    sudo dhcpcd eth0
    sudo systemctl enable dhcpcd@eth0.service

    if [ ! -f /usr/bin/hub ]; then
        sudo pacman -S --noconfirm --needed hub
    fi

    if [ ! -f /usr/bin/pacaur ]; then
        #dialog --title "$upper_title" --msgbox "Installing pacaur" 20 70
        sudo pacman -S --noconfirm --needed yajl
        sudo pacman -S --noconfirm --needed jshon
        sudo pacman -S --noconfirm --needed jansson
        wget https://aur.archlinux.org/packages/pa/packer/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman -U --noconfirm --needed packer* && cd
        packer -S --noconfirm pacaur
    fi

    if [ ! -f /usr/bin/pacman-color ]; then
        #dialog --title "$upper_title" --msgbox "Installing pacman-color" 20 70
        packer -S --noconfirm pacman-color
    fi

    if [ ! -f /usr/bin/powerpill ]; then
        #dialog --title "$upper_title" --msgbox "Installing powerpill" 20 70
        sudo pacman -S --noconfirm --needed python3
        packer -S --noconfirm powerpill
    fi

    sleep 3s
    if [ ! -d "${dev_directory}pdq" ]; then
        dialog --title "$upper_title" --msgbox "Cloning initial repo to ${dev_directory}pdq/" 10 30
        cd ${dev_directory}
        hub clone idk/pdq
        hub clone idk/etc
        cd
        sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
        sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
        sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
        sudo mv -v /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
        sudo cp -v ${dev_directory}etc/mirrorlist /etc/pacman.d/mirrorlist
        sudo mv -v /etc/powerpill/powerpill.json /etc/powerpill/powerpill.json.bak
        sudo cp -v ${dev_directory}etc/powerpill.json /etc/powerpill/powerpill.json
        cp -rv ${dev_directory}pdq/.config/pacaur ${my_home}.config/pacaur
        sudo pacman-color -Syy
    fi

    if [ ! -f /usr/bin/rsync ]; then
        sudo pacman-color -S --noconfirm rsync
    fi

    dialog --clear --title "$upper_title" --yesno "Is this a VirtualBox install?" 10 30
    if [ $? = 0 ] ; then
        sudo powerpill -S --noconfirm --needed virtualbox-guest-utils
        sudo sh -c "echo 'vboxguest
vboxsf
vboxvideo' > /etc/modules-load.d/virtualbox.conf"
    fi

    dialog --clear --title "$upper_title" --yesno "Install main packages?" 10 30
    if [ $? = 0 ] ; then
        dialog --title "$upper_title" --msgbox "When it askes if install 1) phonon-gstreamer or 2) phonon-vlc\nchose 2\n\nWhen it asks if replace foo with bar chose y for everyone" 20 70
        sudo powerpill -Syy
        sudo pacman-color -S --needed $(cat ${dev_directory}pdq/main.lst)
    fi

    dialog --clear --title "$upper_title" --yesno "Install AUR packages?" 10 30
    if [ $? = 0 ] ; then
        sudo powerpill -Syy
        dialog --title "$upper_title" --msgbox "Installing AUR packages (no confirm)\n[This may take a while]" 10 40
        pacaur --noconfirm -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
    fi

    dialog --clear --title "$upper_title" --yesno "Install AUR packages (with confirm)\n[Use this option if the prior one failed, otherwise skip it]" 10 40
    if [ $? = 0 ] ; then
        sudo powerpill -Syy
        dialog --title "$upper_title" --msgbox "Installing AUR packages (with confirm)" 10 30
        pacaur -S $(cat ${dev_directory}pdq/local.lst | grep -vx "$(pacman -Qqm)")
    fi

    dialog --clear --title "$upper_title" --yesno "Clone all repos?" 10 30
    if [ $? = 0 ] ; then
        cd ${dev_directory}
        hub clone idk/awesomewm-X
        hub clone idk/conky-X
        hub clone idk/zsh
        hub clone idk/bin
        hub clone idk/php
        hub clone idk/systemd
        hub clone idk/eggdrop-scripts
        hub clone idk/gh
        cd
    fi

    dialog --clear --title "$upper_title" --yesno "Install all repos [Cannot do in chroot]?" 10 30
    if [ $? = 0 ] ; then
        wget https://raw.github.com/idk/pdq-utils/master/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman --noconfirm -U pdq-utils* && cd
        wget https://raw.github.com/idk/gh/master/PKGBUILD -O /tmp/PKGBUILD && cd /tmp && makepkg -sf PKGBUILD && sudo pacman --noconfirm -U gh* && cd
        
        dialog --clear --title "$upper_title" --msgbox "Backing up and copying root configs" 10 30
        # sudo mv -v /etc/pacman.conf /etc/pacman.conf.bak
        # sudo cp -v ${dev_directory}etc/pacman.conf /etc/pacman.conf
        # sudo sed -i "s/pdq/$USER/g" /etc/pacman.conf
        sudo cp -v ${dev_directory}etc/custom.conf /etc/X11/xorg.conf.d/custom.conf

        dialog --title "$upper_title" --msgbox "Backing up and copying user configs" 10 30
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

        dialog --clear --title "$upper_title" --msgbox "awesomewm-X, zsh, eggdrop-scripts, php, etc, bin, gh and conky-X... Installing..." 10 40
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

        dialog --clear --title "$upper_title" --yesno "Download Wallpapers [size: 260 MB]?" 10 30
        if [ $? = 0 ] ; then
            mkdir -p ${my_home}Pictures
            cd ${my_home}Pictures
            wget https://dl.dropbox.com/u/9702684/wallpaper.tar.gz
            rm -v wallpaper.tar.gz
            cd
        fi

        dialog --clear --title "$upper_title" --msgbox "Installing Apache/MySQL/PHP/PHPMyAdmin/mpd/tor/privoxy configuration files" 10 30
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
        dialog --clear --title "$upper_title" --yesno "Enable automatic login to virtual console?" 10 30
        if [ $? = 0 ] ; then
            sudo systemctl disable getty@tty1
            sudo systemctl enable autologin@tty1
            sudo systemctl start autologin@tty1
        fi
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

        dialog --clear --title "$upper_title" --msgbox "Creating self-signed certificate" 10 30
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

        dialog --clear --title "$upper_title" --msgbox "w00t!! You're just flying through this stuff you hacker you!! :p" 10 30
        dialog --clear --title "$upper_title" --msgbox "rah rah $USER rah rah $USER!!!" 10 30
        sudo systemctl start httpd
        sudo systemctl start mysqld
        sleep 1s
        dialog --clear --title "$upper_title" --msgbox "Ok... starting MySQL and setting a root password for MySQL...." 10 30
        rand=$RANDOM
        sudo mysqladmin -u root password $USER-$rand
        dialog --title "$upper_title" --msgbox "You're mysql root password is $USER-$rand\nWrite this down before proceeding..." 10 30
        dialog --title "$upper_title" --msgbox "If you want to change/update the above root password (AT A LATER TIME), then you need to use the following command:\n$ mysqladmin -u root -p'$USER-$rand' password newpasswordhere\nFor example, you can set the new password to 123456, enter:\n$ mysqladmin -u root -p'$USER-$rand' password '123456'" 20 40
        sudo ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpmyadmin.$USER.c0m
        sudo ln -s /srv/http ${my_home}localhost
        sudo chown -R $USER /srv/http

        dialog --clear --title "$upper_title" --msgbox "Your LAMP setup is set to be started manually via the Awesome menu->Services-> LAMP On/Off" 10 30

        dialog --clear --title "$upper_title" --msgbox "If you want LAMP to start at boot, run these commands ay any time as root user:\n\nsystemctl enable httpd.service\nsystemctl enable mysqld.service\nsystemctl enable memcached.service" 10 40
        
        dialog --clear --title "$upper_title" --yesno "Do you want this to be done now? [default=No]?" 10 30
        if [ $? = 0 ] ; then
            sudo systemctl enable httpd.service
            sudo systemctl enable mysqld.service
            sudo systemctl enable memcached.service
        fi
        cd ${my_home}localhost
        pwd
        chsh -s $(which zsh)
        cd
        dialog --clear --title "$upper_title" --msgbox "exiting_installer install script...\nIf complete, type: sudo reboot (you may also want to search, chose and install a video driver now.\n\n pacaur intel [replacing 'intel' with your graphics card type]" 20 40
    fi
fi

#DEBUG
echo "end of script"
sleep 2s