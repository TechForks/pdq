#!/bin/sh
## chroot-rs.sh sub-script for chroot from github backup! =)
## 12-15-2012 pdq

#exit 1

upper_title="[ pdqOS environment configuration ] (chroot)"

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}

if [ $(id -u) -eq 0 ]; then

    clr="\Zb\Z0"

    # temporary files
    _TEMP=/tmp/chanswer$$
    mkdir -p /tmp/tmp 2>/dev/null
    TMP=/tmp/tmp 2>/dev/null
    echo "unset" > $TMP/rootpasswd

    # sanity default checks
    systemctl enable dhcpcd@eth0.service
    pacman -Syy

    # functions
    exiting() {
        clear
        rm -f $_TEMP
        exit
    }

    gen_tz() {
        echo
    }

    gen_hostname() {
        echo
        }

    gen_locale() {
        echo
           }

    set_root_pass() {
        dialog --clear --backtitle "$upper_title" --title "[ ROOT PASSWD ]" --msgbox "Set root password" 20 70
        
        if [ $? = 1 ] ; then
            chroot_menu
        fi

        passwd
        echo "set" > $TMP/rootpasswd
        dialog --clear --backtitle "$upper_title" --title "[ ROOT PASSWD ]" --msgbox "root password set!" 20 70
    }

    add_user() {
        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --msgbox "Create user and add to sudoers" 20 70
        
        if [ $? = 1 ] ; then
            chroot_menu
        fi

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --inputbox "Please choose your username:\n\n" 10 70 2> $TMP/puser
        puser=$(cat $TMP/puser)
        adduser $psuer

        sudo cp /etc/sudoers /etc/sudoers.bak

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --yesno "Require no password for sudo? [suggested: Yes]" 10 30
        if [ $? = 1 ] ; then
            sudo sh -c "echo '$puser ALL=(ALL) NOPASSWD: ALL' >>  /etc/sudoers"
            npasswd="no password required"
        else
            sudo sh -c "echo '$puser ALL=(ALL) ALL' >>  /etc/sudoers"
            npasswd="password required"
        fi

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --msgbox "Added the user $puser with $npsswd for sudo." 20 70
    }

    install_grub() {
        dialog --clear --backtitle "$upper_title" --title "[ GRUB ]" --msgbox "Install Grub" 20 70
        if [ $? = 1 ] ; then
            chroot_menu
        fi

        ## TODO
        pacman -S --needed grub-bios

        # choose root partition
        dialog --clear --backtitle "$upper_title" --title "[ GRUB ]" --inputbox "Please choose the disk to install grub to.\n\n This should be the same drive your root partition is on:\n\nUsually /dev/sda. Be careful!" 10 70 2> $TMP/bout

        bout=$(cat $TMP/bout)
       
        dialog --clear --backtitle "$upper_title" --title "[ GRUB ]" --yesno "Is this correct?\n\n grub-install --target=i386-pc --recheck $bout" 10 30
        if [ $? = 1 ] ; then
            grub-install --target=i386-pc --recheck $bout
            dialog --clear --backtitle "$upper_title" --title "[ GRUB ]" --msgbox "Grub installed" 20 70

        else
            dialog --clear --backtitle "$upper_title" --title "[ GRUB ]" --msgbox "Grub not installed..." 20 70
        fi
    }

    conf_grub() {
        dialog --clear --backtitle "$upper_title" --title "[ GRUB CONFIGURE ]" --msgbox "Configure Grub" 20 70
        if [ $? = 1 ] ; then
            chroot_menu
        fi

        ## TODO
        cp -v /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
        grub-mkconfig -o /boot/grub/grub.cfg
        dialog --clear --backtitle "$upper_title" --title "[ GRUB CONFIGURE ]" --msgbox "Grub configured" 20 70
    }

    conf_view() {

        echo "HOSTNAME: $(cat /etc/hostname)"
        echo "TIMEZONE: $(readlink /etc/localtime)"
        echo "LOCALE: $(cat /etc/locale.conf)"
        echo "ROOT PASSWORD: $(cat $TMP/rootpasswd)"
        echo "USER: $(cat $TMP/puser)"
        echo "GRUB: installed as: --target=i386-pc --recheck $(cat $TMP/bout)"
        dialog --clear --backtitle "$upper_title" --title "[ VIEW CONFIGURATION ]" --msgbox "Return" 20 70
    }

    chroot_menu() {
        echo "make it so"
        dialog \
            --colors --backtitle "$upper_title" --title "pdqOS Installer (chroot) for Arch Linux x86_64" \
            --menu "\ZbSelect action:" 20 60 9 \
            1 $clr"Generate hostname" \
            2 $clr"Generate timezone" \
            3 $clr"Generate locale" \
            4 $clr"Set root password" \
            5 $clr"Create default user and add to sudoers" \
            6 $clr"Install Grub" \
            7 $clr"Configure Grub" \
            8 $clr"View/confirm generated data" \
            9 $clr"Exit chroot" 2>$_TEMP

        choice=$(cat $_TEMP)
        case $choice in
            1) gen_hostname;;
            2) gen_tz;;
            3) gen_locale;;
            4) set_root_pass;;
            5) add_user;;
            6) install_grub;;
            7) conf_grub;;
            8) conf_view;;
            9) exiting;;
        esac
    }

    # utility execution
    while true
    do
        chroot_menu
        echo "end of chroot function"
    done
fi