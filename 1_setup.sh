#!/bin/bash
###############################################################
###############################################################
### basic personal setup debian minimal                     ###
###############################################################
###             https://github.com/thanasxda                ###
###############################################################
### thanasxda 15927885+thanasxda@users.noreply.github.com   ###
###############################################################
### explanation at every step, read to know. be warned.     ###
### DON'T RUN AS SU!!! DIRS ARE NOT /home/root/             ###
###############################################################
###############################################################
### dir variables - don't change                            ###
source="$(pwd)"                                             ###
basicsetup=$source/.basicsetup                              ###
###############################################################
### set bash colors                                         ####
magenta="\033[05;1;95m"                                     #####
yellow="\033[1;93m"                                         #######
restore="\033[0m"                                           ##########
###########################################################################
### display header                                                      ###
echo -e "${magenta}"                                                    ###
echo ".::BASIC-LINUX-SETUP::. - mainly for debian"                      ###
echo -e "${restore}"                                                    ###
###########################################################################
####### START #############################################################

sudo chmod 755 *

sudo ./2_restore-debian-sources.sh

systemctl enable --now apparmor.service

sudo apt -f install -y aptitude

cd $source
sudo cp *.list /etc/apt/sources.list.d/
sudo rm -rf /etc/apt/sources.list.d/*sources.list
sudo cp preferences /etc/apt/
sudo cp preferences /etc/apt/preferences.d/



####### GENERAL DIRECTORIES #########################################################################
#####################################################################################################
### set up dirs of git and prebuilt toolchain
git=~/GIT
mkdir -p $git #&& mkdir -p $tc




####### MINOR LINUX OPTIMIZATIONS ###################################################################
#####################################################################################################
### optimizations press -y & enter
printf 'y\n' | sudo dpkg-reconfigure dash
sudo aptitude -f install -y kexec-tools
sudo apt -f install -y && sudo apt --fix-missing install -y
printf 'y\ny\n' | sudo dpkg-reconfigure kexec-tools


### brave
sudo aptitude -f install -y apt-transport-https curl
curl -s https://brave-browser-apt-nightly.s3.brave.com/brave-core-nightly.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-nightly.list
sudo apt update
sudo apt install -y brave-browser-nightly


####### GIT CONFIGURATION ###########################################################################
#####################################################################################################
### your git name & email - unhash and set up for personal usage
sudo aptitude -f install -y git curl
#git config --global user.name thanasxda
#git config --global user.email 15927885+thanasxda@users.noreply.github.com




####### EULA LICENSE AGREEMENTS #####################################################################
#####################################################################################################
### take care of licenses first  #
sudo apt update                  #
echo -e "${yellow}"              #
echo LICENSES                    #
echo -e "${restore}"             #
##################################
echo ttf-mscorefonts-installer ttf-mscorefonts-installer/accepted-ttf-mscorefonts-installer-eula select true | sudo debconf-set-selections
sudo aptitude -f install -y ttf-mscorefonts-installer




####### SYSTEM CONFIGURATION ########################################################################
#####################################################################################################
### configure system customization
echo -e "${yellow}"              #
echo MINOR SYSTEM CUSTOMIZATION  #
echo -e "${restore}"             #
##################################
echo -e "${yellow}"              #
echo setting up weekly fstrim... #
echo -e "${restore}"             #
##################################
### trigger weekly fstrim
sudo systemctl start fstrim.timer

### set up init.sh for kernel configuration #########################################
echo -e "${yellow}"                                                                 #
echo setting up userspace kernel configuration                                      #
echo on root filesystem /init.sh can be found, adjust it to your needs if necessary #
echo -e "${restore}"                                                                #
#####################################################################################
cd $basicsetup
#
sudo aptitude -f install -y rsync
chmod +x init.sh
sudo \cp init.sh /init.sh
if grep -q "@reboot root /init.sh" /etc/crontab
then
echo "Flag exists"
else
sudo sed -i "\$a@reboot root /init.sh" /etc/crontab
fi

### copy wallpaper & grub splash
sudo rsync -v -K -a --force  MalakasUniverse /usr/share/wallpapers
#sudo \cp -rf  splash.jpg /boot/grub

### copy kde optimal preconfiguration
sudo pkill brave-browser-nightly
#sudo pkill brave-browser-beta
sudo rsync -v -K -a --force --include=".*" .config ~/
sudo rsync -v -K -a --force --include=".*" .kde ~/
sudo rsync -v -K -a --force --include=".*" .local ~/
sudo rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/
sudo rsync -v -K -a --force --include=".*" .kodi ~/

### fix ownership preconfig - rare cases
cd ~/ && sudo chown -R $(id -u):$(id -g) $HOME


####### FIREFOX CONFIGURATION
### installation firefox addons, install as firefox opens. close firefox and reclick on console ###############
#echo -e "${magenta}"                                                                                          #
#echo INSTALL FIREFOX ADDONS ONE BY ONE, AFTER CLOSE FIREFOX AND CLICK ON CLI TILL ALL ADDONS ARE INSTALLED!!! #
#echo -e "${restore}"                                                                                          #
###############################################################################################################
cd $source

yes | brave-browser-nightly https://chrome.google.com/webstore/detail/audio-only-youtube/pkocpiliahoaohbolmkelakpiphnllog
yes | brave-browser-nightly https://chrome.google.com/webstore/detail/scrollanywhere/jehmdpemhgfgjblpkilmeoafmkhbckhi


####### SWAP CONFIGURATION ##########################################################################
#####################################################################################################
### configure swap               #
echo -e "${yellow}"              #
echo CONFIGURE SWAP              #
echo -e "${restore}"             #
##################################
swap=5000000
swappiness=90
##################################
if grep -q "/swapfile" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i "\$a/swapfile    none    swap    sw    0    0" /etc/fstab
fi
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=$swap count=1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon -a
sudo free -h
### set swappiness to a low value for ram preference
sudo sysctl vm.swappiness=$swappiness



####### SYSTEM CONFIGURATION ########################################################################
#####################################################################################################
### grub config & system optimization
echo -e "${yellow}"                 #
echo GRUB CONFIG                    #
echo -e "${restore}"                #
#####################################
### switch off mitigations improving linux performance
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash log_priority=0 udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
sudo sed -i '/GRUB_CMDLINE_LINUX/c\GRUB_CMDLINE_LINUX="quiet splash log_priority=0 udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
### set grub timeout
sudo sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub
### apply grub settings
sudo update-grub2


### preconfigure ccache and mute output
if grep -q "USE_CCACHE=1" ~/.bashrc
then
echo "Flag exists"
else
sudo sed -i "\$aexport USE_CCACHE=1" ~/.bashrc
sudo sed -i "\$aexport USE_PREBUILT_CACHE=1" ~/.bashrc
sudo sed -i "\$aexport PREBUILT_CACHE_DIR=~/.ccache" ~/.bashrc
sudo sed -i "\$aexport CCACHE_DIR=~/.ccache" ~/.bashrc
sudo sed -i "\$accache -M 30G >/dev/null" ~/.bashrc
fi

### fstab flags
### ext4
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i 's/errors=remount-ro/commit=60,discard,quota,lazytime,errors=remount-ro/g' /etc/fstab
fi
### xfs
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i 's/xfs     defaults/xfs     defaults,quota,discard,lazytime,noatime/g' /etc/fstab
fi
### f2fs
if grep -q "f2fs     rw,noatime,lazytime" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i 's/f2fs    defaults,noatime/f2fs     rw,noatime,lazytime,background_gc=on,discard,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,alloc_mode=default,fsync_mode=posix,quota/g' /etc/fstab
fi
### tmpfs
sudo sed -i 's+/tmp           tmpfs   defaults,noatime,mode=1777 0 0++g' /etc/fstab
if grep -q "/run/shm" /etc/fstab
then
echo "Flag exists"
else
  sudo sed -i "\$atmpfs    /tmp        tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /var/tmp    tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /run/shm    tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
fi




####### BUILD ENVIRONMENT SETUP #####################################################################
#####################################################################################################
### build env scripts ############
echo -e "${yellow}"              #
echo BUILD ENV SCRIPTS           #
echo -e "${restore}"             #
##################################
cd $git
#
### add i386 architecture needed for env
sudo dpkg --add-architecture i386
sudo aptitude update
git clone https://github.com/akhilnarang/scripts.git
cd scripts/setup
Keys.ENTER | ./android_build_env.sh
Keys.ENTER | ./ccache.sh

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y




####### LINUX REPOSITORY SOURCES SETUP ##############################################################
### setup repos !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
echo -e "${yellow}"              #
echo SET UP REPOS                #
echo -e "${restore}"             #
##################################

### fetch keys ubuntu
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1378B444
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
### fetch keys llvm git
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
### obaif
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 957d2708a03a4626
### kodi
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6d975c4791e7ee5e
### git
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys a1715d88e1df1f24
### usb stuff
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3729827454b8c8ac
### multimedia
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
### google
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
### tvheadend
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 89942AAE5CEAA174
sudo apt-get -y install coreutils wget apt-transport-https lsb-release ca-certificates
sudo wget -qO- https://doozer.io/keys/tvheadend/tvheadend/pgp | sudo apt-key add -
### llvm
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 15CF4D18AF4F7421
### opensuse
sudo wget -qO- https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/other-deps/Debian_Unstable/Release.key | sudo apt-key add -
sudo wget -qO- https://download.opensuse.org/repositories/Debian:/debbuild/Debian_Testing/Release.key | sudo apt-key add -
###
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E6D4736255751E5D
### kali
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6
###
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2836cb0a8ac93f7a
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B8AC39B0876D807E
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A2F33E359F038ED9

cd $source
sudo cp *.list /etc/apt/sources.list.d/
sudo rm -rf /etc/apt/sources.list.d/*sources.list
sudo cp preferences /etc/apt/
sudo cp preferences /etc/apt/preferences.d/



####### THANAS PACKAGES #############################################################################
#####################################################################################################
### thanas build env, vulkan drivers, codecs and extras
echo -e "${yellow}"              #
echo THANAS PACKAGES             #
echo -e "${restore}"             #
##################################
sudo apt update
sudo aptitude update

sudo aptitude -f install -y android-tools-adb android-tools-fastboot build-essential ccache clang clang-11 clang-11-doc clang-format clang-format-11 clang-tidy clang-tools-11 clangd clangd-11 cmake curl dash dkms flatpak gcc gdebi gedit gettext git git-svn gnupg gstreamer1.0-qt5 help2man lib32ncurses-dev lib32readline-dev lib32z1 lib32z1-dev libbz2-dev libc++-11-dev libc++abi-11-dev libc6-dev libc6-dev-i386 libcap-dev libclang-11-dev libclang-dev libclang1 libclang1-11 libelf-dev libexpat1-dev libffi-dev libfuzzer-11-dev libghc-bzlib-dev libgl1-mesa-dev libllvm-11-ocaml-dev libllvm-ocaml-dev libllvm11 libncurses-dev libncurses5 libncurses5-dev libomp-11-dev libsdl1.2-dev libssl-dev libvdpau-va-gl1 libvulkan1 libx11-dev libxml2 libxml2-dev libxml2-utils linux-libc-dev linux-tools-common lld lld-11 lldb llvm llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime llvm-dev llvm-runtime lzma lzma-alone lzma-dev lzop m4 make maven mesa-opencl-icd mesa-va-drivers mesa-vulkan-drivers ocl-icd-libopencl1 openssh-client patch pigz pkg-config python-all-dev python-clang python3.8 python3-distutils qt5-default rsync snapd tasksel texinfo txt2man unzip vdpau-driver-all vlc vulkan-utils wget x11proto-core-dev xsltproc yasm zip zlib1g-dev mpc muon

### extras
sudo aptitude -f install -y fwupd plasma-discover-backend-fwupd cpufrequtils ksystemlog libavcodec-extra preload w64codecs deb-multimedia-keyring ffmpeg

### ensure full clang
sudo aptitude -f install -y libomp-11-dev llvm-11 llvm clang-11 lld-11 gcc clang binutils make flex bison bc build-essential libncurses-dev libssl-dev libelf-dev qt5-default libclang-common-11-dev

### npm
sudo apt -f install -y npm && sudo apt -f install -y && sudo npm cache clean -f && sudo npm cache clean -f && sudo npm install npm@latest -g

### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### SELECT EXPLICITLY FOR KDE PLASMA DESKTOP ENVIRONMENT! needs manual enabling from within settings
sudo apt install -y plasma-workspace-wayland kwayland-integration wayland-protocols
### allow root privilege under wayland and supress output
if grep -q "xhost +si:localuser:root >/dev/null" ~/.bashrc
then
echo "Flag exists"
else
sudo sed -i "\$axhost +si:localuser:root >/dev/null" ~/.bashrc
fi
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

sudo aptitude -f install -y f2fs-tools xfsprogs rt-tests net-tools
sudo aptitude -f install -y wine wine32
sudo aptitude -f install -y kodi-pvr-hts kodi-x11 kodi-wayland kodi
sudo aptitude -f install -y gimp audacity

sudo aptitude -f install -y alien bleachbit atom
sudo aptitude -f install -y libmng2 mencoder libenca0 libvorbisidec1 libdvdcss2
sudo aptitude -f install -y libavcodec-extra58 libavcodec-extra

### extra
sudo aptitude -f install -y psensor flatpak

### fwupd
sudo aptitude -f install -y fwupd plasma-discover-backend-fwupd

#sudo aptitude -f install -y appimagelauncher

#sudo echo 'deb http://gr.archive.ubuntu.com/ubuntu/ groovy main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo aptitude -f install -y kubuntu-restricted-extras ubuntu-restricted-extras
sudo aptitude -f install -y x264 x265
#sudo sed -i 's+deb http://gr.archive.ubuntu.com/ubuntu/ groovy main restricted universe multiverse++g' /etc/apt/sources.list

### extra .deb packages
cd $source
#

wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf gitkraken*

### google
wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
sudo dpkg -i google-earth-pro*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf google-earth-pro*

wget https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Linux-x64.deb
sudo dpkg -i VNC-V*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf VNC-V*

wget http://ftp.br.debian.org/debian/pool/main/d/diffuse/diffuse_0.4.8-4_all.deb
sudo dpkg -i diffuse*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf diffuse*

wget https://atom.io/download/deb
sudo dpkg -i deb*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf deb*

wget https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/kuu_18.9.3-0~201902031503~ubuntu18.04.1_amd64.deb
sudo dpkg -i ukuu*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf ukuu*


### enable snap
sudo apt purge -y snapd snap-confine && sudo apt install -y snapd
sudo systemctl enable --now snapd.socket
if grep -q "export PATH" ~/.bashrc
then
echo "Flag exists"
else
sudo sed -i "\$aexport PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH'" ~/.bashrc
fi
sleep 5
sudo apparmor_parser -r /etc/apparmor.d/*snap-confine*
sudo apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
#sudo snap install ngrok

###### GITHUB REPOSITORIES ##########################################################################
#####################################################################################################
### git stuff                    #
echo -e "${yellow}"              #
echo GIT EXTRAS                  #
echo -e "${restore}"             #
##################################
#cd $git
#


#sudo aptitude -f install -y kali-tools-exploitation kali-tools-hardware kali-tools-wireless kali-tools-rfid kali-tools-fuzzing kali-tools-reporting kali-tools-sdr kali-tools-bluetooth kali-tools-social-engineering kali-tools-crypto-stego kali-tools-database kali-tools-voip kali-tools-802-11 kali-tools-post-exploitation kali-tools-sniffing-spoofing kali-tools-top10 kali-tools-reverse-engineering kali-tools-web kali-tools-vulnerability kali-tools-forensics kali-tools-information-gathering kali-tools-windows-resources kali-menu

sudo apt full-upgrade -y
sudo apt -f install -y kde-config-systemd
sudo apt install -y -t Debian_Unstable plasma-desktop lasma-desktop plasma-workspace kde-baseapps sddm xserver-xorg kwin-x11 kde-config-systemd plasma-desktop-data libkfontinst5  libkfontinstui5 libkworkspace5-5 libnotificationmanager1 libtaskmanager6abi1 kwin-x11 plasma-workspace kinfocenter
sudo apt upgrade --with-new-pkgs -t Debian_Unstable -y

### microcode
sudo apt remove -y intel-microcode
sudo apt remove -y amd-microcode

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y
sudo apt upgrade --with-new-pkgs -y
sudo apt --purge autoremove -y && sudo apt purge
sudo apt autoclean && sudo apt clean
sudo aptitude -f install -y apt-listbugs apt-listchanges
sudo aptitude install -y prelink irqbalance && sudo prelink -amR




####### SETUP FINISHED ##############################################################################
#####################################################################################################
echo -e "${magenta}"                                                                                #
echo ...                                                                                            #
echo DONE WITH BASIC SETUP! COMPILING AND AUTO INSTALLING THANAS-x86-64-KERNEL                      #
echo ...                                                                                            #
echo -e "${restore}"                                                                                #
#####################################################################################################




####### KERNEL COMPILATION/INSTALLATION #############################################################
#####################################################################################################
### auto compile and install thanas x86-64 kernel on latest llvm
### can be done isolated as well on any distro, use ./build.sh
cd $git
git clone --depth=1 https://github.com/thanasxda/thanas-x86-64-kernel.git
cd thanas-x86-64-kernel && sudo chmod 755 *.sh
./1*




#####################################################################################################
####### END #########################################################################################
#####################################################################################################
