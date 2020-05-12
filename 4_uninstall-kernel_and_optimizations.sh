#!/bin/bash
### KERNEL UNINSTALL SCRIPT
###########################

###### SET BASH COLORS
yellow="\033[1;93m"
magenta="\033[05;1;95m"
restore="\033[0m"

###### DETECT CURRENT PATCHLEVEL VERSIONING ONLY - for safety
makefile=~/GIT/thanas-x86-64-kernel/Makefile

VERSION=$(cat $makefile | head -2 | tail -1 | cut -d '=' -f2)
PATCHLEVEL=$(cat $makefile | head -3 | tail -1 | cut -d '=' -f2)
SUBLEVEL=$(cat $makefile | head -4 | tail -1 | cut -d '=' -f2)
EXTRAVERSION=$(cat $makefile | head -5 | tail -1 | cut -d '=' -f2)
VERSION=$(echo "$VERSION" | awk -v FPAT="[0-9]+" '{print $NF}')
PATCHLEVEL=$(echo "$PATCHLEVEL" | awk -v FPAT="[0-9]+" '{print $NF}')
SUBLEVEL=$(echo "$SUBLEVEL" | awk -v FPAT="[0-9]+" '{print $NF}')
#EXTRAVERSION="$(echo -e "${EXTRAVERSION}" | sed -e 's/^[[:space:]]*//')"
#KERNELVERSION="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}${EXTRAVERSION}"
RC_KERNEL="${VERSION}.${PATCHLEVEL}.${SUBLEVEL}"-rc*

### for deletion of a specific version or older than current version
### input kernelname into one of the "manual='name_here*'" underneath
### note that the usage of * will remove any kernel starting with that name
###### INPUT KERNEL NAME HERE!
manual=5.7.0-rc4*

echo -e "${magenta}"
echo ALL MANUALLY SPECIFIED KERNELS WITHIN THIS SCRIPT WILL BE REMOVED!
echo if kernel source is present in predetermined location,
echo all current version $RC_KERNEL will be removed.
echo -e "${restore}"

###### KERNEL REMOVAL
sudo rm -rf /boot/vmlinuz-$manual
sudo rm -rf /boot/initrd-$manual
sudo rm -rf /boot/initrd.img-$manual
sudo rm -rf /boot/System.map-$manual
sudo rm -rf /boot/config-$manual
sudo rm -rf /lib/modules/$manual/
sudo rm -rf /var/lib/initramfs/$manual/
sudo rm -rf /var/lib/initramfs-tools/$manual

sudo rm -rf /boot/vmlinuz-$RC_KERNEL
sudo rm -rf /boot/initrd-$RC_KERNEL
sudo rm -rf /boot/initrd.img-$RC_KERNEL
sudo rm -rf /boot/System.map-$RC_KERNEL
sudo rm -rf /boot/config-$RC_KERNEL
sudo rm -rf /lib/modules/$RC_KERNEL/
sudo rm -rf /var/lib/initramfs/$RC_KERNEL/
sudo rm -rf /var/lib/initramfs-tools/$RC_KERNEL

###### INIT.SH KERNEL PRECONFIG SCRIPT REMOVAL
sudo rm -rf /init.sh

###### SYSTEM OPTIMIZATION REVERSAL TO STOCK
sudo sed -i '10s/.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
sudo update-grub2
GRUB_PATH=$(sudo fdisk -l | grep '^/dev/[a-z]*[0-9]' | awk '$2 == "*"' | cut -d" " -f1 | cut -c1-8)
sudo grub-install $GRUB_PATH

###### COMPLETION
echo -e "${yellow}"
echo ...
echo ...
echo ...
echo ALL SPECIFIED KERNELS UNINSTALLED AND ALL OPTIMIZATIONS REVERTED
echo -e "${restore}"

###### END
