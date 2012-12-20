#!/bin/sh
## chroot-rs.sh sub-script for chroot from github backup! =)
## 12-15-2012 pdq

## color formatting
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # Red Colored
bldgreen=${txtbld}$(tput setaf 2) # Green Colored
bldblue=${txtbld}$(tput setaf 6) # Blue Colored
bldyellow=${txtbld}$(tput setaf 3) # Yellow Colored
txtrst=$(tput sgr0)             # Reset

MOUNT_POINT="/mnt"
is_chroot=$(ls -di /)

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

if [ "$is_chroot" = "2 /" ] ; then
    echo "Hrm, something went fubar! pdq!?!?!?!?!?"
else
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

        chroot_menu() {
            dialog \
                --colors --title "pdqOS Installer (chroot) for Arch Linux x86_64" \
                --menu "\ZbSelect action:" 20 60 8 \
                1 $clr"Generate hostname" \
                2 $clr"Generate timezone" \
                3 $clr"Generate locale" \
                4 $clr"Set root password" \
                5 $clr"Create default user and add to sudoers" \
                6 $clr"Install Grub" \
                7 $clr"Configure Grub" \
                8 $clr"Exit chroot" 2>$_TEMP

            choice=$(cat $_TEMP)
            case $choice in
                1) gen_hostname;;
                2) gen_tz;;
                3) gen_locale;;
                4) set_root_pass;;
                5) add_user;;
                6) install_grub;;
                7) conf_grub;;
                8) exiting;;
            esac
            
            initialize_start
        }

        gen_hostname() {
            dialog --title "pdqOS" --clear "$@" \
                --inputbox "Enter desired hostname: (ie: pdqos)" 16 51 2>$_TEMP

            retval=$?
            HOSTNAME_TEXT=""

            case $retval in
                $DIALOG_OK)
                    HOSTNAME_TEXT=$(cat $_TEMP);;
                $DIALOG_CANCEL)
                    return;;
                $DIALOG_HELP)
                    echo "Help pressed.";;
                $DIALOG_EXTRA)
                    echo "Extra button pressed.";;
                $DIALOG_ITEM_HELP)
                    echo "Item-help button pressed.";;
                $DIALOG_ESC)
                    return;;
            esac

            echo $HOSTNAME_TEXT > /etc/hostname

            chroot_menu
        }

        gen_tz() {
            ln -s /usr/share/zoneinfo/America/Winnipeg /etc/localtime

            chroot_menu
        }

        gen_locale() {
            nano /etc/locale.gen
            echo LANG=en_US.UTF-8 > /etc/locale.conf
            export LANG=en_US.UTF-8
            locale-gen

            chroot_menu
        }

        set_root_pass() {
            passwd
            chroot_menu
        }

        add_user() {
            adduser
            EDITOR=nano visudo
            chroot_menu
        }

        install_grub() {
            pacman -S grub-bios
            grub-install --target=i386-pc --recheck /dev/sda
            chroot_menu
        }

        conf_grub() {
            cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
            grub-mkconfig -o /boot/grub/grub.cfg
            chroot_menu
        }

        # utility execution
        while true
        do
            chroot_menu
        done
    fi
fi