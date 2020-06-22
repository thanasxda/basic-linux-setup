#!/bin/bash
###############################################################
###############################################################
### basic personal setup v2.1 (KDE Kali)                    ###
### contains basic build env & plasma preconfig & extras    ###
### https://cdimage.kali.org/kali-images/kali-weekly/       ###
###############################################################
###             https://github.com/thanasxda                ###
###############################################################
### thanasxda 15927885+thanasxda@users.noreply.github.com   ###
###############################################################
### explanation at every step, read to know. be warned.     ###
### DON'T RUN AS SU!!! DIRS ARE NOT /home/root/             ###
###############################################################
### optionally install "kde connect" app on your android    ###
###############################################################
### script meant mainly as unattended if needed adjust      ###
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
echo ".::BASIC-LINUX-SETUP::. V2.1 - mainly for (KDE) Kali linux"       ###
echo -e "${restore}"                                                    ###
###########################################################################
####### START #############################################################
# all underneath setup parts marked with many "!!!" need to be set according to your distro
# for transposable compatibility in case it is not used for KDE Kali

wget https://out7.hex-rays.com/files/idafree70_linux.run
sudo chmod 755 *
./idafree70_linux.run
sudo rm -rf idafree70_linux.run

systemctl enable --now apparmor.service

### first of all install aptitude to ease out package conflicts
sudo apt -f install -y aptitude




####### GENERAL DIRECTORIES #########################################################################
#####################################################################################################
### set up dirs of git and prebuilt toolchain
git=~/GIT
tc=~/TOOLCHAIN
mkdir -p $git && mkdir -p $tc




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
sudo apt install brave-browser-nightly


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
cd / && sudo ./init.sh
cd $basicsetup
if grep -q "@reboot root -l /init.sh" /etc/crontab
then
echo "Flag exists"
else
sudo sed -i "\$a@reboot root /init.sh" /etc/crontab
fi

### copy wallpaper & grub splash
sudo rsync -v -K -a --force  MalakasUniverse /usr/share/wallpapers
sudo \cp -rf  splash.jpg /boot/grub

### copy kde optimal preconfiguration
sudo pkill brave-browser-nightly
sudo pkill brave-browser-beta
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
#sudo pkill firefox
#echo sorry for that firefox crash. part of setup...

### copy firefox advanced settings and enable hw acceleration
#cd $basicsetup/.mozilla/firefox/.default-release
#sudo \cp -rf prefs.js ~/.mozilla/firefox/*.default-esr/prefs.js
cd $source

### install browser modules
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3539016/adblock_plus-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3560936/duckduckgo_privacy_essentials-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3502002/youtube_audio_only-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3053229/adblocker_for_youtubetm-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3553672/youtube_video_and_audio_downloader_webex-
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3550879/plasma_integration-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3534334/video_downloadhelper-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/805784/kde_connect-*
#yes | firefox https://addons.mozilla.org/firefox/downloads/file/3547657/hotspot_shield_free_vpn_proxy_unlimited_vpn-*

#yes | brave-browser-beta https://chrome.google.com/webstore/detail/duckduckgo-privacy-essent/bkdgflcldnnnapblkhphbgpggdiikppg
#yes | brave-browser-beta https://chrome.google.com/webstore/detail/adblock-%E2%80%94-best-ad-blocker/gighmmpiobklfepjocnamgkkbiglidom
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
### LVM
#/vgkubuntu-swap_1




####### SYSTEM CONFIGURATION ########################################################################
#####################################################################################################
### grub config & system optimization
echo -e "${yellow}"                 #
echo GRUB CONFIG                    #
echo -e "${restore}"                #
#####################################
### switch off mitigations improving linux performance
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash udev.log_priority=3 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0"' /etc/default/grub
sudo sed -i '/GRUB_CMDLINE_LINUX/c\GRUB_CMDLINE_LINUX="quiet splash udev.log_priority=3 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0"' /etc/default/grub
### set grub timeout
sudo sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub
### set grub min resolution
sudo sed -i "/GRUB_GFXMODE/c\GRUB_GFXMODE=1024x768" /etc/default/grub
### set grub wallpaper
sudo sed -i '/GRUB_BACKGROUND/c\GRUB_BACKGROUND="/boot/grub/splash.jpg"' /etc/default/grub
### apply grub settings
sudo update-grub2
### grub auto detection
GRUB_PATH=$(sudo fdisk -l | grep '^/dev/[a-z]*[0-9]' | awk '$2 == "*"' | cut -d" " -f1 | cut -c1-8)
sudo grub-install $GRUB_PATH

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
sudo sed -i 's/errors=remount-ro/commit=60,discard,quota,lazytime,nodiratime,errors=remount-ro/g' /etc/fstab
fi
### xfs
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i 's/xfs     defaults/xfs     defaults,quota,discard,lazytime,noatime,nodiratime/g' /etc/fstab
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
  sudo sed -i "\$atmpfs    /tmp        tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /var/tmp    tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /run/shm    tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
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

### daily llvm git builds - not always support for lto
### DO NOT change distro on the llvm repos. these branches are only meant for the toolchain
### and will ensure you will always use latest llvm when using "make CC=clang"
#llvm_1='deb http://apt.llvm.org/unstable/ llvm-toolchain main'
#llvm_2='deb-src http://apt.llvm.org/unstable/ llvm-toolchain main'

#new_sources=("$source_1" "$source_2" "$source_3" "$source_4" "$llvm_1" "$llvm_2")

#for i in ${!new_sources[@]}; do
#    if ! grep -q "${new_sources[$i]}" /etc/apt/sources.list; then
#        echo "${new_sources[$i]}" | sudo tee -a /etc/apt/sources.list
#        echo "Added ${new_sources[$i]} to source list"
#    fi
#done

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
### appimage
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys4af9b16f75ef2fca
### multimedia
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5C808C2B65558117
### google
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 78BD65473CB3BD13
### tvheadend
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 89942AAE5CEAA174
sudo apt-get -y install coreutils wget apt-transport-https lsb-release ca-certificates
sudo wget -qO- https://doozer.io/keys/tvheadend/tvheadend/pgp | sudo apt-key add -


##################################
####### PPA'S
### mesa drivers and extras
sudo add-apt-repository -y ppa:oibaf/graphics-drivers
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo add-apt-repository -y ppa:team-xbmc/unstable
sudo add-apt-repository -y ppa:team-xbmc/xbmc-nightly
#sudo add-apt-repository -y ppa:appimagelauncher-team/stable

### fix distro syncing for now (forceful method - for now must be overridden)
sudo bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu disco main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-xbmc-nightly-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu cosmic main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-unstable-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-ppa-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list'
sudo sh -c 'echo "deb https://apt.tvheadend.org/stable stretch main" | tee /etc/apt/sources.list.d/tvheadend.list'
sudo sh -c 'echo "deb https://apt.tvheadend.org/unstablestable stretch main" | tee /etc/apt/sources.list.d/tvheadend.list'

### add debian multimedia
if grep -q "www.deb-multimedia.org" /etc/apt/sources.list
then
echo "Flag exists"
else
sudo sed -i 's/deb [arch=amd64,i386] http://www.deb-multimedia.org sid main non-free/g' /etc/apt/sources.list
sudo sed -i 's/deb [arch=amd64,i386] http://www.deb-multimedia.org unstable main non-free/g' /etc/apt/sources.list
fi

### kali
if grep -q "kali-dev" /etc/apt/sources.list
then
echo "Flag exists"
else
sudo echo '
deb http://http.kali.org/kali kali-debian-picks main non-free contrib
deb http://http.kali.org/kali debian-testing main non-free contrib
deb http://http.kali.org/kali kali-dev main non-free contrib
deb http://http.kali.org/kali kali-experimental main non-free contrib
deb http://http.kali.org/kali kali-last-snapshot main non-free contrib
' | sudo tee -a /etc/apt/sources.list
fi

### add debian experimental
if grep -q "debian experimental main" /etc/apt/sources.list
then
echo "Flag exists"
else
sudo sed -i 's/#deb http://http.debian.net/debian experimental main contrib non-free/g' /etc/apt/sources.list
fi

### add debian unstable repos
#if grep -q 'deb http://deb.debian.org/debian/ unstable main contrib non-free' /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#sudo echo '# debian unstable repos - will break distro' | sudo tee -a /etc/apt/sources.list
#sudo echo '# only use for rare individual packages' | sudo tee -a /etc/apt/sources.list
#sudo echo 'deb http://deb.debian.org/debian/ unstable main contrib non-free' | sudo tee -a /etc/apt/sources.list
#sudo echo 'deb-src http://deb.debian.org/debian/ unstable main contrib non-free' | sudo tee -a /etc/apt/sources.list
#fi

### add llvm repos
if grep -q 'deb http://apt.llvm.org/unstable/ llvm-toolchain main' /etc/apt/sources.list
then
echo "Flag exists"
else
sudo echo '### llvm git repos' | sudo tee -a /etc/apt/sources.list
sudo echo 'deb http://apt.llvm.org/unstable/ llvm-toolchain main' | sudo tee -a /etc/apt/sources.list
sudo echo 'deb-src http://apt.llvm.org/unstable/ llvm-toolchain main' | sudo tee -a /etc/apt/sources.list
#sudo echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main' | sudo tee -a /etc/apt/sources.list
#sudo echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main' | sudo tee -a /etc/apt/sources.list
fi



####### THANAS PACKAGES #############################################################################
#####################################################################################################
### thanas build env, vulkan drivers, codecs and extras
echo -e "${yellow}"              #
echo THANAS PACKAGES             #
echo -e "${restore}"             #
##################################
sudo apt update

sudo aptitude -f install -y amd64-microcode android-sdk android-tools-adb android-tools-fastboot autoconf autoconf-archive autogen automake autopoint autotools-dev bash bc binfmt-support binutils-dev bison build-essential bzip2 ca-certificates ccache clang clang-11 clang-11-doc clang-format clang-format-11 clang-tidy clang-tools-11 clangd clangd-11 cmake curl dash dkms dpkg-dev ecj expat fastjar file flatpak flex g++ gawk gcc gcc-10 gdebi gedit gettext git git-svn gnupg gparted gperf gstreamer1.0-qt5 help2man imagemagick intel-microcode java-propose-classpath kubuntu-restricted-extras kwrite lib32ncurses-dev lib32readline-dev lib32z1 lib32z1-dev libbz2-dev libc++-11-dev libc++abi-11-dev libc6-dev libc6-dev-i386 libcap-dev libclang-11-dev libclang-dev libclang1 libclang1-11 libelf-dev libexpat1-dev libffi-dev libfuzzer-11-dev libghc-bzlib-dev libgl1-mesa-dev libgmp-dev libjpeg8-dev libllvm-11-ocaml-dev libllvm-ocaml-dev libllvm11 liblz4-1 liblz4-1:i386 liblz4-dev liblz4-java liblz4-jni liblz4-tool liblzma-dev liblzma-doc liblzma5 libmpc-dev libmpfr-dev libncurses-dev libncurses5 libncurses5-dev libomp-11-dev libsdl1.2-dev libssl-dev libtool libtool-bin libvdpau-va-gl1 libvulkan1 libx11-dev libxml2 libxml2-dev libxml2-utils linux-libc-dev linux-tools-common lld lld-11 lldb llvm llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime llvm-dev llvm-runtime lzma lzma-alone lzma-dev lzop m4 make maven mesa-opencl-icd mesa-va-drivers mesa-vulkan-drivers nautilus ninja-build ocl-icd-libopencl1 openjdk-8-jdk openssh-client openssh-server optipng patch pigz pkg-config pngcrush python-all-dev python-clang python3.8 python3-distutils qt5-default rsync schedtool shtool snapd squashfs-tools subversion tasksel texinfo txt2man ubuntu-restricted-extras unzip vdpau-driver-all vlc vulkan-utils wget x11proto-core-dev xsltproc yasm zip zlib1g-dev mpc dkms

### extras
sudo aptitude -f install -y fwupd plasma-discover-backend-fwupd cpufrequtils ksystemlog libavcodec-extra preload w64codecs deb-multimedia-keyring ffmpeg

### list mesa drivers seperately
sudo aptitude -f install -y vulkan-tools libd3dadapter9-mesa libd3dadapter9-mesa-dev libegl-mesa0 libegl1-mesa-dev libgl1-mesa-dev libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libgles2-mesa-dev libglu1-mesa libglu1-mesa-dev libglx-mesa0 libosmesa6 libosmesa6-dev mesa-common-dev mesa-vdpau-drivers mesa-vulkan-drivers mir-client-platform-mesa-dev vulkan-utils mesa-opencl-icd

### openwrt toolchain
sudo aptitude -f install -y subversion g++ zlib1g-dev build-essential git python python3 python3-distutils libncurses5-dev gawk gettext unzip file libssl-dev wget libelf-dev ecj fastjar java-propose-classpath

### kali full packages
sudo aptitude -f install -y kali-tools-exploitation kali-tools-hardware kali-tools-wireless kali-tools-rfid kali-tools-fuzzing kali-tools-reporting kali-tools-sdr kali-tools-bluetooth kali-tools-social-engineering kali-tools-crypto-stego kali-tools-database kali-tools-voip kali-tools-802-11 kali-tools-post-exploitation kali-tools-sniffing-spoofing kali-tools-top10 kali-tools-reverse-engineering kali-tools-web kali-tools-vulnerability kali-tools-forensics kali-tools-information-gathering kali-tools-windows-resources
sudo apt remove -y lime-forensics-dkms
sudo aptitude -f install -y routersploit

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f full-upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y

### ...
#sudo aptitude -f install -y gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi gcc-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabi
sudo aptitude -f install -y gcc-multilib
sudo aptitude -f install -y gcc-10-multilib
sudo aptitude -f install -y gcc-10-x86-64-linux-gnu-base gcc-9-x86-64-linux-gnu-base
sudo aptitude -f install -y binutils-mips-linux-gnu

### ensure full clang
sudo aptitude -f install -y llvm-11
sudo aptitude -f install -y llvm
sudo aptitude -f install -y clang-11 lld-11
sudo aptitude -f install -y clang-10 lld-10
sudo aptitude -f install -y gcc-10
sudo aptitude -f install -y gcc clang binutils make flex bison bc build-essential libncurses-dev libssl-dev libelf-dev qt5-default binutils-multiarch

### ram cache stuff
sudo aptitude -f install -y zlib1g zlib1g-dev libcryptsetup12 libcryptsetup-dev libjansson4 libjansson-dev

### kde kali
sudo aptitude install -y muon kde-baseapps kde-plasma-desktop plasma-browser-integration telegram-desktop

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
### TEMPORARILY ADD DEBIAN USNTABLE REPOS TO GET SOME PACKAGES!!!
sudo echo 'deb http://deb.debian.org/debian/ unstable main contrib non-free' | sudo tee -a /etc/apt/sources.list
sudo echo 'deb-src http://deb.debian.org/debian/ unstable main contrib non-free' | sudo tee -a /etc/apt/sources.list
sleep 5
sudo apt update --allow-insecure-repositories

### extra thanas packages
### some listed purposefully seperate to avoid future conflicts or to distinguish packages from unique repo's or ppa's
sudo aptitude -f install -y diffuse f2fs-tools rt-tests uget net-tools aircrack-ng wine32 wine
sudo aptitude -f install -y kodi-pvr-hts kodi-x11 kodi-wayland kodi
sudo aptitude -f install -y shellcheck gnome-disk-utility putty gimp audacity

sudo aptitude -f install -y alien bleachbit
sudo aptitude -f install -y libmng2 mencoder libenca0 libvorbisidec1 libdvdcss2
sudo aptitude -f install -y libavcodec-extra58 libavcodec-extra

### extra
sudo aptitude -f install -y krdc psensor firefox flatpak

### fwupd
sudo aptitude -f install -y fwupd plasma-discover-backend-fwupd

#sudo aptitude -f install -y appimagelauncher

sudo echo 'deb http://gr.archive.ubuntu.com/ubuntu/ groovy main restricted universe multiverse' | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo aptitude -f install -y kubuntu-restricted-extras ubuntu-restricted-extras
sudo aptitude -f install -y x264 x265
sudo sed -i 's+deb http://gr.archive.ubuntu.com/ubuntu/ groovy main restricted universe multiverse+#deb http://gr.archive.ubuntu.com/ubuntu/ groovy main restricted universe multiverse+g' /etc/apt/sources.list


### REMOVE DEBIAN UNSTABLE REPOS AGAIN
sudo sed -i 's+deb http://deb.debian.org/debian/ unstable main contrib non-free+#deb http://deb.debian.org/debian/ unstable main contrib non-free+g' /etc/apt/sources.list
sudo sed -i 's+deb-src http://deb.debian.org/debian/ unstable main contrib non-free+#deb-src http://deb.debian.org/debian/ unstable main contrib non-free+g' /etc/apt/sources.list
apt update

s/old-text/new-text/g
### .exe files for wine
mkdir -p ~/wine && cd ~/wine
wget https://winscp.net/download/files/202005080143368dd0551d11a66577d4727edb0182a2/WinSCP-5.17.5-Portable.zip
unzip -o WinSCP*
rm -rf license* readme* WinSCP*.zip WinSCP*.com

### usb stuff
sudo add-apt-repository -y ppa:mkusb/ppa
sudo apt update
sudo apt -f install --install-recommends -y mkusb mkusb-nox usb-pack-efi

### extra .deb packages
cd $source
#
#wget https://github.com/balena-io/etcher/releases/download/v1.5.89/balena-etcher-electron_1.5.89_amd64.deb
#sudo dpkg -i balena-etcher*
#sudo apt -f install -y && sudo apt --fix-broken install -y
#rm -rf balena-etcher*

wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf gitkraken*

### google
wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
sudo dpkg -i google-earth-pro*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf google-earth-pro*

#wget http://archive.ubuntu.com/ubuntu/pool/main/u/usb-creator/usb-creator-gtk_0.3.7_amd64.deb
#sudo dpkg -i usb-creator*
#sudo apt -f install -y && sudo apt --fix-broken install -y
#rm -rf usb-creator*

wget http://ftp.br.debian.org/debian/pool/main/d/diffuse/diffuse_0.4.8-4_all.deb
sudo dpkg -i diffuse*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf diffuse*

wget https://atom.io/download/deb
sudo dpkg -i deb*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf deb*

wget https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/ukuu_18.9.3-0~201902031503~ubuntu18.04.1_amd64.deb
sudo dpkg -i ukuu*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf ukuu*

wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo dpkg -i teamviewer*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf teamviewer*

wget https://github.com/shiftkey/desktop/releases/download/release-2.4.1-linux2/GitHubDesktop-linux-2.4.1-linux2.deb
sudo dpkg -i GitHubDesktop*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf GitHubDesktop*

### ensure packages are well installed
sudo apt update && sudo apt -f install -y && sudo apt --fix-broken install -y

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
sudo snap install ngrok

###### GITHUB REPOSITORIES ##########################################################################
#####################################################################################################
### git stuff                    #
echo -e "${yellow}"              #
echo GIT EXTRAS                  #
echo -e "${restore}"             #
##################################
cd $git
#
### whereisbssid script
git clone --depth=1 https://github.com/Trackbool/WhereIsBSSID.git

### prebuilt llvm tc with lto=full pgo polly support
cd $tc
#
git clone --depth=1 https://github.com/TwistedPrime/twisted-clang.git
mv twisted-clang clang
cd $source

### microcode
sudo apt remove -y intel-microcode
sudo apt remove -y amd-microcode

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f full-upgrade -y && sudo apt -f upgrade --with-new-pkgs -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y
sudo apt autoclean
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
###### MANUALLY INSTALL LLVM/CLANG-11 POLLY SUPPORT FOR NOW
### do this prior to clang-11 installation so that if support will officially come
### it will be overridden by the official latest clang libraries
#echo -e "${yellow}"
#echo "Adding support for clang-11 polly..."
#echo ""
#polly=/usr/lib/llvm-11/lib
#sudo mkdir -p $polly
#sudo \cp -rf LLVMPolly.so $polly/
#echo "done!"
#echo -e "${restore}"
./1*




#####################################################################################################
####### END #########################################################################################
#####################################################################################################
