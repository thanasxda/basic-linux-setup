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

#{

yellow="\033[1;93m"
restore="\033[0m"
### variables
source="$(pwd)"
tmp=$source/tmp
s="sudo"
ins="$s aptitude -f install -y -t experimental"
up="$s apt update"
a="$s apt install -y"
fl="$s flatpak install  -y"
rem="$s apt -f remove -y"

echo -e "${yellow}"
echo "" && echo "" && echo "" && echo "pkglist0 starting..." && echo "" && echo "" && echo ""

# thanas
cd $tmp

# deb packages here
wget https://github.com/shiftkey/desktop/releases/download/release-3.1.1-linux1/GitHubDesktop-linux-3.1.1-linux1.deb
$s dpkg -i GitHubDesktop*
$s $a && $s apt --fix-broken install -y
rm -rf GitHubDesktop*

#
#$a npm && $a && $s npm cache clean -f && $s npm cache clean -f && $s npm install npm@latest -g

# section 1
#xdotool key Left | xdotool key KP_Enter | $a libc6
$a autotools-dev \
  axel \
  bash \
  bc \
  binfmt-support \
  binutils \
  bison \
  build-essential \
  cmake \
  expat \
  flex \
  g++ \
  gnupg \
  gperf \
  libc6-dev \
  libcap-dev \
  libexpat1-dev \
  "^liblz4-.*" \
  "^liblzma.*" \
  libmpc-dev \
  libmpfr-dev \
  libtool \
  libssl-dev \
  libxml2 \
  libxml2-utils \
  "^lzma.*" \
  lzop \
  make \
  maven \
  pkg-config \
  texinfo \
  unzip \
  xsltproc \
  zip \
  zlib1g-dev \
  libncurses6 \
  libncurses-dev

$a tig
  
echo -e "$restore}"



sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/M0Rf30/android-udev-rules/master/51-android.rules
sudo chmod 644 /etc/udev/rules.d/51-android.rules
sudo chown root /etc/udev/rules.d/51-android.rules
sudo systemctl restart udev

cd $source

	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)

#####################################################################################################
####### END #########################################################################################
#####################################################################################################
