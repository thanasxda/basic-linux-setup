## About

- mainly for (K)ubuntu focal/groovy. hash out script sections for compatibility if other distro. 
- auto compiles&installs thanas-x86-64-kernel upon completion, based on latest modded fork of torvalds dev git.
- built with latest daily llvm-11 for now.
- every file comes with extensive instructions to make life easier in case of personlatization.
- script mainly meant as an unattended script, minimal user input is needed right at the start only.
- plugin devices which require exceptional driver support when running the script for kernel support.

Note: **<font color='red'>DO NOT run the script as SU!</font> (unless root is your useraccount)**

## Instructions

**copy & paste underneath line in console to start:**

```
sudo apt update && sudo apt -f install -y git && git clone https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && chmod 755 setup.sh && ./setup.sh
```

## Links
- [Kubuntu daily build](http://cdimage.ubuntu.com/kubuntu/daily-live/current/)
