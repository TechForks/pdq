#!/bin/sh
## chroot-rs.sh sub-script for chroot from github backup! =)
## 12-25-2012 pdq

upper_title="[ pdqOS environment configuration ] (chroot)"

## only allow root to run script
if [ $(id -u) -eq 0 ]; then

    ## sanity default checks
    wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
    if [ ! -s /tmp/index.google ] ; then
        systemctl enable dhcpcd@eth0.service
    fi

    wget -q --tries=10 --timeout=5 http://www.google.com -O /tmp/index.google &> /dev/null
    if [ ! -s /tmp/index.google ] ; then
        echo "It appears you have no internet connectivity.\n\nRead: https://wiki.archlinux.org/index.php/Configuring_network"
        echo "This script will exit in 1 minute... or press ctrl-c to exit now."
        sleep 60s
        exit 0
    fi

    ## styling
    clr=""

    ## temporary files
    _TEMP=/tmp/chanswer$$
    mkdir -p /tmp/tmp 2>/dev/null
    TMP=/tmp/tmp 2>/dev/null
    echo "unset" > $TMP/rootpasswd

    pacman -Syy
    pacman -S --noconfirm --needed dialog

    ## functions
    exiting() {
        clear
        rm -f $_TEMP
        dialog --clear --backtitle "$upper_title" --title "[ Return to Installer ]" --msgbox "Proceed." 10 30
        exit 0
        exit 0
    }

    gen_tz() {
        dialog --clear --backtitle "$upper_title" --title "[ TIMEZONE ]" --msgbox "Generate timezone/localtime" 10 40
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        local tz_list tz
        for tz in $(grep -v "#" /usr/share/zoneinfo/zone.tab | awk '{print $3}') ; do
            tz_list+="${tz} - "
        done

        GEN_TIMEZONE=$(dialog --stdout --backtitle "${upper_title}" --title '[ TIMEZONE ]' --cancel-label "Go Back" \
           --default-item "${GEN_TIMEZONE}" --menu "Choose timezone or <Go Back> to return" 16 40 23 ${tz_list} "null" "-" || echo "${GEN_TIMEZONE}")

        if [ "$GEN_TIMEZONE" = "" ] ; then
            chroot_menu
            return 0
        fi

        if [ -f "/usr/share/zoneinfo/$GEN_TIMEZONE" ] ; then
            ln -s /usr/share/zoneinfo/$GEN_TIMEZONE /etc/localtime
            dialog --clear --backtitle "$upper_title" --title "[ TIMEZONE ]" --msgbox "Set timezone to $GEN_TIMEZONE" 10 30
        else
            dialog --clear --backtitle "$upper_title" --title "[ TIMEZONE ]" --msgbox "Failed to set timezone...timezone does not exist?" 10 30
        fi
    }

    gen_hostname() {
        dialog --clear --backtitle "$upper_title" --title "[ HOSTNAME ]" --msgbox "Generate hostname" 10 30
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        GEN_HOSTNAME=$(dialog --stdout --backtitle "${upper_title}" --title '[ HOSTNAME ]' --cancel-label "Go Back" \
           --inputbox "Enter desired hostname or <Go Back> to return" 9 40 "${GEN_HOSTNAME}" || echo "${GEN_HOSTNAME}")
      
        if [ "$GEN_HOSTNAME" = "" ] ; then
            chroot_menu
            return 0
        fi

        echo $GEN_HOSTNAME > /etc/hostname
        dialog --clear --backtitle "$upper_title" --title "[ HOSTNAME ]" --msgbox "Set hostname to $GEN_HOSTNAME" 10 30
    }

    gen_locale() {
        dialog --clear --backtitle "$upper_title" --title "[ LOCALES ]" --msgbox "Generate locale" 10 30
        
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        GEN_LANG=$(dialog --stdout --backtitle "${upper_title}" --title '[ LOCALES ]' --cancel-label "Go Back" --default-item "${GEN_LANG}" \
           --menu "Choose a locale or <Go Back> to return" 16 40 23 \
            en_US.UTF-8 - \
            aa_DJ.UTF-8 - \
            af_ZA.UTF-8 - \
            an_ES.UTF-8 - \
            ar_AE.UTF-8 - \
            ar_BH.UTF-8 - \
            ar_DZ.UTF-8 - \
            ar_EG.UTF-8 - \
            ar_IQ.UTF-8 - \
            ar_JO.UTF-8 - \
            ar_KW.UTF-8 - \
            ar_LB.UTF-8 - \
            ar_LY.UTF-8 - \
            ar_MA.UTF-8 - \
            ar_OM.UTF-8 - \
            ar_QA.UTF-8 - \
            ar_SA.UTF-8 - \
            ar_SD.UTF-8 - \
            ar_SY.UTF-8 - \
            ar_TN.UTF-8 - \
            ar_YE.UTF-8 - \
            ast_ES.UTF-8 - \
            be_BY.UTF-8 - \
            bg_BG.UTF-8 - \
            br_FR.UTF-8 - \
            bs_BA.UTF-8 - \
            ca_AD.UTF-8 - \
            ca_ES.UTF-8 - \
            ca_FR.UTF-8 - \
            ca_IT.UTF-8 - \
            cs_CZ.UTF-8 - \
            cy_GB.UTF-8 - \
            da_DK.UTF-8 - \
            de_AT.UTF-8 - \
            de_BE.UTF-8 - \
            de_CH.UTF-8 - \
            de_DE.UTF-8 - \
            de_LU.UTF-8 - \
            el_GR.UTF-8 - \
            el_CY.UTF-8 - \
            en_AU.UTF-8 - \
            en_BW.UTF-8 - \
            en_CA.UTF-8 - \
            en_DK.UTF-8 - \
            en_GB.UTF-8 - \
            en_HK.UTF-8 - \
            en_IE.UTF-8 - \
            en_NZ.UTF-8 - \
            en_PH.UTF-8 - \
            en_SG.UTF-8 - \
            en_US.UTF-8 - \
            en_ZA.UTF-8 - \
            en_ZW.UTF-8 - \
            es_AR.UTF-8 - \
            es_BO.UTF-8 - \
            es_CL.UTF-8 - \
            es_CO.UTF-8 - \
            es_CR.UTF-8 - \
            es_DO.UTF-8 - \
            es_EC.UTF-8 - \
            es_ES.UTF-8 - \
            es_GT.UTF-8 - \
            es_HN.UTF-8 - \
            es_MX.UTF-8 - \
            es_NI.UTF-8 - \
            es_PA.UTF-8 - \
            es_PE.UTF-8 - \
            es_PR.UTF-8 - \
            es_PY.UTF-8 - \
            es_SV.UTF-8 - \
            es_US.UTF-8 - \
            es_UY.UTF-8 - \
            es_VE.UTF-8 - \
            et_EE.UTF-8 - \
            et_EE.ISO-8859-15 - \
            eu_ES.UTF-8 - \
            fi_FI.UTF-8 - \
            fo_FO.UTF-8 - \
            fr_BE.UTF-8 - \
            fr_CA.UTF-8 - \
            fr_CH.UTF-8 - \
            fr_FR.UTF-8 - \
            fr_LU.UTF-8 - \
            ga_IE.UTF-8 - \
            gd_GB.UTF-8 - \
            gl_ES.UTF-8 - \
            gv_GB.UTF-8 - \
            he_IL.UTF-8 - \
            hr_HR.UTF-8 - \
            hsb_DE.UTF-8 - \
            hu_HU.UTF-8 - \
            hy_AM.ARMSCII-8 - \
            id_ID.UTF-8 - \
            is_IS.UTF-8 - \
            it_CH.UTF-8 - \
            it_IT.UTF-8 - \
            iw_IL.UTF-8 - \
            ja_JP.EUC-JP - \
            ja_JP.UTF-8 - \
            ka_GE.UTF-8 - \
            kk_KZ.UTF-8 - \
            kl_GL.UTF-8 - \
            ko_KR.EUC-KR - \
            ko_KR.UTF-8 - \
            ku_TR.UTF-8 - \
            kw_GB.UTF-8 - \
            lg_UG.UTF-8 - \
            lt_LT.UTF-8 - \
            lv_LV.UTF-8 - \
            mg_MG.UTF-8 - \
            mi_NZ.UTF-8 - \
            mk_MK.UTF-8 - \
            ms_MY.UTF-8 - \
            mt_MT.UTF-8 - \
            nb_NO.UTF-8 - \
            nl_BE.UTF-8 - \
            nl_NL.UTF-8 - \
            nn_NO.UTF-8 - \
            oc_FR.UTF-8 - \
            om_KE.UTF-8 - \
            pl_PL.UTF-8 - \
            pt_BR.UTF-8 - \
            pt_PT.UTF-8 - \
            ro_RO.UTF-8 - \
            ru_RU.KOI8-R - \
            ru_RU.UTF-8 - \
            ru_UA.UTF-8 - \
            sk_SK.UTF-8 - \
            sl_SI.UTF-8 - \
            so_DJ.UTF-8 - \
            so_KE.UTF-8 - \
            so_SO.UTF-8 - \
            sq_AL.UTF-8 - \
            st_ZA.UTF-8 - \
            sv_FI.UTF-8 - \
            sv_SE.UTF-8 - \
            tg_TJ.UTF-8 - \
            th_TH.UTF-8 - \
            tl_PH.UTF-8 - \
            tr_CY.UTF-8 - \
            tr_TR.UTF-8 - \
            uk_UA.UTF-8 - \
            vi_VN.TCVN - \
            wa_BE.UTF-8 - \
            xh_ZA.UTF-8 - \
            yi_US.UTF-8 - \
            zh_CN.GB18030 - \
            zh_CN.GBK - \
            zh_CN.UTF-8 - \
            zh_HK.UTF-8 - \
            zh_SG.UTF-8 - \
            zh_SG.GBK - \
            zh_TW.EUC-TW - \
            zh_TW.UTF-8 - \
            zu_ZA.UTF-8 - "null" "-" || echo "${GEN_LANG}")
    
        if [ "$GEN_LANG" = "" ] ; then
            chroot_menu
            return 0
        fi

        echo "${GEN_LANG} ${GEN_LANG##*.}" > "/etc/locale.gen"
        echo "LANG=${GEN_LANG}" > "/etc/locale.conf"
        export "LANG=${GEN_LANG}"
        locale-gen 1>/dev/null || echo "Unable to setup the locales to" "${GEN_LANG}"
        dialog --clear --backtitle "$upper_title" --title "[ LOCALES ]" --msgbox "Set locale to ${GEN_LANG}" 10 30
    }

    set_root_pass() {
        dialog --clear --backtitle "$upper_title" --title "[ ROOT PASSWD ]" --msgbox "Set root password" 10 30
        
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        passwd
        echo "set" > $TMP/rootpasswd
        dialog --clear --backtitle "$upper_title" --title "[ ROOT PASSWD ]" --msgbox "root password set!" 10 30
    }

    add_user() {
        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --msgbox "Create user and add to sudoers" 10 30
        
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --inputbox "Please choose your username:\n\n" 10 70 2> $TMP/puser
        puser=$(cat $TMP/puser)

        useradd -m -g users -s /bin/zsh $puser
        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --msgbox "Next step is to add password for $puser" 10 30
        passwd $puser
        sudo cp /etc/sudoers /etc/sudoers.bak

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --yesno "Require no password for sudo? [suggested: Yes]" 10 30
        if [ $? = 0 ] ; then
            sudo sh -c "echo '$puser ALL=(ALL) NOPASSWD: ALL' >>  /etc/sudoers"
            npasswd="no password required"
        else
            sudo sh -c "echo '$puser ALL=(ALL) ALL' >>  /etc/sudoers"
            npasswd="password required"
        fi

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --defaultno --yesno "Confirm/view sudoers?" 10 30
        if [ $? = 0 ] ; then
            EDITOR=nano visudo
        fi

        ## copy this script to user home directory
        if [ ! -f /home/$puser/rs.sh ]; then
            wget http://is.gd/pdqos -O /home/$puser/rs.sh
            chown -R $puser /home/$puser/rs.sh
        fi

        dialog --clear --backtitle "$upper_title" --title "[ CREATE USER ]" --msgbox "Added the user $puser with $npsswd for sudo." 10 30
    }

    install_bootloader() {
        dialog --clear --backtitle "$upper_title" --title "[ BOOTLOADER ]" --msgbox "Install Bootloader" 10 30
        if [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi
        
        dialog --clear --backtitle "$upper_title" --title "[ BOOTLOADER ]" --radiolist "Select bootloader" 20 70 30 \
        "1" "grub 2" on \
        "2" "syslinux" off \
        2> $TMP/pbootloader
        if [ $? = 1 ] || [ $? = 255 ] ; then
            chroot_menu
            return 0
        fi

        pbootloader=$(cat $TMP/pbootloader)
        if [ "$pbootloader" == "1" ] ; then
            dialog --clear --backtitle "$upper_title" --title "[ GRUB 2]" --radiolist "Select grub type" 20 70 30 \
            "1" "grub-bios" on \
            "2" "grub-efi" off \
            2> $TMP/pgrub
            if [ $? = 1 ] || [ $? = 255 ] ; then
                chroot_menu
                return 0
            fi

            pgrub=$(cat $TMP/pgrub)
            if [ "$pgrub" == "1" ] ; then
                pacman -S --noconfirm --needed grub-bios
            else
                pacman -S --noconfirm --needed grub-efi-x86_64
            fi

            # choose boot/root drive
            dialog --clear --backtitle "$upper_title" --title "[ GRUB 2 ]" --inputbox "Please choose the disk to install grub to.\n\n This should be the same drive your boot or root partition is on:\n\nUsually /dev/sda. Be careful!" 10 70 2> $TMP/bout
            if [ $? = 1 ] || [ $? = 255 ] ; then
                chroot_menu
                return 0
            fi

            bout=$(cat $TMP/bout)
            bootmsg="grub-install --target=i386-pc --recheck $bout"
           
            dialog --clear --backtitle "$upper_title" --title "[ GRUB 2 ]" --yesno "Is this correct?\n\n grub-install --target=i386-pc --recheck $bout" 10 30
            if [ $? = 0 ] ; then
                grub-install --target=i386-pc --recheck $bout
                dialog --clear --backtitle "$upper_title" --title "[ GRUB 2 ]" --msgbox "Grub installed" 10 30
    
                dialog --clear --backtitle "$upper_title" --title "[ GRUB CONFIGURE ]" --msgbox "Configure Grub" 10 30
                if [ $? = 1 ] ; then
                    chroot_menu
                    return 0
                fi

                ## TODO
                cp -v /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
                grub-mkconfig -o /boot/grub/grub.cfg
                dialog --clear --backtitle "$upper_title" --title "[ GRUB CONFIGURE ]" --msgbox "Grub configured" 10 30

            else
                dialog --clear --backtitle "$upper_title" --title "[ GRUB 2 ]" --msgbox "Grub not installed..." 10 30
            fi
        else
            pacman -S --noconfirm --needed syslinux
            syslinux-install_update -i -a -m
            dialog --clear --backtitle "$upper_title" --title "[ SYSLINUX ]" --msgbox "Syslinux installed" 10 30
            dialog --clear --backtitle "$upper_title" --title "[ SYSLINUX ]" --defaultno --yesno "Edit/view syslinux.cfg?" 10 30
            if [ $? = 0 ] ; then
                nano /boot/syslinux/syslinux.cfg
            fi
            bootmsg="syslinux @ /boot/syslinux/syslinux.cfg"
        fi
    }

    conf_view() {
        echo "HOSTNAME: $(cat /etc/hostname)"
        echo "TIMEZONE: $(readlink /etc/localtime)"
        echo "LOCALE: $(cat /etc/locale.conf)"
        echo "ROOT PASSWORD: $(cat $TMP/rootpasswd)"
        echo "USER: $(awk -F":" '$7 ~ /\/bin\/zsh/ {print $1}' /etc/passwd)"
        echo "BOOTLOADER: $bootmsg"
        echo "Returning to menu in 5 seconds..."
        sleep 5s
        dialog --clear --backtitle "$upper_title" --title "[ VIEW CONFIGURATION ]" --msgbox "Return" 10 30
    }

    edit_file() {
        dialog --clear --backtitle "$upper_title" --title "[ Edit files ]" --msgbox "Please choose a file to open with nano.\n\nUse the <tab>, <spacebar> and arrow keys to navigate and select file." 10 30

        file_edit=$(dialog --stdout --backtitle "$upper_title" --title "Please select file." --fselect /etc/ 20 40)

        if [ $? = 0 ] ; then
            nano "$file_edit"
            dialog --clear --backtitle "$upper_title" --title "[ Edit files ]" --defaultno --yesno "Edit/view another file?" 10 30
            if [ $? = 0 ] ; then
                edit_file
            else
                chroot_menu
                return 0 
            fi
        else
            chroot_menu
            return 0 
        fi
    }

    chroot_menu() {
        echo "make it so"
        rootpasswd=$(cat $TMP/rootpasswd)
        dialog \
            --colors --backtitle "$upper_title" --title "pdqOS Installer (chroot) for Arch Linux x86_64" \
            --menu "Select action:" 20 60 9 \
            1 $clr"Generate hostname [${GEN_HOSTNAME}]" \
            2 $clr"Generate timezone [${GEN_TIMEZONE}]" \
            3 $clr"Generate locale [${GEN_LANG}]" \
            4 $clr"Set root password [$rootpasswd]" \
            5 $clr"Create default user and add to sudoers" \
            6 $clr"Install Bootloader" \
            7 $clr"View/confirm generated data" \
            8 $clr"View/edit files [optional]" \
            9 $clr"Exit chroot and return to installer" 2>$_TEMP

        if [ $? = 1 ] || [ $? = 255 ] ; then
            exiting
            return 0
        fi

        choice=$(cat $_TEMP)
        case $choice in
            1) gen_hostname;;
            2) gen_tz;;
            3) gen_locale;;
            4) set_root_pass;;
            5) add_user;;
            6) install_bootloader;;
            7) conf_view;;
            8) edit_file;;
            9) exiting;;
        esac
    }

    # utility execution
    while true
    do
        chroot_menu
    done
fi