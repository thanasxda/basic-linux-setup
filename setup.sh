#!/bin/bash
#########################################################
#########################################################
### basic personal setup ubuntu (kubuntu daily builds)
### contains basic build env & extras
### http://cdimage.ubuntu.com/kubuntu/daily-live/current/
#########################################################
#########################################################
### explanation at every step, read to know. be warned.
### DON'T RUN AS SU!!! DIRS ARE NOT /home/root/
#########################################################
### optionally install "kde connect" app on your android
source="$(pwd)"
basicsetup=$source/.basicsetup
### set bash colors
magenta="\033[05;1;95m"
yellow="\033[1;93m" 
restore="\033[0m"
echo -e "${magenta}"
echo ".::BASIC-LINUX-SETUP::. - mainly for (K)ubuntu focal/groovy"
echo -e "${restore}"

### whats your grub dir?
grub=/dev/sda

### size of swap - 4.8gb in this case
swap=5000000

### setup dirs
git=~/GIT
tc=~/TOOLCHAIN

### your git name & email - unhash and set up for personal usage
sudo apt -f install -y git curl 
#gitname=thanasxda
#gitmail=15927885+thanasxda@users.noreply.github.com
#git config --global user.name $gitname
#git config --global user.email $gitmail

### take care of licenses first
sudo apt update
echo -e "${yellow}"
echo LICENSES
echo -e "${restore}"
echo ttf-mscorefonts-installer ttf-mscorefonts-installer/accepted-ttf-mscorefonts-installer-eula select true | sudo debconf-set-selections
sudo apt -f install -y ttf-mscorefonts-installer

### configure system customization
echo -e "${yellow}"
echo MINOR SYSTEM CUSTOMIZATION
echo -e "${restore}"
cd $basicsetup && mkdir -p tmp
unzip -o basicsetup.zip -d $basicsetup/tmp
cd $basicsetup/tmp
sudo \cp -rf .local/ ~/
sudo \cp -rf .config/ ~/
### installation firefox addons, install as firefox opens. close firefox and reclick on console
echo -e "${magenta}"
echo INSTALL FIREFOX ADDONS ONE BY ONE, AFTER CLOSE FIREFOX AND CLICK ON CLI TILL ALL ADDONS ARE INSTALLED!!!
echo -e "${restore}"
sudo pkill firefox
echo sorry for that firefox crash. part of setup... 
cd .mozilla/firefox/.default-release
sudo \cp -rf prefs.js ~/firefox/*.default-release/prefs.js
sudo rm -rf $basicsetup/tmp
cd $source
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3539016/adblock_plus-* 
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3560936/duckduckgo_privacy_essentials-* 
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3502002/youtube_audio_only-* 
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3053229/adblocker_for_youtubetm-* 
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3547657/hotspot_shield_free_vpn_proxy_unlimited_vpn-* 
yes | firefox https://addons.mozilla.org/firefox/downloads/file/3550879/plasma_integration-* 

### configure swap 5G - hash out if unwanted
echo -e "${yellow}"
echo CONFIGURE SWAP
echo -e "${restore}"
sudo swapoff -a
sudo dd if=/dev/zero of=/swapfile bs=$swap count=1024
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon -a
sudo free -h
### set swappiness to a low value for ram preference
sudo sysctl vm.swappiness=10
### LVM
#/vgkubuntu-swap_1

### setup dirs
git=~/GIT
tc=~/TOOLCHAIN
mkdir -p $git && mkdir -p $tc

### add i386 architecture needed for env
sudo dpkg --add-architecture i386

### grub config
echo -e "${yellow}"
echo GRUB CONFIG
echo -e "${restore}"
### switch off mitigations improving linux performance
sudo sed -i '10s/.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier mds=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off"/' /etc/default/grub
### set grub timeout
sudo sed -i '8s/.*/GRUB_TIMEOUT=2/' /etc/default/grub
### set grub min resolution
sudo sed -i '24s/.*/GRUB_GFXMODE=1024x768/' /etc/default/grub
### apply grub settings
sudo update-grub
### CAREFUL HERE TO CHOOSE CORRECT GRUB PARTITION!!!
sudo grub-install $grub

### build env scripts
echo -e "${yellow}"
echo BUILD ENV SCRIPTS
echo -e "${restore}"
cd $git
git clone https://github.com/akhilnarang/scripts.git
cd scripts/setup
Keys.ENTER | ./android_build_env.sh
Keys.ENTER | ./ccache.sh 

### setup repos #####################################################################################
echo -e "${yellow}"
echo SET UP REPOS
echo -e "${restore}"
### repos needed to contain all packages - set underneath repos according to your distro if necessary 
sudo bash -c 'echo "deb http://archive.canonical.com/ubuntu/ focal partner"  >> /etc/apt/sources.list'
sudo bash -c 'echo "deb http://gr.archive.ubuntu.com/ubuntu/ bionic main"  >> /etc/apt/sources.list'
sudo bash -c 'echo "deb http://gr.archive.ubuntu.com/ubuntu/ eoan main universe"  >> /etc/apt/sources.list'
### fetch keys
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1378B444
#####################################################################################################

### daily llvm git builds - not always support for lto
sudo bash -c 'echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal main"  >> /etc/apt/sources.list'
sudo bash -c 'echo "deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main"  >> /etc/apt/sources.list'
### fetch keys
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -


### mesa drivers and extras
sudo add-apt-repository -y ppa:oibaf/graphics-drivers 
sudo add-apt-repository -y ppa:git-core/ppa 
sudo add-apt-repository -y ppa:team-xbmc/ppa
### fix groovy distro syncing for now
sudo bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-ppa-*.list'
sudo bash -c 'echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list'


### thanas build env, vulkan drivers, codecs and extras
echo -e "${yellow}"
echo THANAS PACKAGES
echo -e "${restore}"
sudo apt update
sudo apt -f install -y aptitude
sudo aptitude -f install -y amd64-microcode android-sdk android-tools-adb android-tools-fastboot autoconf autoconf-archive autogen automake autopoint autotools-dev bash bc binfmt-support binutils-dev bison build-essential bzip2 ca-certificates ccache clang clang-11 clang-11-doc clang-format clang-format-11 clang-tidy clang-tools-11 clangd clangd-11 cmake curl dash desktop-base dkms dpkg-dev ecj expat fastjar file flatpak flex g++ gawk gcc gcc-10 gdebi gedit gettext git git-svn gnupg gparted gperf gstreamer1.0-qt5 help2man imagemagick intel-microcode java-propose-classpath kubuntu-restricted-extras kwrite lib32ncurses-dev lib32readline-dev lib32z1 lib32z1-dev libbz2-dev libc++-11-dev libc++abi-11-dev libc6-dev libc6-dev-i386 libcap-dev libclang-11-dev libclang-dev libclang1 libclang1-11 libelf-dev libexpat1-dev libffi-dev libfuzzer-11-dev libghc-bzlib-dev libgl1-mesa-dev libgmp-dev libjpeg8-dev libllvm-11-ocaml-dev libllvm-ocaml-dev libllvm11 liblz4-1 liblz4-1:i386 liblz4-dev liblz4-java liblz4-jni liblz4-tool liblzma-dev liblzma-doc liblzma5 libmpc-dev libmpfr-dev libncurses-dev libncurses5 libncurses5-dev libomp-11-dev libsdl1.2-dev libssl-dev libtool libtool-bin libvdpau-va-gl1 libvulkan1 libx11-dev libxml2 libxml2-dev libxml2-utils linux-libc-dev linux-tools-common lld lld-11 lldb llvm llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime llvm-dev llvm-runtime lzma lzma-alone lzma-dev lzop m4 make maven mesa-opencl-icd mesa-va-drivers mesa-vulkan-drivers nautilus ninja-build ocl-icd-libopencl1 openjdk-8-jdk openssh-client openssh-server optipng patch pigz pkg-config pngcrush python-all-dev python-clang python3.8 python3-distutils qt5-default rsync schedtool shtool snapd squashfs-tools subversion tasksel texinfo txt2man ubuntu-restricted-extras unzip vdpau-driver-all vlc vulkan-utils wget x11proto-core-dev xsltproc yasm zip zlib1g-dev

### SELECT EXPLICITLY FOR KDE PLASMA DESKTOP ENVIRONMENT!!! needs manual enabling from within settings
sudo apt install plasma-workspace-wayland kwayland-integration wayland-protocols  
### allow root privilege under wayland and supress output
sudo sed -i '4s/.*/xhost +si:localuser:root >/dev/null/' /etc/default/grub
#####################################################################################################

### gcc arm
sudo apt install -y gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi gcc-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabi

### extra packages
sudo apt -f install -y audacity diffuse gimp kodi kodi-pvr-hts kodi-wayland f2fs-tools

### extra packages
wget https://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
sudo dpkg -i viber*
sudo apt -f install -y && sudo apt --fix-broken install -y
rm -rf viber*

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
sudo snap install anbox --edge --devmode

### anbox - run android android/apps within linux
sudo apt -f install linux-headers-generic
cd $git
git clone https://github.com/thanasxda/anbox-modules-fix.git
cd anbox-modules-fix
sudo ./anbox_modules_fix.sh
sudo apt -f install -y

### usb stuff
#sudo add-apt-repository -y ppa:mkusb/ppa
#sudo apt update
#sudo apt -f install --install-recommends -y mkusb mkusb-nox usb-pack-efi

### git stuff
echo -e "${yellow}"
echo GIT EXTRAS
echo -e "${restore}"

### prebuilt llvm tc with lto=full pgo polly support
cd $tc
git clone https://github.com/TwistedPrime/twisted-clang.git
mv twisted-clang clang

### llvm binutils gcc buildscripts 
cd $git
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

### make sure all is set up right
sudo dpkg --configure -a && sudo apt update && sudo apt -f upgrade -y && sudo apt -f --fix-broken install -y && sudo apt -f --fix-missing install -y && sudo apt autoremove -y

### setup finished
echo -e "${magenta}"
echo ...
echo DONE WITH BASIC SETUP! COMPILING AND AUTO INSTALLING THANAS-x86-64-KERNEL
echo ...
echo -e "${restore}"

### auto compile and install thanas x86-64 kernel on latest llvm
cd $git
git clone --depth=1 https://github.com/thanasxda/thanas-x86-64-kernel.git
cd thanas-x86-64-kernel
./build.sh 

### DONE



