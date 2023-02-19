#!/bin/bash
#############################################################
#############################################################
##                  basic-linux-setup                      ##
#############################################################
##             https://github.com/thanasxda                ##
#############################################################
##      15927885+thanasxda@users.noreply.github.com        ##
#############################################################
##    https://github.com/thanasxda/basic-linux-setup.git   ##
#############################################################
#############################################################

DATE_START=$(date +"%s")
magenta="\033[05;1;95m"  ## colors
yellow="\033[1;93m"
restore="\033[0m"

###########################################################################
echo -e "${magenta}"            ## display header - information and tips ##
echo ".::BASIC-LINUX-SETUP::."
echo -e "${restore}" && echo -e "${yellow}"
echo "Unattended setup mainly for desktop with subsection for OpenWrt and general linux devices."
echo "DISCLAIMER!!!:"
echo "I am not responsible if your computer catches fire and brings your house along with it."
echo -e "${magenta}"
echo "https://wiki.archlinux.org/title/Improving_performance"
echo -e "${restore}" && echo -e "${yellow}"
echo "Git credentials for lazy copy paste:"
echo "git config --global user.name <NAME-HERE>"
echo "git config --global user.email <EMAIL-HERE>"
echo "" && echo ""
###########################################################################
####### START #############################################################

# arch script is sloppier... no mood for too much effort as long as it works
          if [ $USER = root ] ; then
          echo -e "DO NOT RUN AS $USER OR sudo ! If you're using root type exit or reopen bash and do not execute the script with sudo. Just ./script* or sh script* and enter password." ; exit 0
          else echo -e "WELCOME $USER" ; fi

himri=/home/$(who | head -n1 | awk '{print $1}')


	echo "" && echo "" && echo " .:::: $(uname -a) ::::."
	echo -e "$(lscpu | grep 'Architecture')"
	echo -e "$(lscpu | grep 'Model name')"
	echo -e "Total memory:                    $(awk '/MemTotal/ { print $2 }' /proc/meminfo)kB" &&
	echo "" && echo ""
	echo -e "${restore}"
	echo "Commit=" && echo "$(git show --name-only)" && echo "" && echo "START SETUP:" && echo "" && echo ""




	            s="sudo"
         echo -e "${yellow}"

	     echo "Please enter your password to start the setup..." ; sudo echo ""

    ### choice of buildenv
    #    while true; do read -p "Do you wish to install build environment packages? If you are not involved in development of software please choose No to avoid bloating your system. YES=Devpkgs, NO=No devpkgs. Answer Y/N. :  " yn
    #    case $yn in
    #    [Yy]* ) echo " You have selected DEV PACKAGES" ; export INSTALLBUILDENV=true ; break;;
    #    [Nn]* ) echo " You have NOT selected DEV PACKAGES" ; break;; * ) echo "Please answer yes or no. Confirm by pressing ENTER:";; esac ; done
        echo "" && echo ""

   echo -e "${restore}"


        source="$(pwd)"
        basicsetup=$source/.basicsetup
        tmp=$source/tmp
            sl=">/dev/null"
            installxanmod="no"
        $s rm -rf /var/lib/pacman/db.lck
        cd /tmp
wget --content-disposition https://www.archlinux.org/packages/core/x86_64/pacman/download/
tar xvf pacman-*-x86_64.pkg.tar.zst etc/makepkg.conf
cat etc/makepkg.conf | sudo tee /etc/makepkg.conf
wget https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/pacman/trunk/pacman.conf ; cat pacman.conf | sudo tee /etc/pacman.conf
  $s sed -i 's/#MAKEFLAGS=.*/MAKEFLAGS="-j'"$(nproc --all)"'"/g' /etc/makepkg.conf

cd $PWD ; sudo chown root /etc /etc/*
        $s sed -z -i -e 's/#ParallelDownloads =.*/ParallelDownloads = 5 \nILoveCandy/g' /etc/pacman.conf
        $s sed -z -i 's/SyncFirst   =.*//g' /etc/pacman.conf
#nSyncFirst = archlinux-keyring
        $s pacman-key --init
        $s pacman -Syu --noconfirm --needed
        #$s pacman -S --noconfirm --needed go
        $s chown $USER *
        $s chmod +x *
        passwd_timeout=60
        $s rm -rf $tmp
        mkdir -p $tmp
        $s pacman -S --noconfirm --needed git
        cd $tmp
        	$s cp -rf $basicsetup/pacman.conf /etc/pacman.conf

        	$s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed

        yay --version ; if [ $? = 0 ] ; then echo " liljon already installed" ; else
        $s pacman -S --noconfirm --needed go
       git clone https://aur.archlinux.org/yay.git
       cd yay ; makepkg -si --noconfirm --needed
       fi

#[extra]
#SigLevel = PackageRequired
#Include = /etc/pacman.d/mirrorlist

        $s sed -z -i -e 's/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf





cd $tmp
	$s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed
    $s pacman -S --noconfirm --needed wget unzip dpkg curl git zsh rsync dash kexec-tools coreutils ca-certificates vim
    EDITOR=$(which vim)

	$s pacman -S --noconfirm --needed zsh

        $s chsh -s $(which zsh)
        $s sed -i 's/\/bin\/bash/\/usr\/bin\/zsh/g' /etc/passwd ; $s sed -i 's/\/bin\/fish/\/usr\/bin\/zsh/g' /etc/passwd
        for i in $(ls /home) ; do sudo rm -rf /home/$i/.oh-my-zsh ; done
        sudo rm -rf /root/.oh-my-zsh
        $s sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
                $s pacman -S --noconfirm --needed oh-my-zsh-git





            $s cp -f init.sh /etc/rc.local
            $s rm -rf /etc/update_hosts.sh # rm potentially outdated hosts script
            $s sed -i '/@weekly sh \/etc\/update_hosts.sh >\/dev\/null/c\' /etc/anacrontabs
                        if ! grep -q "@reboot sh /etc/rc.local" /etc/anacrontabs; then echo "@reboot sh /etc/rc.local >/dev/null" | $s tee -a /etc/anacrontabs ; fi

cd $tmp


            yay -S --noconfirm --needed brave-nightly-bin google-earth-pro
            $s pacman -S --noconfirm --needed firefox

        git config --global color.diff auto
        git config --global color.status auto
        git config --global color.branch auto


        for i in $(ls /home) ; do
        git clone --depth=1 --single-branch -j16 https://github.com/zsh-users/zsh-autosuggestions.git /home/$i/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone --depth=1 --single-branch -j16 https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$i/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        git clone --depth=1 --single-branch -j16 https://github.com/zdharma-continuum/fast-syntax-highlighting.git /home/$i/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
        git clone --depth=1 --single-branch -j16 https://github.com/marlonrichert/zsh-autocomplete.git /home/$i/.oh-my-zsh/custom/plugins/zsh-autocomplete
        git clone --depth=1 --single-branch -j16 https://github.com/romkatv/powerlevel10k.git /home/$i/.oh-my-zsh/custom/themes/powerlevel10k
        done
        $s git clone --depth=1 --single-branch -j16 https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        $s git clone --depth=1 --single-branch -j16 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        $s git clone --depth=1 --single-branch -j16 https://github.com/zdharma-continuum/fast-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
        $s git clone --depth=1 --single-branch -j16 https://github.com/marlonrichert/zsh-autocomplete.git /root/.oh-my-zsh/custom/plugins/zsh-autocomplete
        $s git clone --depth=1 --single-branch -j16 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
        $s chown root /root/.oh-my-zsh/*
        #$s chmod 0600 /root/.oh-my-zsh/*
        $s pacman -S --noconfirm --needed zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k



cd $basicsetup


icon=$(awk '/ID=/{print}' /etc/os-release | cut -d '=' -f 2 | head -n1)
if [ -e /usr/share/pixmaps/"$icon".svg ] ; then
sed -i '/neofetch/c\neofetch --color_blocks off --cpu_temp C  --gtk2 off --gtk3 off --iterm2 /usr/share/pixmaps/'"$icon"'.svg' .zshrc ; fi
if [ $icon = endeavouros ] ; then
sed -i '/neofetch/c\neofetch --color_blocks off --cpu_temp C  --gtk2 off --gtk3 off --iterm2 /usr/share/pixmaps/'"$icon"'.svg ; if [ -e /etc/pacman.d/endeavouros-mirrorlist ] ; then typeset _p9k_os_icon= ; typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=$'/''\uF303'/'' ; fi' .zshrc
if ! grep -qi endeavouros .p10k.zsh ; then
echo 'if [ -e /etc/pacman.d/endeavouros-mirrorlist ] ; then typeset -g _p9k_os_icon= ; typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION=$'/''\uF303'/'' ; fi' .p10k.zsh
fi ; fi
if [ $icon = arch ] ; then
#$s wget https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Archlinux-icon-crystal-64.svg/480px-Archlinux-icon-crystal-64.svg.png -O /usr/share/pixmaps/arch.png
sed -i '/fastfetch/c\fastfetch -l /usr/share/pixmaps/'"$icon"'linux-logo.png --logo-type auto --logo-padding-top 4 --logo-padding-left 10 --multithreading '"$(nproc --all)"'' .zshrc

echo '[Theme]
Current=breeze' | $s tee /etc/sddm.conf
else
sed -i '/neofetch/c\neofetch --color_blocks off --cpu_temp C  --gtk2 off --gtk3 off' .zshrc ; fi

if grep -q arch /etc/os-release ; then if ! grep -q 'alias up' .zshrc ; then echo 'alias up="sudo pacman -Syu --noconfirm --needed && yay -Syu --noconfirm --needed"' | tee -a .zshrc ; fi ; fi
if grep -q arch /etc/os-release ; then if ! grep -q 'alias clean' .zshrc ; then echo 'alias clean="sudo pacman -Rs $(pacman -Qdtq)"' | tee -a .zshrc ; fi ; fi

#echo 'alias sr="read input ; pacman -Ss $input ; yay -Ss $input"' | tee -a .zshrc

        $s rsync -v -K -a --force --include=".*" .p10k.zsh /root/.p10k.zsh
        $s rsync -v -K -a --force --include=".*" .p10k.zsh ~/.p10k.zsh
        $s rsync -v -K -a --force --include=".*" .zshrc ~/ # were still on zsh config this part, read carefully when editing
        $s rsync -v -K -a --force --include=".*" .zshrc /root/.zshrc
        $s chown root /root/.zshrc /root/.p10k.zsh
        #$s chmod 0600 /root/.zshrc /root/.p10k.zsh

                    $s rsync -v -K -a --force --include=".*" usr /
                    #$s rsync -v -K -a --force --include=".*" .hushlogin ~/.hushlogin
                    #$s rsync -v -K -a --force --include=".*" .hushlogin /root/.hushlogin
                    #$s rsync -v -K -a --force --include=".*" .bashrc ~/.bashrc
                    #$s rsync -v -K -a --force --include=".*" .bashrc /root/.bashrc
                    $s rsync -v -K -a --force --include=".*" .config ~/
                    $s rsync -v -K -a --force --include=".*" .config /root/
                    $s rsync -v -K -a --force --include=".*" .kde ~/
                    $s rsync -v -K -a --force --include=".*" .local ~/
                    $s rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/
                    $s rsync -v -K -a --force --include=".*" .kodi ~/
                    $s rsync -v -K -a --force --include=".*" MalakasUniverse /usr/share/wallpapers/
                    $s rsync -v -K -a --force --include=".*" .config/BraveSoftware/Brave-Browser-Nightly/* ~/.config/chromium/

                   $s rm -rf $tmp ; $s mkdir -p $tmp ; cd $tmp ; $s mkdir -p /usr/share/fonts/truetype/hack/ ; sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip ; sudo unzip Hack.zip -d hackz ; sudo cp hackz/* /usr/share/fonts/truetype/hack/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
                   yay -S --noconfirm --needed ttf-hack-nerd debtap dpkg
                   sudo debtap -u
                   #sudo wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_amd64.deb ; echo -ne '\n' | sudo debtap logo-ls_amd64.deb  ; sudo debtap -U *pkg.tar.zst ; sudo rm -rf logo-ls*
                   $s wget https://github.com/Yash-Handa/logo-ls/releases/download/v1.3.7/logo-ls_Linux_x86_64.tar.gz ; $s tar -xvf logo-ls_Linux_x86_64.tar.gz ; $s cp -f logo-ls_Linux_x86_64/logo-ls /opt/ ; $s ln -s /opt/logo-ls /usr/bin/logo-ls
$s chown root /usr /var


if [ ! -z $XDG_CURRENT_DESKTOP ] ; then
        echo -e "${yellow}"
echo ".....................................................................
If setup gets stuck on this screen, just open and close firefox (not firefox-esr, regular firefox. from the start menu. START MENU>INTERNET>FIREFOX) for it to speed up...
.....................................................................
Don't forget to go to settings in Firefox after the setup and enabling the addons that come preinstalled in settings>extensions>enable...
If they appear enabled in settings but do not show up on the top bar of Firefox just disable and re-enable them...
....................................................................."
        echo -e "${restore}"


cd $basicsetup/.mozilla/firefox/.default-release


                    $s pkill -f firefox
                    for i in {1..20} ; do until ls $himri/.mozilla/firefox/*.default-release ; do firefox & sleep 10 ; $s pkill -f firefox ; done ; done ; if $(ls $himri/.mozilla/firefox) [ $? = 0 ] ; then break ; fi

                    $s rsync -v -K -a --force --include=".*" extensions/* /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/
                    #yes | firefox -install-global-extension /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/*

                    for i in $(ls /home) ; do
                    $s \cp -rf prefs.js /home/$i/.mozilla/firefox/"$(ls /home/$i/.mozilla/firefox | grep default-release)"/prefs.js
                    $s \cp -rf prefs.js /etc/firefox/firefox.js
                    $s \cp -rf extensions /home/$i/.mozilla/firefox/extensions
                    $s \cp -rf extensions /home/$i/.mozilla/firefox/"$(ls /home/$i/.mozilla/firefox | grep default-release)"/extensions ; done

fi
                        # fix ~/  home folder permissions
                            $s chown -R $(id -u):$(id -g) $HOME
cd $source

            mkdir -p ~/.wine && $s mkdir -p /root/.wine
            # echo "127.0.0.1 release.gitkraken.com"  | $s tee -a /etc/hosts # workaround to use kraken with private repos dunno if works

                ### additional config
                $s systemctl enable fstrim.timer # fstrim is also preconfigured weekly, so we enable the service
                $s systemctl start fstrim.timer


                 ./pkglistarch.sh


        echo -e "${restore}"


cd $source





               sudo firstrun=yes ./init.sh # execute copied init.sh which now is /etc/rc.local
               # $s sh /etc/update_hosts.sh $sl     # remember we have executed the init.sh which is rc.local which includes stock pihole blocklists, so during setup we execute an update
                $s fc-cache -rfv

                cd $basicsetup
                ### sync more preconfig that wasnt convenient prior to pkg installation
                    $s rsync -v -K -a --force --include=".*" system.conf /etc/systemd/system.conf
                    $s rsync -v -K -a --force --include=".*" journald.conf /etc/systemd/journald.conf

                $s pacman -S --noconfirm --needed kdebugsettings dbus-broker
                yay -S --noconfirm --needed xorg-mkcomposecache

                mkcomposecache en_US.UTF-8 /var/tmp/buildroot/usr/share/X11/locale/en_US.UTF-8/Compose /var/tmp/buildroot/var/X11R6/compose_cache /usr/share/X11/locale/en_US.UTF-8/Compose

                kdebugsettings --disable-full-debug
                #kdebugsettings --debug-mode Off

$s systemctl enable --now dbus-broker


cd $tmp

        $s bootctl install && $s bootctl update
        wget https://raw.githubusercontent.com/freedesktop/xorg-mkcomposecache/master/mkallcomposecaches.sh -O tmp/mkcache.sh ; $s chmod +x tmp/mkcache.sh ; $s sh tmp/mkcache.sh ; sh tmp/mkcache.sh
        $s rm -rf $tmp
                #if apt search systemd-boot | grep -q installed && [ -d /sys/firmware/efi ] ; then $s apt purge -y grub-common ; fi
            $s rm -rf /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/ccache*
            $s rm -rf /etc/apt/sources.list.d/google*
            $s mkdir -p /tmp
            $s systemctl daemon-reload
            $s mount -a



             yay -S --noconfirm --needed systemd-boot-pacman-hook kernel-install-for-dracut


$s mkdir /etc/pacman.d


#        $s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed

        $s pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
        $s pacman-key --lsign-key FBA220DFC880C036
        #echo "\n"
        #printf 'y'
        #yes
                echo "\n" | $s pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

        $s wget https://aur.chaotic.cx/mirrorlist.txt -O /etc/pacman.d/chaotic-mirrorlist
        $s cp -f chaotic-mirrorlist /etc/pacman.d/

        $s wget https://raw.githubusercontent.com/xerolinux/xerolinux-mirrorlist/main/etc/pacman.d/xero-mirrorlist
        $s cp -f xero-mirrorlist /etc/pacman.d/

        $s wget https://raw.githubusercontent.com/endeavouros-team/PKGBUILDS/master/endeavouros-mirrorlist/endeavouros-mirrorlist
        $s cp -f endeavouros-mirrorlist /etc/pacman.d/

        $s wget https://raw.githubusercontent.com/arcolinux/arcolinux-mirrorlist/master/etc/pacman.d/arcolinux-mirrorlist
        $s cp arcolinux-mirrorlist /etc/pacman.d/



        wget https://build.cachyos.org/cachyos-repo.tar.xz
        tar xvf cachyos-repo.tar.xz
        cd cachyos-repo
        echo "\n" | $s ./cachyos-repo.sh





             for i in $(echo _v4 ; echo _v3 ; echo LoLz) ; do
echo '######################################################
####                                              ####
####        CachyOS Repository Mirrorlist         ####
####                                              ####
######################################################
#### Entry in file /etc/pacman.conf:
###     [cachyos]
###     Include = /etc/pacman.d/cachyos'"$i"'mirrorlist
######################################################
## Netherlands
Server = https://nl.cachyos.org/repo/$arch'"$i"'/$repo
## Germany
Server = https://mirror.cachyos.org/repo/$arch'"$i"'/$repo
Server = https://aur.cachyos.org/repo/$arch_v'"$i"'/$repo
Server = https://build.cachyos.org/repo/$arch'"$i"'/$repo
## Hungary much thanks to to ArchanfelHUN!
Server = https://hun.cachyos.org/repo/$arch'"$i"'/$repo
## Singapore much thanks to SM9!
Server = https://sg.cachyos.org/repo/$arch'"$i"'/$repo
## South Korea much thanks to silent_heigou!
Server = https://kr.cachyos.org/repo/$arch'"$i"'/$repo' | sudo tee $(echo /etc/pacman.d/cachyos-"$i"-mirrorlist | sed 's/_\| \|LoLz//g' | sed 's/--/-/g')
done


      #          if ! grep -q cachyos /etc/pacman.conf ; then
#
#        if /lib/ld-linux-x86-64.so.2 --help | grep "v4 (supported" ; then
#        $s sed -z -i 's/# after the header, and they will be used before the default mirrors./# after the header, and they will be used before the default mirrors.\n\n[cachyos-v4]\nInclude = \/etc/pacman.d\/cachyos-v4-mirrorlist\n\n[cachyos-v3]\nInclude = \/etc/pacman.d\/cachyos-v3-mirrorlist\n\n[cachyos-community-v3]\nInclude = \/etc/pacman.d\/cachyos-v3-mirrorlist\n\n[cachyos]\nInclude = \/etc\/pacman.d\/cachyos-mirrorlist/g' /etc/pacman.conf
#        cachy=$(echo _v4 ; echo _v3 ; echo " ")
#        crepo


#        elif /lib/ld-linux-x86-64.so.2 --help | grep "v3 (supported" ; then
#        $s sed -z -i 's/# after the header, and they will be used before the default mirrors./# after the header, and they will be used before the default mirrors.\n\n[cachyos-v3]\nInclude = \/etc/pacman.d\/cachyos-v3-mirrorlist\n\n[cachyos-community-v3]\nInclude = \/etc/pacman.d\/cachyos-v3-mirrorlist\n\n[cachyos]\nInclude = \/etc\/pacman.d\/cachyos-mirrorlist/g' /etc/pacman.conf
#        cachy=$(echo _v3 ; echo " ")
#        crepo

#        else
#        $s sed -z -i 's/# after the header, and they will be used before the default mirrors./# after the header, and they will be used before the default mirrors.\n\n[cachyos]\nInclude = \/etc\/pacman.d\/cachyos-mirrorlist/g' /etc/pacman.conf
#        cachy=$(echo " ")
#        crepo
#        fi
#                fi



       # crepo

       $s sed -i 's/arch \/$repo/arch\/$repo/g' /etc/pacman.d/cachyos-mirrorlist
               $s sed -i 's/LoLz//g' /etc/pacman.d/cachyos-mirrorlist



        wget https://build.cachyos.org/cachyos-repo.tar.xz
        tar xvf cachyos-repo.tar.xz
        cd cachyos-repo
        echo "\n" | $s ./cachyos-repo.sh



        if ! grep -q kde-unstable /etc/pacman.conf ; then
        $s sed -i 's/# after the header, and they will be used before the default mirrors./# after the header, and they will be used before the default mirrors.\n\n#[kde-unstable]\n#Include = \/etc\/pacman.d\/mirrorlist\n/g' /etc/pacman.conf
        fi
$s gpg --keyserver keyserver.ubuntu.com --recv-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
$s pacman-key --lsign-key 882DCFE48E2051D48E2562ABF3B607488DB35A47


    $s pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    $s pacman-key --lsign-key FBA220DFC880C036
        $s pacman-key --recv-key 0D4D2FDAF45468F3DDF59BEDE3D0D2CD3952E298 --keyserver keyserver.ubuntu.com
    $s pacman-key --lsign-key 0D4D2FDAF45468F3DDF59BEDE3D0D2CD3952E298

    $s pacman -U --noconfirm --needed 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'


        $s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed

        $s pacman -S --noconfirm --needed endeavouros-keyring arcolinux-keyring
         #$s pacman -S --noconfirm --needed gcc-git
         #$s pacman -S --noconfirm --needed llvm-git
         $s pacman -S --noconfirm --needed alhp-keyring alhp-mirrorlist

         ##
echo '## ALHP repository mirrorlist
## Updated on 2022-12-25
## https://git.harting.dev/ALHP/alhp-mirrorlist
##
## There is an IPFS mirror available.
## Setup instructions in /etc/pacman.d/alhp-mirrorlist.ipfs.
##

## Worldwide (Cloudfare)
Server = https://alhp.krautflare.de/$repo/os/$arch/

## Europe
Server = https://mirror.sunred.org/alhp/$repo/os/$arch/
Server = https://alhp.panibrez.com/$repo/os/$arch/
Server = https://alhp.harting.dev/$repo/os/$arch/

## Asia
Server = https://mirrors.shanghaitech.edu.cn/alhp/$repo/os/$arch/' | $s tee /etc/pacman.d/alhp-mirrorlist

         ## messy script but not in mood for maintenance

$s sed -i -z -e 's/#\[chaotic-aur\]\n#Include = \/etc\/pacman.d\/chaotic-mirrorlist/\[chaotic-aur\]\nInclude = \/etc\/pacman.d\/chaotic-mirrorlist/g' /etc/pacman.conf
           # $s rm -rf /boot/efi/loader/entries/* ; $s rm -rf /boot/loader/entries/* ; $s rm -rf /efi/loader/entries/*

           $s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed

 $s pacman -S --noconfirm --needed preload
 $s pacman -S --noconfirm --needed pamac-aur
 $s pacman -S --noconfirm --needed octopi
 $s pacman -S --noconfirm --needed fastfetch
 $s pacman -S --noconfirm --needed cw
 $s pacman -S --noconfirm --needed plzip
 $s pacman -S --noconfirm --needed pkg_scripts
 #yes | $s pacman -S --needed ffmpeg-git #$(if glxinfo | grep -qi intel ; then echo "libva-git" ; fi)
 pkg2="alsa-tools dkms debtap linux-clear-bin linux-clear-headers-bin w3m-imgcat"
 $s pacman -S --noconfirm --needed $pkg2

if
glxinfo | grep -q Intel ; then
$s pacman -S --noconfirm --needed intel-compute-runtime intel-graphics-compiler intel-opencl-clang
#elif
#glxinfo | grep -q NVIDIA ; then
#$s pacman -S --noconfirm --needed  ; elif
#glxinfo | grep -q AMD ; then
#$s pacman -S --noconfirm --needed
fi

           $s pacman -S --noconfirm --needed kernel-modules-hook find-the-command
           yay -S --noconfirm --needed system76-scheduler


           if [ $? = 0 ] ; then if ! grep -q /usr/share/doc/find-the-command/ftc.zsh $basicsetup/.zshrc ; then
           echo 'source /usr/share/doc/find-the-command/ftc.zsh' | tee -a $basicsetup/.zshrc
        $s rsync -v -K -a --force --include=".*" .zshrc ~/
        $s rsync -v -K -a --force --include=".*" .zshrc /root/.zshrc
                fi ; fi




           reflector | $s tee /etc/pacman.d/mirrorlist



            $s sh /etc/environment ; $s update-grub ; $s grub-mkconfig ; $s bootctl install ; $s bootctl systemd-efi-options ""$par"" ; $s bootctl update ; $s update-initramfs -u -k all ; $s mkinitramfs -c lz4 -o /boot/initrd.img-*


$s chown root /usr /var



        if /lib/ld-linux-x86-64.so.2 --help | grep "v4 (supported" ; then
$s sed -i -z -e 's/#\[cachyos-v4\]\n#Include = \/etc\/pacman.d\/cachyos-v4-mirrorlist/\[cachyos-v4\]\nInclude = \/etc\/pacman.d\/cachyos-v4-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[core-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[core-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[extra-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[extra-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[community-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[community-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf

        elif /lib/ld-linux-x86-64.so.2 --help | grep "v3 (supported" ; then
$s sed -i -z -e 's/#\[core-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[core-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[extra-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[extra-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[community-x86-64-v3\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[community-x86-64-v3\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf

        elif /lib/ld-linux-x86-64.so.2 --help | grep "v2 (supported" ; then
$s sed -i -z -e 's/#\[core-x86-64-v2\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[core-x86-64-v2\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[extra-x86-64-v2\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[extra-x86-64-v2\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
$s sed -i -z -e 's/#\[community-x86-64-v2\]\n#SigLevel = Optional TrustAll\n#Include = \/etc\/pacman.d\/alhp-mirrorlist/\[community-x86-64-v2\]\nSigLevel = Optional TrustAll\nInclude = \/etc\/pacman.d\/alhp-mirrorlist/g' /etc/pacman.conf
        fi


        $s wget https://gitlab.com/endeavouros-filemirror/PKGBUILDS/-/raw/master/endeavouros-mirrorlist/endeavouros-mirrorlist?inline=false -O /etc/pacman.d/endeavouros-mirrorlist
        $s wget https://raw.githubusercontent.com/endeavouros-team/keyring/main/endeavouros.gpg -O /usr/share/pacman/keyrings/endeavouros.gpg





 $s pacman -S --noconfirm --needed help2man cmake vulkan-headers dkms alsa-tools
 $s pacman -Rsnc --noconfirm linux-headers
 yay -S --noconfirm --needed dracut-hook-uefi
 $s pacman -Rsc --noconfirm go
 $s pacman -S --noconfirm --needed downgrade
 $s pacman -S --noconfirm --needed ttf-jetbrains-mono
 $s pacman -S --noconfirm --needed modprobed-db
 $s pacman -S --noconfirm --needed refind-theme-nord
 $s pacman -S --noconfirm --needed zsh powerline zsh-theme-powerlevel10k zsh-autosuggestions zsh-completions zsh-syntax-highlighting

 yes | $s pacman -S preload

if $(yay -Ss linux-clear-bin | grep -q installed) ; then
 sudo pacman -Rsc --noconfirm linux
 sudo pacman -Rsc --noconfirm linux-headers
fi


$s gpg --keyserver keyserver.ubuntu.com --recv-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
$s pacman-key --lsign-key 882DCFE48E2051D48E2562ABF3B607488DB35A47

$s gpg --keyserver keyserver.ubuntu.com --recv-key ABAF11C65A2970B130ABE3C479BE3E4300411886
$s pacman-key --lsign-key ABAF11C65A2970B130ABE3C479BE3E4300411886

$s gpg --keyserver keyserver.ubuntu.com --recv-key 647F28654894E3BD457199BE38DBBDC86092693E
$s pacman-key --lsign-key 647F28654894E3BD457199BE38DBBDC86092693E

$s gpg --keyserver keyserver.ubuntu.com --recv-key 38DBBDC86092693E
$s pacman-key --lsign-key 38DBBDC86092693E

if [ $installxanmod = yes ] ; then
if /lib/ld-linux-x86-64.so.2 --help | grep "v3 (supported" ; then
yay -S --noconfirm --needed linux-xanmod-linux-bin-x64v3  ; elif /lib/ld-linux-x86-64.so.2 --help | grep "v2 (supported" ; then
yay -S --noconfirm --needed linux-xanmod-linux-bin-x64v2  ; else
yay -S --noconfirm --needed linux-xanmod-linux-bin-x64v1  ; fi
if [ $? = 1 ] ; then
yay -S --noconfirm --needed linux-xanmod-bin ; fi
fi

# for more failsafe setup, mods to repos done near and of script
$s sed -i -z -e 's/#\[cachyos\]\n#Include = \/etc\/pacman.d\/cachyos-mirrorlist/\[cachyos\]\nInclude = \/etc\/pacman.d\/cachyos-mirrorlist/g' /etc/pacman.conf
$s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed

$s gpg --keyserver keyserver.ubuntu.com --recv-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
$s pacman-key --lsign-key 882DCFE48E2051D48E2562ABF3B607488DB35A47
$s pacman -S --noconfirm absolutely-proprietary
 yes | echo "\n" | $s pacman -S gcc-git
 yes | $s pacman -S pamac-aur
 yes | $s pacman -S haveged
         if grep -qi endeavouros /etc/os-release ; then
$s sed -i -z -e 's/\n#\[endeavouros\]\n#SigLevel = PackageRequired\n#Include = \/etc\/pacman.d\/endeavouros-mirrorlist//g' /etc/pacman.conf
$s sed -z -i -e 's/# after the header, and they will be used before the default mirrors./# after the header, and they will be used before the default mirrors.\n\n\[endeavouros\]\nSigLevel = PackageRequired\nInclude = \/etc\/pacman.d\/endeavouros-mirrorlist/g' /etc/pacman.conf
        fi

$s pacman -Syu --noconfirm --needed ; yay -Syu --noconfirm --needed


if [ $(awk '/ID=/{print}' /etc/os-release | cut -d '=' -f 2 | head -n1) = endeavouros ] ; then
$s pacman -S --noconfirm --needed eos-sddm-theme eos-plasma-sddm-config eos-settings-plasma endeavouros-skel-default eos-dracut eos-downgrade eos-hooks ; fi
#yay -S --noconfirm --needed kernel-install-for-dracut ; fi


yay -S --noconfirm spack






$s pacman -Rscn --noconfirm intel-ucode
$s pacman -Rscn --noconfirm amd-ucode


$s sed -i 's/#SigLevel .*/SigLevel = Never/g' /etc/pacman.conf
$s sed -i 's/SigLevel .*/SigLevel = Never/g' /etc/pacman.conf

yes | $s pacman -U https://www.parabola.nu/packages/libre/x86_64/parabola-keyring/download
yes | $s pacman -U https://www.parabola.nu/packages/libre/x86_64/pacman-mirrorlist/download











 yes | $s pacman -Rs $(pacman -Qdtq)

 $s cp -f $basicsetup/makepkg.conf /etc/makepkg.conf

 sudo touch /etc/firstboot



 #$s pacman -Rs --noconfirm plasma ; $s pacman -S --noconfirm --needed plasma-desktop ; $s pacman -Rs --noconfirm $(pacman -Qdtq)









 #$s pacman -Rsn --noconfirm plasma-meta drkonqi



$s sed -i 's/#SigLevel .*/SigLevel = Required DatabaseOptional/g' /etc/pacman.conf
$s sed -i 's/SigLevel .*/SigLevel = Required DatabaseOptional/g' /etc/pacman.conf

$s mv /etc/pacman.d/mirrorlist.pacnew /etc/pacman.d/parabola-mirrorlist


for i in cronie haveged rngd firewalld apparmor dbus-broker irqbalance rtirq preload thermald sddm clr-power ; do
$s systemctl enable $i 
done

echo " BUILDING AND BRUSHING KERNAL"
cd $source ; cd .. ; git clone https://github.com/thanasxda/clrxt-x86 --single-branch --depth=1 -j8
cd clrxt-x86 
sudo bls=yes ./build.sh




        echo -e "${magenta}" && echo "Finalizing with fstrim / ... be patient." && echo -e "${yellow}"

            $s fstrim /






####################################################### display header ####
echo -e "${magenta}" && echo ".::BASIC-LINUX-SETUP::."
echo -e "${yellow}" && echo "DONE - WAKE UP...!..." && echo "" && echo ""
###########################################################################
###########################################################################


	echo " .:::: "$(uname -a)" ::::." && echo "" && echo "" ### display kernel setup for log after

DATE_END=$(date +"%s") ; DIFF=$(($DATE_END - $DATE_START))
echo "Setup took: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds to complete." && echo "" && echo ""
read -p "    !!!!!! PRESS < ENTER > TO REBOOT Ctrl+C TO CANCEL !!!!!!!    "     ### REBOOT


         systemctl reboot



#####################################################################################################
####### END #########################################################################################
#####################################################################################################
