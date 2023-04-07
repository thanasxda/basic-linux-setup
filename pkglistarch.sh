#!/bin/sh
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
echo -e "${yellow}"
echo "" && echo "" && echo "" && echo "pkglist starting..." && echo "" && echo "" && echo ""

u=$(who | head -n1 | awk '{print $1}')

$s chown root /usr /var

# thanas

#jitterentropy

#$s pacman -Rsc iptables
pkg="base-devel mesa arch-install-scripts usbutils bash-language-server python-lsp-server xorg util-linux-libs gptfdisk iputils net-tools nftables perl wireless_tools iw busybox dracut systemd-ui systemd-sysvcompat f2fs-tools xfsprogs attr linux-firmware kmod cronie bc discover flatpak fwupd partitionmanager gstreamer phonon-qt5 gstreamer gstreamer-vaapi qt-gstreamer python-pip openssh putty rng-tools rt-tests shellcheck uget ccache vlc hdparm ethtool xsettingsd virt-manager apparmor diffuse htop psensor wireless-regdb binwalk rtirq lz4 shellcheck kvantum-theme-materia kvantum kio-fuse kio-extras kio firewalld kwrite dolphin dolphin-plugins irqbalance openssl efibootmgr dbus-broker xorg-xinit fail2ban android-tools android-udev dpkg lz4 macchanger kdebugsettings ffmpeg ffmpeg4.4 x264 x265 aom dav1d svt-av1 schroedinger libdv libmpeg2 libtheora libvpx libva-mesa-driver mesa-utils mesa-vdpau opencl-mesa vulkan-mesa-layers libva-mesa-driver libva-utils libva-vdpau-driver libvdpau-va-gl vdpauinfo vulkan-icd-loader spectacle openbox imagemagick vim powerline-vim x86_energy_perf_policy openh264 glxinfo sweeper xz zstd pigz pbzip2 gst-libav libcdio libdvdread libsidplay gst-plugins-base gst-plugins-good gst-plugins-ugly gst-plugins-bad libdvdcss os-prober lsb-release reflector tcc perl-locale-gettext sxiv zathura ranger nix i7z inetutils xmlto refind gnubg tig lld polly llvm openmp cmake ninja git-lfs traceroute ristretto okular"
 yes | $s pacman -S iptables-nft
 #for i in ${pkg[@]} ; do
 $s pacman -S --noconfirm --needed $pkg
 #done
 #r8168

 #$s pacman -S --noconfirm --needed jitterentropy uresourced nohang

 $s rm -rf ~/.cache/yay /home/$u/.cache/yay /root/.cache/yay
pkg2="alsa-tools dkms debtap linux-clear-bin w3m-imgcat"
 #for i in ${pkg2[@]} ; do
 #yay -S --noconfirm --needed $i ; done
 #$s pacman -R --noconfirm --needed $pkg2
 yay -S --noconfirm --needed $pkg2

$s pacman -S --noconfirm --needed tk python ipython 
$s pacman -S --noconfirm --needed jdk-openjdk
$s pip install requests instaloader pillow

pip install requests instaloader pillow


 yay -S --noconfirm --needed preload
 #yay -S --noconfirm --needed pamac-aur
 #yay -S --noconfirm --needed octopi
 yay -S --noconfirm --needed fastfetch
 #yay -S --noconfirm --needed cw
 yay -S --noconfirm --needed plzip
 yay -S --noconfirm --needed pkg_scripts


 #yay -S --noconfirm --needed cfiles archlinux-tweak-tool-git

pip install requests

$s flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
$s pacman -S --noconfirm --needed glxinfo
if
glxinfo | grep -qi Intel ; then
$s pacman -S --noconfirm --needed vulkan-intel intel-media-driver libva-intel-driver xf86-video-intel lib32-vulkan-intel libvdpau-va-gl lib32-vulkan-intel libva-utils lib32-mesa ; elif
glxinfo | grep -qi NVIDIA ; then
$s pacman -S --noconfirm --needed nvidia-utils libvdpau xf86-video-fbdev nvidia nvidia-xconfig ; elif
glxinfo | grep -qi AMD ; then
$s pacman -S --noconfirm --needed vulkan-radeon amdvlk xf86-video-amdgpu
fi

yay -S --noconfirm --needed vscodium


if lscpu | grep -q Intel ; then
yay -S --noconfirm --needed iucode-tool intel-ucode-clear
$s pacman -S --noconfirm --needed thermald
fi


if [ $(awk '/ID=/{print}' /etc/os-release | cut -d '=' -f 2 | head -n1) = endeavouros ] ; then
$s pacman -S --noconfirm --needed eos-sddm-theme eos-plasma-sddm-config eos-settings-plasma endeavouros-skel-default eos-dracut eos-downgrade eos-hooks ; fi
#yay -S --noconfirm --needed kernel-install-for-dracut ; fi



if $(yay -Ss linux-clear-bin | grep -q installed) ; then
$s pacman -Rsn --noconfirm linux
$s pacman -Rsn --noconfirm linux-headers
fi



if pacman -Ss dracut | grep -q installed ; then $s pacman -Rsn --noconfirm mkinitcpio ; fi


#####################################################################################################
####### END #########################################################################################
#####################################################################################################
