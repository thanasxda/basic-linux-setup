#!/bin/bash
sudo mkdir -p /mnt/boot/efi
sudo mount -t vfat /dev/sda1 /mnt/boot/efi
sudo mount -t xfs /dev/sda2 /mnt
sudo mount --bind /dev /mnt/dev &&
sudo mount --bind /dev/pts /mnt/dev/pts &&
sudo mount --bind /proc /mnt/proc &&
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
