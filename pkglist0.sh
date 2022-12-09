#!/bin/bash
#############################################################
#############################################################
##                  basic-linux-setup                      ##
#############################################################                   #UNMAINTAINED
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
a="$s apt -f install -y"
fl="$s flatpak install  -y"
rem="$s apt -f remove -y"

echo -e "${yellow}"
echo "" && echo "" && echo "" && echo "pkglist0 starting..." && echo "" && echo "" && echo ""

# thanas
cd $tmp

# deb packages here
wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
$s dpkg -i gitkraken*
$s $a && $s apt --fix-broken install -y
rm -rf gitkraken*

#wget https://github.com/shiftkey/desktop/releases/download/release-3.1.1-linux1/GitHubDesktop-linux-3.1.1-linux1.deb
#$s dpkg -i GitHubDesktop*
#$s $a && $s apt --fix-broken install -y
#rm -rf GitHubDesktop*

#
#$a npm && $a && $s npm cache clean -f && $s npm cache clean -f && $s npm install npm@latest -g

# build environment needs to be updated. better not use it. will break system. not in mood to constantly maintain this script.

# section 1
#xdotool key Left | xdotool key KP_Enter | $a libc6
#$ins autoconf \
  autoconf-archive \
  automake \
  autopoint \
  autotools-dev \
  bash \
  bc \
  binfmt-support \
  binutils-dev \
  bison \
  build-essential \
  bzip2 \
  ca-certificates \
  ccache \
  checkinstall \
  clang \
  clang-format \
  clang-tidy \
  clang-tools \
  clangd \
  cmake \
  curl \
  dash \
  dpkg-dev \
  ecj \
  expat \
  fastboot \
  fastjar \
  file \
  flex \
  g++ \
  g++-multilib \
  gawk \
  gcc-multilib \
  gettext \
  gnupg \
  gperf \
  help2man \
  java-propose-classpath \
  lib32ncurses-dev \
  lib32readline-dev \
  lib32z1 \
  lib32z1-dev \
  libbz2-dev \
  libc6-dev \
  libc6-dev-i386 \
  libcap-dev \
  libclang-dev \
  libclang1 \
  libelf-dev \
  libenca0 \
  libexpat1-dev \
  libffi-dev \
  libgmp-dev \
  liblz4-1 \
  liblz4-1:i386 \
  liblz4-dev \
  liblz4-java \
  liblz4-jni \
  liblz4-tool \
  liblzma-dev \
  liblzma-doc \
  liblzma5 \
  libmng2 \
  libmpc-dev \
  libmpfr-dev \
  libncurses-dev \
  libtool \
  libssl-dev \
  libtool-bin \
  libx11-dev \
  libxml2 \
  libxml2-dev \
  libxml2-utils \
  linux-libc-dev \
  lld \
  llvm \
  llvm-dev \
  llvm-runtime \
  lzma \
  lzma-alone \
  lzma-dev \
  lzop \
  m4 \
  make \
  maven \
  ninja-build \
  patch \
  pigz \
  pkg-config \
  pngcrush \
  qemu-utils \
  squashfs-tools \
  subversion \
  swig \
  texinfo \
  txt2man \
  unzip \
  xsltproc \
  yasm \
  zip \
  zlib1g-dev \
  libncurses6

echo -e "$restore}"

### updated build env
#git clone https://github.com/akhilnarang/scripts.git
#cd scripts/setup
#Keys.ENTER | ./android_build_env.sh
#cd $source && $S rm -rf scripts
#$s dpkg --configure -a

cd $source

	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)

#####################################################################################################
####### END #########################################################################################
#####################################################################################################
