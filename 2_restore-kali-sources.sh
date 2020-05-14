#!/bin/bash
### if you don't use this distro, change distro in stock sources.list prior to restoration
###

###### SET VARIABLES
source="$(pwd)"
distro=kali

###### SET BASH COLORS
magenta="\033[05;1;95m"
yellow="\033[1;93m"
restore="\033[0m"

###### START
echo -e "${magenta}"
echo "THIS WILL OVERRIDE YOUR LOCAL SOURCES.LIST!!! in favor of a clean basic-linux-setup default setting"
echo "additional info in sources.list as well as in setup.sh"
echo "either case it makes a first time backup named "/backup.${distro}.sources.list" which you can find in the root folder of this repo"
echo "if initial "/backup.${distro}.sources.list" isn't present it will be regenerated based on currently used sources.list after "restore-${distro}-sources.sh" has been executed again"
echo -e "${restore}"

### restource sources.list - if there already is a backup keep it as it is
### if there is no backup, create one
if [ -e $source/backup.${distro}.sources.list ]; then
echo -e "${yellow}"
echo you already have a "/backup.${distro}.sources.list" in the root of this folder
echo so there is no need to restore it. it will remain unchanged from initial backup
echo -e "${restore}"
sudo cp sources.list /etc/apt/sources.list
sudo apt update
echo -e "${yellow}"
echo done, sources.list restored to basic-linux-setup
echo -e "${restore}"
else
sudo cp /etc/apt/sources.list $source/backup.${distro}.sources.list
echo -e "${yellow}"
echo "backup created "/backup.${distro}.sources.list""
echo "if the file is present it wont be overridden next time restoring"
echo -e "${restore}"
sudo cp sources.list /etc/apt/sources.list
sudo apt update
echo -e "${yellow}"
echo "sources.list restored to basic-linux-setup"
echo -e "${restore}"
fi;

###### END
