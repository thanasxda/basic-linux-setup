### personal setup (eol/unmaintained) 
Only arch script might work despite lack of maintenance. Main focus of this setup is reducing overhead. Be sure to run `sudo ./configure.py` to configure it to YOUR needs prior to using this setup if you choose to do so.
TLDR: Remember prior to using this setup as is inform yourself on mitigations. 
Test [__here__](https://leaky.page/). Unless you use the GUI config they will be disabled by default on anything less than v4 instruction-set cpu's that are x86. Also remember this setup optionally will compile clrxt-x86 which I have no time updating and by default only the Arch script (since if I do update its mainly the Arch setup as it requires lesser effort) will pass the option to the kernel build script for building for security or performance (mitigations mainly & zeroing registers). Be sure to personalize this setup prior to usage, as it is set to my own needs. I did go as far as making it easily configurable for you.
The Arch setup can be used in many ways, libre repo's are included for people having privacy in mind for conversion (will need linux-libre-firmware and libre kernel after activating the specific repositories. check for proprietary software and remove all non-free instructions in readme). There are example configs in this setup. The rest is up to your personal needs. Setup might see more balanced approach between performance and security in future.
Further tests [__here__](https://webkay.robinlinus.com/).
DISCLAIMER: use setup responsibly. it's personal. 

![image](bls.jpg)

## About:

*__Basic-linux-setup__ is a quick script to setup Linux. It is meant to be used with KDE desktop environment. There is a small subsection for OpenWrt and/or any general device running Android or Linux wanting to benefit from kernel parameter configuration. In short this is a multi setup containing everything from full Linux for desktop up to Linux configuration for general devices. Its purpose is basic automation of a freshly installed system for convenience and optimize Linux devices in general for performance. This is done through configuring userspace and kernel. Additionally also includes drivers, codecs, general packages, zsh shell customization, KDE preconfiguration, browser preconfiguration and extras in case of the full desktop system. The scripts in this newer setup have been slimmed down to function as a base more or less for your own setup.
Both variants of the full-setup come with a custom kernel which I modified taking from clear-linux and xanmod which will be compiled and installed automatically near the end of the setup using native code optimization.
ps. The custom kernel will be deblobbed however you can easily merge mainline if needed.*

## Instructions for all devices:

**For the full setup of basic-linux-setup on x86 copy paste underneath line in console to start:**
```
sudo apt update && sudo apt -f install -y git && git clone -j32 --depth=1 -4 --single-branch https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && git checkout master && chmod +x *.sh &&
firstrun=yes ./1_debian*/1_arch* (or any other future distro that might be included.)
```
**For parameter configuration only, running any distribution on x86, OpenWrt, Open/Libre-elec & Linux devices in general, copy paste:**
```
wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh -O /tmp/init.sh && chmod +x /tmp/init.sh &&
firstrun=yes sh /tmp/init.sh
```
**For Android, install [__Busybox__](https://forum.xda-developers.com/t/tools-zips-scripts-osm0sis-odds-and-ends-multiple-devices-platforms.2239421/) and copy paste in [__terminal__](https://store.nethunter.com/packages/com.offsec.nhterm/):**
```
su
# After copy & paste
if [ -f /system/xbin/sh ] ; then export xbin="/system/xbin/" ; fi
cd /sdcard && rm -f init.sh
"$xbin"wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh
"$xbin"chmod +x init.sh 
firstrun=yes "$xbin"sh -x init.sh
```
Also available for installation in the form of a Magisk module which is the recommended installation method: [__Download here__](https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/basic-linux-setup-installer-magisk-module.zip).
Reboot and connect to internet after flashing the module for it to get activated. You must install the [__Busybox__](https://forum.xda-developers.com/t/tools-zips-scripts-osm0sis-odds-and-ends-multiple-devices-platforms.2239421/) Magisk module which is located in `/system/xbin` for it to work. Legacy devices especially when using older Busybox binaries.
After reboot the first run of the setup which happens automatically when connected to the internet might take a bit on older devices, once finished a final reboot is needed for everything to get activated. This is only on the first run, you know its done when the script is placed under `/data/adb/service.d/init.sh`. If it's not done and you reboot too early the Magisk module will rerun the setup in first run mode. Once the first run is complete it will execute normally on every reboot. If youre online it will automatically fetch latests updates from this repo on every reboot and execute them on every next reboot. Otherwise the setup will use local settings and not update anything. Setup will also enable F2FS support on Android.

_Since script tries to aim for compatibility, if you have troubles booting the script enable [__init.d__](https://forum.xda-developers.com/attachments/update-kernel_init-d_injector-ak2-signed-zip.3761907/)_ _support. This should only be necessary when not being able to run [__Magisk__](https://github.com/topjohnwu/Magisk/releases)_. _All links to the downloads are in this text._

**For OpenWrt basic setup check out:**
```
wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/wrt.sh -O /tmp/wrt.sh && chmod +x /tmp/wrt.sh &&
sh /tmp/wrt.sh
```
Note: Only been tested by myself personally on x86 and OpenWrt. Not compatible with your device? Leave note and contribute by giving information for me to include it. 
__DO NOT FORGET IT IS STILL IN EARLY STAGES AND REQUIRES MORE WORK TO BE FLAWLESS WITHOUT BUGS, AT LEAST ON DEVICES IT HAS NOT BEEN TESTED ON YET!__

## Main contents:
---
   - [configuration](https://github.com/thanasxda/basic-linux-setup/blob/master/init.sh)
***
   - [basic openwrt setup](https://github.com/thanasxda/basic-linux-setup/blob/master/wrt.sh)
___

## Additional information:

 Repositories:
  - [__sources.list__](https://github.com/thanasxda/basic-linux-setup/blob/master/sources.list)

  - [__extras.list__](https://github.com/thanasxda/basic-linux-setup/blob/master/extras.list)
  
 Mitigations:
  - [__mitigations=off__](https://www.phoronix.com/review/3-years-specmelt)

 Recommendations for bios:
  - [__me_cleaner__](https://github.com/corna/me_cleaner)
  - [__coreboot__](https://github.com/coreboot/coreboot)

 For kernel parameters check:
  - [__linux - kernel parameters__](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt)

 Filesystems:
  - [__XFS/F2FS__](https://www.phoronix.com/review/linux-58-filesystems/2)
  
## Recommendations:

   - Disabling __HPET__ or any timers used in bios.
   - Formatting disk to __blocksize 4096__ on __XFS__ on __GPT__ partitioning table while disabling __MBR__ in bios and choosing __UEFI__ mode only. If using anything Arch based pick __F2FS__.
     This can be done prior or during expert installation not sure if with the regular setup, you drop down in shell: _"Execute a shell"_ and for example: `fdisk -l ; mkfs.xfs /dev/sda2 -b size=4096 -f`
   - In case of Intel using [__me_cleaner__](https://github.com/corna/me_cleaner) don't know if AMD has a counterpart fix.
   - Modifying the setup to __your own needs__.
   - If your hardware supports gpu rebar enable it in bios, the setup is configured to enable it.
   - Kdeconnect app is nice to have on Android.
   - Having a minimum of __2GB RAM__ for the full Kali Linux KDE setup. As for the preconfiguration, no limit for generic devices.
     Zswap + zram enabled by default for devices of 2GB or less except for OpenWrt, Tvboxes & Open/Libre-elec.
     Memory management dependent on the amount present. Different amounts different settings.
     In the case of a low spec system make use of a separate __swap__ partition if using desktop.
     Always prefer a swap partition over a __/swapfile__ due to relative performance.
     Mind you Linux in combination with KDE only uses up 400MB/600MB ram max, it's heavy applications that don't.
     [__Swap on vram__](https://wiki.archlinux.org/title/Swap_on_video_RAM) is also possible.
   - If you need windows for dual boot for any reason, [__ReactOS__](https://reactos.org/) is an opensource reverse engineered version of windows.

## Command line parameters on Android:

Note that hijacking the kernel command line parameters through userspace was a lazy effort as I am focused solely on userspace configuration through this setup. It is however very easy since chances are slim many devices will support this, doing this on other devices without recompilation. For example on Android the boot.img can be extracted, configured and repacked with kernel command line parameters and changes within the fstab if the fstab happens to be on the ramdisk instead of on a device partition. One of the many methods of achieving this explained underneath by example. Hackbench and other tools are also availabe on Android under Magisk module [benchkit](https://github.com/kdrag0n/benchkit/releases/tag/v2.0.0). It's also possible running Linux in chroot within Android if you need more or if you would like to keep it minimal [termux](https://termux.dev/en/). Most devices will have a kernel which will not read added parameters at boot, mainly for security. However if it does, the kernel can be adjusted either from hijacking /proc/cmdline or from the command line parameters within the boot.img. Same goes to OpenWrt btw. Not to every device however. In case of making your own kernel make sure to check out options such as `CONFIG_CMDLINE_FROM_BOOTLOADER`, `CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_MODIFY_CMDLINE` etc. Note that changes should be seen in `cat /proc/cmdline`. `dmesg | grep "Command line"` doesn't show everything even when it's enabled. It is worth if your kernel supports this configuring it from userspace, as compilation takes time and effort and can't apply to multiple devices simoultanious if they differ.
```
git clone -j32 --depth=1 -4 --single-branch https://github.com/thanasxda/AIK
cd AIK
# Enter adb shell on device
adb shell
su
cat $(grep /boot /path/to/fstab* | awk '{print $1}') > /sdcard/boot.img
exit
# Exit adb shell from device
adb pull /sdcard/boot.img boot.img
sudo su
./cleanup.sh
./unpackimg.sh boot.img
# If your fstab is on ramdisk then...
nano ramdisk/fstab*
# Editing linux kernel command line parameters
nano split_img/boot.img-cmdline
# Flags that are worth for commandline might be: cgroup_disable=memory and for newer kernels above 5.1.13 mitigations=off, older kernels must call mention the individual mitigations, for fstab: lazytime.
# Disabling mitigations on older kernels for arm64: spectre_v2_user=off ssbd=force-off kvm.nx_huge_pages=off kpti=0 (also needs 'nokaslr')... more details in the script.
# Now repack the image. Note modifying default.prop on ramdisk is also possible. Modifying init.rc might also be a good idea.
./repackimg.sh
adb push image-new.img /sdcard/moddedboot.img
adb reboot recovery
# Ready for flashing, can script all this in to be automed. Yet safer doing manually.
# You can also flash directly from userspace with underneath method
dd if=/sdcard/moddedboot.img of=$(grep /boot /path/to/fstab* | awk '{print $1}') 
```
Note: This way one could also include F2FS support on Android since the drivers are within the kernel by copying the /data and /cache lines from EXT4 and swapping the flags for the filesystem.

## Extras:

List non-free software:
Debian:
```
dpkg-query -W -f='${Section}\t${Package}\n' | grep ^non-free
```
Arch:
```
absolutely-proprietary
```

## Links:

   - [clrxt-x86](https://github.com/thanasxda/clrxt-x86)
   
   - [linux kernel - parameters](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt)

   - [linux kernel - x86 general](https://docs.kernel.org/x86)

   - [arch wiki - improving performance](https://wiki.archlinux.org/title/Improving_performance)

