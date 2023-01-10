#!/bin/bash
#############################################################
#############################################################
##                  basic-linux-setup                      ##
#############################################################
##             https://github.com/thanasxda                ##
#############################################################
##      15927885+thanasxda@users.noreply.github.com        ##
#############################################################
##    https://github.com/thanasxda/basic-linux-setup.git   ##
#############################################################
#############################################################

magenta="\033[05;1;95m"     ## set colors
yellow="\033[1;93m"
restore="\033[0m"
##### SET VARIABLES
source="/root"
distro="$(if grep -q debian /etc/os-release; then echo debian; else echo linux; fi)"
s="sudo"

echo -e "${yellow}"

if grep -q sid /etc/apt/apt.conf.d/00debian ; then sed -z -i 's/Pin: release n=sid\nPin-Priority: -1/Pin: release n=sid\nPin-Priority: 999/g' preferences ; fi


if [ -f  ${source}/backup.${distro}.sources.list ]; then
### restource sources.list - if there already is a backup keep it as it is
### if there is no backup, create one
echo "Hey, $(whoami), You already have a backup of ${source}/backup.${distro}.sources.list."
echo "There is no need to restore it. It will remain unchanged from initial backup."
echo "But we will copy the latest sources.list from this source to your setup."
$s cp sources.list /etc/apt/sources.list
$s cp *.list /etc/apt/sources.list.d/
$s rm -rf /etc/apt/sources.list.d/*sources.list
$s cp preferences /etc/apt/
$s cp preferences /etc/apt/preferences.d/
else
###### START
echo "The backup will be located at ${source}/backup.${distro}.sources.list."
echo "If initial ${distro}.sources.list isn't present it will be regenerated based on current sources."
echo "" && echo "" 
$s cp /etc/apt/sources.list ${source}/backup.${distro}.sources.list
echo "Backup created ${source}/backup.${distro}.sources.list"
echo "If the file is present it wont be overridden next time restoring"
echo "sources.list restored to basic-linux-setup"
$s cp sources.list /etc/apt/sources.list
$s cp *.list /etc/apt/sources.list.d/
$s rm -rf /etc/apt/sources.list.d/*sources.list
$s cp preferences /etc/apt/
$s cp preferences /etc/apt/preferences.d/
fi
echo "To restore your backup sources:"
echo "# sudo cp ${source}/backup.*.sources.list /etc/apt/sources.list"
echo "Done."
echo -e "${restore}"

###### END

sed -z -i 's/Pin: release n=sid\nPin-Priority: 999/Pin: release n=sid\nPin-Priority: -1/g' preferences 
