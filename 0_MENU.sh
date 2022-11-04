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
yellow="\033[1;93m"
green="\033[1;32m"
restore="\033[0m"
bgr="\033[05;1;32m"
red="\033[1;91m"
blink="\033[05;1;95m"
magenta="\033[1;95m"
italic="\x1b[3m"
underline="\e[4m"
a=$(echo -e "${yellow}")
b=$(echo -e "${green}")
c=$(echo -e "${restore}")
d=$(echo -e "${bgr}")
e=$(echo -e "${red}")
f=$(echo -e "${blink}")
g=$(echo -e "${magenta}")
h=$(echo -e "${italic}")
i=$(echo -e "${underline}")
stp="BASIC-LINUX-SETUP"
keffect=$g$stp$c$b
x1=$a"1)"$c$h
x2=$a"2)"$c$h
x3=$a"3)"$c$h
x4=$a"4)"$c$h
x5=$a"5)"$c$h
x6=$a"6)"$c$h
x7=$a"7)"$c$h
x8=$a"8)"$c$h
x9=$a"9)"$c$h
PS3=$c$h$f'

Please enter your choice:  '$c$a
echo ""
echo "        $b..:::::::$f$keffect"$d"::$f"MENU"$c$b:::::::.."
echo ""$c$h
echo "        what boredom leads to..."
echo ""$c$a
o1=$b$i"*RUN $keffect$b$i*$c$h
                    - mainly used with Kali or Debian... mod if needed
"$c$a
o2=$b$i"*restore $keffect$i sources.list to defaults*$c$h
                    - option $x1
"$c$a
o3=$b$i"*uninstall $keffect$i customizations*$c$h
                    - option $x2
"$c$a
o4=$b$i"*uninstall $keffect$i modded kernel and revert customizations*$c$h
                    - option $x3
"$c$a
o5=$b$i"*fix permissions of home dir*$c$h
                    - option $x4
"$c$a
o6=$b$i"*enter chroot*$c$h
                    - option $x5
"$c$a
o7=$b$i"*grub repair*$c$h
                    - option $x6
"$c$a
o8=$b$i"*run init.sh $(echo -e "\e[9m& this will sync your setup at reboot from this source\e[0m")*$c$h
                    - option $x7
"$c$a
o9=$b$i"*run openwrt script*$c$h
                    - option $x8

"$c$e
options=("$o1" "$o2" "$o3" "$o4" "$o5" "$o6" "$o7" "$o8" "$o9" "$e$i*QUIT!*")
select opt in "${options[@]}"
do
echo -e "${restore}"
    case $opt in
        "$o1")
            echo $a"you chose option 1"
            echo $e"setup starting..."
            ./1*
            ;;
        "$o2")
            echo $a"you chose option 2"
            echo $e"check sources in folder..."
            ./2*
            ;;
        "$o3")
            echo $a"you chose option 3"
            echo $e"reverting customizations..."
            ./3*
            ;;
        "$o4")
            echo $a"you chose option 4"
            echo $e"uninstall custom kernel & revert optimizations..."
            ./4*
            ;;
        "$o5")
            echo $a"you chose option 5"
            echo $e"fix home permissions..."
            ./5*
            ;;
        "$o6")
            echo $a"you chose option 6"
            echo $e"enter chroot..."
            ./6*
            ;;
        "$o7")
            echo $a"you chose option 7"
            echo $e"repair grub..."
            ./7*
            ;;
        "$o8")
            echo $a"you chose option 8"
            echo $e"execute init.sh..."
            ./8*
            ;;
        "$o9")
            echo $a"you chose option 9"
            echo $e"run openwrt script..."
            echo "ssh root@192.168.?.?:/root && wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/wrt.sh && sh wrt.sh" 
            ;;
        "$e$i*QUIT!*")
            break
            ;;
        *) echo $e"go sleep $a$REPLY$e?!";;
    esac
done
