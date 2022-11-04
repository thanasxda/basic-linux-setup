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


# section 1
#xdotool key Left | xdotool key KP_Enter | $a libc6
#$a autoconf
#$a autoconf-archive
#$a autogen
#$a automake
#$a autopoint
#$a autotools-dev
#$a bash
#$a bc
#$a binfmt-support
#$a binutils-dev
#$a bison
#$a build-essential
#$a bzip2
#$a ca-certificates
#$a ccache
#$a checkinstall
#$a clang
#$a clang-format
#$a clang-tidy
#$a clang-tools
#$a clangd
#$a cmake
#$a curl
#$a dash
#$a dpkg-dev
#$a ecj
#$a expat
#$a fastboot
#$a fastjar
#$a file
#$a flex
#$a g++
#$a g++-multilib
#$a gawk
#$a gcc-multilib
#$a gettext
#$a gnupg
#$a gperf
#$a help2man
#$a java-propose-classpath
#$a lib32ncurses-dev
#$a lib32readline-dev
#$a lib32z1
#$a lib32z1-dev
#$a libbz2-dev
#$a libc++-dev
#$a libc++abi-dev
#$a libc6-dev
#$a libc6-dev-i386
#$a libcap-dev
#$a libclang-dev
#$a libclang1
#$a libelf-dev
#$a libenca0
#$a libexpat1-dev
#$a libffi-dev
#$a libfuzzer-dev
#$a libghc-bzlib-dev
#$a libgmp-dev
#$a libllvm
#$a libllvm-ocaml-dev
#$a liblz4-1
#$a liblz4-1:i386
#$a liblz4-dev
#$a liblz4-java
#$a liblz4-jni
#$a liblz4-tool
#$a liblzma-dev
#$a liblzma-doc
#$a liblzma5
#$a libmng2
#$a libmpc-dev
#$a libmpfr-dev
#$a libncurses-dev
#$a libomp-dev
#$a libssl-dev
#$a libtool
#$a libtool-bin
#$a libx11-dev
#$a libxml2
#$a libxml2-dev
#$a libxml2-utils
#$a linux-libc-dev
#$a lld
#$a lldb
#$a llvm
#$a llvm-dev
#$a llvm-runtime
#$a lzma
#$a lzma-alone
#$a lzma-dev
#$a lzop
#$a m4
#$a make
#$a maven
#$a ninja-build
#$a optipngcd
#$a patch
#$a pigz
#$a pkg-config
#$a pngcrush
#$a python-all-dev
#$a python-clang
#$a qemu-utils
#$a squashfs-tools
#$a subversion
#$a swig
#$a texinfo
#$a txt2man
#$a unzip
#$a xsltproc
#$a yasm
#$a zip
#$a zlib1g-dev

echo -e "$restore}"

### updated build env
git clone https://github.com/akhilnarang/scripts.git
cd scripts/setup
Keys.ENTER | ./android_build_env.sh
cd $source && $S rm -rf scripts
$s dpkg --configure -a

cd $source

	#} 2>&1 | tee -a $(ls -t ~/Desktop/BLS-LOGS/BLS_LOG* | head -1)
	
#####################################################################################################
####### END #########################################################################################
#####################################################################################################
