#!/bin/bash -l
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
gccver="$(apt-cache search gcc | awk '{print $1}' | grep "gcc-.*-linux-gnu" | cut -c5-6 | sort -n | tail -n 1)"

### kernel version kali
kernelv="6*"

echo -e "${yellow}"
echo "" && echo "" && echo "" && echo "pkglist starting..." && echo "" && echo "" && echo "" 
echo "DO NOT INSTALL ALL PACKAGES ITS COMPLETELY UNNECESSARY AND WILL DOUBLE YOUR LATENCY ON SCORES AND OVERALL PERFORMANCE, AS IS IS OPTIMAL. HANDPICK YOURSELF WHAT YOU ABSOLUTELY NEED ONLY. AND DOUBLECHECK IF WHAT YOU INSTALL RUNS 24/7 ON BACKGROUND SERVICES WITHOUT BEING NECESSARY WHATSOVER." && echo "" && echo "" && echo ""




# thanas

 $a kde-config-systemd \
 kdeconnect \
 openbox-kde-session \
 kde-config-plymouth \
 kde-config-updates \
 plasma-browser-integration \
 partitionmanager \
 plasma-discover-backend-flatpak plasma-discover-backend-fwupd 



if dmesg | grep -q nvidia ; then $a nvidia-driver-495 libnvidia-gl-495 libnvidia-gl-495:i386 libvulkan1 libvulkan1:i386 ; fi
$a -t unstable libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
cd $tmp
$a pip
pip install requests


$rem kali-linux-default \
 kali-linux-headless \
 kali-tools-top10


# kernel
#$a "$(apt search linux-image-6.*-rt-amd64-unsigned | awk '{print $1}' | grep "linux-image-.*-rt-amd64-unsigned" | tail -n 1 | cut -c1-37)" -t experimental
#$a linux-image-$kernelv-kali*-rt-amd64 -t kali-experimental
$a linux-image-amd64 -t experimental 
$a linux-image-6.*-kali3-amd64 -t kali-experimental


$a flatpak -t unstable

#flatpak --noninteractive
$s flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
#$fl freetube



# remove stuff
#$rem intel-microcode
#$rem amd64-microcode
$rem akonadi-server \
 openssh-server openssh-sftp-server \
 ubuntu-archive-keyring \
 avahi-daemon \
 cron \
 bluez \
 firefox-esr



$a -t unstable libdvdcss2 \
mencoder \
libvorbisidec1 

$a -t unstable libavcodec59 

$a -t unstable q4wine \
 wine \
 wine32 \
 wine64 \
 winetricks 
 
 $a -t unstable flatpak \
 fwupd \
 git \
 links \
 mpv \
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
 libmkl-def \
 blktool \
 tuned-utils \
 npm \
 xattr attr \
 gedit \
 gufw
 
 $a -t experimental libllvm-$llver-ocaml-dev \
 libllvm$llver \
 llvm-$llver \
 llvm-$llver-dev \
 llvm-$llver-examples \
 llvm-$llver-runtime \
 clang-$llver \
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
 mlir-$llver-tools 
 
 $a -t unstable binwalk \
 firmware-mod-kit \
 atom-beta \
 nmap \
 apparmor \
 cachefilesd \
 cpufrequtils \
 diffuse \
 dkms \
 firmware-amd-graphics \
 firmware-linux \
 firmware-linux-free \
 firmware-linux-nonfree \
 firmware-misc-nonfree \
 haveged \
 hdparm \
 jitterentropy-rngd \
 kmod \
 net-tools \
 wireless-regdb \
 xinit \
 kali-linux-firmware \
 kali-linux-core \
 kali-tweaks \
 kali-defaults \
 kali-defaults-desktop \
 htop \
 qapt-deb-installer 

 $a -t unstable libdrm2 libxcb-dri3-0 libtxc-dxtn0 libdrm-common libgl-image-display0 libgl2ps1.4 libglc0 libgle3 libglfw3 libglew2.2 libglw1-mesa libglvnd0 libglut3.12 mir-platform-graphics-mesa-kms16 xscreensaver-gl \
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
 mir-client-platform-mesa5 \
 libglx-mesa0 \
 mir-platform-graphics-mesa-x16 \
 glx-alternative-mesa \
 libegl1-mesa \
 libglapi-mesa \
 libwayland-egl1-mesa \
 mesa-utils \
 mesa-utils-bin 
 
 $a -t unstable x265
 $a -t unstable w64codecs
 $a -t unstable ffmpeg
 $a -t unstable x264
  
 $a -t unstable mesa-vdpau-drivers \
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
 
  $rem akonadi-server \
 openssh-server openssh-sftp-server \
 ubuntu-archive-keyring \
 avahi-daemon \
 cron \
 bluez \
 firefox-esr
 
 $a -t unstable ethtool \
 wireless-tools \
 rcconf \
 mc \
 iw \
 rtirq-init \
 rename \
 anacron \
 lz4 \
 arch-install-scripts \
 anacron \
 qt5-style-kvantum-themes qt5-style-kvantum-l10n qt5-style-kvantum \
 dolphin-plugins \
 sddm \
 kio-fuse kio-extras mtp-tools kio \
 gstreamer1.0-qt5 gstreamer1.0-plugins-bad \
 openssl ufw unattended-upgrades fail2ban \
 *qtgstreamer* \
 firewall* \
 xinit \
 preload \
 dbus-broker \
 linux-cpupower \
 efibootmgr systemd-boot systemd-boot-efi \
 irqbalance \
 adb fastboot
 
 
 $a kde-config-systemd \
 kdeconnect \
 openbox-kde-session \
 kde-config-plymouth \
 kde-config-updates \
 plasma-browser-integration \
 partitionmanager \
 plasma-discover-backend-flatpak plasma-discover-backend-fwupd 

 
 
 
 #plasma-discover-backend-snap
 #$a qdbus-qt6
 
 #$a libpoppler-qt6-3 qt6-base-dev 
 
$a llvm-$llver -t experimental
$a gcc-$gccver -t experimental
 
 #qt6ct 
 


 
$a kali-desktop-kde 





	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)
	
#####################################################################################################
####### END #########################################################################################
#####################################################################################################
