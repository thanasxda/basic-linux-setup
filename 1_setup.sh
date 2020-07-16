#!/bin/bash
###############################################################
###############################################################
###              basic personal setup debian                ###
###############################################################
###             https://github.com/thanasxda                ###
###############################################################
### thanasxda 15927885+thanasxda@users.noreply.github.com   ###
###############################################################
### explanation at every step, read to know. be warned.     ###
### DON'T RUN AS SU!!! DIRS ARE NOT /home/root/             ###
###############################################################
###############################################################

### bash colors
magenta="\033[05;1;95m"
yellow="\033[1;93m"
restore="\033[0m"

###########################################################################
### display header                                                      ###
echo -e "${magenta}"                                                    ###
echo ".::BASIC-LINUX-SETUP::. - mainly for debian"                      ###
echo -e "${restore}"                                                    ###
###########################################################################
####### START #############################################################

### dir variables
source="$(pwd)"
basicsetup=$source/.basicsetup

### variables
ins="aptitude -f install -y"
apt="apt -f install -y"
s="sudo"
key="apt-key adv --keyserver keyserver.ubuntu.com --recv-keys"

#wget https://out7.hex-rays.com/files/idafree70_linux.run
$s chmod 755 *
#./idafree70_linux.run
#$s rm -rf idafree70_linux.run

### dont require prompt for sudo
#if $s grep -q "ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
#then
#echo "Flag exists"
#else
#$s sed -i "\$a$USER ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
#fi
$s passwd -l root
$s dpkg-reconfigure locales
$s locale-gen

$s ./2*

systemctl enable --now apparmor.service

### first of all install aptitude to ease out package conflicts
$s $apt aptitude

cd $source
$s cp *.list /etc/apt/sources.list.d/
$s rm -rf /etc/apt/sources.list.d/*sources.list
$s cp preferences /etc/apt/
$s cp preferences /etc/apt/preferences.d/

####### GENERAL DIRECTORIES #########################################################################
#####################################################################################################
### set up dirs of git and prebuilt toolchain
git=~/GIT
tc=~/TOOLCHAIN
mkdir -p $git && mkdir -p $tc

####### MINOR LINUX OPTIMIZATIONS ###################################################################
#####################################################################################################
### optimizations press -y & enter
printf 'y\n' | $s dpkg-reconfigure dash
$s $ins kexec-tools
$s $apt && $s apt --fix-missing install -y
printf 'y\ny\n' | $s dpkg-reconfigure kexec-tools

### brave
$s $ins apt-transport-https curl
curl -s https://brave-browser-apt-nightly.s3.brave.com/brave-core-nightly.asc | $s apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-prerelease.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-nightly.s3.brave.com/ stable main" | $s tee /etc/apt/sources.list.d/brave-browser-nightly.list
$s apt update
$s $ins brave-browser-nightly

####### GIT CONFIGURATION ###########################################################################
#####################################################################################################
### your git name & email - unhash and set up for personal usage
$s $ins git curl
#git config --global user.name thanasxda
#git config --global user.email 15927885+thanasxda@users.noreply.github.com

####### EULA LICENSE AGREEMENTS #####################################################################
#####################################################################################################
### take care of licenses first  #
#$s apt update                  #
#echo -e "${yellow}"              #
#echo LICENSES                    #
#echo -e "${restore}"             #
##################################
#echo ttf-mscorefonts-installer ttf-mscorefonts-installer/accepted-ttf-mscorefonts-installer-eula select true | $s debconf-set-selections
#$s $ins ttf-mscorefonts-installer

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
$s systemctl start fstrim.timer

### set up init.sh for kernel configuration #########################################
echo -e "${yellow}"                                                                 #
echo setting up userspace kernel configuration                                      #
echo on root filesystem /init.sh can be found, adjust it to your needs if necessary #
echo -e "${restore}"                                                                #
#####################################################################################
cd $basicsetup
#
$s $ins rsync
chmod +x init.sh
$s \cp init.sh /init.sh
if grep -q "@reboot root /init.sh" /etc/crontab
then
echo "Flag exists"
else
$s sed -i "\$a@reboot root /init.sh >/dev/null" /etc/crontab
fi

### copy wallpaper & grub splash
$s rsync -v -K -a --force  MalakasUniverse /usr/share/wallpapers
#$s \cp -rf  splash.jpg /boot/grub

### copy kde optimal preconfiguration
$s pkill brave-browser-nightly
#$s pkill brave-browser-beta
$s rsync -v -K -a --force --include=".*" .config ~/
$s rsync -v -K -a --force --include=".*" .kde ~/
$s rsync -v -K -a --force --include=".*" .local ~/
$s rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/
$s rsync -v -K -a --force --include=".*" .kodi ~/

### fix ownership preconfig - rare cases
cd ~/ && $s chown -R $(id -u):$(id -g) $HOME

####### FIREFOX CONFIGURATION
### installation firefox addons, install as firefox opens. close firefox and reclick on console ###############
#echo -e "${magenta}"                                                                                          #
#echo INSTALL FIREFOX ADDONS ONE BY ONE, AFTER CLOSE FIREFOX AND CLICK ON CLI TILL ALL ADDONS ARE INSTALLED!!! #
#echo -e "${restore}"                                                                                          #
###############################################################################################################
#$s pkill firefox
#echo sorry for that firefox crash. part of setup...

### copy firefox advanced settings and enable hw acceleration
#cd $basicsetup/.mozilla/firefox/.default-release
#$s \cp -rf prefs.js ~/.mozilla/firefox/*.default-esr/prefs.js
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
yes | brave-browser-nightly https://chrome.google.com/webstore/detail/touch-vpn-secure-and-unli/bihmplhobchoageeokmgbdihknkjbknd

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
$s sed -i "\$a/swapfile    none    swap    sw    0    0" /etc/fstab
fi
$s swapoff -a
$s dd if=/dev/zero of=/swapfile bs=$swap count=1024
$s chmod 600 /swapfile
$s mkswap /swapfile
$s swapon -a
$s free -h
### set swappiness to a low value for ram preference
$s sysctl vm.swappiness=$swappiness
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
$s sed -i '/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash log_priority=0 udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
$s sed -i '/GRUB_CMDLINE_LINUX="quiet splash"/c\GRUB_CMDLINE_LINUX="quiet splash log_priority=0 udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
### set grub timeout
$s sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub
### set grub min resolution
#$s sed -i "/GRUB_GFXMODE/c\GRUB_GFXMODE=1024x768" /etc/default/grub
### set grub wallpaper
#$s sed -i '/GRUB_BACKGROUND/c\GRUB_BACKGROUND="/boot/grub/splash.jpg"' /etc/default/grub
### apply grub settings
$s update-grub2
### grub auto detection
#GRUB_PATH=$($s fdisk -l | grep '^/dev/[a-z]*[0-9]' | awk '$2 == "*"' | cut -d" " -f1 | cut -c1-8)
#$s grub-install $GRUB_PATH

### preconfigure ccache and mute output
if grep -q "USE_CCACHE=1" ~/.bashrc
then
echo "Flag exists"
else
$s sed -i "\$aexport USE_CCACHE=1" ~/.bashrc
$s sed -i "\$aexport USE_PREBUILT_CACHE=1" ~/.bashrc
$s sed -i "\$aexport PREBUILT_CACHE_DIR=~/.ccache" ~/.bashrc
$s sed -i "\$aexport CCACHE_DIR=~/.ccache" ~/.bashrc
$s sed -i "\$accache -M 30G >/dev/null" ~/.bashrc
fi

if grep -q "fancy-bash-promt.sh" ~/.bashrc
then
echo "Flag exists"
else
cd $source
$s bash -c 'mkdir -p /root/.config'
$s cp $basicsetup/.config/fancy-bash-promt.sh ~/.config/
$s cp $basicsetup/.config/fancy-bash-promt2.sh /root/.config/
bash -c 'echo "source ~/.config/fancy-bash-promt.sh" >> ~/.bashrc'
$s bash -c 'echo "source /root/.config/fancy-bash-promt2.sh" >> /root/.bashrc'
fi

### fstab flags
### ext4
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
$s sed -i 's/errors=remount-ro/commit=60,discard,quota,lazytime,errors=remount-ro/g' /etc/fstab
fi
### xfs
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
$s sed -i 's/xfs     defaults/xfs     defaults,rw,noatime,lazytime,attr2,inode64,logbufs=8,logbsize=32k,noquota,discard,lazytime/g' /etc/fstab
fi
### f2fs
if grep -q "f2fs     rw,noatime,lazytime" /etc/fstab
then
echo "Flag exists"
else
$s sed -i 's/f2fs    defaults,noatime/f2fs     rw,noatime,lazytime,background_gc=on,discard,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,alloc_mode=default,fsync_mode=posix,quota/g' /etc/fstab
fi
### tmpfs
$s sed -i 's+/tmp           tmpfs   defaults,noatime,mode=1777 0 0++g' /etc/fstab
if grep -q "/run/shm" /etc/fstab
then
echo "Flag exists"
else
$s sed -i "\$atmpfs    /tmp        tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
$s sed -i "\$atmpfs    /var/tmp    tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
$s sed -i "\$atmpfs    /run/shm    tmpfs    rw,defaults,lazytime,noatime,mode=1777 0 0" /etc/fstab
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
$s dpkg --add-architecture i386
$s aptitude update
git clone https://github.com/akhilnarang/scripts.git
cd scripts/setup
Keys.ENTER | ./android_build_env.sh
Keys.ENTER | ./ccache.sh

### make sure all is set up right
$s dpkg --configure -a && $s apt update && $s apt -f upgrade -y --with-new-pkgs && $s apt -f --fix-broken install -y && $s apt -f --fix-missing install -y && $s apt autoremove -y

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
#        echo "${new_sources[$i]}" | $s tee -a /etc/apt/sources.list
#        echo "Added ${new_sources[$i]} to source list"
#    fi
#done

### fetch keys
$s $ins ubuntu-archive-keyring deb-multimedia-keyring
### ubuntu
$s $key 1378B444
$s $key 871920D1991BC93C
$s $key 3B4FE6ACC0B21F32
### obaif
$s $key 957d2708a03a4626
### kodi
$s $key 6d975c4791e7ee5e
### git
$s $key a1715d88e1df1f24
### usb stuff
$s $key 3729827454b8c8ac
### multimedia
$s $key 5C808C2B65558117
### google
$s $key 78BD65473CB3BD13
### kali
$s $key ED444FF07D8D0BF6
###
$s $key E6D4736255751E5D
###
$s $key 04EE7237B7D453EC
$s $key 648ACFD622F3D138
$s $key 3B4FE6ACC0B21F32
$s $key 2836cb0a8ac93f7a
$s $key B8AC39B0876D807E
$s $key A2F33E359F038ED9
### tvheadend
$s $key 89942AAE5CEAA174
$s apt-get -y install coreutils wget apt-transport-https lsb-release ca-certificates
$s wget -qO- https://doozer.io/keys/tvheadend/tvheadend/pgp | $s apt-key add -
### opensuse
$s wget -qO- https://download.opensuse.org/repositories/home:/npreining:/debian-kde:/other-deps/Debian_Unstable/Release.key | $s apt-key add -
$s wget -qO- https://download.opensuse.org/repositories/Debian:/debbuild/Debian_Testing/Release.key | $s apt-key add -
### llvm git
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|$s apt-key add -
$s $key 15CF4D18AF4F7421

cd $source
$s cp *.list /etc/apt/sources.list.d/
$s rm -rf /etc/apt/sources.list.d/*sources.list
$s cp preferences /etc/apt/
$s cp preferences /etc/apt/preferences.d/

##################################
####### PPA'S
### mesa drivers and extras
#$s add-apt-repository -y ppa:oibaf/graphics-drivers
#$s add-apt-repository -y ppa:git-core/ppa
#$s add-apt-repository -y ppa:team-xbmc/ppa
#$s add-apt-repository -y ppa:team-xbmc/unstable
#$s add-apt-repository -y ppa:team-xbmc/xbmc-nightly
#$s add-apt-repository -y ppa:appimagelauncher-team/stable

### fix distro syncing for now (forceful method - for now must be overridden)
#$s bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu disco main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-xbmc-nightly-*.list'
#$s bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu cosmic main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-unstable-*.list'
#$s bash -c 'echo "deb http://ppa.launchpad.net/team-xbmc/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/team-xbmc-ubuntu-ppa-*.list'
#$s bash -c 'echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main"  > /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.list'
#$s sh -c 'echo "deb https://apt.tvheadend.org/stable stretch main" | tee /etc/apt/sources.list.d/tvheadend.list'
#$s sh -c 'echo "deb https://apt.tvheadend.org/unstable stretch main" | tee /etc/apt/sources.list.d/tvheadend.list'

### add debian multimedia
#if grep -q "www.deb-multimedia.org" /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#$s sed -i 's/deb [arch=amd64,i386] http://www.deb-multimedia.org sid main non-free/g' /etc/apt/sources.list
#$s sed -i 's/deb [arch=amd64,i386] http://www.deb-multimedia.org unstable main non-free/g' /etc/apt/sources.list
#fi

### kali
#if grep -q "kali-dev" /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#$s echo '
#deb http://http.kali.org/kali kali-debian-picks main non-free contrib
#deb http://http.kali.org/kali debian-testing main non-free contrib
#deb http://http.kali.org/kali kali-dev main non-free contrib
#deb http://http.kali.org/kali kali-experimental main non-free contrib
#deb http://http.kali.org/kali kali-last-snapshot main non-free contrib
#' | $s tee -a /etc/apt/sources.list
#fi

### add debian experimental
#if grep -q "debian experimental main" /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#$s sed -i 's/#deb http://http.debian.net/debian experimental main contrib non-free/g' /etc/apt/sources.list
#fi

### add debian unstable repos
#if grep -q 'deb http://deb.debian.org/debian/ unstable main contrib non-free' /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#$s echo '# debian unstable repos - will break distro' | $s tee -a /etc/apt/sources.list
#$s echo '# only use for rare individual packages' | $s tee -a /etc/apt/sources.list
#$s echo 'deb http://deb.debian.org/debian/ unstable main contrib non-free' | $s tee -a /etc/apt/sources.list
#$s echo 'deb-src http://deb.debian.org/debian/ unstable main contrib non-free' | $s tee -a /etc/apt/sources.list
#fi

### add llvm repos
#if grep -q 'deb http://apt.llvm.org/unstable/ llvm-toolchain main' /etc/apt/sources.list
#then
#echo "Flag exists"
#else
#$s echo '### llvm git repos' | $s tee -a /etc/apt/sources.list
#$s echo 'deb http://apt.llvm.org/unstable/ llvm-toolchain main' | $s tee -a /etc/apt/sources.list
#$s echo 'deb-src http://apt.llvm.org/unstable/ llvm-toolchain main' | $s tee -a /etc/apt/sources.list
#$s echo 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal main' | $s tee -a /etc/apt/sources.list
#$s echo 'deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal main' | $s tee -a /etc/apt/sources.list
#fi

####### THANAS PACKAGES #############################################################################
#####################################################################################################
### thanas build env, vulkan drivers, codecs and extras
echo -e "${yellow}"              #
echo THANAS PACKAGES             #
echo -e "${restore}"             #
##################################
$s apt update
$s aptitude update

$s $ins muon android-tools-adb android-tools-fastboot autoconf autoconf-archive autogen automake autopoint autotools-dev bash bc binfmt-support binutils-dev bison build-essential bzip2 ca-certificates ccache clang clang-11 clang-11-doc clang-format clang-format-11 clang-tidy clang-tools-11 clangd clangd-11 cmake curl dash dkms dpkg-dev ecj expat fastjar file flatpak flex g++ gawk gcc gdebi gedit gettext git git-svn gnupg gperf gstreamer1.0-qt5 help2man java-propose-classpath kubuntu-restricted-extras lib32ncurses-dev lib32readline-dev lib32z1 lib32z1-dev libbz2-dev libc++-11-dev libc++abi-11-dev libc6-dev libc6-dev-i386 libcap-dev libclang-11-dev libclang-dev libclang1 libclang1-11 libelf-dev libexpat1-dev libffi-dev libfuzzer-11-dev libghc-bzlib-dev libgl1-mesa-dev libgmp-dev libjpeg8-dev libllvm-11-ocaml-dev libllvm-ocaml-dev libllvm11 liblz4-1 liblz4-1:i386 liblz4-dev liblz4-java liblz4-jni liblz4-tool liblzma-dev liblzma-doc liblzma5 libmpc-dev libmpfr-dev libncurses-dev libncurses5 libncurses5-dev libomp-11-dev libsdl1.2-dev libssl-dev libtool libtool-bin libvdpau-va-gl1 libvulkan1 libx11-dev libxml2 libxml2-dev libxml2-utils linux-libc-dev linux-tools-common lld lld-11 lldb llvm llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime llvm-dev llvm-runtime lzma lzma-alone lzma-dev lzop m4 make maven mesa-opencl-icd mesa-va-drivers mesa-vulkan-drivers nautilus ninja-build ocl-icd-libopencl1 openssh-client optipng patch pigz pkg-config pngcrush python-all-dev python-clang python3.8 python3-distutils qt5-default rsync schedtool shtool snapd squashfs-tools subversion tasksel texinfo txt2man ubuntu-restricted-extras unzip vdpau-driver-all vlc vulkan-utils wget x11proto-core-dev xsltproc yasm zip zlib1g-dev mpc dkms \
nautilus plasma-discover-backend-fwupd cpufrequtils ksystemlog libavcodec-extra preload w64codecs ffmpeg \
libomp-11-dev llvm-11 llvm clang-11 lld-11 gcc clang binutils make flex bison bc build-essential libncurses-dev libssl-dev libelf-dev qt5-default libclang-common-11-dev \
subversion g++ zlib1g-dev build-essential git python python3 python3-distutils libncurses5-dev gawk gettext unzip file libssl-dev wget libelf-dev ecj fastjar java-propose-classpath \
f2fs-tools xfsprogs rt-tests net-tools \
libavcodec-extra58 libavcodec-extra \
wine wine32 \
kodi-pvr-hts kodi-x11 kodi-wayland kodi \
gimp audacity uget \
alien bleachbit atom \
libmng2 mencoder libenca0 libvorbisidec1 libdvdcss2 \
psensor flatpak plasma-discover-backend-flatpak \
fwupd plasma-discover-backend-fwupd \
kubuntu-restricted-extras ubuntu-restricted-extras \
x264 x265 putty shellcheck \
gnome-maps minitube packagekit sweeper gnome-disk-utility \
prelink irqbalance \
links lynx \
arch-install-scripts fish \
virt-manager selinux-utils \
libreoffice-writer \
checkinstall \
firmware-mod-kit


### npm
$s $apt npm && $s $apt && $s npm cache clean -f && $s npm cache clean -f && $s npm install npm@latest -g

### list mesa drivers seperately
#$s $ins vulkan-tools libd3dadapter9-mesa libd3dadapter9-mesa-dev libegl-mesa0 libegl1-mesa-dev libgl1-mesa-dev libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa libgles2-mesa-dev libglu1-mesa libglu1-mesa-dev libglx-mesa0 libosmesa6 libosmesa6-dev mesa-common-dev mesa-vdpau-drivers mesa-vulkan-drivers mir-client-platform-mesa-dev vulkan-utils mesa-opencl-icd

### kali full packages
#$s $ins kali-tools-exploitation kali-tools-hardware kali-tools-wireless kali-tools-rfid kali-tools-fuzzing kali-tools-reporting kali-tools-sdr kali-tools-bluetooth kali-tools-social-engineering kali-tools-crypto-stego kali-tools-database kali-tools-voip kali-tools-802-11 kali-tools-post-exploitation kali-tools-sniffing-spoofing kali-tools-top10 kali-tools-reverse-engineering kali-tools-web kali-tools-vulnerability kali-tools-forensics kali-tools-information-gathering kali-tools-windows-resources
#$s apt remove -y lime-forensics-dkms
#$s $ins routersploit

### ...
#$s $ins gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi gcc-10-aarch64-linux-gnu gcc-10-arm-linux-gnueabi
#$s $ins gcc-multilib
#$s $ins gcc-10-multilib
#$s $ins gcc-10-x86-64-linux-gnu-base gcc-9-x86-64-linux-gnu-base
#$s $ins binutils-mips-linux-gnu

### ram cache stuff
#$s $ins zlib1g zlib1g-dev libcryptsetup12 libcryptsetup-dev libjansson4 libjansson-dev

### kde kali
#$s $ins muon kde-baseapps kde-plasma-desktop plasma-browser-integration

### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### SELECT EXPLICITLY FOR KDE PLASMA DESKTOP ENVIRONMENT! needs manual enabling from within settings
$s apt install -y plasma-workspace-wayland kwayland-integration wayland-protocols
### allow root privilege under wayland and supress output
if grep -q "xhost +si:localuser:root >/dev/null" ~/.bashrc
then
echo "Flag exists"
else
$s sed -i "\$axhost +si:localuser:root >/dev/null" ~/.bashrc
fi
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### TEMPORARILY ADD DEBIAN USNTABLE REPOS TO GET SOME PACKAGES!!!
#$s echo 'deb http://deb.debian.org/debian/ unstable main contrib non-free' | $s tee -a /etc/apt/sources.list
#$s echo 'deb-src http://deb.debian.org/debian/ unstable main contrib non-free' | $s tee -a /etc/apt/sources.list
#sleep 5
#$s apt update --allow-insecure-repositories

### REMOVE DEBIAN UNSTABLE REPOS AGAIN
#$s sed -i 's+deb http://deb.debian.org/debian/ unstable main contrib non-free+#deb http://deb.debian.org/debian/ unstable main contrib non-free+g' /etc/apt/sources.list
#$s sed -i 's+deb-src http://deb.debian.org/debian/ unstable main contrib non-free+#deb-src http://deb.debian.org/debian/ unstable main contrib non-free+g' /etc/apt/sources.list

### .exe files for wine
#mkdir -p ~/wine && cd ~/wine
#wget https://winscp.net/download/files/202005080143368dd0551d11a66577d4727edb0182a2/WinSCP-5.17.5-Portable.zip
#unzip -o WinSCP*
#rm -rf license* readme* WinSCP*.zip WinSCP*.com

### usb stuff
#$s add-apt-repository -y ppa:mkusb/ppa
#$s apt update
#$s apt -f install --install-recommends -y mkusb mkusb-nox usb-pack-efi

### extra .deb packages
cd $source

wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
$s dpkg -i gitkraken*
$s $apt && $s apt --fix-broken install -y
rm -rf gitkraken*

wget https://dl.google.com/dl/earth/client/current/google-earth-pro-stable_current_amd64.deb
$s dpkg -i google-earth-pro*
$s $apt && $s apt --fix-broken install -y
rm -rf google-earth-pro*

wget https://www.realvnc.com/download/file/viewer.files/VNC-Viewer-6.20.529-Linux-x64.deb
$s dpkg -i VNC-V*
$s $apt && $s apt --fix-broken install -y
rm -rf VNC-V*

wget http://ftp.br.debian.org/debian/pool/main/d/diffuse/diffuse_0.4.8-4_all.deb
$s dpkg -i diffuse*
$s $apt && $s apt --fix-broken install -y
rm -rf diffuse*

wget https://atom.io/download/deb
$s dpkg -i deb*
$s $apt && $s apt --fix-broken install -y
rm -rf deb*

wget https://launchpad.net/~teejee2008/+archive/ubuntu/ppa/+files/ukuu_18.9.3-0~201902031503~ubuntu18.04.1_amd64.deb
$s dpkg -i ukuu*
$s $apt && $s apt --fix-broken install -y
rm -rf ukuu*

#wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
#$s dpkg -i teamviewer*
#$s $apt && $s apt --fix-broken install -y
#rm -rf teamviewer*

#wget https://github.com/shiftkey/desktop/releases/download/release-2.4.1-linux2/GitHubDesktop-linux-2.4.1-linux2.deb
#$s dpkg -i GitHubDesktop*
#$s $apt && $s apt --fix-broken install -y
#rm -rf GitHubDesktop*

### ensure packages are well installed
#$s apt update && $s $apt && $s apt --fix-broken install -y

### enable snap
$s apt purge -y snapd snap-confine && $s apt install -y snapd
$s systemctl enable --now snapd.socket
if grep -q "export PATH" ~/.bashrc
then
echo "Flag exists"
else
$s sed -i "\$aexport PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH'" ~/.bashrc
fi
sleep 5
$s apparmor_parser -r /etc/apparmor.d/*snap-confine*
$s apparmor_parser -r /var/lib/snapd/apparmor/profiles/snap-confine*
#$s snap install ngrok

### language
#f grep -q " LC_ALL=en_US.UTF-8" ~/.bashrc
#then
#echo "Flag exists"
#else
#$s sed -i "\$aexport LC_CTYPE=en_US.UTF-8" ~/.bashrc
#$s sed -i "\$aexport LC_ALL=en_US.UTF-8" ~/.bashrc
#fi

###### GITHUB REPOSITORIES ##########################################################################
#####################################################################################################
### git stuff                    #
echo -e "${yellow}"              #
echo GIT EXTRAS                  #
echo -e "${restore}"             #
##################################
#cd $git

### whereisbssid script
#git clone --depth=1 https://github.com/Trackbool/WhereIsBSSID.git

### prebuilt llvm tc with lto=full pgo polly support
#cd $tc

#git clone --depth=1 https://github.com/TwistedPrime/twisted-clang.git
#mv twisted-clang clang
#cd $source

#$s $ins kali-tools-exploitation kali-tools-hardware kali-tools-wireless kali-tools-rfid kali-tools-fuzzing kali-tools-reporting kali-tools-sdr kali-tools-bluetooth kali-tools-social-engineering kali-tools-crypto-stego kali-tools-database kali-tools-voip kali-tools-802-11 kali-tools-post-exploitation kali-tools-sniffing-spoofing kali-tools-top10 kali-tools-reverse-engineering kali-tools-web kali-tools-vulnerability kali-tools-forensics kali-tools-information-gathering kali-tools-windows-resources kali-menu

$s apt -f install -y qt5-style-kvantum* \
plasma-discover-backend* \
firewall*

$s apt -f install -y gstreamer*

$s $apt kde-config-systemd kde-style-qtcurve-qt5 \
gstreamer1.0-vaapi \
sddm-theme-breeze sddm-theme-debian-breeze kde-config-sddm \
plasma-browser-integration apper kde-config-cron kde-config-plymouth \
task-greek task-greek-desktop task-greek-kde-desktop kdeplasma-addons-data \
plasma-desktop plasma-workspace kde-baseapps sddm xserver-xorg kwin-x11 kde-config-systemd plasma-desktop-data libkfontinst5  libkfontinstui5 libkworkspace5-5 libnotificationmanager1 libtaskmanager6abi1 kwin-x11 plasma-workspace kinfocenter
$s apt upgrade --with-new-pkgs -y #-t Debian_Unstable
$s apt full-upgrade -y -t Debian_Unstable
$s $apt full-upgrade

$s apt -f remove -y chromium firefox-esr imagemagick konqueror \
intel-microcode amd64-microcode \
plasma-discover-backend-*-dbgsym \
gstreamer*dbg


### make sure all is set up right
$s dpkg --configure -a && $s apt update && $s apt -f --fix-broken install -y && $s apt -f --fix-missing install -y
$s apt upgrade --with-new-pkgs -y
$s pkcon refresh && $s pkcon update -y
$s apt upgrade --with-new-pkgs -y -t experimental
$s $ins apt-listbugs apt-listchanges
$s prelink -amR

#cd $basiclinuxsetup
#$s cp McMojave.tar.xz /tmp/
#$s cp -a .local ~/

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
cd thanas-x86-64-kernel && $s chmod 755 *.sh
###### MANUALLY INSTALL LLVM/CLANG-11 POLLY SUPPORT FOR NOW
### do this prior to clang-11 installation so that if support will officially come
### it will be overridden by the official latest clang libraries
#echo -e "${yellow}"
#echo "Adding support for clang-11 polly..."
#echo ""
#polly=/usr/lib/llvm-11/lib
#$s mkdir -p $polly
#$s \cp -rf LLVMPolly.so $polly/
#echo "done!"
#echo -e "${restore}"
./1*

#####################################################################################################
####### END #########################################################################################
#####################################################################################################
