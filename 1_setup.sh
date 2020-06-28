source="$(pwd)"                                             ###
basicsetup=$source/.basicsetup

### config
cd $basicsetup
chmod +x init.sh
sudo \cp init.sh /init.sh
cd / && sudo ./init.sh
if grep -q "@reboot root /init.sh" /etc/crontab
then
echo "Flag exists"
else
sudo sed -i "\$a@reboot root /init.sh" /etc/crontab
fi
cd $basicsetup
sudo dnf config-manager --add-repo https://brave-browser-rpm-nightly.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-nightly.s3.brave.com/brave-core-nightly.asc
sudo dnf install -y brave-browser-nightly
sudo pkill brave-browser-nightly

sudo rsync -v -K -a --force  MalakasUniverse /usr/share/wallpapers

sudo rsync -v -K -a --force --include=".*" .config ~/
sudo rsync -v -K -a --force --include=".*" .kde ~/
sudo rsync -v -K -a --force --include=".*" .local ~/
sudo rsync -v -K -a --force --include=".*" .gtkrc-2.0 ~/
sudo rsync -v -K -a --force --include=".*" .kodi ~/

cd ~/ && sudo chown -R $(id -u):$(id -g) $HOME

cd $source
yes | brave-browser-nightly https://chrome.google.com/webstore/detail/audio-only-youtube/pkocpiliahoaohbolmkelakpiphnllog
yes | brave-browser-nightly https://chrome.google.com/webstore/detail/scrollanywhere/jehmdpemhgfgjblpkilmeoafmkhbckhi

### swap
swap=5000000
swappiness=90

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
sudo sysctl vm.swappiness=$swappiness

### grub
sudo sed -i 's+GRUB_CMDLINE_LINUX_DEFAULT++g' /etc/default/grub
sudo bash -c 'echo "GRUB_CMDLINE_LINUX_DEFAULT" >> /etc/default/grub'
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/c\GRUB_CMDLINE_LINUX_DEFAULT="quiet splash udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
sudo sed -i '/GRUB_CMDLINE_LINUX/c\GRUB_CMDLINE_LINUX="quiet splash udev.log_priority=0 audit=0 noibrs noibpb nopti nospectre_v2 nospectre_v1 l1tf=off nospec_store_bypass_disable no_stf_barrier pti=off mds=off spectre_v1=off spectre_v2_user=off spec_store_bypass_disable=off mitigations=off scsi_mod.use_blk_mq=1 idle=poll tsx_async_abort=off elevator=none i915.enable_rc6=0 acpi_osi=Linux"' /etc/default/grub
sudo sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub

sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg

### fstab
### ext4
if grep -q "lazytime" /etc/fstab
then
echo "Flag exists"
else
sudo sed -i 's/errors=remount-ro/commit=60,discard,quota,lazytime,noatime,errors=remount-ro/g' /etc/fstab
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
  sudo sed -i "\$atmpfs    /tmp        tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /var/tmp    tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
  sudo sed -i "\$atmpfs    /run/shm    tmpfs    rw,defaults,lazytime,noatime,nodiratime,mode=1777 0 0" /etc/fstab
fi

### bashrc
if grep -q "export PATH" ~/.bashrc
then
echo "Flag exists"
else
sudo sed -i "\$aexport PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH'" ~/.bashrc
fi
if grep -q "xhost +si:localuser:root >/dev/null" ~/.bashrc
then
echo "Flag exists"
else
sudo sed -i "\$axhost +si:localuser:root >/dev/null" ~/.bashrc
fi
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

### setup
sudo dnf update
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf groupupdate -y core

sudo dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
sudo dnf install -y lame\* --exclude=lame-devel
sudo dnf group upgrade -y --with-optional Multimedia

sudo dnf group install -y kde-desktop-environment kwayland-integration

sudo dnf install -y --skip-broken alien dpkg debconf kexec-tools dnf-plugins-core dnf-plugin-system-upgrade vlc ccache kodi kodi-pvr-hts lsb-core-noarch \
bc binutils bison ccache clang curl diffutils flex gcc gcc-aarch64-linux-gnu gcc-c++ git glibc-devel.{x86_64,i686} gnupg1 gperf hostname java-1.8.0-openjdk-devel java-latest-openjdk-headless libstdc++.i686 libtool libX11-devel.i686 libXrandr.i686 libXrender.i686 lld llvm m4 make mesa-libGL-devel.i686 ncurses-compat-libs ncurses-devel.i686 perl-Digest-MD5-File pngcrush python-markdown readline-devel.i686 schedtool shtool which xz-lzma-compat zip zlib-devel.{x86_64,i686} \
gnome-disk-utility putty gimp audacity rt-tests uget net-tools aircrack-ng nmap snapd

sudo dnf install -y npm && sudo npm cache clean -f && sudo npm cache clean -f && sudo npm install npm@latest -g

wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
sudo rpm -i gitkraken-amd64*
sudo rm -rf gitkraken-amd64*

wget https://atom-installer.github.com/v1.48.0/atom.x86_64.rpm?s=1591786015&ext=.rpm
sudo rpm -i atom.x86_64*
sudo rm -rf atom.x86_64*

mkdir ~/GIT && cd ~/GIT
git clone https://github.com/akhilnarang/scripts.git
cd scripts/setup
Keys.ENTER | ./fedora.sh

### llvm
sudo touch /etc/yum.repos.d/che-llvm.repo
sudo sh -c 'echo "[che-llvm]
name=Copr repo for llvm owned by che
baseurl=https://copr-be.cloud.fedoraproject.org/results/che/llvm/fedora-32-x86_64/
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/che/llvm/pubkey.gpg
enabled=1
enabled_metadata=1

[che-llvm-x86]
name=Copr repo for llvm i386 owned by che
baseurl=https://copr-be.cloud.fedoraproject.org/results/che/llvm/fedora-32-i386/
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/che/llvm/pubkey.gpg
enabled=1
enabled_metadata=1" | tee /etc/yum.repos.d/che-llvm.repo'

sudo dnf update && sudo dnf upgrade -y

echo DONE! you can reboot rn...
read -p "Press Enter to reboot or Ctrl+C to cancel"

sudo reboot
