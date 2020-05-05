#!/bin/bash
### if you don't use groovy, change distro in stock sources.list prior to restoration
###
magenta="\033[05;1;95m"
yellow="\033[1;93m" 
restore="\033[0m"
echo -e "${magenta}"
echo "if you don't use groovy, change distro in stock sources.list prior to restoration"
echo "THIS WILL OVERRIDE YOUR LOCAL SOURCES.LIST!!! in favor of a clean basic-linux-setup default setting"
echo "additional info in sources.list as well as in setup.sh"
echo "either case it makes a first time backup named "/backup.sources.list" which you can find in the root folder of this repo"
echo "if initial "/backup.sources.list" isn't present it will be regenerated based on currently used sources.list after "restore_groovy_sources.sh" has been executed again"
echo -e "${restore}"
source="$(pwd)"
if [ -e $source/backup.sources.list ]; then
sudo cp sources.list /etc/apt/sources.list
sudo apt update
clear
echo -e "${yellow}"
echo done, sources.list restored to basic-linux-setup
echo -e "${restore}"
else
sudo cp /etc/apt/sources.list $source/backup.sources.list
echo -e "${yellow}"
echo "backup created "/backup.sources.list""
echo "if the file is present it wont be overridden next time restoring"
echo -e "${restore}"
sudo cp sources.list /etc/apt/sources.list
sudo apt update
echo -e "${yellow}"
echo "sources.list restored to basic-linux-setup"
echo -e "${restore}"
fi;
