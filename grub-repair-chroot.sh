#!/bin/bash
sudo mkdir -p /boot/efi
sudo mount -t vfat /dev/sda1 /boot/efi
sudo aptitude -f install grub-efi grub2 -t kali-rolling
sudo grub-install /dev/sda
sudo grub-mkconfig /boot/grub/grub.cfg
sudo update-grub2
