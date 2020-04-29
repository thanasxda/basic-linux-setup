#!/bin/bash
### if you don't use groovy, change distro in stock sources.list prior to restoration
echo "if you don't use groovy, change distro in stock sources.list prior to restoration"
echo "this will override your local sources.list in favor for a clean basic-linux-setup default setting"
echo "additional info in sources.list as well as in setup.sh"
echo "either case it makes a first time backup named "backup.sources.list" which you can find here"
echo "upon deletion of initial "backup.sources.list" it will be regenerated based on current sources.list after "restore_groovy_sources.sh has" been executed again"
source="$(pwd)"
if [ -e $source/backup.sources.list ]; then
sudo cp sources.list /etc/apt/sources.list
sudo apt update
clear
echo sources.list restored to basic-linux-setup
else
sudo cp /etc/apt/sources.list $source/backup.sources.list
echo "backup created "backup.sources.list""
echo "if the file is present it wont be overridden"
sudo cp sources.list /etc/apt/sources.list
sudo apt update
echo sources.list restored to basic-linux-setup
fi;
