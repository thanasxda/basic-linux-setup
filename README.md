## About

- different branches for different distros, as of right now (kde) kali and (k)ubuntu groovy 20.10. (don't forget to checkout to distro branch)
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
sudo apt update && sudo apt -f install -y git && git clone https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && git checkout kali && chmod 755 *.sh && ./1*
```
## f2fs rootfs on kali

there is an easy method to get f2fs on distro's which doesn't involve taking a backup image and manually restoring and adjusting it.
goes as follows.

as opposed to a regular installation you will need to download the [kali-linux-2020-*-live-amd64.iso](https://cdimage.kali.org/kali-images/kali-weekly/) this time.
flash on usb using underneath command, or just pick your own method of flashing the image onto any medium.
```
sudo dd if=/path/to/image of=/path/to/bootablemedia bs=10M
```
once done boot it, if possible set bios to uefi only mode.
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
sudo ./calamares
```
proceed with the setup, however choose manual partitioning.
format first partition with a size of 512mb as FAT32. set it's mountpoint to '/boot/efi' and pick 'boot' from flags.
for the second partition pick F2FS and make it whatever size you wish to run your distro on select mountpoint '/' no bootalble flags required.
proceed with the installation and reboot once done.
once  rebooted into the f2fs installed system run.
```
sudo apt update && sudo apt install -y tasksel && sudo tasksel
```
now clear selection of xfce desktop, pick kde and proceed.
calamares will also overwrite sources.list so in this case recover it like this:
```
sudo bash -c 'echo "deb http://http.kali.org/kali kali-rolling main non-free contrib
"  > /etc/apt/sources.list'
```
you can now move on to running the basic-linux-setup while on f2fs.

## Links
- [kubuntu branch: Kubuntu daily build - KDE/plasma desktop (groovy-desktop-amd64.iso)](http://cdimage.ubuntu.com/kubuntu/daily-live/current/)
- [kali branch: Kali weekly build - KDE/plasma desktop (kali-linux-*-installer-netinst-amd64.iso)](https://cdimage.kali.org/kali-images/kali-weekly/)
- [thanas-x86-64-kernel source](https://github.com/thanasxda/thanas-x86-64-kernel.git)
