## About

- different branches for different distros, as of right now (kde) kali and (k)ubuntu. (don't forget to checkout to distro branch)
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
sudo apt update && sudo apt -f install -y git && git clone --depth=1 https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && git checkout kali && chmod 755 *.sh && ./1*
```

## Links
- [kubuntu branch: Kubuntu daily build - KDE/plasma desktop (groovy-desktop-amd64.iso)](http://cdimage.ubuntu.com/kubuntu/daily-live/current/)
- [kali branch: Kali weekly build - KDE/plasma desktop (kali-linux-*-installer-netinst-amd64.iso)](https://cdimage.kali.org/kali-images/kali-weekly/)
- [thanas-x86-64-kernel source](https://github.com/thanasxda/thanas-x86-64-kernel.git)
