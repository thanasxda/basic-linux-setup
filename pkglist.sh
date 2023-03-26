﻿#!/bin/bash -l
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

#{

yellow="\033[1;93m"
restore="\033[0m"
### variables
source="$(pwd)"
tmp=$source/tmp
s="sudo"
ins="$s aptitude -f install -y"
up="$s apt update"
a="$s apt -y install --fix-missing --fix-broken"
fl="$s flatpak install  -y"
rem="$s apt -f -y purge"
### llvm version
#llver="$(apt-cache search llvm | awk '{print $1}' | grep llvm- | tail  | head -n 1 | cut -c6-7)"
llver="$(apt-cache search llvm | awk '{print $1}' | grep "llvm-.*-runtime" | sort -n | tail -n 1 | cut -c6-7)"
gccver="$(apt-cache search gcc -t experimental | awk '{print $1}' | grep "gcc-.*-linux-gnu" | cut -c5-6 | sort -n | tail -n 1)"

### kernel version
kernelv="6*"

echo -e "${yellow}"
echo "" && echo "" && echo "" && echo "pkglist starting..." && echo "" && echo "" && echo "" 




  if [ $enable_sid = yes ] ; then echo 'APT::Default-Release "sid";' | $s tee /etc/apt/apt.conf.d/00debian ; fi
  if grep -q sid /etc/apt/apt.conf.d/00debian || [ $enable_sid = yes ] ; then sed -z -i 's/Pin: release n=sid\nPin-Priority: -1/Pin: release n=sid\nPin-Priority: 999/g' preferences ; fi
$s apt update
$s apt dist-upgrade -y 


# thanas

 $a kde-config-systemd \
 kdeconnect \
 openbox-kde-session \
 kde-config-plymouth \
 kde-config-updates \
 plasma-browser-integration \
 partitionmanager \
 plasma-discover-backend-flatpak plasma-discover-backend-fwupd 



#if dmesg | grep -q nvidia ; then $a nvidia-driver-495 libnvidia-gl-495 libnvidia-gl-495:i386 libvulkan1 libvulkan1:i386 ; fi
$a libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
cd $tmp
$a pip
pip install requests


# kernel
#$a "$(apt search linux-image-6.*-rt-amd64-unsigned | awk '{print $1}' | grep "linux-image-.*-rt-amd64-unsigned" | tail -n 1 | cut -c1-37)" -t experimental
#$a linux-image-amd64 -t experimental 
if /lib/ld-linux-x86-64.so.2 --help | grep "v3 (supported" ; then
$a linux-xanmod-x64v3 ; elif /lib/ld-linux-x86-64.so.2 --help | grep "v2 (supported" ; then
$a linux-xanmod-x64v3 ; else $a linux-xanmod-x64v1 ; fi


$a flatpak

if [ $nonfree = yes ] ; then
#flatpak --noninteractive
$s flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#$fl freetube
fi

if lscpu | grep -q Intel ; then $a thermald ; fi


# remove stuff
#$rem intel-microcode
#$rem amd64-microcode
$rem openssh-server openssh-sftp-server \
 ubuntu-archive-keyring \
 cron \
 bluez \
 firefox-esr

$a acpi-fakekey acpi-support-base libx86-1 rfkill vbetool bind9-dnsutils inetutils-telnet libgnutls-dane0 liblockfile1 libunbound8 lsof python3-debconf

$a libdvdcss2 \
mencoder \
libvorbisidec1 

$a libavcodec59 

$a libxcb-xf86dri0
if [ $nonfree = yes ] ; then
$a firmware-realtek ; fi

$a ccache \
neofetch

 $a flatpak \
 fwupd \
 git \
 links \
 muon \
 openssh-client \
 putty \
 rng-tools5 \
 rt-tests \
 shellcheck \
 tasksel \
 uget \
 ccache \
 libxgks2 \
 blktool \
 gedit \
 vlc \
 alien \
 xsettings-kde \
 kdebugsettings \
 gkdebconf \
 alsa-tools-gui \
 python-is-python3 \
 virt-manager \
 neofetch \
 vim

 #if [ $nonfree = yes ] ; then if lscpu | grep -q Intel ; then $a libmkl-def ; fi ; fi

# dpdk

$a dracut && $rem initramfs-tools-core
 # choose which of the 2 u want initramfs-tools or dracut
sudo apt -f remove initramfs-tools initramfs-tools-core

 $a libllvm-$llver-ocaml-dev \
 libllvm$llver \
 llvm-$llver \
 llvm-$llver-dev \
 llvm-$llver-examples \
 llvm-$llver-runtime \
 clang-$llver \
 clangd-$llver \
 clang-tools-$llver \
 libclang-common-$llver-dev \
 libclang-$llver-dev \
 libclang1-$llver \
 clang-format-$llver \
 python3-clang-$llver \
 clangd-$llver \
 clang-tidy-$llver \
 libfuzzer-$llver-dev \
 lldb-$llver \
 lld-$llver \
 libc++-$llver-dev \
 libc++abi-$llver-dev \
 libomp-$llver-dev \
 libclc-$llver-dev \
 libunwind-$llver-dev \
 libmlir-$llver-dev \
 mlir-$llver-tools \
 libomp5-$llver \
 bolt-$llver
 
 $a xfsprogs f2fs-tools
 
 $a apparmor \
 cpufrequtils \
 diffuse \
 dkms \
 firmware-linux-free \
 haveged \
 hdparm \
 jitterentropy-rngd \
 kmod \
 net-tools \
 wireless-regdb \
 htop \
 qapt-deb-installer \
 psensor
 
  #atom-beta \
#  nmap \

 #firmware-linux \

 if [ $nonfree = yes ] ; then $a firmware-linux-nonfree firmware-misc-nonfree ; fi

 $a libdrm2 libxcb-dri3-0 libtxc-dxtn0 libdrm-common libgl-image-display0 libgl2ps1.4 libglc0 libgle3 libglfw3 libglew2.2 libglw1-mesa libglvnd0 libglut3.12  xscreensaver-gl \
 libosmesa6 \
 libd3dadapter9-mesa \
 libegl-mesa0 \
 libgl1-mesa-dri \
 libgl1-mesa-glx \
 libglapi-mesa \
 libgles2-mesa \
 libglu1-mesa \
 ocl-icd-libopencl1 \
 libvulkan1 \
 mesa-opencl-icd \
 libglx-mesa0 \
 glx-alternative-mesa \
 libegl1-mesa \
 libglapi-mesa \
 libwayland-egl1-mesa \
 mesa-utils \
 mesa-utils-bin 
 
 #mir-platform-graphics-mesa-x16 \
  #mir-client-platform-mesa5 \
 #mir-platform-graphics-mesa-kms16
 $a x265
 if [ $nonfree = yes ] ; then $a w64codecs ; fi
 $a ffmpeg
 $a x264
  
 $a mesa-vdpau-drivers \
 libvdpau-va-gl1 \
 va-driver-all \
 vdpau-driver-all \
 libgl1-mesa-dri \
 mesa-vulkan-drivers \
 mesa-va-drivers \
 libvulkan-dev \
 mesa-utils \
 vulkan-tools \
 mesa-common-dev \
 mesa-vdpau-drivers 
 
  $rem openssh-server openssh-sftp-server \
 ubuntu-archive-keyring \
 bluez \
 firefox-esr
 
 $a ethtool \
 binwalk \
 wireless-tools \
 rcconf \
 mc \
 iw \
 rtirq-init \
 rename \
 lz4 \
 anacron \
 qt5-style-kvantum-themes qt5-style-kvantum-l10n qt5-style-kvantum \
 dolphin-plugins \
 sddm \
 kio-fuse kio-extras kio \
 gstreamer1.0-qt5 gstreamer1.0-plugins-bad \
 openssl unattended-upgrades fail2ban \
 *qtgstreamer* \
 firewall* \
 xinit \
 preload \
 dbus-broker \
 efibootmgr systemd-boot systemd-boot-efi \
 irqbalance \
 adb fastboot
 
 #ufw
 
 $a kde-config-systemd \
 kdeconnect \
 openbox-kde-session \
 kde-config-plymouth \
 kde-config-updates \
 plasma-browser-integration \
 partitionmanager \
 qapt-utils \
 plasma-discover-backend-flatpak plasma-discover-backend-fwupd \
 software-properties-kde \
 kwrite vlc dolphin dolphin-plugins
 
#  plasma-firewall 


$a plasma-desktop

$a grub2
if [ -d /sys/firmware/efi ] ; then $a grub-efi-amd64 ; fi

 #apt -y install anbox -t unstable
 
 #plasma-discover-backend-snap
 #$a qdbus-qt6
 
 #$a libpoppler-qt6-3 
 #$a qt6-base-dev 
 #$a qt6ct
 #$a xserver-xorg-input-evdev

#$a gcc-$gccver-offload-amdgcn -t experimental
#$a amdgcn-tools -t experimental
$a gcc-$gccver -t experimental
$a llvm-$llver 

# removing microcode will remove firmware-linux firmware-linux-nonfree
#if lscpu | $(! grep -q Intel) ; then $rem intel-microcode ; fi
#if lscpu | $(! grep -q AMD) ; then $rem amd-microcode ; fi
 
 #qt6ct 
 
 
 

$a sddm x11-utils


        if [ $enable_sid = yes ] ; then
        $s apt dist-upgrade -t sid -y ; else
        $s apt dist-upgrade -y ; fi
        $s dpkg --configure -a

$rem k3b \
imagemagick 

$rem "^liblxc*"


	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)
	
#####################################################################################################
####### END #########################################################################################
#####################################################################################################
