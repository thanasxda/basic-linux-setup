#!/bin/bash
###############################################################
###############################################################
### basic personal setup ubuntu v2.1 (kubuntu daily builds) ###
### contains basic build env & plasma preconfig & extras    ###
### http://cdimage.ubuntu.com/kubuntu/daily-live/current/   ###
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
echo ".::BASIC-LINUX-SETUP::. V2.1 - mainly for (K)ubuntu focal/groovy" ###
echo -e "${restore}"                                                    ###
###########################################################################
####### START #############################################################
# all underneath setup parts marked with many "!!!" need to be set according to your distro
# for transposable compatibility in case it is not used for (K}ubuntu focal/groovy



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
sudo apt -f install -y ureadahead
sudo apt -f install -y kexec-tools
sudo apt -f install -y && sudo apt --fix-missing install -y
printf 'y\ny\n' | sudo dpkg-reconfigure kexec-tools



####### GIT CONFIGURATION ###########################################################################
#####################################################################################################
### your git name & email - unhash and set up for personal usage
sudo apt -f install -y git curl
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
sudo apt -f install -y ttf-mscorefonts-installer



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
sudo apt -f install -y rsync

chmod +x init.sh
sudo \cp init.sh /init.sh
sudo sed -i '1s#.*#@reboot root /init.sh#' /etc/crontab

### copy wallpaper & grub splash
sudo rsync -v -K -a --force  MalakasUniverse /usr/share/wallpapers
sudo \cp -rf  splash.jpg /boot/grub

### copy kde optimal preconfiguration
sudo rsync -v -K -a --force --include=".*" .config ~/
sudo rsync -v -K -a --force --include=".*" .kde ~/
sudo rsync -v -K -a --force --include=".*" .local ~/
sudo rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/

### fix ownership preconfig - rare cases
cd ~/ && sudo chown -R $(id -u):$(id -g) $HOME


####### FIREFOX CONFIGURATION
### installation firefox addons, install as firefox opens. close firefox and reclick on console ###############
echo -e "${magenta}"                                                                                          #
echo INSTALL FIREFOX ADDONS ONE BY ONE, AFTER CLOSE FIREFOX AND CLICK ON CLI TILL ALL ADDONS ARE INSTALLED!!! #
echo -e "${restore}"                                                                                          #
###############################################################################################################
sudo pkill firefox
echo sorry for that firefox crash. part of setup...

### copy firefox advanced settings and enable hw acceleration
cd $basicsetup/.mozilla/firefox/.default-release
sudo \cp -rf prefs.js ~/.mozilla/firefox/*.default-release/prefs.js
cd $source

### install firefox modules
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3539016/adblock_plus-*
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3560936/duckduckgo_privacy_essentials-*
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3502002/youtube_audio_only-*
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3053229/adblocker_for_youtubetm-*
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3553672/youtube_video_and_audio_downloader_webex-
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3550879/plasma_integration-*
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3547657/hotspot_shield_free_vpn_proxy_unlimited_vpn-*



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
sudo sed -i '10s/.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1"/' /etc/default/grub
### set grub timeout
sudo sed -i '8s/.*/GRUB_TIMEOUT=2/' /etc/default/grub
### set grub min resolution
sudo sed -i '24s/.*/GRUB_GFXMODE=1024x768/' /etc/default/grub
### set grub wallpaper
sudo sed -i '12s#.*#GRUB_BACKGROUND="/boot/grub/splash.jpg"#' /etc/default/grub
### apply grub settings
sudo update-grub2
### grub auto detection
GRUB_PATH=$(sudo fdisk -l | grep '^/dev/[a-z]*[0-9]' | awk '$2 == "*"' | cut -d" " -f1 | cut -c1-8)
sudo grub-install $GRUB_PATH




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
sudo apt update
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
### repos needed to contain all packages - set underneath repos according to your distro if necessary
source_1='deb http://archive.canonical.com/ubuntu/ focal partner'
source_2='deb http://gr.archive.ubuntu.com/ubuntu/ bionic main'
source_3='deb http://gr.archive.ubuntu.com/ubuntu/ eoan main universe'
### proposed repo for now fixes some issues
source_4='deb http://gr.archive.ubuntu.com/ubuntu/ groovy-proposed main restricted universe multiverse'
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### daily llvm git builds - not always support for lto
### DO NOT change distro on the llvm repos. these branches are only meant for the toolchain
### and will ensure you will always use latest llvm when using "make CC=clang"
llvm_1='deb http://apt.llvm.org/focal/ llvm-toolchain-focal main'
llvm_2='deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main'

new_sources=("$source_1" "$source_2" "$source_3" "$source_4" "$llvm_1" "$llvm_2")

for i in ${!new_sources[@]}; do
    if ! grep -q "${new_sources[$i]}" /etc/apt/sources.list; then
        echo "${new_sources[$i]}" | sudo tee -a /etc/apt/sources.list
        echo "Added ${new_sources[$i]} to source list"
    fi
done

### fetch keys ubuntu
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1378B444
### fetch keys llvm git
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -

##################################
### fix groovy distro syncing for now
#file_4=/etc/apt/sources.list.d/team-xbmc-ubuntu-ppa-*.list
#source_4='deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu focal main'
#file_5=/etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list
#source_5='deb http://gr.archive.ubuntu.com/ubuntu/ bionic main'
##################################
#if test -f "$file_4"; then
#    if ! grep -q "${source_4}" $file_4; then
#        echo "${source_4}" | sudo tee -a $file_4
#    fi
#fi
#
#if test -f "$file_5"; then
#    if ! grep -q "${source_5}" $file_5; then
#        echo "${source_5}" | sudo tee -a $file_5
#    fi
#fi

##################################
####### PPA'S
### mesa drivers and extras
sudo add-apt-repository -y ppa:oibaf/graphics-drivers
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository -y ppa:team-xbmc/ppa
sudo add-apt-repository -y ppa:appimagelauncher-team/stable

### fix focal/groovy distro syncing for now (forceful method - for now must be overridden)
sudo bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-ppa-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/appimagelauncher-team/stable/ubuntu focal main" > /etc/apt/sources.list.d/appimagelauncher-team-ubuntu-stable-*.list'



####### THANAS PACKAGES #############################################################################
#####################################################################################################
### thanas build env, vulkan drivers, codecs and extras
echo -e "${yellow}"              #
echo THANAS PACKAGES             #
echo -e "${restore}"             #
##################################
sudo apt update
sudo apt -f install -y aptitude

sudo aptitude -f install -y amd64-microcode android-sdk android-tools-adb android-tools-adbd android-tools-fastboot autoconf autoconf-archive autogen automake autopoint autotools-dev bash bc binfmt-support binutils-dev bison build-essential bzip2 ca-certificates ccache clang clang-11 clang-11-doc clang-format clang-format-11 clang-tidy clang-tools-11 clangd clangd-11 cmake curl dash desktop-base dkms dpkg-dev ecj expat fastjar file flatpak flex g++ gawk gcc gcc-10 gdebi gedit gettext git git-svn gnupg gparted gperf gstreamer1.0-qt5 help2man imagemagick intel-microcode java-propose-classpath kubuntu-restricted-extras kwrite lib32ncurses-dev lib32readline-dev lib32z1 lib32z1-dev libbz2-dev libc++-11-dev libc++abi-11-dev libc6-dev libc6-dev-i386 libcap-dev libclang-11-dev libclang-dev libclang1 libclang1-11 libelf-dev libexpat1-dev libffi-dev libfuzzer-11-dev libghc-bzlib-dev libgl1-mesa-dev libgmp-dev libjpeg8-dev libllvm-11-ocaml-dev libllvm-ocaml-dev libllvm11 liblz4-1 liblz4-1:i386 liblz4-dev liblz4-java liblz4-jni liblz4-tool liblzma-dev liblzma-doc liblzma5 libmpc-dev libmpfr-dev libncurses-dev libncurses5 libncurses5-dev libomp-11-dev libsdl1.2-dev libssl-dev libtool libtool-bin libvdpau-va-gl1 libvulkan1 libx11-dev libxml2 libxml2-dev libxml2-utils linux-libc-dev linux-tools-common lld lld-11 lldb llvm llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime llvm-dev llvm-runtime lzma lzma-alone lzma-dev lzop m4 make maven mesa-opencl-icd mesa-va-drivers mesa-vulkan-drivers nautilus ninja-build ocl-icd-libopencl1 openjdk-8-jdk openssh-client openssh-server optipng patch pigz pkg-config pngcrush python-all-dev python-clang python3.8 python3-distutils qt5-default rsync schedtool shtool snapd squashfs-tools subversion tasksel texinfo txt2man ubuntu-restricted-extras unzip vdpau-driver-all vlc vulkan-utils wget x11proto-core-dev xsltproc yasm zip zlib1g-dev

### gcc arm
sudo apt install -y gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi gcc-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabi

### npm
sudo apt -f install -y npm && sudo apt -f install -y && sudo npm cache clean -f && sudo npm cache clean -f && sudo npm install npm@latest -g

### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### SELECT EXPLICITLY FOR KDE PLASMA DESKTOP ENVIRONMENT! needs manual enabling from within settings
sudo apt install -y plasma-workspace-wayland kwayland-integration wayland-protocols
### allow root privilege under wayland and supress output
sudo sed -i '4s#.*#xhost +si:localuser:root >/dev/null#' ~/.bashrc
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### extra thanas packages
### some listed purposefully seperate to avoid future conflicts or to distinguish packages from unique repo's or ppa's
sudo apt -f install -y audacity diffuse gimp kodi kodi-pvr-hts kodi-wayland f2fs-tools rt-tests uget net-tools aircrack-ng wine32 wine

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y

sudo apt -f install -y appimagelauncher

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y

### .exe files for wine
mkdir -p ~/wine && cd ~/wine
wget https://winscp.net/download/files/202005080143368dd0551d11a66577d4727edb0182a2/WinSCP-5.17.5-Portable.zip
unzip -o WinSCP*
rm -rf license* readme* WinSCP*.zip

### extra .deb packages
cd $source
#
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo dpkg -i viber*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf viber*

wget https://phoronix-test-suite.com/releases/repo/pts.debian/files/phoronix-test-suite_9.6.0_all.deb
sudo dpkg -i phoronix*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf phoronix*

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

### extras from snap
sudo snap install gitkraken --edge
sudo snap install telegram-desktop --edge
sudo snap install discord --edge
sudo snap install anbox --edge --devmode

### anbox modules fix - run android android/apps within linux
cd $git
#
sudo apt -f install -y linux-headers-generic
git clone https://github.com/thanasxda/anbox-modules-fix.git
cd anbox-modules-fix
sudo ./anbox_modules_fix.sh
sudo apt -f install -y

### usb stuff
#sudo add-apt-repository -y ppa:mkusb/ppa
#sudo apt update
#sudo apt -f install --install-recommends -y mkusb mkusb-nox usb-pack-efi




###### GITHUB REPOSITORIES ##########################################################################
#####################################################################################################
### git stuff                    #
echo -e "${yellow}"              #
echo GIT EXTRAS                  #
echo -e "${restore}"             #
##################################
cd $git
#
### llvm binutils gcc buildscripts
git clone https://github.com/ClangBuiltLinux/tc-build.git
git clone https://github.com/USBhost/build-tools-gcc.git

### android image kitchen
git clone https://github.com/thanasxda/AIK.git

### anykernel3 with sdm845 malakas configuration
git clone https://github.com/thanasxda/AnyKernel3.git

### katoolin script
git clone https://github.com/LionSec/katoolin.git

### whereisbssid script
git clone https://github.com/Trackbool/WhereIsBSSID.git

### prebuilt llvm tc with lto=full pgo polly support
cd $tc
#
git clone https://github.com/TwistedPrime/twisted-clang.git
mv twisted-clang clang
cd $source



### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y

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
cd thanas-x86-64-kernel
./1_build.sh



#####################################################################################################
####### END #########################################################################################
#####################################################################################################
