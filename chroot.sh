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

### variables
s=sudo
### partitions
### bootloader
bootfs='/dev/sda1'
### rootfs
rootfs='/dev/sda2'
### fs
fs='xfs'

### ENTER CHROOT
sudo apt install -f -y xfsprogs f2fs-tools
sudo mkdir -p /mnt/boot/efi
sudo mount -t vfat $bootfs /mnt/boot/efi
sudo mount -t $fs $rootfs /mnt
sudo mount --bind /dev /mnt/dev &&
sudo mount --bind /dev/pts /mnt/dev/pts &&
sudo mount --bind /proc /mnt/proc &&
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt 
echo " * IF YOU HAVE FILLED IN YOUR VARIABLES YOU SHOULD NOW HAVE ENTERED CHROOT * "


### SCRIPT FROM WITHIN CHROOT ONCE ENTERED 
### hdd chroot
hdd="/dev/sda"
bootfs="/dev/sda1"
sudo apt update && sudo apt -f -y install aptitude xfsprogs f2fs-tools
sudo mkdir -p /boot/efi
sudo mount -t vfat $bootfs /boot/efi
sudo aptitude -f install grub-efi grub2 -t kali-rolling
sudo grub-install $hdd
sudo grub-mkconfig /boot/grub/grub.cfg
sudo update-grub2
echo " * DONE * "

### if you ever mess with fstab and your system becomes read-only
#sudo mount -o remount,rw $rootfs /
