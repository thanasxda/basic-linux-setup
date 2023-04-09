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

### script to fix rare permissions issues in home dir

### fix ownership preconfig - rare cases
cd ~/ && chown -R $(id -u):$(id -g) $HOME
echo DONE! you can reboot rn...
read -p "Press Enter to reboot or Ctrl+C to cancel"

sudo reboot

###### END
