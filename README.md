###### mainly for (K)ubuntu focal/groovy. hash out script sections for compatibility if other distro. 
###### auto compiles&installs thanas-x86-64-kernel upon completion, based on latest modded fork of torvalds dev git. 
###### built with latest daily llvm-11 for now. every file comes with extensive instructions to make life easier in case of personlatization. 
##### DO NOT RUN THE SCRIPT AS SU!!! (unless root is your useraccount)
[Download Kubuntu 20.10 daily build here](http://cdimage.ubuntu.com/kubuntu/daily-live/current/groovy-desktop-amd64.iso)
#### basic-linux-setup - copy&paste underneath line in console to start:
```sudo apt update && sudo apt -f install -y git && git clone https://github.com/thanasxda/basic-linux-setup.git && cd basic-linux-setup && chmod 755 setup.sh && ./setup.sh```
