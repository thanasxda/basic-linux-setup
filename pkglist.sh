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
ins="$s aptitude -f install -y -t experimental"
up="$s apt update"
a="$s apt -f -y install"
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
if dmesg | grep -q nvidia ; then $a nvidia-driver-495 libnvidia-gl-495 libnvidia-gl-495:i386 libvulkan1 libvulkan1:i386 ; fi
$a libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio
cd $tmp
$a pip
$s pip install requests

$a libdvdcss2
$a mencoder
$a libvorbisidec1

$a libavcodec59

$rem kali-linux-default
$rem kali-linux-headless
$rem kali-tools-top10



# wine
#$a q4wine
#$a wine
#$a wine32
#$a wine64
#$a winetricks

$a flatpak
$a fwupd
$a git
$a links
$a mpv
$a muon
$a openssh-client
$a putty
$a rng-tools5
$a rt-tests
$a shellcheck
$a tasksel
$a uget
$a ccache


if [ $INSTALLBUILDENV = true ] ; then
# llvm
$a libllvm-$llver-ocaml-dev
$a libllvm$llver
$a llvm-$llver
$a llvm-$llver-dev
$a llvm-$llver-doc
$a llvm-$llver-examples
$a llvm-$llver-runtime
$a clang-$llver
$a clang-tools-$llver
$a clang-$llver-doc
$a libclang-common-$llver-dev
$a libclang-$llver-dev
$a libclang1-$llver
$a clang-format-$llver
$a python3-clang-$llver
$a clangd-$llver
$a clang-tidy-$llver
$a libfuzzer
$a libfuzzer-$llver-dev
$a lldb-$llver
$a lld-$llver
$a libc++-$llver-dev
$a libc++abi-$llver-dev
$a libomp-$llver-dev
$a libclc-$llver-dev
$a libunwind-$llver-dev
$a libmlir-$llver-dev
$a mlir-$llver-tools
$a binwalk
$a firmware-mod-kit
$a atom-beta
fi
 
$a apparmor
$a cachefilesd
$a cpufrequtils
$a diffuse
$a dkms
$a firmware-amd-graphics
$a firmware-linux
$a firmware-linux-free
$a firmware-linux-nonfree
$a firmware-misc-nonfree
$a haveged
$a hdparm
$a jitterentropy-rngd
$a kmod
$a net-tools
$a wireless-regdb
$a xinit
$a kali-linux-firmware
$a kali-linux-core
$a kali-tweaks
$a kali-defaults
$a kali-defaults-desktop
$a htop
$a qapt-deb-installer

# minimal compilers
$a llvm-$llver -t experimental
$a gcc-$gccver -t experimental

$a libosmesa6 
$a libd3dadapter9-mesa
$a libegl-mesa0
$a libgl1-mesa-dri
$a libgl1-mesa-glx
$a libglapi-mesa
$a libgles2-mesa
$a libglu1-mesa
$a ocl-icd-libopencl1
$a libvulkan1
$a mesa-opencl-icd
$a mir-client-platform-mesa5
$a libglx-mesa0 
$a mir-platform-graphics-mesa-x16
$a glx-alternative-mesa
$a libegl1-mesa
$a libglapi-mesa
$a libglapi-mesa
$a libwayland-egl1-mesa
$a mesa-utils
$a mesa-utils-bin
$a mesa-utils-extra

$a ffmpeg
$a mesa-vdpau-drivers
$a libvdpau-va-gl1
$a va-driver-all
$a vdpau-driver-all
$a w64codecs
$a x264
$a x265

$a libgl1-mesa-dri 
$a mesa-vulkan-drivers 
$a mesa-va-drivers 
$a libvulkan-dev 
$a mesa-utils 
$a vulkan-tools 
$a mesa-common-dev 
$a mesa-vdpau-drivers 


# kernel
#$a "$(apt search linux-image-6.*-rt-amd64-unsigned | awk '{print $1}' | grep "linux-image-.*-rt-amd64-unsigned" | tail -n 1 | cut -c1-37)" -t experimental
#$a linux-image-$kernelv-kali*-rt-amd64 -t kali-experimental
$a linux-image-amd64 -t experimental
$a linux-image-6.*-kali3-amd64 -t kali-experimental



$a ethtool
$a wireless-tools
$a rcconf
$a mc
$a iw
$a rtirq-init
$a rename
$a anacron
$a lz4




#$a apper


# DO NOT INSTALL ANY OF THIS. KALI ALREADY HAS FULL KDE WITHOUT BLOATING AND THE SEPARATE KDE REPOS ALLOW FOR LATEST VERSIONS. ALL IS GREYED OUT FOR A REASON, UNLESS YOU WANT BENCHMARKING LATENCY TO DOUBLE LITERALLY. CHOOSE WISELY WHAT YOU INSTALL
$a kde-config-systemd
$a openbox-kde-session

$a anacron
$a qt5-style-kvantum-themes qt5-style-kvantum-l10n qt5-style-kvantum
$a firewall*
$a dolphin-plugins
$a sddm
$a kio-fuse
$a gstreamer1.0-qt5 gstreamer1.0-plugins-bad
$a openssl ufw unattended-upgrades fail2ban


#flatpak --noninteractive
$s flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
$fl freetube

echo -e "${restore}"

#$a initramfs-tools initramfs-tools-core klibc-utils cryptsetup cryptsetup-bin dmeventd dmraid kpartx libdevmapper-event1.02.1 libdmraid1.0.0.rc16 liblvm2cmd2.03 lvm2 mdadm thin-provisioning-tools

# remove stuff
$rem intel-microcode
$rem amd64-microcode
$rem akonadi-server
$rem openssh-server
$rem ubuntu-archive-keyring
$rem avahi-daemon
$rem cron
$rem bluez
$rem firefox-esr


$a *qtgstreamer*
$a xinit
$a preload

$a efibootmgr systemd-boot systemd-boot-efi

$a kali-desktop-kde



	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)
	
#####################################################################################################
####### END #########################################################################################
#####################################################################################################
