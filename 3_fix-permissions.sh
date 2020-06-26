#!/bin/bash
### script to fix rare permissions issues in home dir

### fix ownership preconfig - rare cases
cd ~/ && sudo chown -R $(id -u):$(id -g) $HOME
echo DONE! you can reboot rn...
read -p "Press Enter to reboot or Ctrl+C to cancel"

sudo reboot

###### END
