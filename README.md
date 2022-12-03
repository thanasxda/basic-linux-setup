# BASIC-LINUX-SETUP
Setup has been slimmed down to avoid bloating and serious degradation of performance.
![image](bls.jpg)

## ₀. Table of contents
   -   **₀**.   [_TOC_](https://github.com/thanasxda/basic-linux-setup#-table-of-contents)
   -   **₁**.   [_DISCLAIMER_](https://github.com/thanasxda/basic-linux-setup#-disclaimer)
   -   **₂**.   [_WARNING_](https://github.com/thanasxda/basic-linux-setup#-warning)
   -   **₃**.   [_FOREWORD_](https://www.youtube.com/watch?v=xvFZjo5PgG0)
   -   **₄**.   [_ABOUT_](https://github.com/thanasxda/basic-linux-setup#-about)
   -   **₅**.   [_MAIN CONTENTS_](https://github.com/thanasxda/basic-linux-setup#-main-contents)
   -   **₆**.   [_INSTRUCTIONS_](https://github.com/thanasxda/basic-linux-setup#-instructions)
   -   **₇**.   [_RECOMMENDATIONS_](https://github.com/thanasxda/basic-linux-setup#-recommendations)
   -   **₈**.   [_NOTES_](https://github.com/thanasxda/basic-linux-setup#-notes)
   -   **₉**.   [_TROUBLESHOOTING_](https://github.com/thanasxda/basic-linux-setup#-troubleshooting)
   -   **₁₀**.   [_ALTERNATIVE FILE SYSTEMS_](https://github.com/thanasxda/basic-linux-setup#-alternative-file-systems)
   -   **₁₁**.   [_CHROOT_](https://github.com/thanasxda/basic-linux-setup#-chroot)
   -   **₁₂**.   [_HELP_](https://github.com/thanasxda/basic-linux-setup#-help)
   -   **₁₃**.   [_LINKS_](https://github.com/thanasxda/basic-linux-setup#-links)

## ₁. DISCLAIMER:

<sup>**!!!SCRIPTS ARE INTENDED FOR PERSONAL USE ONLY. USE AT OWN RISK!!!**</sup>
<sup>**I AM NOT RESPONSIBLE IF YOUR SYSTEM GETS MESSED UP OR ANYTHING ELSE THIS SCRIPT MIGHT LEAD TO. ONLY DEFAULT BRANCH MIGHT BE UPDATED. EVEN IF THIS SCRIPT MIGHT WORK WITH DEBIAN OR DEBIAN BASED DISTRIBUTIONS, I DO NOT CHECK NOR AIM FOR THIS. IF IT HAS EVEN BEEN UPDATED WHATSOEVER.**</sup>

## ₂. Warning:

**THIS SETUP IS OPTIMIZED FOR KALI NATIVE INSTALLER USING KDE DESKTOP: [_DOWNLOAD HERE_](https://www.kali.org/get-kali/#kali-installer-images) AND CHOOSE "INSTALLER" ISO. IT WORKS ON OTHER DESKTOP ENVIRONMENTS JUST AS WELL BUT DUE TO KDE WAYLAND PACKAGES WILL AUTOMATICALLY INSTALL KDE. THE SYSTEM BASICALLY BECOMES A HYBRID OF KALI/DEBIAN SID REPOSITORIES. SETUP ALSO DISABLES CRUCIAL SECURITY FUNCTIONS SUCH AS MITIGATIONS SACRIFICING SECURITY IN FAVOR OF PERFORMANCE. I RECOMMEND FORKING AND MODIFYING IT TO YOUR OWN PERSONAL NEEDS. README IS INTENDED FOR INEXPERIENCED USERS UP TO ABSOLUTE BEGINNERS OPTING TO USE THIS SCRIPT. SCRIPTS ARE USER FRIENDLY, PROMOTING CUSTOMIZATION. _NOTE_: README PROBABLY HAS LEAST PRIORITY OF BEING UPDATED. LOTS OF FORCE PUSHING AS WELL.**

## ₃. Foreword:

I am not a developer nor a professional, just an average Linux user at best case. Scripts are slapped together just to get the job done. Minimal effort and maintenance. Only might have a quick update here and there mainly changing packages when I happen to use these scripts. Remember this readme as stated above is made even to be used by the most absolute beginners for the sake of a better experience when using Linux, these scripts or even modify the scripts and configuration. Thus, the most common minor issues are explained in detail. Anyone else should not consider reading all of this.

## ₄. About:

*__Basic-linux-setup__ is a quick script to setup predominately Kali and use it as a base for __functioning as a daily driver, not intended for pentesting.__ It is meant to be used with KDE desktop environment. There is a small subsection for OpenWrt and/or any general device running Android or Linux wanting to benefit from kernel parameter configuration. Its purpose is basic automatization of a freshly installed system for convenience and optimize Linux devices in general for performance. This is done through configuring userspace and kernel. Additionally also includes drivers, codecs, general packages, zsh shell customization, KDE preconfiguration, browser preconfiguration, development packages for a broad build environment and security features which compromise performance insignificantly by default, which are not included on a fresh install.*

 Repositories:
  - [__sources.list__](https://github.com/thanasxda/basic-linux-setup/blob/master/sources.list)

  - [__extras.list__](https://github.com/thanasxda/basic-linux-setup/blob/master/extras.list)
  
 Mitigations:
  - [__mitigations=off__](https://www.phoronix.com/review/3-years-specmelt)

 Recommendations x86 Intel:
  - [__me_cleaner__](https://github.com/corna/me_cleaner)

 Kernel used:

  - [__linux-image-amd64__ _-t experimental_](https://packages.debian.org/experimental/linux-image-amd64)

 For kernel parameters check:
  - [__linux - kernel parameters__](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt)

 Other nice sources would include:
  - [__links section__](https://github.com/thanasxda/basic-linux-setup#-links)

## ₅. Main contents:
---
   - [main setup](https://github.com/thanasxda/basic-linux-setup/blob/master/1_setup.sh)
***
   - [configuration](https://github.com/thanasxda/basic-linux-setup/blob/master/init.sh)
___
   - [general packagelist](https://github.com/thanasxda/basic-linux-setup/blob/master/pkglist.sh)
- - - -
   - [basic openwrt setup](https://github.com/thanasxda/basic-linux-setup/blob/master/wrt.sh)
* * * *

## ₆. Instructions:

**For the full setup of basic-linux-setup on x86 copy paste underneath line in console to start:**
```
sudo apt update && sudo apt -f install -y git && git clone -j32 --depth=1 -4 --single-branch https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && git checkout master && chmod +x *.sh &&
./1*
```
**For parameter configuration only, running any distribution on x86, Android, OpenWrt, Open/Libre-elec & Linux devices in general, copy paste:**
```
wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh -O /tmp/init.sh && chmod +x /tmp/init.sh &&
sh /tmp/init.sh
```
**For OpenWrt basic setup check out:**
```
wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/wrt.sh -O /tmp/wrt.sh && chmod +x /tmp/wrt.sh &&
sh /tmp/wrt.sh
```

## ₇. Recommendations:

   - Disabling __HPET__ or any timers used in bios.
   - Formatting disk to __blocksize 4096__ on __XFS__ on __GPT__ partitioning table while disabling __MBR__ in bios and choosing __UEFI__ mode only.
   - In case of Intel using [__me_cleaner__](https://github.com/corna/me_cleaner) don't know if AMD has a counterpart fix.
   - Modifying the setup to __your own needs__.
   - Having a minimum of __2GB RAM__ for the full Kali Linux KDE setup. As for the preconfiguration, no limit for generic devices.
     Zswap + zram enabled by default for devices of 2GB or less except for OpenWrt, Tvboxes & Open/Libre-elec.
     Memory management dependent on the amount present. Different amounts different settings.
     In the case of a low spec system make use of a separate __swap__ partition if using desktop.
     Always prefer a swap partition over a __/swapfile__ due to relative performance.
     Mind you Linux in combination with KDE only uses up 400MB/600MB ram max, it's heavy applications that don't.
     [__Swap on vram__](https://wiki.archlinux.org/title/Swap_on_video_RAM) is also possible.

## ₈. Notes:

During the end of the script custom package installation takes place. If setup gets stuck during this phase due to a slow repository just press __ctrl+C__ _ONCE_ to skip concerning package while its attempting installation or temporarily disable the corresponding repository, isolated usage of the **pkglists** could make things simpler in such situation. Whenever skipping a package however, make sure only doing this during the apt process being stuck on a slow repository and pressing the key combination only _ONCE_ if necessary at all. The packages call apt individually ensuring proper installation. This will only kill the separate instance of apt trying to fetch the particular package. Remember not doing this during any other time in the setup. For ease of usage nearing the end of the setup this process has been colored yellow in bash for easy recognition. Keep in mind when finalizing setup does attempt __apt-upgrade__. Some repositories aren't perfect, depending on where you're located.

Unfortunately for Debian repositories, it doesn't get more __bleeding edge__ while simultaneously preserving compatibility afaik. Setup should be stable for daily usage. The kernel releases used in this setup are just behind the release candidates of mainline. The stock kernels are preconfigured from userspace sharing some similarities with [__thanas-x86 kernel__](https://github.com/thanasxda/thanas-x86-64-kernel), making them perform a bit better than usual. In addition to this the setup only uses realtime kernels due to perceived responsiveness. Even if you're not into pentesting distro's Debian overall benches quite well and Kali even more so, at least at the time of making this. Also provides additional repo's for Debian packages making it more up to date. You do not need to install any additional tools from Kali to benefit from the setup if you do not use them. The distro is made indistinguishable from your regular distro due to customization. Try avoiding snap and Ubuntu repo unless no alternatives. XFS is also all round best fs for general purpose. Do not forget disabling timers in bios like __hpet__ since the setup uses __clocksource=tsc__. Parameter setup is intended for devices which have enough ram memory to fulfill their purpose.

**Do _NOT_ disable cpu mitigations in the case of of x86 routers...** I do not encourage using this setup as is while syncing from my repo. Make a fork and modify it to own needs and maybe I'll even cherry-pick potential improvements after testing. Not only due to security reasons but mostly due to the fact of automated updates which might lead to trouble when I am working on it while it automatically gets applied for anyone using it. For this reason there is a staging branch, do not use it as most probably it will be broken. As for the other branches, they haven't been updated in ages and do not match the setup being used on the default branch by any means. Neither do I have any intentions providing maintenance for any other distribution.

In this case, the parameter script can be used from the master repo. __Setup.sh__ also contains some packages, but they are preliminary. Most packages are located in the external scripts. Also eases matters when users need to modify the setup, or troubleshoot. The configuration works best when installing the full setup as opposed to just using the configuration files due to dependencies and additional optimizations. Once done with install make sure to check __plasma-discover > settings__, enabling additional repositories for firmware and potentially enabling the flatpak repository as well if necessary at all. Keep in mind, __apt install__ uses regular repositories, __flatpak install__ uses flatpak and __snap install__ uses snap. Snap is probably the least preferable repository. Since this setup is a hybrid setup be wary when using plasma-discover for any potential notifications on package removal, it can be used for updates but do pay attention. The setup is meant to be upgraded using __apt full-upgrade__ & __apt upgrade -t experimental__. Keep in mind in the past this setup had __thanas-x86-kernel__ included by default. It got removed because I don't maintain it anymore however the scripts remained just in case anyone does still use it. Once again for it to be clear: when using the full setup, the preconfiguration syncs the parameter config + sources.list on every reboot. Not __/etc/apt/sources.list.d/extras.list__. Also weekly anacronjob on syncing default pihole blocklist when not using the scripts, just not in the case of OpenWrt. Not installing the full setup is missing out on some optimizations of which some are also preconfigured in the boot script. Optionally one can disable automatic synchronization of the parameter configuration by removing the last lines in __init.sh__ and opt for manual updates.

Main reason for using Kali as the base system for this setup is purely the fact that Kali/Debian outbeat almost every other mainstream distribution but Clear Linux, including Arch when it comes to __hackbench__. The difference in scores is as significant as almost half the latency in some cases, next to the fact that despite performance I personally run this distro. Keep in mind that such facts can and often do fluctuate from release to release of distributions and kernels. Overall the rules apply more or less at the time of making this. If I have missed crucial factors to performance which remain plausible feel free to leave a note. Keep in mind the goal of this whole repository is making minimal compromises for attaining relatively balanced performance. With plausibility I mean not disabling idle cores etc. In the past I have been more or less benchmarking and focusing on scores however nowadays I measure past factors and rely on responsiveness rather than scores. This is just a personal setup, nothing serious. I would be glad to hear of improvements however. Kali already brings down hackbench latency quite a bit, however this setup isolated of distribution almost halfens that latency once more relative to default settings. Its worth a try. The only compromise in security is mitigations=off which can be removed from the kernel parameters in init.sh if one wishes so, however does not go as far as pentesting distributions removing any proprietary software or drivers. With mitigations=off which mind you is mostly only valid for x86, it is no more different than a regular desktop distribution and might even be more secure relatively. Ofcourse there is no comparison whatsoever in between this and Windows and its telemetry. Otherwise go run [BSD](https://www.siliconrepublic.com/wp-content/uploads/2014/12/img/snowden-hiding-meme-100042225-medium.jpg) or something. Final note KDE desktop environment provides balance between features while relatively utilizing minimal system resources relative to desktop environments like Gnome. Ram memory for example can be allocated for performance related factors rather than desktop environment, which is what this setup tries to achieve. Do not forget switching from __X11__ to __plasma wayland__ on your sddm login screen prior to logging in to make use of the __wayland compositor__ for __KDE__ provided by this setup. Keep in mind __vulkan backend__ for compositing will also be most likely a release away as of the moment it is up to __OpenGLES3.2__. For more information on troubleshooting read the [__troubleshooting__](https://github.com/thanasxda/basic-linux-setup#-troubleshooting) section on this readme or just [google](https://www.google.com). This full setup including preconfiguration is ideal for gamers as well. Yes, with this configuration while on Kali specifically one could see significant improvement in frame rates when gaming. Especially when no full set of Kali packages has been selected during the setup and instead just the KDE desktop environment. Handpick the tools you want using __kali-tweaks__ from console. You do not want to have many unnecessary services running that are related to pentesting without using them. Setup is intended to be installed without Kali default packages and instead handpicked by preference.

If you want to fully stay up to date be sure to check any potential diff changes in the full setup as opposed to just the configuration as in some parts they go hand in hand. Alternatively you could rerun the full setup occasionally to get all updates this way. The setup and script work optimal as is, if you want to improve it make sure to run quick tests along the way as some things can harm performance drastically. I would be curious to know what hackbench scores others have gotten before and after the full setup as is. Make sure the boot process is fully complete prior to testing and the boot script has finished successfully and minimize factors of influence by having no background processes for reliability of scores. For myself I get half the latency on my current hardware even after the full setup regardless of mitigations and all other changes this full setup applies when adding just the configuration script as opposed to it not being present. Even though this was made considering past factors for responsiveness, better scores is a byproduct. Be careful when installing any external optimizations or custom kernels as sometimes they include their own configuration and can interfere with this one resulting in alteration of scores. If so completely remove the packages and retry. Keep in mind the full setup contains lots of packages and __X11 tests faster than wayland in response, kde openbox even more so__. As an alternative you could disable the compositing. For people not wanting the full setup, the preconfiguration script is more than sufficient. The stock setup gave me a latency of 4 without preconfiguration or any adjustment whatsoever, the full setup gave me a latency of 10 without the preconfiguration script. Mitigations off only, brought that down to 7 and running the preconfig script on full setup brought latency down from 10 to 2. Have not tested the preconfiguration script on bare setup defaults but since the difference is as big as it is it might be worth. Different hardware might have different results.

For removal of preconfiguration:
```
sudo rm -rf /etc/sysctl.conf && sudo rm -rf /etc/sysctl.conf.d/sysctl.conf && sudo rm -rf /etc/rc.local
```
For removal of bootargs:
```
sudo sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"' /etc/default/grub && sudo sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX="splash quiet"' /etc/default/grub && sudo update-grub
# Or just modify the configuration script instead.
kate /etc/rc.local && sudo cp /etc/rc.local /etc/sysctl.conf
# Remove the auto update part at the and and then:
sudo sh /etc/rc.local
```
When editing the script make sure all functions otherswise it won't even get executed. To check just run the script and debug. Another method underneath:
```
sudo apt -f -y install shellcheck && shellcheck /etc/rc.local
```
For using hackbench:
```
sudo apt update && sudo apt -f -y install rt-tests && hackbench -pTl < VALUE FOR YOUR HARDWARE HERE >
```

## ₉. Troubleshooting:

In some rare cases the gpu drivers might not be preinstalled when booting Kali on a fresh install, depending on what gpu is being used. Issues as such are more often the case when using weekly images instead of stable images. If so choose recovery mode from the grub menu upon boottime and login. In cases of ethernet all connectivity should be fine.
You could run underneath command to make sure:
```
ifconfig
sudo ifup eth0 up
# Or instead of a specific interface type '-a' for all interfaces.
sudo ifup -a
```
Make sure __eth0__ corresponds to the output of your network device prompted by __ifconfig__. running a ping command like underneath can confirm connectivity:
```
ping 1.1.1.1 -c 4
```
If its the case of __wlan__ however you might need to connect to internet using tools such as __nmcli__.
```
nmcli dev status
nmcli radio wifi
nmcli radio wifi on
nmcli dev wifi list
sudo nmcli --ask dev wifi connect < ENTER YOUR NETWORK-SSID HERE PROMPTED BY ABOVE COMMANDS >
```
If you have installed Kali with bare desktop environment without any default tools keep in mind packages as __'wireless-tools'__, __'net-tools'__ & __'nmcli'__ will be missing if you're unfortunate enough not using ethernet.
Use alternatives in this case. once connected to the internet proceed with installing your gpu drivers. Potentially __apt-cdrom__, enabling the usb stick to function as a repository for offline installation. Press Ctrl+Alt+F5 or something once booted in console and proceed.
Underneath example is for __amd gpu drivers__ as of current packages:
```
sudo apt update && sudo apt -f install -y firmware-amd-graphics && sudo dpkg-reconfigure firmware-amd-graphics && sudo reboot -f
```
The system will work as usual upon next reboot. __startx__ command which manually starts the desktop environment from console will not work unless the kernel has rebooted at least once with the just installed gpu kernel modules having been loaded upon boottime. Alternatively you could also browse webpages with package __links__ and or just run __'sudo sh ~/basic-linux-setup/1_setup.sh'__ from your terminal. If you want pieces of the setup, you could always copy paste the missing parts from the script to console and manually take what you need. Just remember that the script uses variables for convenience of editing. They will need to be included. (example, 'export a=apt && $a install pkg')

If this setup does not allow you to boot due to kernel bootargs in grub temporarily disable them by intervening in the grub boot menu. Browse to the desired kernel and press _'e'_ on the keyboard. After remove all kernel parameters and press __Ctrl+X__ to boot. Scrolling down you can also find instructions if ever encountering the __grub rescue__ screen at boot.

When troubleshooting or checking the setup installed if ever necessary usage can be made out of __tasksel__ & __kali-tweaks__. If it does not work I suggest restoring the original backup of sources.list provided by __basic-linux-setup__ after updating and retrying.
```
sudo cp /root/backup.*.sources.list /etc/apt/sources.list && sudo apt update && sudo apt install -f -y tasksel && sudo tasksel
# Or
sudo apt update && sudo apt install -f -y tasksel && sudo tasksel
```
However this being in extreme cases only, most of the time using __aptitude__ is enough. Underneath example of restoring __KDE desktop__ environment with __aptitude__:
```
sudo apt update && sudo apt install aptitude && sudo aptitude -f install plasma-desktop task-kde-desktop
```
Don't forget when switching desktop environment the default __display manager__ has to be reconfigured as well.
gnome=__'gdm3'__, xfce=__'lightdm'__, kde=__'sddm'__.
Underneath example of switching from KDE back to Gnome environment when both are installed:
```
sudo dpkg-reconfigure gdm3
```
Handpicking individual sections can be done with tasksel however there is a more advanced alternative for Kali tools. Underneath commands:
```
sudo tasksel

sudo kali-tweaks
```
If you ever have issues with __dpkg__ not installing packages...
Usage of experimental branches has to be stated explicitly using branch selection like underneath example:
```
sudo dpkg --configure -a
sudo apt -f install --fix-missing --fix-broken -y -t experimental
```
**NEVER USE EXPERIMENTAL BRANCHES PERFORMING DIST-UPGRADE OR FULL-UPGRADE. APT FULL-UPGRADE IS SAFE WITHOUT EXPERIMENTAL BRANCH SPECIFICATION.**

If dpkg ever mentions __broken pipe__, underneath example for fixing:
```
sudo dpkg -i --force-overwrite /var/cache/apt/archives/< PROBLEMATIC PACKAGE HERE>.deb
```
Correct way of fully updating this setup would be:
```
sudo apt update
sudo apt -f -y upgrade -t experimental
sudo apt -f -y dist-upgrade
```
Or you could do it this way as well:
```
sudo apt update
sudo apt upgrade -f -y -t experimental --fix-broken --fix-missing --with-new-pkgs
sudo apt upgrade -f -y -t kali-bleeding-edge --fix-broken --fix-missing --with-new-pkgs
sudo apt upgrade -f -y -t kali-experimental --fix-broken --fix-missing --with-new-pkgs
sudo apt full-upgrade -f -y --fix-broken --fix-missing
sudo dpkg --configure -a
sudo apt autoremove -y
sudo apt clean
sudo apt autoclean
```
Furthermore if recovering grub ever is needed, boot from live usb and make use of the following scripts.
For more information scroll to the bottom of this readme.
The updated scripts for chroot can be found here:
- [chroot.sh](https://github.com/thanasxda/basic-linux-setup/blob/master/chroot.sh)

The setup also creates a backup of your initial repositories, if you want to revert to your sources.list copy underneath command:
```
sudo cp /root/backup*.list /etc/apt/sources.list
```
If you happen to have messed up your services or want to re-enable services the preconfiguration disables there is a reference guide to default services 3 way comparison in this repository and it can be found [here](https://github.com/thanasxda/basic-linux-setup/blob/master/SERVICES.txt).
Recommended command to filter out details when viewing the list:
```
awk -F '.' '{print $1}' SERVICES.txt                                                                     
```
If you want to revert the customizations there are scripts for that but as I dont maintain anything other than the general setup to be sure commands underneath (just make sure to reapply any KDE theme afterwards in the gui settings):
```
sudo rm -rf /etc/rc.local /etc/sysctl.conf ~/.config ~/.kde ~/.local ~/.gtkrc ~/.zshrc && sudo dpkg-reconfigure zsh
```
If you mess up your fstab boot through another partition or live usb and use __genfstab__ command from arch-install-scripts package to regenerate an fstab or enter manually. _/dev/sdX fs defaults,rw 0 0_. If you did something which lead your partition to be "read only" then check underneath command, '$rootfs' being your Linux root partition /dev/sda2 for example. Enough information on this readme to know.
```
sudo mount -o remount,rw $rootfs /
```
If somehow you messed up your fstab and need to restore it easiest method underneath:
```
sudo apt update && sudo apt -f install -y arch-install-scripts
genfstab -U / > /etc/fstab
# To restore the flags
sudo sh init.sh
```
If somehow you mess up grub and end up at the grub rescue screen unable to boot, either recover through the __chroot__ script on this repo or manually. Alternatively if you do not have another partition to recover from or a live usb check information like [this](https://help.ubuntu.com/community/Grub2/Troubleshooting#Search_.26_Set). Remember __you do not need to format__. Underneath an example of how to restore when the latest initramfs didn't boot (remove .old for latest):
```
set prefix=(hd0,gpt2)
set root=(hd0,gpt2)
insmod normal
normal
set
insmod linux
linux /vmlinuz.old root=/dev/sda2 ro
initrd /initrd.img.old
boot
```

If somehow you cant boot due to ending up at a screen which reads busybox what fixes usually is performing a file system check, depending on file system ofcourse. Underneath example:
```
e2fsck -f /dev/sdX
```
Depending on file system underneath is an example for XFS file system check, defragmentation and fstrim. Again /dev/sda referring to your disk as __rootfs__. The partition on which your OS resides, the root of the file system also referred to as '/'.
```
xfs_repair -f /dev/sd*
xfs_fsr -f /dev/sd*
fstrim /
```
If you ever have an error during boot stating "Failed to mount API fylesystems" then during grub edit the custom kernel parameters by disabling any parameter mentioning cgroups / or just all, and boot. If you ever encounter a screen during boot giving an error about compression just reboot and it should be solved. If you ever face trouble and can't get access towards any console for troubleshooting but still have access to grub, go to grub kernel selection press _'e'_ edit the parameters from __ro__ to __rw__ and add __init=/bin/bash__. Press Ctrl+X to boot, and now you should have access to console. When editing parameters within grub or for example adding the init= flag, do not press delete/backspace and wait for the whole list to dissapear. If you do make a coffee for yourself meanwhile while having the delete button jammed with a toothpick or something. Just go to __'ro splash quet'__ and hit enter for the parameters not to be read. After edit __'ro splash quiet'__ to __'rw splash quiet init=/bin/bash'__ and boot. Its also worth trying to boot from an older kernel since very rarely there could be issues when using mainline kernels or experimental branches, or checking for any conflicts in kernel module blacklists in /etc/modprobe.d/ and temporarily __rename 's/.conf/.bak/' *__ and after rebooting. Making use of the zsh plugins, midnight commander and links can be handy when only having access to console when troubleshooting.
If you ever have errors with certificates in linux try setting your time correct on both linux and router and maybe add your router ip in resolv.conf like this: __echo 'nameserver < ROUTER IP >' | tee -a /etc/resolv.conf__. Do the same in your connection details, after reinstall the package __ca-certificates__ and reboot both computer and router.

If and when there are any updates to this repository instead of executing the command and downloading the repository all over fetching just the update is also possible:
```
cd ~/basic-linux-setup
git fetch origin
git reset --hard origin/master
```
Resetting potential changes to default without updating:
```
cd ~/basic-linux-setup
git reset --hard
git clean -xfd
```
If you have messed up your local repo while committing and lost changes by resetting for example you can access your local commit history with underneath command:
```
git reflog
# Pick desired commit out of history from far left of the list
git checkout < COMMIT >
```
Remember to backup or commit any changes you apply because setup will reset the local repo to defaults when finished. Meaning you would also lose your commits if origin is set to this repo. It is meant to be integrated with this repo, best way for any modification is forking. For convenience GithubDesktop and Gitkraken are included within the setup which serve as a graphical interface for interacting with git.

## ₁₀. Alternative file systems:

Underneath is an example of the __F2FS__ file system.
There is an easy method to get __F2FS__ on distro's which doesn't involve taking a backup image, manually restoring and adjusting it afterwards.

As opposed to a regular installation you will need to download [kali-linux-<>-W<>-live-amd64.iso](https://cdimage.kali.org/kali-images/kali-weekly/) this time.
Note that weekly images sometimes can have issues, if so prefer [stable releases](https://www.kali.org/get-kali/#kali-installer-images).

Install kali __live__ usb instead of the native installer.
Once in the live usb environment follow the underneath example. For __F2FS__ and __XFS__ support just to name an example, run underneath command (__XFS__ support only comes with __installer iso__ not with live usb):
```
sudo apt update && sudo apt install xfsprogs f2fs-tools -y
```
Proceed with:
```
sudo apt install fdisk -y
```
Just drag drop iso in console after typing __if=__... Mind you prefer the gpt partitioning scheme when formatting disabling legacy mode in bios using uefi mode only.
Underneath command to get to know the partitioning, or just pick your own method of flashing the image onto any medium.
Example of underneath command: __'sudo dd if=~/Downloads/kali-linux-2020-W26-live-amd64.iso of=/dev/sdb bs=1M status=progress'__.
```
sudo dd if=/path/to/image of=/path/to/bootablemedia bs=1M conv=fsync status=progress
```
Once done boot it on live usb mode, if possible __set bios to uefi only mode__.
After the live usb is booted run. (remember if you reboot you need to redo these steps since the live usb will reset all upon reboot)
```
sudo apt update && sudo apt install -y f2fs-tools calamares calamares-settings-debian
```
Now check on which medium the iso installation is mounted using:
```
sudo fdisk -l
# Or if more convenient
fdisk -l | grep -e /dev/
```
Then proceed on mounting the usb installation on root so __calamares__ installer can detect it. (__sdXX__ for example __/dev/sdb2__/path/to/iso)
```
sudo mount /dev/sdXX /mnt
```
Now finally run the calamares installer.
```
sudo calamares
```
Proceed with the setup, however choose manual partitioning.
Format first partition with a size of __512mb__ as __FAT32__. set its mountpoint to __'/boot/efi'__ and pick __'boot'__ from flags.
For the second partition pick __F2FS__ and make it whatever size you wish to run your distro on select mountpoint __'/'__ no bootalble flags required.
(be aware F2FS can be resized only for enlargement, other words once you set partition size you cannot make it smaller afterwards)
Proceed with the installation and reboot once done.
Once rebooted into the F2FS installed system run.
```
sudo apt update && sudo apt install -y tasksel && sudo tasksel
```
Now clear selection of __XFCE desktop__, pick KDE and proceed.
Calamares will also overwrite sources.list so in this case recover it like this:
```
sudo bash -c 'echo "deb http://http.kali.org/kali kali-rolling main non-free contrib"  > /etc/apt/sources.list' && sudo apt update
```
After installation is complete proceed to installing this setup and afterwards switch to KDE like so:
```
sudo apt install -y sddm && sudo dpkg-reconfigure sddm
```
Remember that the F2FS file system will fsck upon every kernel change on boot.
You can now move on to running the basic-linux-setup while on F2FS.
To fully uninstall XFCE desktop environment fully run __tasksel__ and clear the selection of XFCE and continue.
After run following command while being logged in on KDE:
```
sudo apt -f remove *xfce* lightdm
```
Note: If you want wildcards as above working and you're on zsh shell you have to use bash, __bash -l__ and after __apt remove *package*__.
Also make sure to install __KDE's display manager__, set is as default and switch to __plasma-desktop__ on login screen after installation of this script.

## ₁₁. Chroot:

Note that you can do this trick on several distro's making it possible to install a specific unsupported file system directly.
Keep in mind by doing so worst case sometimes depending on distro it would be necessary to mount the distro as __chroot__ (there are scripts in this repo for this as well for convenience so the underneath example isn't of importance) and after installing specific fs support drivers on the system, next to that you would also need to be on __grub 2.04__ at least to have full support on rootfs (not needing a separate __bootfs__), which you also could install from __chroot__. If necessary at all following this guide on other distro's the correct way to mount chroot and work on the system would be:
```
sudo fdisk -l                         ### check partition layout
sudo mkdir -p /mnt/boot/efi
sudo mount /dev/sdXX /mnt/boot/efi    ### sdXX example /dev/sda1 bootfs
sudo mount /dev/sdXX /mnt             ### sdXX example /dev/sda2 rootfs
sudo mount -t proc none /mnt/proc
sudo mount --rbind /sys /mnt/sys
sudo mount --rbind /dev /mnt/dev
sudo ln -s /etc/resolv.conf /mnt/etc/resolv.conf
sudo chroot /mnt /bin/bash            ### you are now running the system in chroot
```
From there on you can manually get the drivers and update grub to make it work in stubborn cases.
The updated scripts once again for __chroot__ can be found here:
- [chroot.sh](https://github.com/thanasxda/basic-linux-setup/blob/master/chroot.sh)

## ₁₂. Help:

   - [sed](https://www.pement.org/sed/sed1line.txt)

   - [awk](https://www.pement.org/awk/awk1line.txt)

   - [shellcheck](https://www.shellcheck.net/)
   
   - [bash-hackers wiki](https://wiki.bash-hackers.org/start)

## ₁₃. Links:

   - [thanas-x86-kernel](https://github.com/thanasxda/thanas-x86-64-kernel)

   - [kali-linux - weekly releases](https://cdimage.kali.org/kali-images/kali-weekly/)

   - [kali-linux - stable releases](https://www.kali.org/get-kali/#kali-installer-images)

   - [linux kernel - parameters](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt)

   - [linux kernel - documentation](https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt)

   - [arch wiki - improving performance](https://wiki.archlinux.org/title/Improving_performance)

   - [kali linux - documentation](https://www.kali.org/docs/)

   - [debian - wiki](https://wiki.debian.org/)
   
   - [gentoo - wiki](https://wiki.gentoo.org/wiki/Main_Page)

   - [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

   - [ahkilnarang/scripts.git](https://github.com/akhilnarang/scripts.git)

   - [phoronix](https://www.phoronix.com/)

   - [openbenchmarking.org](https://openbenchmarking.org/)
