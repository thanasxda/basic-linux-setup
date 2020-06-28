Note: **DROPPED FUTURE SUPPORT FOR ALL BRANCHES EXCEPT OF 'debian-minimal', furthermore the setup is meant for personal use. adjust if necessary. ALL distros use kde desktop**

## About

- different branches for different distros, as of right now debian, ubuntu, fedora and kali (don't forget to checkout to distro branch)
- hash out script sections for compatibility if other distro.
- auto compiles&installs thanas-x86-64-kernel upon completion, based on latest modded fork of torvalds dev git.
- built with latest daily llvm-11 for now.
- every file comes with extensive instructions to make life easier in case of personalization.
- script mainly meant as an unattended script, minimal user input is needed right at the start only.
- plugin devices which require exceptional driver support when running the script for kernel support.

Note: **<font color='red'>DO NOT run the script as SU!</font> (unless root is your useraccount)**

## Instructions

1. setup
2. sources.list restoration + backup
3. uninstall customizations
4. uninstall kernel & linux optimizations
5. fix home permission errors

**copy & paste underneath line in console to start:**

```
sudo apt update && sudo apt -f install -y git && git clone https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && chmod 755 *.sh && ./1*
```
## alternative filesystems on distros like debian

download [debian-live-testing-amd64-kde.iso](https://cdimage.debian.org/cdimage/weekly-live-builds/amd64/iso-hybrid/debian-live-testing-amd64-kde.iso) and flash it on usb.
boot up and for example for f2fs and xfs support run underneath command:
```
sudo apt update && sudo apt install xfsprogs f2fs-tools
```

proceed with installation and choose your filesystem through the live usb installation.

## f2fs rootfs on kali

there is an easy method to get f2fs on distro's which doesn't involve taking a backup image, manually restoring and adjusting it after.
goes as follows...

as opposed to a regular installation you will need to download the [kali-linux-2020-W*-live-amd64.iso](https://cdimage.kali.org/kali-images/kali-weekly/) this time.
flash on usb using underneath command after using 'fdisk -l' command to get to know the partitioning, or just pick your own method of flashing the image onto any medium.
example of underneath command: 'sudo dd if=~/Downloads/kali-linux-2020-W26-live-amd64.iso of=/dev/sdb bs=10M'
```
sudo dd if=/path/to/image of=/path/to/bootablemedia bs=10M conv=fsync status=progress
```
once done boot it on live usb mode, if possible set bios to uefi only mode.
after the live usb is booted run. (remember if you reboot you need to redo these steps since the live usb will reset all upon reboot)
```
sudo apt update && sudo apt install -y f2fs-tools calamares calamares-settings-debian
```
now check on which medium the iso installation is mounted using:
```
sudo fdisk -l
```
then proceed on mounting the usb installation on root so calamares installer can detect it. (sdXX for ex sdb2, path to installation iso)
```
sudo mount /dev/sdXX /mnt
```
now finally run the calamares installer.
```
sudo calamares
```
proceed with the setup, however choose manual partitioning.
format first partition with a size of 512mb as FAT32. set its mountpoint to '/boot/efi' and pick 'boot' from flags.
for the second partition pick F2FS and make it whatever size you wish to run your distro on select mountpoint '/' no bootalble flags required.
(be aware f2fs can be resized only for enlargement, other words once you set partition size you cannot make it smaller afterwards)
proceed with the installation and reboot once done.
once rebooted into the f2fs installed system run.
```
sudo apt update && sudo apt install -y tasksel && sudo tasksel
```
now clear selection of xfce desktop, pick kde and proceed.
calamares will also overwrite sources.list so in this case recover it like this:
```
sudo bash -c 'echo "deb http://http.kali.org/kali kali-rolling main non-free contrib"  > /etc/apt/sources.list'
```
also make sure to install kde's display manager, set is as default and switch to plasma-desktop on login screen after reboot.
```
sudo apt install -y sddm && sudo dpkg-reconfigure sddm
```
remember that the f2fs filesystem will fsck upon every kernel change on boot.
you can now move on to running the basic-linux-setup while on f2fs.
to fully uninstall all usb live kali apps run following command while being logged in on kde:
```
sudo apt -f remove xfce*
```
note that you can do this trick on several distro's making it possible to directly install a specific unsupported filesystem.
keep in mind by doing so worst case sometimes depending on distro it would be necessary to mount the distro as chroot  and after installing specific fs support drivers on the system, next to that you would also need to be on grub 2.04 at least to have full support on rootfs (not needing a seperate bootfs), which you also could install from chroot. IF necessary at all following this guide on other distro's the correct way to mount chroot and work on the system would be:
```
sudo fdisk -l                         ### check partition layout
sudo mkdir /mnt/boot
sudo mkdir /mnt/boot/efi
sudo mount /dev/sdXX /mnt/boot/efi    ### sdXX example /dev/sda1 bootfs
sudo mount /dev/sdXX /mnt             ### sdXX example /dev/sda2 rootfs
sudo mount -t proc none /mnt/proc
sudo mount --rbind /sys /mnt/sys
sudo mount --rbind /dev /mnt/dev
sudo ln -s /etc/resolv.conf /mnt/etc/resolv.conf
sudo chroot /mnt /bin/bash            ### you are now running the system in chroot
```
from there on you can manually get the drivers and update grub to make it work in stubborn cases.

## Links
- [debian-live-testing-amd64-kde.iso](https://cdimage.debian.org/cdimage/weekly-live-builds/amd64/iso-hybrid/debian-live-testing-amd64-kde.iso)
- [groovy-desktop-amd64.iso](http://cdimage.ubuntu.com/kubuntu/daily-live/current/)
- [kali-linux-*-installer-netinst-amd64.iso](https://cdimage.kali.org/kali-images/kali-weekly/)
- [thanas-x86-64-kernel source](https://github.com/thanasxda/thanas-x86-64-kernel.git)
