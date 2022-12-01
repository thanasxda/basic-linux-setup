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
echo "Unattended setup mainly for Kali/Debian with subsection for OpenWrt and general linux devices."
echo "DISCLAIMER!!!:"
echo "I am not responsible if your computer catches fire and brings your house along with it."
echo -e "${restore}" && echo -e "${yellow}"
echo "Never apt dist-upgrade/full-upgrade -t experimental"
echo "Read arch wiki for personalization:"
echo -e "${magenta}"
echo "https://wiki.archlinux.org/title/Improving_performance"
echo -e "${restore}" && echo -e "${yellow}"
echo "For openwrt:"
echo -e "${magenta}"
echo "wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/wrt.sh && sh wrt.sh"
echo -e "${restore}" && echo -e "${yellow}"
echo "Git credentials:"
echo "git config --global user.name thanasxda"
echo "git config --global user.email 15927885+thanasxda@users.noreply.github.com"
echo "" && echo ""
###########################################################################
####### START #############################################################





    #"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"
    ### workaround to keep you from running as sudo or root ... thats what you get when you dont know echo $LOGNAME lol... [ $LOGNAME = youruseraccount ]  .. $ printenv
          if echo -e $USER | grep -q root; then
          echo -e "DO NOT RUN AS $USER OR sudo ! If you're using root type exit or reopen bash and do not execute the script with sudo. Just ./script* or sh script* and enter password." &&
          exit 0; else echo -e "WELCOME $USER"; fi

          
          
          
          
          
          
    ### output log to desktop
    	#mkdir -p ~/Desktop/BLS-LOGS
    	#echo "" && echo "" && echo "BE SURE TO CHECK LOGFILES ON YOUR DESKTOP!" && echo "" && echo ""
    # { 	# start log, note pkglists will have seperate log appending to this first one this file creates
   	# && echo "        START BLS_LOG: `date +%Y-%m-%d.%H:%M:%S` " && echo "" && echo ""
	echo "" && echo "" && echo " .:::: $(uname -a) ::::."
	echo -e "$(lscpu | grep 'Architecture')"
	echo -e "$(lscpu | grep 'Model name')"
	echo -e "Total memory:                    $(awk '/MemTotal/ { print $2 }' /proc/meminfo)kB" && 
	echo "" && echo ""
	#echo "Logfiles=" && echo "$(ls ~/Desktop/BLS-LOGS)" && echo ""
	echo -e "${restore}"
	echo "Commit=" && echo "$(git show --name-only)" && echo "" && echo "START SETUP:" && echo "" && echo ""

	
	
	
	
	
	
    ### choice of buildenv
        echo -e "${yellow}"
        while true; do read -p "Do you wish to install build environment packages? If you are not involved in development of software please choose No to avoid bloating your system." yn
        case $yn in  [Yy]* ) export INSTALLBUILDENV=true ; break;; [Nn]* ) break;; * ) echo "Please answer yes or no. Confirm by pressing ENTER:";; esac ; done
        echo "" && echo ""
    
        echo "Please enter your password to start the setup..." && echo -e "${restore}" 
    
    
    
    
    
    
    
    ###     <<<< VARIABLES >>>> - values that are called later in the setup for convenience and avoiding clutter >>>>>>>>>>>>>>>>>>>>

   # hdd="/dev/sd*"  # your harddrive here, if you do use xfs. otherwise dont mind. wont get recognized as filesystem
   # nvme="/dev/nvme*"

        source="$(pwd)"
        basicsetup=$source/.basicsetup
        tmp=$source/tmp
            sl=">/dev/null"
            s="sudo"
            up="$s apt update"
            a="$s apt -f install -y --fix-broken --fix-missing"
            apt="$s apt -f install -y -t experimental --fix-broken --fix-missing"
            rem="apt -f -y purge"

            
            
            
            

# just used this as an exemplary marker on top, for dirs explicitly being placed on the far left side for readability and ease of usage
# for editing ~/basic-linux-setup/'test*' is already in gitignore. so make a file, !#/bin/bash on top, save & chmod +x test.sh to make it executable,
# run or copy paste parts to console individually for testing. script is usually safer, keep in mind
cd $source
mkdir -p $tmp

        $s chmod +x *
        echo ""
        $s sh $source/2* # execute backup sources.list script
        $s rm -rf /var/lib/dpkg/lock* /var/lib/aptitude/lock* /var/cache/apt/archives/ /var/lib/apt/lists/*
        #$s mv /var/lib/dpkg/info/install-info.postinst /var/lib/dpkg/info/install-info.postinst.bad
        $s fuser -viks /var/cache/debconf/config.dat
            $s pkill -f apt
            $s pkill -f aptitude
            $s pkill -f packagekitd
            $s pkill -f dpkg
            $s pkill -f /etc/rc.local
            $s pkill -f /etc/sysctl.conf
                echo 'Acquire::ForceIPv4 "true";' | $s tee /etc/apt/apt.conf.d/99force-ipv4
                $s dpkg --add-architecture i386
                $s dpkg-reconfigure dash
            
cd $tmp


    ###     <<<< ADD KEYS >>>> - for access to repositories >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            $s wget http://www.deb-multimedia.org/pool/main/d/deb-multimedia-keyring/deb-multimedia-keyring_2016.8.1_all.deb && $s dpkg -i deb-multimedia-keyring_2016.8.1_all.deb
            $s wget -qO- https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/other-deps/Debian_Unstable/Release.key | $s apt-key add -
            $s wget -qO- https://download.opensuse.org/repositories/Debian:/debbuild/Debian_Testing/Release.key | $s apt-key add -
            $s wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | $s apt-key add -
            $s curl -L https://packagecloud.io/AtomEditor/atom/gpgkey | $s apt-key add -
            $s apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C80E383C3DE9F082E01391A0366C67DE91CA5D5F
                $s apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC 0B31DBA06A8A26F9 1378B444 15CF4D18AF4F7421 23F3D4EA75716059 2836cb0a8ac93f7a 3729827454b8c8ac 3B4FE6ACC0B21F32 4EB27DB2A3B88B8B 5A88D659DCB811BB 5C808C2B65558117 648ACFD622F3D138 6d975c4791e7ee5e 78BD65473CB3BD13 871920D1991BC93C 89942AAE5CEAA174 957d2708a03a4626 A2F33E359F038ED9 A89D7C1B2F76304D B8AC39B0876D807E E6D4736255751E5D ED444FF07D8D0BF6 a1715d88e1df1f24 B8AC39B0876D807E 54404762BBB6E853 112695A0E562B32A 818A435C5FCBF54A 9DE922F1C2FDE6C4 1F3045A5DF7587C3 4C6E74D6C0A35108

                
                
    ###     <<<< WORKAROUND GPG >>>> - avoiding errors when running apt update >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                    $s cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
                    $s rm -rf /var/lib/apt/lists/* && $s apt clean && $s apt autoclean



                
                
                
                
                
    ###      <<<< BASIC PKGS & KEYRINGS >>>> - needed for running this script >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        $up -oAcquire::AllowInsecureRepositories=true
        $s dpkg --configure -a
        $a rsync
            $s rsync -v -K -a --force --include=".*" config.dat /var/cache/debconf/config.dat
            echo -e 'DPkg::Options {
   "--force-overwrite";
   "--force-confold";
   "--force-confdef";
};' | $s tee /etc/apt/apt.conf.d/71debconf
            #$a xdotool
                    #/bin/bash -ic 'xdotool key Left | xdotool key KP_Enter | sudo apt -f -y install libc6'
                    #/bin/bash -ic 'xdotool key Left | xdotool key KP_Enter | sudo apt -f -y install kexec-tools'
                    #/bin/bash -ic 'xdotool key Left | xdotool key KP_Enter | sudo apt -f -y install macchanger'
                    #xdotool key Left | xdotool key KP_Enter | xdotool key Left | xdotool key KP_Enter | $s dpkg-reconfigure kexec-tools
                    $a libc6 ; $a kexec-tools insserv ; $s dpkg-reconfigure --frontend readline insserv kexec-tools --force ; $a libpam-systemd ; $a macchanger
            $a deb-multimedia-keyring
            #$a ubuntu-archive-keyring
            #$a gnome-keyring
                $a ca-certificates
                $a apt-transport-https
                $a coreutils
                $a lsb-release
                $a curl
                $a git
                $a aptitude
                    $s dpkg --configure -a
                    $s mv /var/lib/dpkg/info/install-info.postinst /var/lib/dpkg/info/install-info.postinst.bad









    ###     <<<< COPY SOURCES.LIST & MORE >>>> - make executable, backup and copy repositories setup and execute init.sh script >>>>>
        #$s chmod +x *
        #$s sh $source/2* # execute backup sources.list script
        $s cp *.list /etc/apt/sources.list.d/
        $s rm -rf /etc/apt/sources.list.d/*sources.list
        $s cp preferences /etc/apt/
        $s cp preferences /etc/apt/preferences.d/
        $s cp -f init.sh /etc/rc.local && $s cp -f init.sh /etc/sysctl.conf
            $s rm -rf /etc/update_hosts.sh # rm potentially outdated hosts script
            $s sed -i '/@weekly sh \/etc\/update_hosts.sh >\/dev\/null/c\' /etc/anacrontabs
                        if ! grep -q "@reboot sh /etc/rc.local" /etc/anacrontabs; then echo "@reboot sh /etc/rc.local >/dev/null" | $s tee -a /etc/anacrontabs ; fi

cd $tmp







                    
                    

    ###     <<<< BASIC PKGS >>>> - we just added and updated sources, latest pkgs can be updated >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        $a deb-multimedia-keyring
            $a brave-browser-nightly
            $a google-earth-pro-stable
            $rem firefox-esr
            $a firefox
                #$a netselect-apt
                        $a kali-tweaks

                        
                        
                        
                        

    ###     <<<< NECESSARY PACKAGE FOR GIT >>>> - pkgs and the way they operate get changed >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            if [ $INSTALLBUILDENV = true ] ; then
                    curl -LO https://raw.githubusercontent.com/GitCredentialManager/git-credential-manager/main/src/linux/Packaging.Linux/install-from-source.sh &&
                    printf 'y' | sh ./install-from-source.sh &&
                    git-credential-manager-core configure &&
                    git config --global credential.credentialStore secretservice ; fi


                    
                    
                    
                    


    ###     <<<< CUSTOMIZE LINUX >>>> - zsh, preconfig kde, browsers & extras >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        # zsh
        #`ZSH= sh install.sh`
        $a zsh
        $a curl
        #$s apt -f -y remove zsh-autosuggestions zsh-syntax-highlighting zsh-antigen
        $s dpkg-reconfigure zsh
        $s chsh -s $(which zsh) # switch to zsh if not already on kali
        for i in $(ls /home) ; do sudo rm -rf /home/$i/.oh-my-zsh ; done
        sudo rm -rf /root/.oh-my-zsh
        $s sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        for i in $(ls /home) ; do
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /home/$i/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$i/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git /home/$i/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
        git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git /home/$i/.oh-my-zsh/custom/plugins/zsh-autocomplete
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/$i/.oh-my-zsh/custom/themes/powerlevel10k ; done
        $s git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        $s git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        $s git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git /root/.oh-my-zsh/custom/plugins/fast-syntax-highlighting
        $s git clone --depth=1 https://github.com/marlonrichert/zsh-autocomplete.git /root/.oh-my-zsh/custom/plugins/zsh-autocomplete
        $s git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
        $s chown root /root/.oh-my-zsh/*
        #$s chmod 0600 /root/.oh-my-zsh/*
        $a zsh-autosuggestions
        $a zsh-syntax-highlighting
        $a zsh-antigen
        $a fonts-powerline


        
cd $basicsetup

    ###     <<<< COPY PRECONFIG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        $s rsync -v -K -a --force --include=".*" .p10k.zsh /root/.p10k.zsh
        $s rsync -v -K -a --force --include=".*" .p10k.zsh ~/.p10k.zsh
        $s rsync -v -K -a --force --include=".*" .zshrc ~/ # were still on zsh config this part, read carefully when editing
        $s rsync -v -K -a --force --include=".*" .zshrc.root /root/.zshrc
        $s chown root /root/.zshrc /root/.p10k.zsh
        #$s chmod 0600 /root/.zshrc /root/.p10k.zsh
    ### ############
            killb="$s pkill -f brave-browser-nightly"       # remember the browsers are preconfigerd for hardware acceleration which is in underneath part, thus kill process
            killf="$s pkill -f firefox"
                $killb && $killf
                    $s rsync -v -K -a --force --include=".*" .hushlogin ~/.hushlogin
                    $s rsync -v -K -a --force --include=".*" .hushlogin /root/.hushlogin
                    $s rsync -v -K -a --force --include=".*" .bashrc ~/.bashrc
                    $s rsync -v -K -a --force --include=".*" .bashrc /root/.bashrc
                    $s rsync -v -K -a --force --include=".*" .config ~/
                    $s rsync -v -K -a --force --include=".*" .kde ~/
                    $s rsync -v -K -a --force --include=".*" .local ~/
                    $s rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/
                    $s rsync -v -K -a --force --include=".*" .kodi ~/
                    $s rsync -v -K -a --force --include=".*" MalakasUniverse /usr/share/wallpapers/
                    
                    
                    
                    
                    
                    
                    
    ### <<<< ADJUST BROWSERS >>>> - 1 firefox, 2 brave >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        echo -e "${yellow}"
echo ".....................................................................
If setup gets stuck on this screen, just open and close firefox for it to speed up...
.....................................................................
Don't forget to go to settings in Firefox after the setup and enabling the addons that come preinstalled in settings>extensions>enable...
If they appear enabled in settings but do not show up on the top bar of Firefox just disable and re-enable them...
....................................................................."
        echo -e "${restore}"

 
cd $basicsetup/.mozilla/firefox/.default-release
                    
                    
                    
                    
                # make sure firefox generates config
                    #inotifywait -m -e create /tmp/x | while read -r _ flags file; do if [[ $flags = CREATE,ISDIR ]]; then printf "subdirectory '%s' was created\n" "$file"; fi; done
                    #while $(ls /home/"$(ls /home)"/.mozilla/firefox) [ $? = 1 ] ; do
                    for i in {1..20} ; do until ls /home/$(ls /home)/.mozilla/firefox/*.default-release ; do firefox | sleep 2 | sudo pkill -f firefox ; done ; done ; if $(ls /home/$(ls /home)/.mozilla/firefox) [ $? = 0 ] ; then break ; fi 
                    # done 
                    $s rsync -v -K -a --force --include=".*" extensions/* /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/
                    #yes | firefox -install-global-extension /usr/share/mozilla/extensions/\{ec8030f7-c20a-464f-9b0e-13a3a9e97384\}/*
                    for i in $(ls /home) ; do 
                    $s \cp -rf prefs.js /home/$i/.mozilla/firefox/"$(ls /home/$i/.mozilla/firefox | grep default-release)"/prefs.js
                    $s \cp -rf extensions /home/$i/.mozilla/firefox/extensions
                    $s \cp -rf extensions /home/$i/.mozilla/firefox/"$(ls /home/$i/.mozilla/firefox | grep default-release)"/extensions ; done


                        # fix ~/  home folder permissions
                            $s chown -R $(id -u):$(id -g) $HOME
cd $source
                        
                        ### deprecated part of setup, more automated now...
                        
            # browser plugins firefox
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/youtube-audio_only/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/adblock-for-firefox/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/adblock-for-youtube/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/bloody-vikings/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/random_user_agent/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/uaswitcher/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/css-exfil-protection/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/librejs/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/adnauseam/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/webgl-fingerprint-defender/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/font-fingerprint-defender/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/switchyomega/
                #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/absolutedouble-trace/
                    #yes | firefox https://addons.mozilla.org/en-US/firefox/addon/myki-password-manager/


                                                                                                            ## section not needed - preinstalled already
            # browser addons brave (based on chrome)
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/audio-only-youtube/pkocpiliahoaohbolmkelakpiphnllog && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/scrollanywhere/jehmdpemhgfgjblpkilmeoafmkhbckhi >/dev/null && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/touch-vpn-secure-and-unli/bihmplhobchoageeokmgbdihknkjbknd && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/trace-online-tracking-pro/njkmjblmcfiobddjgebnoeldkjcplfjb  && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/random-user-agent-switche/einpaelgookohagofgnnkcfjbkkgepnp && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/user-agent-switcher-for-c/djflhoibgkdhkhhcedjiklpkjnoahfmg && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/css-exfil-protection/ibeemfhcbbikonfajhamlkdgedmekifo && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/cookie-autodelete/fhcgjolkccmbidfldomjliifgaodjagh && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/webgl-fingerprint-defende/olnbjpaejebpnokblkepbphhembdicik && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/font-fingerprint-defender/fhkphphbadjkepgfljndicmgdlndmoke && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif && $killb
                #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/trace-online-tracking-pro/njkmjblmcfiobddjgebnoeldkjcplfjb && $killb
                    #yes | brave-browser-nightly https://chrome.google.com/webstore/detail/myki-password-manager-aut/bmikpgodpkclnkgmnpphehdgcimmided && $killb

            $killb && $killf

            
            
    ### lol, dont use snap pls - disabled it again
        #$s apt purge -y snapd snap-confine && $s apt install -y snapd
        #$s systemctl enable --now snapd.socket
        #sleep 5
        #$s apparmor_parser -r /etc/apparmor.d/*snap-confine*
        #$s apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
            mkdir -p ~/.wine && $s mkdir -p /root/.wine
            # echo "127.0.0.1 release.gitkraken.com"  | $s tee -a /etc/hosts # workaround to use kraken with private repos dunno if works

                ### additional config
                $s systemctl enable fstrim.timer # fstrim is also preconfigured weekly, so we enable the service
                $s systemctl start fstrim.timer




    ### <<<< ALL PKGLIST.SH >>>> - color pkglist installation so user is aware of part, scripts can be found externally and be executed isolated for troubleshooting >
        if [ $INSTALLBUILDENV = true ] ; then $s sh pkglist0.sh ; fi
         $s sh pkglist.sh


        echo -e "${restore}"
        $s dpkg-reconfigure -f noninteractive unattended-upgrades
        $s apt-get remove --purge texlive-fonts-recommended-doc texlive-latex-base-doc texlive-latex-extra-doc texlive-latex-recommended-doc texlive-pictures-doc texlive-pstricks-doc
        $s systemctl enable --now rngd apparmor firewalld ufw fail2ban
        
        


    ### <<<< SCRIPT NEARING ITS END >>>> - check tasksel, mirrors, services and extra prior to finalizing >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
cd $source
        #$a kali-tweaks		# pick individual kali tools if needed
        #$s tasksel              # recheck setup and potentially modify. packages get changed constantly and this setup isnt being maintained constantly. even if it is not seriously. so make sure kde is fully installed prior to upgrading...


	#{     # start 2d part of log and append to latest log
    $s apt install --reinstall ca-certificates


          $s apt upgrade -f -y -t experimental --fix-broken --fix-missing --with-new-pkgs
          $s apt upgrade -f -y -t kali-bleeding-edge --fix-broken --fix-missing --with-new-pkgs
          $s apt upgrade -f -y -t kali-experimental --fix-broken --fix-missing --with-new-pkgs
          $s apt full-upgrade -f -y --fix-broken --fix-missing
        $s dpkg --configure -a
        #$s apt clean
        #$s apt autoclean

                #$s netselect-apt -n     # check out your fastests mirrors, if this messes up sources.list the synced preconfig will automatically refresh them from repo on next reboot
                #$s systemctl list-unit-files | grep enabled     # check running services after the setup is complete if necessary
                #$s service --status-all                                       # just read and check. script is easy now
                #$s systemd-analyze blame
                #$s stacer

                
                
                                
                
                
                
                
                
                
                
     # UPDATE: now http3 on latest firefox in this install enabled and preconfigured by default.
    ### <<<< DNSCRYPT >>>> - add enable and preconfigure cloudflaredoh. do not replace these settings if you want http3 and DoH, in the past buggy dnsscrypt-proxy was needed now it works without. http3 quic protocol only works with brave and is preconfigured in about:flags. also check about:gpu if you need to make changes depending in your hardware. 1.1.1.1/help for doublechecking dns does in fact run over DoH. pllugins for firefox have not been included anymore. 
    #cause of there being no workaround for remaining unattended and it doesnt support most new features anyway. manually take them if you need them from this setup. preconfiguration for hw acceleration however is included for firefox as well.
        $a rename
        #$a dnscrypt-proxy
        #dnscver="2.1.2"
        #wget https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/2.1.2/dnscrypt-proxy-linux_x86_64-$dnsver.tar.gz
        #$s tar -xf dnscrypt-proxy-linux_x86_64-"$dnscver".tar.gz
        #cd linux-x86_64
        #$s rename 's/example-/ /' *
        #$s mv dnscrypt-proxy /usr/sbin/
        #$s mv * /etc/dnscrypt-proxy
        #$s systemctl enable dnscrypt-proxy  && $s systemctl start dnscrypt-proxy   #
        $s systemctl stop --now NetworkManager NetworkManager-wait-online 
        sleep 2
        
echo '[main]
plugins=ifupdown,keyfile
dns=none
#rc-manager=unmanaged
systemd-resolved=false

[ifupdown]
managed=false' | $s tee /etc/NetworkManager/NetworkManager.conf
       
       
       #
echo 'nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 127.0.0.1
options edns0' | $s tee /etc/resolv.conf.override /etc/resolv.conf
        $s mkdir -p /run/resolvconf
        
if grep -q wrt /etc/os-release ; then 
if ! grep -q edns0 /tmp/resolv.conf.ppp ; then
echo 'options edns0' | tee -a /etc/resolv.conf.ppp ; fi ; fi
        
        
echo '#!/bin/sh
sudo mkdir -p /run/resolvconf
sudo cp -f /etc/resolv.conf.override /run/resolvconf/resolv.conf' | $s tee /etc/NetworkManager/dispatcher.d/20-resolv-conf-override


        $s chown root /etc/NetworkManager/dispatcher.d/20-resolv-conf-override && $s chmod +x /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
        $s chmod 0600 /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
        $a uuid-runtime
        #
        #/bin/bash -c 'sudo rm -rf "/etc/NetworkManager/system-connections/*'
        $s rm -rf "/etc/NetworkManager/system-connections/802-11-wireless connection 1" "/etc/NetworkManager/system-connections/Wired connection 1"
        $s touch "/etc/NetworkManager/system-connections/802-11-wireless connection 1" "/etc/NetworkManager/system-connections/Wired connection 1"

        
        
        uuidgen="$(uuidgen)"
        sleep 1
        
        
echo '[main]
plugins=ifupdown,keyfile
dns=none
#rc-manager=unmanaged
systemd-resolved=false

[ifupdown]
managed=false' | $s tee /etc/NetworkManager/NetworkManager.conf
        #
echo 'nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 127.0.0.1
options edns0' | $s tee /etc/resolv.conf.override /etc/resolv.conf


        
        $s mkdir -p /run/resolvconf
        
        

        echo '#!/bin/sh
sudo mkdir -p /run/resolvconf
sudo cp -f /etc/resolv.conf.override /run/resolvconf/resolv.conf' | $s tee /etc/NetworkManager/dispatcher.d/20-resolv-conf-override


        
        $s chown root /etc/NetworkManager/dispatcher.d/20-resolv-conf-override && $s chmod +x /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
        $s chmod 0600 /etc/NetworkManager/dispatcher.d/20-resolv-conf-override
        $a uuid-runtime
        #
        $s rm -rf "/etc/NetworkManager/system-connections/*"
        $s rm -rf '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        $s touch '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        $s chown root '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        $s chmod 0666 '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        
        

        uuidgen="$(uuidgen)"
        sleep 1
        

echo '[connection]
id=802-11-wireless connection 1
uuid=
type=wifi
metered=2
zone=block

[wifi]
# cloned-mac-address=1A:76:38:6B:A9:A1 # leave disabled handled by macchanger
mode=infrastructure
ssid=YourWifiHere

[ipv4]
dns=1.1.1.1;1.0.0.1;
dns-search=
ignore-auto-dns=true
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=disabled

[proxy]' | $s tee '/etc/NetworkManager/system-connections/802-11-wireless connection 1'



        $s sed -i '/uuid/c\uuid='"$uuidgen"'' "/etc/NetworkManager/system-connections/802-11-wireless connection 1"
        
        


echo '[connection]
id=Wired connection 1
uuid=
type=ethernet
metered=2
zone=block

[ethernet]
# cloned-mac-address=CA:11:D1:A5:7E:1D # leave disabled handled by macchanger

[ipv4]
dns=1.1.1.1;1.0.0.1;
dns-search=
ignore-auto-dns=true
method=auto

[ipv6]
addr-gen-mode=stable-privacy
method=disabled

[proxy]' | $s tee '/etc/NetworkManager/system-connections/Wired connection 1'



        $s sed -i 's/uuid/uuid='"$uuidgen"'/g' '/etc/NetworkManager/system-connections/Wired connection 1'
        
        

        $s chown root '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        $s chmod 0600 '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
        
        
        
    #$s systemctl unmask NetworkManager-wait-online 
    #$s systemctl stop --now NetworkManager NetworkManager-wait-online 
    #$s systemctl enable --now NetworkManager NetworkManager-wait-online 
    #$s systemctl restart --now NetworkManager NetworkManager-wait-online 
    #$s systemctl stop NetworkManager-wait-online && $s systemctl mask NetworkManager-wait-online
    

    

    $s apt remove -f -y remove resolvconf dnsmasq
    
    
   
   
            $s mv /var/lib/dpkg/info/install-info.postinst /var/lib/dpkg/info/install-info.postinst.bad
                
                
                
                cd $basicsetup
                ### sync more preconfig that wasnt convenient prior to pkg installation
                    $s rsync -v -K -a --force --include=".*" system.conf /etc/systemd/system.conf
                    $s rsync -v -K -a --force --include=".*" journald.conf /etc/systemd/journald.conf
                
                
                
                
                
            ### run preconfiguration script and meanwhile update /etc/hosts with blocklist and dns optimizations
                $s sh /etc/rc.local $sl # execute copied init.sh which now is /etc/rc.local
                $s sh /etc/update_hosts.sh $sl     # remember we have executed the init.sh which is rc.local which includes stock pihole blocklists, so during setup we execute an update
                $s fc-cache -rfv

                
                
                
                
                    ### disable and mask unneeded services
$s systemctl disable plymouth-log pulseaudio-enable-autospawn uuidd x11-common avahi-daemon bluetooth gdomap smartmontools speech-dispatcher avahi-daemon.service bluetooth.service cron ifupdown-wait-online.service geoclue.service keyboard-setup.service logrotate.service ModemManager.service NetworkManager-wait-online.service plymouth-quit-wait.service plymouth-log.service pulseaudio-enable-autospawn.service remote-fs.service rsyslog.service smartmontools.service speech-dispatcher.service speech-dispatcherd.service systemd-networkd-wait-online.service x11-common.service uuidd.service syslog.socket bluetooth.target remote-fs-pre.target remote-fs.target rpcbind.target printer.target cups                
                
$s systemctl mask plymouth-log pulseaudio-enable-autospawn uuidd x11-common avahi-daemon bluetooth gdomap smartmontools speech-dispatcher avahi-daemon.service bluetooth.service cron ifupdown-wait-online.service geoclue.service keyboard-setup.service logrotate.service ModemManager.service NetworkManager-wait-online.service plymouth-quit-wait.service plymouth-log.service pulseaudio-enable-autospawn.service remote-fs.service rsyslog.service smartmontools.service speech-dispatcher.service speech-dispatcherd.service systemd-networkd-wait-online.service x11-common.service uuidd.service syslog.socket bluetooth.target remote-fs-pre.target remote-fs.target rpcbind.target printer.target cups    

$s systemctl enable --now dbus-broker

    $s update-initramfs -u -k all
    $s mkinitramfs -c lz4 -o /boot/initrd.img-*
    
    # switch to dracut
    $a dracut
    $s dracut --regenerate-all --lz4 --add-fstab /etc/fstab --fstab --aggressive-strip --host-only -f # --no-early-microcode
    
    $s systemctl disable --now mdmonitor.service mdmonitor-oneshot.service mdcheck_start.service mdcheck_continue.service mdadm.service mdadm-shutdown.service lvm2-monitor.service lvm2-lvmpolld.service lvm2-lvmpolld.socket
    
    $s systemctl mask --now mdmonitor.service mdmonitor-oneshot.service mdcheck_start.service mdcheck_continue.service mdadm.service mdadm-shutdown.service lvm2-monitor.service lvm2-lvmpolld.service lvm2-lvmpolld.socket
    
        ### <<<< DISK MAINTENANCE >>>> - as this script is for me i want to reduce clutter, for ease of maintenance edit yourself. im on xfs. >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        #$s rm -rf $source/tmp
        #git reset --hard    # reset and clean up source
        #git clean -xfd
        #$s passwd -l root # remove root account, use init=/bin/bash instead as parameter in grub
        
        
        echo -e "${magenta}" && echo "Finalizing with fstrim / ... be patient." && echo -e "${yellow}"
    

           # $s xfs_repair -f /dev/$hdd
           # $s xfs_fsr -f /dev/$hdd
           # $s xfs_repair -f /dev/$nvme
           # $s xfs_fsr -f /dev/$nvme
         
            #wget http://ftp.de.debian.org/debian/pool/main/p/prelink/execstack_0.0.20131005-1+b10_amd64.deb
            #$s dpkg -i execstack*.deb
            #wget http://ftp.de.debian.org/debian/pool/main/p/prelink/prelink_0.0.20131005-1+b10_amd64.deb
            #$s dpkg -i prelink*.deb
            #$s apt -f -y install
            #$s prelink -amfR

            $s fstrim /






####################################################### display header ####
echo -e "${magenta}" && echo ".::BASIC-LINUX-SETUP::."
echo -e "${yellow}" && echo "DONE - WAKE UP...!..." && echo "" && echo ""
###########################################################################
###########################################################################


	echo " .:::: "$(uname -a)" ::::." && echo "" && echo "" ### display kernel setup for log after installation
	#echo "        STOP BLS_LOG" && echo ""





	# stop first part of log again for stdin
	#} 2>&1 | tee ~/Desktop/BLS-LOGS/BLS_LOG-`date +%Y-%m-%d.%H:%M:%S`.log

		# stop 2d log
		#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)
		
DATE_END=$(date +"%s") ; DIFF=$(($DATE_END - $DATE_START))
echo "Setup took: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds to complete." && echo "" && echo ""
read -p "    !!!!!! PRESS < ENTER > TO REBOOT Ctrl+C TO CANCEL !!!!!!!    "     ### REBOOT


        reboot



#####################################################################################################
####### END #########################################################################################
#####################################################################################################
