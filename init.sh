#!/bin/sh -x
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
# setup meant as universal config for x86, android & general.
POSIXLY_CORRECT=0 ; droidprop="/system/build.prop" ; wrt="grep -q wrt /etc/os-release" ; # distro="\|your-distro" # unhash if running another distro, but know it has not been tested !!!!!!!!!!
linux=$(grep -q "debian\|arch$distro" /etc/os-release) ; arch="grep -q arch /etc/os-release" ; debian="grep -q debian /etc/os-release" 
     ### script execution delay
bgmips=$(grep -qi "bogomips\|BogoMIPS" /proc/cpuinfo | awk -F ":" '{print $2}' | awk -F '.' '{print $1}' | head -n 1)
                if [ $testing = yes ] ; then echo " skip delay, testing..." ; else
  if [ -f $droidprop ] ; then
if [ $bgmips -le 6000 ] ; then echo " slow device boot delay 200 seconds..." ; sleep 200
elif [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 8 ] ; then echo " less or equal to android 8, sleep 60 seconds..." ; sleep 60
else echo " android 9 or above found, sleep 30 seconds..." ; sleep 30 ; fi
  fi
if [ ! -f $droidprop ] && [ $bgmips -le 6000 ] ; then echo " bogomips less than or equal to 6000, sleep 30 seconds..." ; sleep 30
elif [ ! -f $droidprop ] ; then echo " script starting..." ; sleep 5 ; fi
                fi
      ### busybox for android
if [ -f $doidprop ] ; then
if [ -f /sbin/sh ] ; then export bb="/sbin/" ; fi
if [ -f /bin/sh ] ; then export bb="/bin/" ; fi
if [ -f /system/bin/sh ] ; then export bb="/system/bin/" ; fi
if [ -f /system/xbin/sh ] ; then export bb="/system/xbin/" ; fi
fi 
# GITHUB/microsoft
interjection() {
if [ ! -z $vars ] ; then echo "$vars" | tee $PWD/.blsconfig ; fi ; if [ -e $droidprop ] && [ ! -z $(cat $PWD/.blsconfig) ] ; then cat $PWD/.blsconfig | tee /data/adb/service.d/.blsconfig ; elif [ ! -e $droidprop ] && [ ! -z $(cat $PWD/.blsconfig) ] ; then cat $PWD/.blsconfig | tee /etc/.blsconfig ; fi ; if [ -e $PWD/.blsconfig ] ; then for i in $(cat $PWD/.blsconfig) ; do export $i ; done ; fi
}     
########################################################################################################################################################################################################################
##################  DO NOT CONTINUE ANY FURTHER WITHOUT HAVING READ THE UNDERNEATH DISCLAIMER  #########################################################################################################################
########################################################################################################################################################################################################################
     ### < DISCLAIMER >
      # !!! I AM NOT RESPONSIBLE IF YOUR COMPUTER CATCHES FIRE AND BRINGS YOUR HOUSE ALONG WITH IT. !!! 
      # eol
      
    ### < CREDITS >
      # special thanks to all underneath in particular: 
      # /* Arch wiki (improving performance) and all of its contributors for the outstanding information */
      # /* Alexandre Oliva for making linux libre, free of proprietary code */
      # /* Intel for clear-linux and Arjan van de Ven for actively maintaining the kernel */
      # /* Alexandre Frade for Xanmod kernel */
      # /* Phoronix by Michael Larabel for providing detailed benchmarks over every aspect */
      # /* Tons of thousands contributors i do injustice upon by not mentioning making stuff like this possible, as this stuff is just a minor mod/configuration over preexisting work like gnu/linux and all the software that comes with it. where the real work is done, mainly free of charge. showing some appreciation will not hurt despite of the level of professionalism... unless you want to be using proprietary closed source software for the rest of your life which does not respect your freedom */
      # if i happen to mess up a commit on authorship due to a dirty merge/patchset, again... just a hobbyist having fun learning, so my excuses.
      
    ### < COMPATIBILITY >
      # since i dont include stuff i dont test or run... and this script is just for fun...
      # if running anything else upto you to tweak to your needs.
      # general devices and android are configured to use the script differently. config hardware dependent.
      # setup optimized for: 
      # /* init:         systemd */
      # /* bootloader:   grub/systemd/maybe refind, bios/efi/efi-stub */
      # /* initramfs:    dracut/initramfs-tools */
      # /* kernel:       custom-linux-libre (not hurd), amd/intel only (full-setup only) */
      # /* de:           kde */
      # /* compositor:   x11 */
      # /* os:           debian/arch (might break others, not tested) */
      # /* general:      must work from android 4.x or earlier (if busybox is present) upto latest (if maintained), same case openwrt. other general devices must be supported, but lack of testing. */
      # if the script does not work on debian/arch for you, android and/or general devices... probably it lacks maintenance. 
      # if modifying the script be aware doing things according to shellcheck might break compatibility over legacy devices. (older android versions, routers. etc)

########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
### <<<< VARIABLES >>>> - UNDERNEATH VARIABLES ARE SETUP RELATED >>>>>>>>>>>>>>>>>>>>>>>>>>>>
 # note that some options are related to x86 specific linux distributions only and have no effect on general devices
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
### WARNING: using this script means configuring it to << YOUR needs >>. its just a couple variables... (if youre lazy scrolling down at least). if you do not create a `.blsconfig` prior to running this script... you can make one here. you get the point... note that there are many options even stupid stuff such as igpumitigations. they default to `on` however. just thought it was nice putting the knobs there. in short, user can control quite a lot and personalize just from these variables for personalization of quite a lot going on in the full setup. not all however. edit the full script for fine-tuning if needed.
# lots of settings just changed when making this script due to it still having been in its testing phase... however i think as is is the sweetspot more or less for a decent setup over various hardware.
########################################################################################################################################################################################################################
## it WONT hurt setting extra, already handled preconfigured variables if this setup would ever change to remain on your settings. so dont rely on my repo... use yours
# example config: 
# vars='mitigations=on ; level=medium ; script_autoupdate=no ; account=your-forked-repo ; git=gitlab ; branch=name-of-your-branch ; repo=name-of-your-repo ; path=/path/to/file ; file=name-of-script.sh ; microcode=on ; loglevel=7 ; areyoustupid=no ; ksm=1 ; thp=madvise ; nobarrier=off ; audit=1 ; ignoreloglevel=off ; inteligpumitigations=auto ; bluetooth=on ; ipv6=on ; unsafesysctl=no ; clean_sources_list_d=no ; sourceslist_update=no ; override=yes ; sdsched=mq-deadline ; sched=kyber ; dns1=your-router-ip ; dns2=your-router-ip ; dns61=your-router-ipv6-ip ; dns62=your-router-ipv6-ip ; pingaddr=8.8.8.8 ; governor=ondemand ; pwrsave=on ; country=will-be-auto-detected-and-appended ; ranvasp=2 ; kaslr=on ; seccomp=1' 
########################################################################
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY      !!!!      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY      !!!!      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY      
##      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY      !!!!      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY      !!!!      WARNING: ENTER SETUP VARIABLE VALUES YOU WANT TO OVERRIDE LOCALLY
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
########################################################################
        vars=''                                                      
########################################################################
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
    ### < GENERAL SCRIPT CONFIG >
########################################################################################################################################################################################################################
    ### < SCRIPT AUTO UPDATE FEATURE > - syncs latest script from repo. do not enable this it has been mainly for my own convenience while making this. only enable when forking from your OWN repo.
        #script_autoupdate="no" # use `sudo script_autoupdate=yes sh /etc/rc.local` instead, this will get the single update once... if and when there is one. preferably dont even use this.
        persistent="yes" # when rc.local on openwrt isnt used to autoupdate the script, echo the config to /etc/rc.local on openwrt instead. for openwrt only. these 2 cant work simultanious. so set local persistent config.

        account=thanasxda # links to use for this setup, in case of forking (global btw). complaining about what I use is a waste of your time...
        repo=basic-linux-setup
        branch=master
        git=github
        #path=/path/to
        file=init.sh
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
########################################################################################################################################################################################################################
        interjection ; if [ $git = github ] ; then # gitlab/github. if using anything else just override rawlink alltogether
        rawlink=https://raw.${git}usercontent.com/$account/$repo/$branch$path
        elif [ $git = gitlab ] ; then
        rawlink=https://${git}.com/$account/$repo/-/raw/$branch$path
        fi # dont quoute, if not on git replace rawlink instead in $vars
        if [ -e $droidprop ] ; then if [ ! -e /data/adb/service.d/init.sh ] ; then script_autoupdate="on" ; else script_autoupdate="off" ; fi ; fi # on android instead of modding the module, only sync first time to install the android module. after that requires  manual input as option in local .blsconfig within same $pwd 
        if [ ! -e $droidprop ] && $(! $wrt) && echo $PWD | grep -qi $repo && $(! grep -qi $(git show --name-only) /etc/.blscommitlog) ; then touch /etc/.blscommitlog ; echo "$(date) $(git show --name-only)" | tee -a /etc/.blscommitlog ; fi # keep local logs of commits for GNU/LINUX mainly for debugging
        
        #fix_bootpart="no" # fix boot partition systemd-boot/refind efi stub only (do not use otherwise, will wipe boot and efi partition), dont use if dual boot. unhash for usage or call out prior to running script: sudo fix_bootpart=yes sh init.sh
        sourceslist_update="no"
        clean_sources_list_d="no" # clean /etc/apt/sources.list.d/* with the exception of extras.list which isn't synced
        restore_backup="no" # to avoid much maintenance is partial
        uninstall="no"
        override="no" # due to compatibility reasons script is present over many devices. if choosing to edit the script then enable override variable underneath. this is to keep the script local without overriding and directly editing the script without relying on a local config file or vars.
        #firstrun="yes" # additional first run setup, unlike others hashed out this one is active if you unhash
        #safeconfig="no" # ld_preload and stuff if you have issues enable this for bootparams only. mainly x86. also overrides LD_PRELOAD libraries .. not used anymore btw 
        unsafesysctl="no" # only contains tcp config, labeled `unsafe` because on some hardware it could cause connection issues
########################################################################################################################################################################################################################
################## AFTER HAVING PAID ATTENTION AND HAVING READ ALL THIS FAR, YOU ARE FREE TO DO WHATEVER YOU WANT. THANKS FOR YOUR TIME AND HOPE YOU ENJOY AS MUCH AS I DID MAKING THIS ################################
########################################################################################################################################################################################################################
    
      ### < MISC >
        compositor="x11" # before switching to wayland, check phoronix. settings are how they are for a reason. besides point, setup made on x11 for performance, most probably wouldnt work well on wayland as its not been tested on it.
        #windowmanager="kwin_x11" # kwin, kwin_gles, kwin_x11, kwin_wayland, openbox etc
        ipv6="off" # ipv6 "on" to enable
        dns1="1.1.1.1" # dns servers - default in this setup is cloudflare which supports dns over https (DoH) by default.
        dns2="1.0.0.1"
        dns61="2606:4700:4700::1111" # ipv6 dns servers, only when ipv6 is on
        dns62="2606:4700:4700::1001"
        pingaddr="1.1.1.1" # preferred address to ping
        bluetooth="off"
        webcam="yes"

      ### < I/O SCHEDULER >
      # - i/o scheduler for block devices - none/kyber/bfq/mq-deadline (remember they are configured low latency in this setup) can vary depending on kernel version. [none] is recommended for nvme. test yourself though.
        if find /dev/nvme* ; then sched="none" ; else sched="bfq" ; fi
      # - only used when /dev/sd* ssd hdd etc.
        sdsched="bfq"
        mtdsched="bfq"
        mmcsched="cfq"
        if $(! grep -q 'cfq' /sys/block/mmc*/queue/scheduler) ; then mmcsched="bfq" ; fi

      ### < CPU GOVERNOR >
      # - linux kernel cpu governor
        governor="performance" # use pstates - only managed clocks on cpu's supporting pstates. older cpu's relying on acpi-cpufreq probably want to set schedutil here to keep cores from maxing out constant rate.
        if [ -e $droidprop ] ; then governor="schedutil" ; fi
        
      ### < MITIGATIONS > - expect HIGH!!! performance penalty in favor of security when enabling this. one of your main concerns in this setup should be THIS. degree of performance degradation relative to the hardware. can leave disabled and run trusted code, use librejs browser plugin (remember you might have the most insane hardening but 1 wrong javascript through the browser is enough to infect you with malware or worse, so dont be lazy... make use of librejs/jshelter/noscript. unfortunately trying to remain on `free` software will limit what you can and cannot do. note that browsers are preconfigured using http3 by default, which is udp: less secure. full-setup only, i think... or maybe in this script as well. too lazy dont remember check for yourself. dont need me to explain it. as im tired of this setup use `about:flags` and find quic protocol for anything chrome based. `about:config` and find http3 for anything based on mozilla.)
      # by default only enabed on v4 capable instruction set and all non x86_64 cpu's. override with $vars, easiest. preferably use this only if your kernel+userspace setup is deblobbed and has no non-free software. 
      # (most newer v4 cpu's see just 5% improvements over older gen which could be over 30%, ranges depending hardware & benchmark)
      # THIS IS CONFIGURED TO WORK WITH DEBIAN/ARCH ONLY! (other distributions might be different)
        if $arch ; then x86="/lib/ld-linux-x86-64.so.2" ; elif $debian ; then x86="/usr/lib64/ld-linux-x86-64.so.2" ; fi
        if [ ! -e $x86 ] ; then                                       mitigations="on"    # non-x86_64     - enabled 
        elif $x86 --help | grep -q "v4 (supported" ;         then     mitigations="on"    # x86_64_v4      - enabled - modern cpu's not worthwhile 
        elif $x86 --help | grep -q "v3 (supported" ;         then     mitigations="off"   # x86_64_v3      - disabled
        elif $x86 --help | grep -q "v2 (supported" ;         then     mitigations="off"   # x86_64_v2      - disabled
        else                                                          mitigations="off"   # x86_64         - disabled
          fi

      ### < TCP CONGESTION CONTROL >
      # - tcp congestion algorithm
        tcp_con="bbr"
        if [ ! -f /proc/sys/net/core/default_qdisc ] ; then if grep -q 'westwood' /proc/sys/net/ipv4/tcp_allowed_congestion_control ; then tcp_con="westwood" ; else tcp_con="cubic" ; fi ; fi
        if grep -q 'bbr2' /proc/sys/net/ipv4/tcp_allowed_congestion_control ; then tcp_con="bbr2" ; fi

      ### < QDISC >
      # - queue managment
        qdisc="fq_codel"
        if [ ! $tcp_con = bbr ] || [ ! $tcp_con = bbr2 ] ; then if $(! $wrt) ; then qdisc="fq" ; else qdisc="cake" ; fi ; fi

      ### < WIRELESS REG-DB >
      # - wireless regulatory settings per country 00 for global
      if $(! grep -q country= "$PWD"/.blsconfig) ; then which curl ; if [ $? = 0 ] ; then
      ctest=$(curl -i ipinfo.io | awk -F ':' '/"country":/{print $2}' | sed -e 's/,\|"\| //g')
      if [ -z $ctest ] ; then country="00" ; else echo "country=$ctest" | tee -a "$PWD"/.blsconfig ; fi ; fi ; fi
        #country="00"

      ### < WIFI SETTINGS >
      # - basic wifi settings
        beacons="50"
        frag="2346"
        rts="2347"
        txpower="auto"
        pwrsave="off"
        distance="10"
        # both wifi and ethernet
        txqueuelen="128"
        mtu="1500"

      ### < ETHERNET SETTINGS >
      # - ethernet offloading
        rx="4096"
        tx="4096"
        fl="on"
        duplex="full"
        autoneg="on"

      ### < EXTRAS >
      # GENERAL INFORMATION & EXTRA OPTIONS: 
        level="high" # low/medium/high(morethanmedium is mitigated high) for benchmarkig use high. for security + benchmarking use morethanmedium=on (level will be ignored when enabling this). more mild is medium. low just medium bootparams. high disables almost all (i could think of) causing overhead. anything other than level=high,morethanmedium=on will skip parts of this script alltogether so dont expect the script to even be configurable using those options as most will be left on defaults. mitigations need to be disabled manually on newer (v4 instructionset) cpu's. this level option requires better scripting when switching from one level to the other only if falling back from high to medium or vice versa... due to it being a personal script pick one option and stick with it as im not in the mood for wasted efforts nor investing more time in this. for benchmarking only use high. instead of relying on this quick general setup you should scroll down and check or modify. this is just for ease of use.
        #morethanmedium="on" # keeps settings high but mitigations on every instructionset cpu even if the compromise in performance could be tremendous. keeps nobarrier enabled on storage. assuming you have read the readme, most probably youre on f2fs/xfs as this script is not for your average user. active when unhashed.
        idle="nomwait" # setting this to `poll` can improve performance but keeps cores from idling. deteriorating efficiency. 
        nobarrier="on" # only applicable on f2fs/ext4. can compromise data integrity in favor of performance. f2fs works best.
        cpumaxcstate="9" # c-states even for benchmarking purposes. only consumes more energy. some cstates can benefit latency under circumstances as well.
        pagec="0" # dependent on ksm
        ksm="0" # depending on your system usecase and memory management in some usecases might be beneficial leaving on. disabling can cause improved latency with sacrifice of consuming more memory. if i dont give explanations... linux kernel documentation is your friend.
        ranvasp="2" # no performance benefit switching off, not worth it
        kaslr="on" # no performance benefit switching off, not worth it. if youre on an old distro and still using prelink, it breaks security functions as these. (note: on android it must be off to set mitigations=off. not on other architectures, maybe thats why it doesnt benefit x86 in my experience but did something for aarch64... not sure might have been other factors as well did not pinpoint. tips in readme for mitigations on android, not handled by this setup as hijacking cmdline wont work on most if not all default kernels. lots of things testing very well on aarch64 have almost no effect on x86 btw... so this setup might not be optimal at all for you if on any other arhcitecture, keep in mind.)
        microcode="off" # the full-setup does not use microcode updates from userspace because of it being proprietary. hardware microcode cannot be switched off since its baked in. this also serves as a performance boost (on my hardware, significant). keep in mind some mitigations can also be handled through microcode. if you use a deblobbed libre kernel this will not work eitherway, even when enabled. the kernel provided in the full-setup is deblobbed. if you are not concerned with free code nor performance you might want to enable this. it slows down performance however if mitigations=on microcode might be able to mitigate more efficiently. part from reading, have not benched this in practice as i tend not to use mitigations. (maybe when on v4 cpu, more reasonable)
        seccomp="1" # switch only working if systemd is present, permanently disabling needs patched kernel. when off in kernel causes system to be slightly more responsive without gains in benchmarks. not worth on x86, does more for arm. (custom kernel tried patch, not worth so revered to defaults)
        thp="madvise" # always/madvise/off - will be overriden automatically depending on how much memory you have now. so this setting is useless now. if you have sufficient ram use persistent preallocated hugepages and disable transparant hugepages. most performance increase when working with databases.  ( hindsight enforced to madvise now since latency penalty is too much )
        vdso="on" # many things including vdso, on by default. just some kernels might differ so leave switches in despite.
        extras="off" # off for defaults. init_on_free, init_on_alloc off means defaults btw, so enabled.
        dracut="enabled" # include dracut in mkinitramfs firstrun
        rcu="rcu_nocbs=0" # rcu_nocbs=<cpu#>/rcu_nocb_poll
        perfamdgpu="auto" # "performance" for automatic scaling till highest clocks when necessary "high" for highest constant clocks and "auto" for default # more info here https://wiki.archlinux.org/title/AMDGPU
        inteligpumitigations="auto" # auto for default = on , as for the benching addicts.... do not disable mitigations on your intel igpu lol
        zpool="z3fold" # zram and zswap only autoconfigured for 2gb ram or less in this setup and only of kernel modules are present, so not on routers. only regresses performance if ram is sufficient.
        zpoolpercent="35" # dependent on zram
        audit="0" # could cause slight overhead when on
        loglevel="5" # set loglevel. loglevel 1 info. 7 is default. to avoid overhead on disk you could set a high loglevel on tmpfs but it requires sufficient ram and scripting to be dumped on disk during reboots and im not willing to put in more effort into this. (set to more sane defaults now for the average user, since setup is huge and theres many sorts of logging/debugging/auditing in linux scroll down ensuring all is set to your needs)
        ignoreloglevel="off" # overrides loglevel specified in cmdline params to kernel defaults. (note that custom kernel from full-setup uses 1 info)
        #areyoustupid="no" # this disables additional security and irrelevant options and sets settings more extreme hoewever there are no real performance gains despite. thus the title. 
        #additional_cmdline="" # apply additional cmdline parameters
      
      ### < ANDROID ONLY >
        debloatandroid="yes" # if on android on first run script will debloat android on first run of the script only, select no if issues (this is highly likely to cause you trouble if you use factory roms and not aosp/lineage. not guaranteed but possible)
        androidfstab="yes" # script will modify android fstab, select no if experiencing bootloop lol. restore defaults with variables or manually `cp -rf/system/etc/bak /` in recovery (contains most likely failsafe kernelversion matching for appropriate flags)
        androidbuildprop="yes" # setup will apply persistent minimal build.prop modifications to android disable if facing any issues (just a couple, almost all are hashed out... most only for legacy devices since script aims for compatibility. probably most not present in latest source)

      ### < ADDITIONAL BLOCKLISTS FOR HOSTS FILE > - not on openwrt
        list1=
        list2=
        list3=
        list4=
        list5=
        list6=
        list7=
        list8=
        list9=
        list10=
        
      ### < FSTAB FLAGS >
      # - /etc/fstab - let fstrim.timer handle discard # https://www.kernel.org/doc/Documentation/filesystems/<ext4.txt><f2fs.txt><xfs.txt> some flags might be incompatible with android, if bootloop check
        if [ ! -e $droidprop ] ; then export errorsmnt=",errors=remount-ro" ; fi
        if [ $(uname -r | cut -c1-1) -ge 5 ] ; then f2fsmem=",memory=normal,compress_algorithm=lz4:9,compress_chksum" ; fi # f2fs compression lz4 level 9 used. setting zstd,lz4hc here can improve disk read speeds upto 20% according to benchmarks over defaults at the cost of slight cpu overhead depending on the settings used. as reasonable balance set to lz4:9. needs kernel support (included in custom kernel provided by this setup, will not fail to boot if not so). option can be tweaked further if needed. kept reasonable.
                # trigger morethanmedium config if set 
        interjection ; if [ $morethanmedium = on ] ; then level="high" ; fi
        xfs="defaults,rw,lazytime,noatime,noquota,nodiscard,attr2,inode64,logbufs=8,logbsize=256k,allocsize=64m,largeio,swalloc,filestreams,async"
       ext4="defaults,rw,lazytime,noatime,noquota,nodiscard$(if [ $level = high ] || [ $nobarrier = on ] && [ $level = high ] ; then echo ",commit=60,nobarrier" ; fi),noauto_da_alloc,user_xattr,max_batch_time=120,noblock_validity,nomblk_io_submit,init_itable=0,async$errorsrmnt"
       f2fs="defaults,rw,lazytime,noatime,noquota,nodiscard,background_gc=on,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,alloc_mode=default,fsync_mode=$(if [ $level = high ] || [ $nobarrier = on ] && [ $level = high ] ; then echo "nobarrier" ; else echo "posix" ; fi),gc_merge,async$f2fsmem"
       vfat="defaults,rw,lazytime,noatime,fmask=0022,dmask=0022,shortname=mixed,utf8,errors=remount-ro"
      tmpfs="defaults,rw,lazytime,noatime,nr_inodes=1M,auto"

      ### < STORAGE >
      # - linux storage devices only used for hdparm. wildcard picks up all
        #strg=$(fdisk -l | grep "Linux filesystem" | awk '{print $1}')
        #storage=$(fdisk -l | grep "Disk /dev" | grep -v zram | awk '{print $2}'  | sed 's/://g')
        raid="no"
        lvm="no"
        crypt="no"
        ls -f /fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /fstab*) ; fi
        ls -f /etc/fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /etc/fstab*) ; fi
        ls -f /vendor/fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /vendor/fstab*) ; fi
        if $linux ; then export fstab=/etc/fstab ; fi

        # android dirs
        if [ -f $droidprop ] ; then
        #droidfstab=$(if [ -f $droidprop ] ; then "$bb"find / -name "fstab*" -type f -not -name "*bak" | grep -v "sbin\|storage\|sdcard" | sort -u ; fi)
        droidresolv="/system/etc/resolv.conf"
        droidsysctl="/system/etc/sysctl.conf"
        droidhosts="/system/etc/hosts"
        droidcmdline="/system/etc/root/cmdline"
        droidshell="/system\/xbin\/sh" # only shebang ps if you mod this use different delimiters for sed, didnt know at the time thus the \//\/\//\\/ got used to it by now
        #if $(! grep -q lazytime "$fstab") ; then export droidshell="/system\/bin\/sh" ; fi
        #if [ $testing = yes ] ; then export droidshell="/bin\/sh" ; fi
        #"$bb"mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
        #"$bb"mount -o rw /dev/block/bootdevice/by-name/system /system
        #"$bb"mount -o rw /dev/block/bootdevice/by-name/data /data
        "$bb"mount -o remount,rw /system
        "$bb"mount -o remount,rw /vendor
        "$bb"mount -o remount,rw /data
        "$bb"mount -o remount,rw rootfs /
        fi
        # fix boot partition setup
        if $linux && $(! $wrt) && [ ! -e $droidprop ] ; then # DO NOT MESS AROUND WITH THIS ( if modding the script by accident ) AND WIPE /boot PARTITION $linux ONLY! explicitly used with sudo now not to be recognized by busybox or wrt. it wouldnt lead to a hardbrick, but still spares some effort. especially if youre not handy with unbricking android or wrt, or anything else.
        if [ -e /efi/ ] ; then systemdb=/efi/loader ; elif [ -e /boot/efi/ ] ; then systemdb=/boot/efi/loader ; elif [ -e /boot/loader/loader.conf ] ; then systemdb=/boot/loader ; fi
        if [ $fix_bootpart = yes ] ; then firstrun=yes ; if [ ! -z $systemdb ] ; then 
        if apt-cache search dracut | grep -qi intalled || pacman -Qm dracut | grep -qi dracut ; then yes | sudo rm -rf /boot/* /efi/* ; dracut --regenerate-all --uefi ; bootctl install ; refind-install ; refind-mkdefault ; firstrun=yes ; fi ; fi ; fi ; fi

        
      ### < MEMORY ALLOCATION >
      # - if memory under 2gb or swap or zram considered low spec if not high spec
export zram='#!/bin/sh
# zram/zswap init script
modprobe zram
modprobe lz4
modprobe lz4_compress
echo lz4 > /sys/block/zram0/comp_algorithm
echo "$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo | cut -c1-1)G"  > /sys/block/zram0/disksize
if [ "$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo )" -lt 1000000 ] ; then
echo "0.$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo | cut -c1-1)00m"  > /sys/block/zram0/disksize ; fi
echo 0 > /sys/block/zram0/queue/add_random
echo 0 > /sys/block/zram0/queue/chunk_sectors
echo 0 > /sys/block/zram0/queue/dax
echo 4096 > /sys/block/zram0/queue/discard_granularity
echo 0 > /sys/block/zram0/queue/discard_zeroes_data
echo 511 > /sys/block/zram0/queue/dma_alignment
echo 0 > /sys/block/zram0/queue/fua
echo 4096 > /sys/block/zram0/queue/hw_sector_size
echo 0 > /sys/block/zram0/queue/io_poll
echo 0 > /sys/block/zram0/queue/io_poll_delay
echo 0 > /sys/block/zram0/queue/iostats
echo 4096 > /sys/block/zram0/queue/logical_block_size
echo 1 > /sys/block/zram0/queue/max_discard_segments
echo 124 > /sys/block/zram0/queue/max_hw_sectors_kb
echo 0 > /sys/block/zram0/queue/max_integrity_segments
echo 124 > /sys/block/zram0/queue/max_sectors_kb
echo 128 > /sys/block/zram0/queue/max_segments
echo 65536 > /sys/block/zram0/queue/max_segment_size
echo 4096 > /sys/block/zram0/queue/minimum_io_size
echo 2 > /sys/block/zram0/queue/nomerges
echo 64 > /sys/block/zram0/queue/nr_requests
echo 0 > /sys/block/zram0/queue/nr_zones
echo 4096 > /sys/block/zram0/queue/optimal_io_size
echo 4096 > /sys/block/zram0/queue/physical_block_size
echo 8192 > /sys/block/zram0/queue/read_ahead_kb
echo 0 > /sys/block/zram0/queue/rotational
echo 2 > /sys/block/zram0/queue/rq_affinity
echo none > /sys/block/zram0/queue/scheduler
echo 1 > /sys/block/zram0/queue/stable_writes
echo 0 > /sys/block/zram0/queue/virt_boundary_mask
echo write through > /sys/block/zram0/queue/write_cache
echo 0 > /sys/block/zram0/queue/write_same_max_bytes
echo 0 > /sys/block/zram0/queue/zone_append_max_bytes
echo none > /sys/block/zram0/queue/zoned
echo 0 > /sys/block/zram0/queue/zone_write_granularity
echo 0 > /sys/block/zram0/alignment_offset
echo none > /sys/block/zram0/backing_dev
echo 4 > /sys/block/zram0/capability
echo 254 > /sys/block/zram0/dev
echo 0 > /sys/block/zram0/discard_alignment
echo 2 > /sys/block/zram0/diskseq
echo -1 > /sys/block/zram0/events_poll_msecs
echo 1 > /sys/block/zram0/ext_range
echo 0 > /sys/block/zram0/hidden
echo 1 > /sys/block/zram0/initstate
echo '"$(nproc --all)"' > /sys/block/zram0/max_comp_streams
echo 1 > /sys/block/zram0/range
echo 0 > /sys/block/zram0/removable
echo 0 > /sys/block/zram0/ro
echo MAJOR=254 > /sys/block/zram0/uevent
echo MINOR=0 > /sys/block/zram0/uevent
echo DEVNAME=zram0 > /sys/block/zram0/uevent
echo DEVTYPE=disk > /sys/block/zram0/uevent
echo DISKSEQ=2 > /sys/block/zram0/uevent
echo 0 > /sys/block/zram0/writeback_limit
echo 0 > /sys/block/zram0/writeback_limit_enable
echo 0 > /sys/devices/virtual/block/zram0/debug_stat
echo 90 > /sys/module/zswap/parameters/accept_threshold_percent
echo lz4 > /sys/module/zswap/parameters/compressor
echo Y > /sys/module/zswap/parameters/enabled
echo '"$zpoolpercent"' > /sys/module/zswap/parameters/max_pool_percent
echo Y > /sys/module/zswap/parameters/non_same_filled_pages_enabled
echo Y > /sys/module/zswap/parameters/same_filled_pages_enabled
echo '"$zpool"' > /sys/module/zswap/parameters/zpool
mkswap -L zram0 /dev/zram0
swapon -p 1000 /dev/zram0
if $(! grep "z3fold" /etc/modules) ; then
sed -i -r '\''/^z3fold?/D'\'' /etc/modules
cat <<EOL>> /etc/modules
lz4
lz4_compress
z3fold
zsmalloc
EOL
echo lz4 >> /etc/initramfs-tools/modules
echo lz4_compress >> /etc/initramfs-tools/modules
echo z3fold >> /etc/initramfs-tools/modules
echo zsmalloc >> /etc/initramfs-tools/modules
update-initramfs -u
sudo sed -i '\''s/#ALGO.*/ALGO=lz4/g'\'' /etc/default/zramswap
sudo sed -i '\''s/PERCENT.*/PERCENT='"$zpoolpercent"'/g'\'' /etc/default/zramswap; fi'

# if NOT tv box OR openwrt (USED TO BE THAT WAY NOT ANYMORE, ALL INCLUSIVE) then 2 gb and 1 gb zram+zwap, if more than 2 gb none of both. different hugepages and /dev/shm tmpfs, overriding more settings regarding memory. read to know. note big hugepages need hardware support. 'grep Huge /proc/meminfo' adjust to your needs.
# all


#hpages=' transparent_hugepage=madvise'
#hugepages="16"
#hpages=' transparent_hugepage=madvise'

# 8gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 6500000 ] ; then
devshm=",size=1G"
vmalloc="256"
#hugepages="512"
#hugepagesz="2MB"
#echo 'soft memlock 1024000
#hard memlock 1024000' | tee -a /etc/security/limits.conf
shmmax=1000000000
shmmni=64000000
shmall=100000000
hoverc=256
overcommit=1
oratio=50
swappiness=10
cpress=30
thp=madvise
rm -rf /etc/zram.sh
sed -i 's/RUNSIZE=.*/RUNSIZE=20%/g' /etc/initramfs-tools/initramfs.conf ; fi

# 16 gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 14000000 ] ; then
#export XDG_CACHE_HOME="/dev/shm/.cache"
devshm=",size=2G"
vmalloc="512"
#hugepages="1024"
#hugepagesz="2MB"
#echo 'soft memlock 2048000
#hard memlock 2048000' | tee -a /etc/security/limits.conf
shmmax=2000000000
shmmni=64000000
shmall=100000000
hoverc=512
overcommit=1
oratio=100
swappiness=5
cpress=50
thp=always
sed -i 's/RUNSIZE=.*/RUNSIZE=25%/g' /etc/initramfs-tools/initramfs.conf ; fi

# 32 gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 29000000 ] ; then
#export XDG_CACHE_HOME="/dev/shm/.cache"
devshm=",size=3G"
vmalloc="1024"
#hugepages="2048"
#hugepagesz="2MB"
#echo 'soft memlock 4096000
#hard memlock 4096000' | tee -a /etc/security/limits.conf
shmmax=3000000000
shmmni=64000000
shmall=100000000
hoverc=1024
overcommit=1
oratio=180
swappiness=2
cpress=90
thp=always
sed -i 's/RUNSIZE=.*/RUNSIZE=30%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 4gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 4400000 ] ; then
devshm=",size=512m"
vmalloc="192"
#hugepages="256"
#hugepagesz="2MB"
#echo 'soft memlock 512000
#hard memlock 512000' | tee -a /etc/security/limits.conf
shmmax=1000000000
shmmni=64000000
shmall=100000000
hoverc=192
overcommit=1
oratio=50
#hpages=' transparent_hugepage=madvise'
swappiness=10
cpress=10
thp=madvise
rm -rf /etc/zram.sh
sed -i 's/RUNSIZE=.*/RUNSIZE=15%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 2gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 2200000 ] ; then
devshm=",size=192m"
vmalloc="128"
#hugepages="128"
#hugepagesz="2MB"
shmmax=200000000
shmmni=16000000
shmall=350000000
#echo 'soft memlock 262144
#hard memlock 262144' | tee -a /etc/security/limits.conf
zswap=" zswap.enabled=1 zswap.max_pool_percent=$zpoolpercent zswap.zpool=$zpool zswap.compressor=lz4"
if [ -e $droidprop ] ; then export droidzram="/system" ; fi
echo 1 > /sys/module/zswap/parameters/enabled ; echo lz4 > /sys/module/zswap/parameters/compressor ; echo "$zram" | tee "$droidzram"/etc/zram.sh ; if $(! grep -q "zram" /etc/crontab /etc/anacrontabs) ; then echo "@reboot root sh /etc/zram.sh >/dev/null" | tee -a /etc/crontab && echo "@reboot sh /etc/zram.sh >/dev/null" | tee /etc/anacrontabs && chmod +x /etc/zram.sh && sh /etc/zram.sh ; if [ -e $droidprop ] ; then echo "$zram" | tee "$droidzram"/etc/zram.sh ; chown root /system/etc/zram.sh ; chmod +x /system/etc/zram.sh &&  "$bb"sh /system/etc/zram.sh ; fi ; fi
hoverc=64
overcommit=1
oratio=50
swappiness=10
cpress=10
thp=madvise
sed -i 's/RUNSIZE=.*/RUNSIZE=15%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 1gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 1200000 ] ; then
devshm=",size=64m"
vmalloc="128"
#hugepages="64"
#hugepagesz="2MB"
shmmax=10000000
shmmni=1600000
shmall=35000000
#echo 'soft memlock 102400
#hard memlock 102400' | tee /etc/security/limits.conf
hoverc=32
overcommit=1
oratio=50
swappiness=10
cpress=10
thp=madvise
sed -i 's/RUNSIZE=.*/RUNSIZE=10%/g' /etc/initramfs-tools/initramfs.conf ; fi

# ENFORCE TRANSPARANT HUGEPAGES MADVISE AVOIDING LATENCY PENALTY
thp=madvise

sysctl -w vm.nr_overcommit_hugepages=$hoverc
#sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio

interjection ; if [ $areyoustupid = yes ] ; then for i in export ; do
if $(! grep -q nokaslr /proc/cmdline) ; then $i firstrun="yes" ; fi
if $arch && [ -e /etc/firstboot ] ; then
pacman -Rsn --noconfirm intel-ucode
pacman -Rsn --noconfirm amd-ucode
rm -rf /etc/firstboot
firstrun="yes" ; fi
$i thp="always" ; done ; fi

# remove arch firstboot file. created to ensure all is setup well during second boot after clean setup ( setup got too complicated and i got too lazy )
rm -rf /etc/firstboot

if [ $thp = madvise ] ; then
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
echo madvise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
elif [ $thp = always ] ; then
echo always > /sys/kernel/mm/transparent_hugepage/enabled
echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
elif [ $thp = off ] ; then
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag ; fi

# from the kernel documentation: The number of kernel parameters is not limited, but the length of the complete command line (parameters including spaces etc.) is limited to a fixed number of characters. This limit depends on the architecture and is between 256 and 4096 characters. It is defined in the file ./include/asm/setup.h as COMMAND_LINE_SIZE.
# if you wonder why your setup doesnt show all parameters in /proc/cmdline.... suddenly chronological order becomes important.
interjection ; if [ $areyoustupid = yes ] ; then for i in export ; do
if $(! grep -q nokaslr /proc/cmdline) ; then $i firstrun="yes" ; fi
$i governor="performance" ; $i seccomp="0" ; $i kaslr="off" ; $i ranvasp="0" ; $i extras="on" ; $i cpumaxcstate="0" ; $i idle="poll" ; $i rcu="rcu_nocbs=0 rcu_nocb_poll" ; $i sched="none" ; $i sdsched="none" ; $i microcode="off" ; $i vdso="0" ; $i thp="always" ; done ; fi
# mitigations
if [ $mitigations = off ] ; then
if [ $(uname -r | cut -c1-1) -ge 5 ] ; then mit1=" mitigations=off" ; fi
if lscpu | grep -qi ARM || [ -f $droidprop ] ; then mit2=" nokaslr kpti=0" ; fi
if lscpu | grep -qi PPC ; then mit3=" no_stf_barrier" ; fi
if lscpu | grep -qi Intel ; then mit4=" ibpb=off kvm-intel.vmentry_l1d_flush=never mds=off" ; fi
if lscpu | grep -qi x86 ; then mit5=" noibrs nopti l1tf=off" ; fi
if [ $(uname -r | cut -c1-1) -lt 5 ] ; then
if lscpu | grep -qi ARM || [ -f $droidprop ] ; then mit6=" ssbd=force-off nospectre_bhb" ; fi
if lscpu | grep -qi PPC ; then mit7=" no_entry_flush no_uaccess_flush" ; fi
if lscpu | grep -qi s390 ; then mit8=" nobp=0" ; fi
if lscpu | grep -qi Intel ; then mit9=" srbds=off" ; fi
if lscpu | grep -qi x86 ; then mit10=" mmio_stale_data=off retbleed=off mds=off tsx_async_abort=off kvm.nx_huge_pages=off l1tf=off spectre_v2_user=off" ; fi
if lscpu | grep -qi "x86\|PPC" ; then mit11=" nospectre_v1 spec_store_bypass_disable=off" ; fi # some kernels support nospec flag instead
if lscpu | grep -qi "x86\|PPC\|s390|\ARM" || [ -f $droidprop ] ; then mit12=" nospectre_v2" ; fi
fi
xmitigations="$mit1$mit2$mit3$mit4$mit5$mit6$mit7$mit8$mit9$mit10$mit11$mit12$mit13" ; elif [ $mitigations = on ] ; then xmitigations=" mitigations=auto" ; fi
if [ $level = medium ] || [ $level = low ] || [ $morethanmedium = on ] ; then xmitigiations=" mitigations=auto" ; extras="off" ; fi
if [ $ignoreloglevel = off ] ; then log=" audit=$audit loglevel=$loglevel mminit_loglevel=$loglevel log_priority=$loglevel udev.log_priority=$loglevel udev.log_level=$loglevel" ; fi
# cpu amd/intel
xcpu="$(if lscpu | grep -qi AMD ; then echo " amd_iommu=pgtbl_v2 kvm-amd.avic=1 amd_iommu_intr=vapic amd_pstate=passive" ; elif lscpu | grep -qi Intel ; then echo " kvm-intel.nested=1 intel_iommu=on,igfx_off$(if [ $level != medium ] || [ $level != low ] ; then echo " tsx=on" ; fi) intel_pstate=hwp_only" ; fi)"
#
xvarious=" pci=noaer,pcie_bus_perf,realloc$(if lscpu | grep -qi AMD ; then echo ",check_enable_amd_mmconf" ; fi) cgroup_disable=cpu,cpuacct,cpuset,memory$(if [ $level = high ] ; then echo ",io,perf_event,rdma,net_prio,hugetlb,blkio,devices,freezer,net_cls,pids,misc cgroup_no_v1=all noautogroup" ; fi) big_root_window numa=off nowatchdog $rcu irqaffinity=0 slub_merge$(if [ ! -z $additional_cmdline ] ; then echo " $additional_cmdline" ; fi) align_va_addr=on iommu.strict=0 novmcoredd iommu=force,pt$(if [ $extras = on ] && [ $level = high ] ; then echo " init_on_free=0 init_on_alloc=0" ; fi) acpi_enforce_resources=lax edd=on iommu.forcedac=1 idle=$idle preempt=full highres=on hugetlb_free_vmemmap=on clocksource=tsc tsc=reliable acpi=force lapic apm=on nohz=on psi=0 cec_disable skew_tick=1 vmalloc=$vmalloc cpu_init_udelay=1000 no_debug_objects noirqdebug csdlock_debug=0 kmemleak=off tp_printk_stop_on_boot dma_debug=off gcov_persist=0 kunit.enable=0 printk.devkmsg=off nosoftlockup pnp.debug=0 nohpet ftrace_enabled=0 slub_memcg_sysfs=0 clk_ignore_unused migration_debug=0 acpi_sleep=s4_hwsig slub_min_objects=24 schedstats=0$(if [ $(uname -r | cut -c1-1) -eq 5 ] && lscpu | grep -qi Intel ; then echo ' unsafe_fsgsbase=1' ; fi) mce=dont_log_ce gbpages$log$( if [ $ignoreloglevel = on ] ; then echo " ignore_loglevel" ; fi) rcupdate.rcu_expedited=1 workqueue.power_efficient=$(if [ $level = high ] ; then echo "0" ; else echo "1" ; fi) noreplace-smp refscale.loops=$(($(nproc --all)*2))"
#
xrflags=$(if [ $(uname -r | cut -c1-1) -ge 4 ] && grep -q "/ " /etc/fstab | $(! grep -q "btrfs\|zfs" $fstab) ; then echo " rootflags=lazytime,noatime" ; else echo " rootflags=noatime" ; fi)
#
xsched=$(if [ $(uname -r | cut -c1-1) -le 5 ] ; then echo " elevator=$sched" ; fi)
#
xipv6="$(if [ ! $ipv6 = on ] || $(! $wrt) ; then echo " ipv6.disable=1" ; fi)"
#
xmicrocode="$(if [ $microcode = off ] ; then echo " dis_ucode_ldr" ; fi)"
#
xkaslr="$(if [ $kaslr = off ] && [ ! -f $droidprop ] || [ $kaslr = off ] && $(lscpu | $(! grep -qi ARM)) ; then echo " nokaslr" ; fi)"
#
xzsw="$(if echo "$zswap" | grep -q "zswap.enabled=1" ; then echo "$zswap" ; else echo " zswap.enabled=0" ; fi)"
# extras only with kexec # udma$(dmesg | grep 'configured for UDMA' | awk -F 'UDMA' '{print $2}'),
xtra0=" libahci.ignore_sss=1 libata.force=ncq,dma$(if [ $level = high ] ; then echo ",nodmalog,noiddevlog,nodirlog" ; fi),lpm,setxfer nodelayacct no-steal-acc enable_mtrr_cleanup printk.always_kmsg_dump=0 pcie_aspm=force pcie_aspm.policy=performance$(if [ $level = high ] ; then echo " pstore.backend=null" ; fi)"
#
xtra1=" cpufreq.default_governor=performance cryptomgr.notests stack_depot_disable=true$(if [ $level = high ] ; then echo " nf_conntrack.acct=0" ; fi) numa_balancing=disable workqueue.disable_numa nfs.enable_ino64=1$(if $(find /sys/block/nvme*) ; then echo " nvme_core.default_ps_max_latency_us=0 nvme_load=YES" ; fi) ahci.mobile_lpm_policy=0 plymouth.ignore-serial-consoles fstab=yes processor.ignore_tpc=1$(if [ $cpumaxcstate = 0 ] ; then echo " processor.latency_factor=1" ; fi) noresume hibernate=noresume no_timer_check processor.bm_check_disable=1$(if [ $vdso = off ] ; then echo " vdso=0" ; fi)"
#if [ $safeconfig = no ] ; then
xtra2=" reboot=warm$xipv6 io_delay=none uhci-hcd.debug=0 usb-storage.quirks=p usbcore.usbfs_snoop=0 apparmor=1 autoswap biosdevname=0 boot_delay=0 memtest=0 page_poison=0 rd.systemd.gpt_auto=1 rd.systemd.show_status=false rd.udev.exec_delay=0 slab_merge sysfs.deprecated=0 systemd.default_timeout_start_sec=0 systemd.gpt_auto=1 udev.exec_delay=0 waitdev=0 cec.debug=0 kvm.mmu_audit=0 scsi_mod.use_blk_mq=1 bootconfig processor.max_cstate=$cpumaxcstate$(if ip -o link | grep -qi wlan ; then echo " rfkill.default_state=0 rfkill.master_switch_mode=1" ; fi) carrier_timeout=1 ip=:::::::$dns1:$dns2:$(if [ $level = high ] ; then echo " rd.udev.log_level=0 systemd.unified_cgroup_hierarchy=0" ; fi)"

#fi
# disable radeon and have just amdgpu workaround for performance degradation in some gpus. need to unlock for manual control of voltages, didnt work for me
#unlockgpu="$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))")"
#x="$( if dmesg | grep -q amdgpu ; then echo " radeon.cik_support=0 radeon.si_support=0 amdgpu.cik_support=1 amdgpu.si_support=1 amdgpu.dc=1 amdgpu.modeset=1 amdgpu.dpm=1 amdgpu.audio=1 $unlockgpu" ; fi)"
#
#x="$( if dmesg | grep -q nouvaeu ; then echo " nouveau.modeset=0 nvidia-drm.modeset=1 nvidia-uvm.modeset=1" ; else echo " rdblacklist=nouveau nouveau.blacklist=1 nouveau.modeset=0 nouveau.runpm=0" ; fi)"
#
#x="$( if dmesg | grep -q i915 ; then echo " i915.modeset=1 i915.enable_ppgtt=3 i915.fastboot=0 i915.enable_fbc=1 i915.enable_guc=3 i915.lvds_downclock=1 i915.semaphores=1 i915.reset=0 i915.enable_dc=2 i915.enable_psr=0 i915.enable_cmd_parser=1 i915.enable_rc6=0 i915.lvds_use_ssc=0 i915.use_mmio_flip=1 i915.disable_power_well=1 i915.powersave=1 i915.enable_execlists=0" ; else echo " i915.enable_rc6=0" ; fi)"
#
# nohz_full=1-$(nproc) parport=0 floppy=0 agp=0 lp=0 pata_legacy.all=0

# find local config and override above setup variables determined by what is defined within the persistent config
interjection
# first run of script does more
if [ -f $droidprop ] && [ ! -f /data/adb/service.d/${file} ] || [ ! -f $doidprop ] && $(! grep -q thanas /etc/rc.local) ; then export firstrun=yes ; firstrun=yes ; fi

if echo "$(pwd)" | grep -q basic-linux-setup ; then export firstrun=yes ; firstrun=yes ; fi
if [ $firstrun = yes ] ; then export DEBIAN_FRONTEND=noninteractive ; DEBIAN_FRONTEND=noninteractive ; fi

# clear linux microcode
if [ $microcode = on ] && $arch && $(lscpu | grep -q Intel) && [ $firstrun = yes ] ; then if $(pacman -Qm intel-ucode-clear | grep -q intel-ucode-clear) ; then echo " /boot/intel-ucode.cpio" ; cp -f /boot/intel-ucode.cpio /lib/firmware/ ; fi ; fi



                                    ### < LINUX KERNEL BOOT PARAMETERS >
                                        # - /proc/cmdline or /root/cmdline - Ctrl+F & Google are your friends here...
                                        # https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt
                                          bootargvars="$(echo "$xmicrocode$xmitigations$xcpu$xvarious$xkaslr$xrflags$xsched$xzsw")"
                                        export xpar="quiet splash$bootargvars$xtra0$xtra1$xtra2"
                                      if lscpu | grep -q x86_64 ; then export par="root=$(awk '/\/ / {print $1}' /etc/fstab) $(if find *clrxt* /boot >/dev/null ; then echo "rw" ; else echo "rw" ; fi) $xpar" ; else export par=$xpar ; fi # if clrxt-x86 doesnt boot set to rw manually (hindsight always set to rw since it has no use locally it can be changed easily as most kernels have trouble booting ro)
                                        if [ $uninstall = yes ] ; then par=$(cat "$ifdr"/etc/bak/root/cmdline) ; fi

# module options
for i in modprobe ; do

$i usbhid mousepoll=4
$i ahci mobile_lpm_policy=0
$i cec debug=0
$i cpufreq default_governor=$governor
$i cryptomgr notests
$i kvm mmu_audit=0
$i libahci ignore_sss=1
$i libata force=udma$(dmesg | grep 'configured for UDMA' | awk -F 'UDMA' '{print $2}'),ncq,dma$(if [ $level = high ] ; then echo ",nodmalog,noiddevlog,nodirlog" ; fi),lpm,setxfer
$i nfs enable_ino64=1
if [ $level = high ] ; then $i pstore backend=null ; $i scsi_mod scsi_logging_level=0 ; $i nf_conntrack acct=0 ; fi
$i scsi_mod use_blk_mq=1
$i uhci-hcd debug=0
$i usb-storage quirks=p
$i usbcore usbfs_snoop=0
$i drm_kms_helper poll=0
$i tcp_bbr2 debug_port_mask=0
$i tcp_bbr2 debug_ftrace=N
$i tcp_bbr2 debug_with_printk=N
$i tcp_bbr2 ecn_enable=Y
$i tcp_bbr2 fast_path=Y
$i tcp_bbr2 fast_ack_mode=1
$i usbcore autosuspend=5
$i processor max_cstate=$cpumaxcstate
$i processor bm_check_disable=1
$i processor ignore_tpc=1
#$i processor ignore_ppc=1
#$i pata_legacy all=0
#$i snd_ac97_codec power_save=1

if ip -o link | grep -q wlan ; then
$i rfkill default_state=0
$i rfkill master_switch_mode=1
fi

if lscpu | grep -qi intel ; then 
$i snd_hda_intel power_save=1
fi

if [ $cpumaxcstate = 0 ] ; then
$i processor latency_factor=1
fi

if $(find /sys/block/nvme*) ; then
$i nvme_core default_ps_max_latency_us=0
fi

if glxinfo | grep -qi Intel ; then
$i i915 mitigations=$inteligpumitigations
$i i915 enable_fbc=1
$i i915 fastboot=1
$i i915 modeset=1
$i i915 enable_guc=2 #blobs arent included in libre
$i i915 enable_dc=1
$i i915 mmio_debug=0
$i i915 guc_log_level=0
$i i915 enable_dp_mst=1
$i i915 memtest=0
$i i915 enable_ips=1
$i i915 enable_gvt=1
$i i915 enable_psr=1
$i i915 psr_safest_params=0
$i i915 enable_psr2_sel_fetch=1
$i i915 verbose_state_checks=0
fi

if glxinfo | grep -qi radeon ; then
$i radeon modeset=1
$i radeon benchmark=0
$i radeon dynclks=1
$i radeon tv=0
$i radeon test=0
$i radeon disp_priority=2
$i radeon hw_i2c=1
$i radeon pcie_gen2=-1
$i radeon msi=1
$i radeon fastfb=1
$i radeon dpm=1
$i radeon aspm=1
$i radeon runpm=1
$i radeon deep_color=1
$i radeon auxch=1
$i radeon uvd=1
$i radeon vce=1
$i radeon si_support=-1
$i radeon cik_support=-1
fi

if glxinfo | grep -qi amdgpu ; then
$i amdgpu moverate=-1
$i amdgpu disp_priority=2
$i amdgpu hw_i2c=1
$i amdgpu pcie_gen2=-1
$i amdgpu msi=1
$i amdgpu dpm=1
$i amdgpu aspm=1
$i amdgpu runpm=1
$i amdgpu bapm=1
$i amdgpu sched_jobs=64
$i amdgpu deep_color=1
$i amdgpu vm_debug=1
$i amdgpu exp_hw_support=1
$i amdgpu dc=1
$i amdgpu ppfeauturemask=0xffffffff
$i amdgpu cg_mask=0xffffffff
$i amdgpu pg_mask=0xffffffff
$i amdgpu lbpw=1
$i amdgpu compute_multipipe=1
$i amdgpu gpu_recovery=1
$i amdgpu ras_enable=1
$i amdgpu ras_mask=0xffffffff
$i amdgpu si_support=-1
$i amdgpu cik_support=-1
$i amdgpu async_gfx_ring=1
$i amdgpu mcbp=1
$i amdgpu discovery=1
$i amdgpu mes=1
$i amdgpu mes_kiq=1
$i amdgpu sched_policy=0
$i amdgpu cwsr_enable=1
$i amdgpu debug_largebar=1
$i amdgpu hws_gws_support=1
$i amdgpu debug_evictions=false
$i amdgpu no_system_mem_limit=true
$i amdgpu tmz=1
$i amdgpu ip_block_mask=0xffffffff
$i amdgpu vcnfw_log=0
fi

if [ $ipv6 = off ] ; then
$i ipv6 disable_ipv6=1
$i ipv6 disable=1
$i ipv6 autoconf=0
elif [ $ipv6 = on ] ; then
$i ipv6 disable_ipv6=0
$i ipv6 disable=0
$i ipv6 autoconf=1
fi

done

  ### < BLOCKLISTS >
  ### ping, some devices didnt pickup on it... workaround
    ping=$(echo ''"$pingaddr"'')
  # - /etc/hosts & /etc/update_hosts.sh - not on openwrt
blocklist='#!/bin/sh
### pihole default blocklists & more, /etc/hosts weekly updated. at least on systems having cronjobs
### no redundancy since awk will filter duplicates prior to adding.
u1="https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
u2="https://mirror1.malwaredomains.com/files/justdomains"
u3="http://sysctl.org/cameleon/hosts"
u4="https://zeustracker.abuse.ch/blocklist.php"
u5="https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
u6="https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
u7="https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/raw/master/hosts/hosts0"
u8="https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/raw/master/hosts/hosts1"
u9="https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/raw/master/hosts/hosts2"
u10="https://github.com/Ultimate-Hosts-Blacklist/Ultimate.Hosts.Blacklist/raw/master/hosts/hosts3"
u11="https://www.github.developerdan.com/hosts/lists/tracking-aggressive-extended.txt"
ping -c3 '"$ping"'
if [ $? -eq 0 ]; then
if [ -e /system/build.prop ] ; then '"$bb"'mount -o remount,rw /system ; export ifdr="/system" ; fi
rm -rf "$ifdr"/etc/hosts "$ifdr"/etc/hosts_temp &&
mkdir -p "$ifdr"/etc/hosts_temp && cd "$ifdr"/etc/hosts_temp
'"$bb"'echo '\''options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 single-request-reopen no-tld-query
127.0.0.1 localhost'\'' | tee "$ifdr"/etc/hosts
echo "127.0.1.1 $(cat "$ifdr"/etc/hostname)" | tee -a "$ifdr"/etc/hosts
x1="$('"$bb"'wget $u1 -O "$ifdr"/etc/hosts_temp/u1'"$wg"')"
x2="$('"$bb"'wget $u2 -O "$ifdr"/etc/hosts_temp/u2'"$wg"')"
x3="$('"$bb"'wget $u3 -O "$ifdr"/etc/hosts_temp/u3'"$wg"')"
x4="$('"$bb"'wget $u4 -O "$ifdr"/etc/hosts_temp/u4'"$wg"')"
x5="$('"$bb"'wget $u5 -O "$ifdr"/etc/hosts_temp/u5'"$wg"')"
x6="$('"$bb"'wget $u6 -O "$ifdr"/etc/hosts_temp/u6'"$wg"')"
x7="$('"$bb"'wget $u7 -O "$ifdr"/etc/hosts_temp/u7'"$wg"')"
x8="$('"$bb"'wget $u8 -O "$ifdr"/etc/hosts_temp/u8'"$wg"')"
x9="$('"$bb"'wget $u9 -O "$ifdr"/etc/hosts_temp/u9'"$wg"')"
x10="$('"$bb"'wget $u10 -O "$ifdr"/etc/hosts_temp/u10'"$wg"')"
x11="$('"$bb"'wget $u11 -O "$ifdr"/etc/hosts_temp/u11'"$wg"')"
$x1 || $x2 && $x2 || $x3 && $x3 || $x4 && $x4 || $x5 && $x5 || $x6 && $x6 || $x7 && $x7 || $x8 && $x8 || $x9 && $x9 || $x10 && $x10 || $x11 && $x11 || echo fail

              ### yours
              l1='"$list1"'
              l2='"$list2"'
              l3='"$list3"'
              l4='"$list4"'
              l5='"$list5"'
              l6='"$list6"'
              l7='"$list7"'
              l8='"$list8"'
              l9='"$list9"'
              l10='"$list10"'
              c1="$('"$bb"'wget $l1 -O "$ifdr"/etc/hosts_temp/u11'"$wg"')"
              c2="$('"$bb"'wget $l2 -O "$ifdr"/etc/hosts_temp/u12'"$wg"')"
              c3="$('"$bb"'wget $l3 -O "$ifdr"/etc/hosts_temp/u13'"$wg"')"
              c4="$('"$bb"'wget $l4 -O "$ifdr"/etc/hosts_temp/u14'"$wg"')"
              c5="$('"$bb"'wget $l5 -O "$ifdr"/etc/hosts_temp/u15'"$wg"')"
              c6="$('"$bb"'wget $l6 -O "$ifdr"/etc/hosts_temp/u16'"$wg"')"
              c7="$('"$bb"'wget $l7 -O "$ifdr"/etc/hosts_temp/u17'"$wg"')"
              c8="$('"$bb"'wget $l8 -O "$ifdr"/etc/hosts_temp/u18'"$wg"')"
              c9="$('"$bb"'wget $l9 -O "$ifdr"/etc/hosts_temp/u19'"$wg"')"
              c10="$('"$bb"'wget $l10 -O "$ifdr"/etc/hosts_temp/u20'"$wg"')"
            if echo $l1 | grep -q http ; then $c1 || $c2 && $c2 || $c3 && $c3 || $c4 && $c4 || $c5 && $c5 || $c6 && $c6 || $c7 && $c7 || $c8 && $c8 || $c9 && $c9 || $c10 && $c10 || echo fail ; fi

cd "$ifdr"/etc/hosts_temp && grep "127.0.0.1\|0.0.0.0" * | awk '\''{print "0.0.0.0 " $2}'\'' | awk '\''!a[$0]++'\'' | tee -a "$ifdr"/etc/hosts >/dev/null
cd "$(pwd)" && rm -rf "$ifdr"/etc/hosts_temp
if [ -e /system/build.prop ] ; then '"$bb"'mount -o remount,ro /system ; fi
else echo "Offline"; fi'

  ### < RC.LOCAL OPENWRT >
    # - /etc/rc.local & /etc/sysctl.conf, /tmp/init.sh for openwrt
    if [ $persistent != yes ] ; then
wrtsh='#!/bin/sh
### get script update on reboot on /tmp/init.sh and run...
link='"${rawlink}"'/'"${file}"'
while [ ! -f /tmp/'"${file}"' ];
sleep 10
do ping -c3 '"$ping"'
if [ $? -eq 0 ]; then wget --continue -4 "$link" -O /tmp/'"${file}"' ; fi
if grep -q thanas /tmp/'"${file}"'
then chmod +x /tmp/'"${file}"' && sh /tmp/'"${file}"' && echo "succes"; exit 0; fi
done'
fi




########################################################################
########################################################################

  ### help identifying basic-linux-setup debug output
    echo "*BLS*=SUCCESS, EXECUTING BLS SCRIPT.
    .........................................
    .........................................
    .........................................
    ........................................"






    # some additional info and config
     # https://gist.github.com/bebosudo/6f43dc6b4329c197f258f25cc69f0ec0 dont know if this works anymore for amd
               #if $wrt ; then himri=/tmp ; else himri=$(getent passwd | grep 1000 | awk -F ':' '{print $1}') ; fi
       #if $linux ; then
         #       if [ $whoami = root ] ; then HOME=/root ; else HOME=/home/$himri ; fi
        #fi
        if $(! $wrt) ; then himri=$(who | head -n1 | awk '{print $1}') ; else himri=/tmp ; fi
       # if $wrt || uname -n | grep -q "x" || ls /home | grep -q "x" || grep -q "x" /etc/hostname /proc/sys/kernel/hostname || "$(getent passwd | grep 1000 | awk -F ':' '{print $1}')" | grep -q "x" || [ $LOGNAME = x ] || $(whoami) | grep -q "x" || [ $USER = x ] || echo $HOME | grep -q x || $SUDO_USER = x || who -H | awk '{print $1}' | tail -n1 | grep -q x ; then country="GR" ; fi #xinput set-button-map 8 1 2 3 0 0 0 0 ; fi # disable my buggy scroll meanwhile
       # if grep -q x $himri ; then export country=GR ; fi

       if [ ! -e $droidprop ] && $(lscpu | grep -q x86) ; then wg=" --connect-timeout=10 --continue -4 --retry-connrefused" ; elif [ -e $droidprop ] ; then export ifdr="/system" ; fi



        /usr/sbin/update-ccache-symlinks
        ln -sfT $(which dash) $(which sh)

        if $arch && [ $firstrun = yes ] ; then
# dash hook
echo '[Trigger]
Type = Package
Operation = Install
Operation = Upgrade
Target = bash

[Action]
Description = Re-pointing /bin/sh symlink to dash...
When = PostTransaction
Exec = '"$(which ln)"' -sfT '"$(which dash)"' '"$(which sh)"'
Depends = dash' | tee /etc/pacman.d/hooks/dash.hook

# clr header hook
#echo '[Trigger]
#Type = Package
#Operation = Install
#Operation = Upgrade
#Target = linux-clear-bin

#[Action]
#Description = Symlinking clr-headers
#When = PostTransaction
#Exec = rm -rf /usr/src/linux-clear-headers-*/include ; mkdir -p /usr/src/linux-clear-headers-$(ls /lib/modules | grep native | head -n1)/include ; /usr/sbin/ln -sfT /lib/modules/$(ls /lib/modules | grep native | head -n1)/build/include/linux /usr/src/linux-#clear-headers-$(ls /lib/modules | grep native | head -n1)/include
#Depends = linux-clear-headers-bin ' | tee /etc/pacman.d/hooks/linux-clr-headers.hook

## clr kexec hook
#echo '[Trigger]
#Type = Package
#Operation = Install
#Operation = Upgrade
#Target = linux-clear-bin

#[Action]
#Description = Symlinking clr-headers
#When = PostTransaction
#Exec = /usr/sbin/ln -sfT /boot/vmlinuz-linuz-clear-bin /vmlinuz ; /usr/sbin/ln -sfT /boot/initramfs-linux-clear-bin.img /initrd.img
#Depends = kexec-tools ' | tee /etc/pacman.d/hooks/kexec-clr.hook

sed -i '/#Color/c\Color ' /etc/pacman.conf
sed -i '/#ParallelDownloads =.*/c\ParallelDownloads = 5\nILoveCandy ' /etc/pacman.conf

fi




               if $linux ; then
      sed -i 's/ACTIVE_CONSOLES=.*/#ACTIVE_CONSOLES="\/dev\/tty[1-2]"/g' /etc/default/console-setup
      sed -i 's/#NAutoVTs=.*/NAutoVTs=2/g' /etc/systemd/logind.conf
      #sed -i 's/#UserStopDelaySec=.*/UserStopDelaySec=1/g' /etc/systemd/logind.conf
      #sed -i 's/#ReserveVT=.*/ReserveVT=1/g' /etc/systemd/logind.conf
      #sed -i 's/#InhibitDelayMaxSec=.*/InhibitDelayMaxSec=1/g' /etc/systemd/logind.conf
      #sed -i 's/#UserStopDelaySec=.*/UserStopDelaySec=1/g' /etc/systemd/logind.conf
      sed -i 's/#HandleRebootKey=.*/HandleRebootKey=reboot/g' /etc/systemd/logind.conf # fixes slow reboots, poweroffs (its either this or noresume parameter in cmdline, which breaks hibernation)
      sed -i 's/#HandlePowerKey=.*/HandlePowerKey=poweroff/g' /etc/systemd/logind.conf
      #sed -i 's/#HoldoffTimeoutSec=.*/HoldoffTimeoutSec=1/g' /etc/systemd/logind.conf
      #sed -i 's/RESUME=UUID=/#RESUME=UUID=/g' /etc/initramfs-tools/conf.d/resume
if [ $level = high ] ; then sed -i 's/#Storage=.*/Storage=none/g' /etc/systemd/coredump.conf ; sed -i 's/#RemoveIPC=.*/RemoveIPC=yes/g' /etc/systemd/logind.conf ; else
      sed -i 's/Storage=.*//g' /etc/systemd/coredump.conf ; sed -i 's/RemoveIPC=.*//g' /etc/systemd/logind.conf ; fi
      
      sed -i 's/#DNSSEC=.*/DNSSEC=yes/g' /etc/systemd/resolved.conf
      sed -i 's/#DNSOverTLS=.*/DNSOverTLS=yes/g' /etc/systemd/resolved.conf
      sed -i 's/#Cache=.*/Cache=yes/g' /etc/systemd/resolved.conf
      sed -i 's/#CacheFromLocalhost=.*/CacheFromLocalhost=yes/g' /etc/systemd/resolved.conf

      #if $(! grep -q "#timeout" /boot/EFI/refind/refind.conf) ; then
      sed -i 's/timeout .*/timeout 1/g' /boot/EFI/refind/refind.conf # ; fi


      sed -i 's/background: Some(.*/background: Some(9),/g' /etc/system76-scheduler/config.ron
     sed -i 's/foreground: Some(.*/foreground: Some(-19),/g' /etc/system76-scheduler/config.ron
    #if $(! grep -q pulseaudio /etc/system76-scheduler/assignments/default.ron) ; then
     #sed -i 's/"wireplumber",/"wireplumber",\n"alsa",\n"pulseaudio",/g' /etc/system76-scheduler/assignments/default.ron ; fi
    #if $(! grep -q brave-browser-nightly /etc/system76-scheduler/assignments/default.ron) ; then
     #sed -i 's/"Xorg",/"Xorg",\n"kwin_x11",\n"kwin_wayland",\n"openbox",\n"firefox",\n"chromium",\n"brave-browser-nightly",\n"google-earth-pro",\n"gitkraken",\n"github-desktop",\n"konsole",/g' /etc/system76-scheduler/assignments/default.ron ; fi
    #if $(! grep -q dbus-broker /etc/system76-scheduler/assignments/default.ron) ; then
     #sed -i 's/"dbus",/"dbus",\n"dbus-broker",/g' /etc/system76-scheduler/assignments/default.ron ; fi


    echo '// WARNING: Modifications to this file will not be preserved on upgrade.
// To configure, make new .ron files under /etc/system76-scheduler/assignments/.

{
// Prevent audio crackling from sound services.
(-11, Realtime(0)): [
    "pipewire",
    "pipewire-pulse",
    "wireplumber"
    "alsa",
    "pulseaudio",
],
// Very high
(-9, BestEffort(0)): [
    "easyeffects",
],
// High priority
(-5, BestEffort(4)): [
    "amsynth",
    "gnome-shell",
    "kwin",
    "sway",
    "steam",
    "vrcompositor",
    "vrdashboard",
    "vrmonitor",
    "vrserver",
    "Xorg",
    "kwin_gles",
    "kwin_x11",
    "kwin_wayland",
    "openbox",
    "firefox",
    "chromium",
    "brave-browser-nightly",
    "google-earth-pro",
    "gitkraken",
    "github-desktop",
    "konsole",

],
// Default
0: [
    "dbus",
    "dbus-broker",
    "sshd",
    "systemd",
    "c++",
    "clang",
    "cpp",
    "g++",
    "gcc",
    "make",
    "rustc",
    "apt:,
    "dpkg",
    "aptitude",
    "lld",
    "mold",
    "ld",
    "ld.gold",
],
// Low
(9, Idle): [
    "accounts-daemon",
    "acpid",
    "automount",
    "avahi-daemon",
    "anacron",
    "bluetoothd",
    "colord",
    "cron",
    "cups-browsed",
    "cupsd",
    "dconf-service",
    "dnsmasq",
    "dockerd",
    "evolution-source-registry",
    "evolution-calendar-factory",
    "evolution-addressbook-factory",
    "evolution-alarm-notify",
    "fwupd",
    "goa-daemon",
    "goa-identify-service",
    "gsd-a11y-settings",
    "gsd-color",
    "gsd-datetime",
    "gsd-housekeeping",
    "gsd-keyboard",
    "gsd-media-keys",
    "gsd-disk-utility-notify",
    "gsd-power",
    "gsd-print-notifications",
    "gsd-rfkill",
    "gsd-screensaver-proxy",
    "gsd-sharing",
    "gsd-smartcard",
    "gsd-sound",
    "gsd-wacom",
    "gsd-xsettings",
    "gsd-printer",
    "hidpi-daemon",
    "iwd",
    "ModemManager",
    "NetworkManager",
    "pop-system-updater",
    "rpcbind",
    "system76-daemon",
    "system76-firmware-daemon",
    "system76-power",
    "system76-scheduler",
    "system76-user-daemon",
    "thermald",
    "udisksd",
    "upowerd",
],
// Absolute lowest priority
(19, Idle): [
    "boinc",
    "FAHClient",
    "FAHCoreWrapper",
    "fossilize_replay",
    "tracker-miner-fs-3",
    "packagekitd",
]}
' | tee /etc/system76-scheduler/assignments/default.ron

    fi


         if $debian ; then cclm=$(ls /usr/lib | grep 'llvm-' | tail -n 1 | rev | cut -c-3 | rev) ; elif [ $firstrun = yes ] && $debian ; then cclm="$(apt-cache search llvm | awk '{print $1}' | grep "llvm-.*-runtime" | sort -n | tail -n 1 | cut -c5-7)" ; fi
         if $(! $debian) ; then cclm=$(echo "") ; fi
         if [ ! -f $droidprop ] && $linux ; then export maxframes="$(xrandr --current | tail -n 2 | head -n 1 | awk -F '.' '{print $1}' | awk '{print $2}')" ; fi #ompthreads=$(($(nproc --all)*4)) ; fi




if $(! grep -q '* soft nofile 524288' /etc/security/limits.conf) ; then
echo '* hard nofile 524288
* soft nofile 524288
* soft as unlimited
* hard as unlimited
root soft as unlimited
root hard as unlimited
* soft nofile 524288
* hard nofile 524288
root soft nofile 524288
root hard nofile 524288
* soft memlock unlimited
* hard memlock unlimited
root soft memlock unlimited
root hard memlock unlimited
* soft core unlimited
* hard core unlimited
root soft core unlimited
root hard core unlimited
* soft nproc unlimited
* hard nproc unlimited
root soft nproc unlimited
root hard nproc unlimited
* soft sigpending unlimited
* hard sigpending unlimited
root soft sigpending unlimited
root hard sigpending unlimited
* soft stack unlimited
* hard stack unlimited
root soft stack unlimited
root hard stack unlimited' | tee /etc/security/limits.conf ; fi

if $(! grep -q "524288" /etc/systemd/system.conf) ; then
echo 'DefaultLimitNOFILE=524288' | tee -a /etc/systemd/system.conf /etc/systemd/user.conf ; fi




    ### make backups - fstab may vary and other dirs maybe depending on phone. qcom is /vendor/fstab.qcom
    # remount rw
     if [ -f $droidprop ] ; then
     #if [ $testing = yes ] ; then
     #su
     #setprop service.adb.tcp.port 5555
     #stop adbd
     #start adbd ; fi
    mkdir -p /etc/bak/system
    mkdir -p /etc/bak/vendor
    mkdir -p /etc/bak/data/adb/service.d
    mkdir -p /etc/bak/data/adb/post-fs-data.d
    fi
    mkdir /etc/bak/etc/sysctl.d ; mkdir -p /etc/bak/etc/environment.d

        # droid
if [ -f $droidprop ] ; then
  if [ ! -f "$ifdr"/etc/bak$fstab ] && [ -f $fstab ] ; then
  for i in $("$bb"echo "$("$bb"echo "$fstab" | sed 's/fstab*/ /g' | awk '{print $1}')") ; do mkdir -p "$ifdr"/etc/bak$i ; done
  for i in $("$bb"echo "$fstab") ; do "$bb"cp -n $i /etc/bak$i ; done ; fi
  if [ ! -f "$ifdr"/etc/bak$droidhosts ] && [ -f $droidhosts ] ; then "$bb"cp -rf $droidhosts "$ifdr"/etc/bak$droidhosts ; fi
  if [ ! -f "$ifdr"/etc/bak$droidresolv ] && [ -f $droidresolv ] ; then "$bb"cp -rf $droidresolv "$ifdr"/etc/bak$droidresolv ; fi
  if [ ! -f "$ifdr"/etc/bak$droidsysctl ] && [ -f $droidsysctl ] ; then "$bb"cp -rf $droidresolv "$ifdr"/etc/bak$droidresolv ; fi
  if [ ! -f "$ifdr"/etc/bak/$droidcmdline ] ; then mkdir -p "$ifdr"/etc/bak/system/etc/root ; cat "$ifdr"/proc/cmdline | tee "$ifdr"/etc/bak$droidcmdline ; fi
  if [ ! -f "$ifdr"/etc/bak$droidprop ] ; then "$bb"cp -rf $droidprop "$ifdr"/etc/bak$droidprop ; fi
    # don't know if this is the way to go about it...
  #if [ -f $droidprop ] && [ -f /system/xbin/sh ] && [ ! -f /etc/bak/DO_NOT_DELETE ] ; then /system/xbin/cp -rf /system/xbin/* /system/bin/ ; /system/xbin/echo "DON'T DELETE THESE FILES, SCRIPT USES PARTS OF THIS BACKUP. ONLY EASY WAY OF RESTORING IF BRICKED" | tee /etc/bak/DO_NOT_DELETE ; fi
fi

  # all ( but exceptions, like openwrt not)
  if [ ! -f "$ifdr"/etc/bak/etc/environment ] ; then \cp -rf "$ifdr"/etc/environment "$ifdr"/etc/bak/etc/environment ; fi

  # all but droid
if [ ! -f $droidprop ] ; then
  if [ ! -f /etc/bak/etc/fstab ] ; then \cp -rf /etc/fstab /etc/bak/etc/fstab ; fi
  if [ ! -f /etc/bak/root/cmdline ] ; then mkdir -p /etc/bak/root ; cat /proc/cmdline | tee /etc/bak/root/cmdline ; fi
fi

# linux only
if $linux ; then
  if [ ! -f /etc/bak/etc/NetworkManager/NetworkManager.conf ] ; then mkdir -p /etc/bak/etc/NetworkManager ; \cp -rf /etc/NetworkManager/NetworkManager.conf /etc/bak/etc/NetworkManager/NetworkManager.conf ; fi
  if [ ! -f /etc/bak/etc/default/grub ] ; then mkdir -p /etc/bak/etc/default ; \cp -rf /etc/default/grub /etc/bak/etc/default/grub ; fi
fi








  ### pls put repos in /etc/apt/sources.list.d/extras.list idc im removing urs
  if [ $clean_sources_list_d = yes ] ; then
   find /etc/apt/sources.list.d/* -type f -not -name 'extras.list' -delete ; fi






  ### script binds dirs later on again
    "$bb"umount -f "$ifdr"/root/cmdline # just to avoid binding it 20 times
    "$bb"umount -f "$ifdr"/etc/root/cmdline
    "$bb"umount -f "$ifdr"/etc/sysctl.conf







  ### < BLOCKLISTS >
  ### if NOT wrt, update /etc/hosts weekly - script in /etc/update_hosts.sh & cronjob
    # add script /etc/update_hosts.sh
    if [ $firstrun = yes ] && $(! $wrt) ; then
    blsync="$(echo "$blocklist" | tee "$ifdr"/etc/update_hosts.sh)"
    if $arch ; then mkdir -p /etc/cron.d ; echo '@weekly root /bin/bash -c '\''sleep 10 ; sh /etc/update_hosts.sh >/dev/null'\''' | tee /etc/cron.d/@weekly ; fi
    if systemctl list-unit-files | grep -q anacron ; then
    if $(! grep update_hosts.sh "$ifdr"/etc/anacrontabs) ; then echo "@weekly sh /etc/update_hosts.sh >/dev/null" | tee -a "$ifdr"/etc/anacrontabs && "$blsync" ; fi
  elif $(! grep update_hosts.sh "$ifdr"/etc/crontab "$ifdr"/etc/crontab/root) ; then echo "0 0 * * 0 root sh /etc/update_hosts.sh >/dev/null" | tee -a "$ifdr"/etc/crontab "$ifdr"/etc/crontabs/root && "$blsync" ; fi ; fi







  ### < CRONJOB INIT.SH >
    if systemctl list-unit-files | grep -q anacron ; then
    if $(! grep -q rc.local "$ifdr"/etc/anacrontabs) ; then echo "@reboot sh /etc/rc.local >/dev/null" | tee -a "$ifdr"/etc/anacrontabs && "$blsync" ; fi
  elif $(! grep -q rc.local "$ifdr"/etc/crontabs/root "$ifdr"/etc/crontab) ; then echo "@reboot root sh /etc/rc.local >/dev/null" | tee -a "$ifdr"/etc/crontabs/root "$ifdr"/etc/crontab ; fi

    #if $arch ; then if ! grep -q ${file} /etc/anacrontab ; then echo "@reboot sh /etc/rc.local >/dev/null" | tee -a "$ifdr"/etc/anacrontabs && "$blsync" ; fi ; fi
    if [ $firstrun = yes ] && $arch ; then pacman -S --noconfirm --needed cronie ; echo '@reboot root /bin/bash -c '\''sleep 10 ; sh /etc/rc.local >/dev/null'\''' | tee /etc/cron.d/@reboot ; systemctl enable cronie ; fi
    #yay -S rc-local ; systemctl enable rc-local ; fi

    # cronjob kernel - daily seek for update mainline kernel only from experimental branch. since i dont trust debian experimental repositories no more and am in no mood to fight with the packages and dependencies...
    if  [ $firstrun = yes ] && $debian ; then
    if $(! grep -q "linux-image-amd64" "$ifdr"/etc/anacrontabs) ; then
    echo "@daily \sh -c 'apt -f -y install -t experimental linux-image-amd64 && grub-mkconfig'" | tee -a "$ifdr"/etc/anacrontabs ; fi ; fi






  ### < SOURCES.LIST >
  ### if ID_LIKE=debian sync sources.list on boot
          if $debian && [ $sourceslist_update = yes ] ; then
          ping -c3 "$ping"
          if [ $? -eq 0 ]; then
          echo "*BLS*=Syncing sources.list." && "$(wget --connect-timeout=10 --continue -4 --retry-connrefused ${rawlink}/sources.list -O /etc/apt/sources.list)" ; fi ; fi







  ### < HIJACK CMDLINE >
  ### detect if linux or openwrt/android to hijack cmdline to adjust bootargs from userspace (gets applied with '# cat /proc/cmdline' not sure if it works though)
      #if $(! $debian) ; then echo "*BLS*=FOUND DEBIAN NOT HIJACKING CMDLINE"
      #if $debian ; then echo "$par" | tee /root/cmdline &&
      #mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi
  ### openwrt
      if $wrt ; then echo "$(cat /etc/bak/root/cmdline) $par" | tee /root/cmdline &&
      mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi
  ### android
      if [ -f $droidprop ] ; then mkdir -p /system/etc/root ; "$bb"echo "$(cat "$ifdr"/etc/bak/system/root/cmdline) '"$par"'" | tee /system/etc/root/cmdline ; "$bb"mount -n --bind -o ro /system/etc/root/cmdline /proc/cmdline ; elif $(! $linux) ; then
      mkdir -p /etc/root ; echo "$par" | tee /etc/root/cmdline &&
      mount -n --bind -o ro /etc/root/cmdline /proc/cmdline ; fi
      #if $(! $linux) ; then
      #if $(! grep -q "/proc/cmdline" $fstab) && [ ! -e $droidfstab ] ; then echo "/etc/root/cmdline /proc/cmdline ro 0 0" | tee -a $fstab ; elif $(! grep -q "/proc/cmdline" $fstab) &&  [ -f $droidfstab ] ; then echo "/system/etc/root/cmdline /proc/cmdline ro 0 0" | tee -a $fstab ; fi
      #fi
      # echo "doesnt work anyways" ; else echo "$par" | tee /root/cmdline &&
      #mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi







  ### < KERNEL PARAMETERS >
  ### grub
      if $linux ; then
        #sed -i '/timeout/c\ ' $systemdb/loader.conf
        echo "options $par" | tee $systemdb/loader.conf
             if [ ! -z $systemdb ] ; then defi=" uefi=yes" ; fi
    resolution="$(xrandr --current | grep current | awk '{print $8$9$10}' | sed 's/\,.*//')"
    sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=""' /etc/default/grub
    sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX=""' /etc/default/grub
    sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="'"$xpar"'"' /etc/default/grub
    #sed -i 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="'"$par"'"/g' /etc/default/grub
    #sed -i 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="splash quiet'"$x0"'"/g' /etc/default/grub
    sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub
    sed -i "/#GRUB_DISABLE_OS_PROBER=false/c\GRUB_DISABLE_OS_PROBER=false" /etc/default/grub
    if $(! grep -q "GRUB_GFXPAYLOAD_LINUX" /etc/default/grub) ; then echo "#GRUB_GFXPAYLOAD_LINUX=" | tee -a /etc/default/grub ; fi
    sed -i 's/#GRUB_GFXPAYLOAD_LINUX=.*/GRUB_GFXPAYLOAD_LINUX="keep"/g' /etc/default/grub
    sed -i 's/#GRUB_GFXMODE=.*/GRUB_GFXMODE="'"$resolution"'"/g' /etc/default/grub
    # systemd-boot
    echo "$par" | tee /etc/kernel/cmdline
    # dracut
    if glxinfo | grep -qi intel ; then dracgpu=" i915" ; elif glxinfo | grep -qi amd ; then dracgpu=" amdgpu" ; elif glxinfo | grep -qi nvidia ; then dracgpu=" nvidia" ; fi
    if [ $raid = no ] ; then oraid=" dmraid mdraid" ; fi
    if [ $bluetooth = off ] ; then obt=" bluetooth" ; fi
    if [ $lvm = no ] ; then olvm=" lvm lvmmerge lvmthinpool-monitor" ; fi
    if [ $crypt = no ] ; then ocrypt=" crypt" ; fi
    if [ ! -z $systemdb ] ; then uefilib=" uefi-lib" ; fi
    dracflags="kernel_cmdline='$par' hostonly=yes hostonly_cmdline=yes use_fstab=yes$defi add_fstab+=/etc/fstab mdadmconf=$raid lvmconf=$lvm$(if [ $microcode = on ] ; then echo " early_microcode=yes" ; fi)$(if [ $ignoreloglevel = off ] ; then echo " stdloglvl=0 sysloglvl=0 fileloglvl=0" ; fi) show_modules=yes do_strip=yes nofscks=no compress=lz4 add_drivers+='lz4 lz4hc$(if lscpu | grep -qi intel ; then echo " intel_pstate" ; elif lscpu | grep -qi amd ; then echo " amd_pstate" ; fi)$dracgpu' omit_dracutmodules+='$(if [ $level = high ] ; then echo "syslog " ; fi)debug watchdog watchdog-modules brltty$oraid$obt$olvm$ocrypt' add_dracutmodules+='dash kernel-modules rootfs-block udev-rules usrmount base fs-lib shutdown systemd dracut-systemd systemd-initrd systemd-sysusers dbus dbus-broker rngd drm fstab-sys i18n kernel-modules-extra terminfo network network-manager img-lib$uefilib'"
              if [ $dracut = enabled ] ; then
        if [ ! "$(cat /etc/dracut.conf.d/*linux.conf)" = "$dracflags" ] ; then
        rm -rf /etc/dracut.conf.d/* ; echo "$dracflags" | tee /etc/dracut.conf.d/10-linux.conf ; fi ; fi
      fi
      if lscpu | grep -qi intel ; then modprobe intel_pstate ; elif lscpu | grep -qi amd ; then modprobe amd_pstate ; fi
        # omit_dracutmodules+='iscsi brltty' dracutmodules+='systemd dash rootfs-block udev-rules usrmount base fs-lib shutdown rngd fips busybox rescue caps lz4 acpi_cpufreq cpufreq_performance processor msr$draczswap'"

if [ $level = low ] ; then echo "\n setup applied till cmdline params on level = low, success" ; exit 0 ; fi
        
##################################### level = low ends here



  ### < FSTAB UPDATE >
  ### fstab update
  if [ ! -f $droidprop ] ; then
    sed -i 's/xfs .*/xfs     '"$xfs"' 0 0/g' /etc/fstab #$fstab
    sed -i 's/ext4 .*/ext4     '"$ext4"' 0 0/g' /etc/fstab #$fstab
    sed -i 's/f2fs .*/f2fs     '"$f2fs"' 0 0/g' /etc/fstab #$fstab
    sed -i 's/vfat .*/vfat     '"$vfat"' 0 0/g' /etc/fstab #$fstab
  fi


       # i hope there are no bash fuckups running legacy stuff here. rip
    if [ -f $droidprop ] && [ $androidfstab = yes ] ; then
      # f2fs droid
      dataf2fsdroid="$(grep /data "$fstab" | grep ext4 | sed 's/ext4/f2fs/g' | awk '{print $1, $2, $3, " '"$f2fs"',nosuid,nodev ", $5}' | sed 's/defaults,rw,//g' | sed 's/\//\\\//g')"
      dataf2fsreplace="$(grep /data "$fstab" | grep f2fs | sed 's/\//\\\//g')"
      cachef2fsdroid="$(grep /cache "$fstab" | grep ext4 | sed 's/ext4/f2fs/g' | awk '{print $1, $2, $3, " '"$f2fs"',nosuid,nodev ", $5}' | sed 's/defaults,rw,//g' | sed 's/\//\\\//g')"
      cachef2fsreplace="$(grep /cache "$fstab" | grep f2fs | sed 's/\//\\\//g')"
      # ext4 droid
      dataext4droid="$(grep /data "$fstab" | grep ext4 | awk '{print $1, $2, $3, " '"$ext4"',nosuid,nodev ", $5}' | sed 's/defaults,rw,//g' | sed 's/\//\\\//g')"
      dataext4replace="$(grep /data "$fstab" | grep ext4 | sed 's/\//\\\//g')"
      cacheext4droid="$(grep /cache "$fstab" | grep ext4 | awk '{print $1, $2, $3, " '"$ext4"',nosuid,nodev ", $5}' | sed 's/defaults,rw,//g' | sed 's/\//\\\//g')"
      cacheext4replace="$(grep /cache "$fstab" | grep ext4 | sed 's/\//\\\//g')"
      systemext4droid="$(grep /system "$fstab" | grep ext4 | awk '{print $1, $2, $3, " '"$ext4"' ", $5}' | sed 's/defaults,rw,/ro,/g' | sed 's/\//\\\//g')"
      systemext4replace="$(grep /system "$fstab" | grep ext4 | sed 's/\//\\\//g')"
      # sdcard
      sdcardreplace="$(grep "external\|sdcard\|storage\|usb" "$fstab" | sed 's/\//\\\//g')"
      sdcarddroid="$(grep "external\|sdcard\|storage\|usb" "$fstab" | awk '{print $1, $2, $3, $4",lazytime,noatime ", $5}' | sed 's/\//\\\//g')"



        if $(! grep -q f2fs "$fstab") ; then
"$bb"echo "$dataf2fsdroid" | tee -a "$fstab"
"$bb"echo "$cachef2fsdroid" | tee -a "$fstab"
        fi


"$bb"sed -i 's/'"$dataf2fsreplace"'/'"$dataf2fsdroid"'/g' "$fstab"
"$bb"sed -i 's/'"$cachef2fsreplace"'/'"$cachef2fsdroid"'/g' "$fstab"
"$bb"sed -i 's/'"$dataext4replace"'/'"$dataext4droid"'/g' "$fstab"
"$bb"sed -i 's/'"$cacheext4replace"'/'"$cacheext4droid"'/g' "$fstab"
"$bb"sed -i 's/'"$systemext4replace"'/'"$systemext4droid"'/g' "$fstab"
"$bb"sed -i 's/'"$sdcardreplace"'/'"$sdcarddroid"'/g' "$fstab"
"$bb"sed -i 's/,errors=remount-ro//g' "$fstab"
    fi


 ### < FSTAB TMPFS > - AVOID IF ZRAM or SWAP IS FOUND
  ### temporarily enable zram for myself
  sh /etc/zram.sh
  if [ ! -e $droidprop ] ; then
  ### fstab tmpfs on ram
    tmpfsadd=$(if grep -q "tmpfs" "$fstab" ; then echo "*BLS*=TMPFS found not applying to /etc/fstab."; else echo "*BLS*=TMPFS added to /etc/fstab." &&
    echo 'tmpfs    /tmp        tmpfs    '"$tmpfs"',mode=1777         0 0' | tee -a "$fstab"
    echo 'tmpfs    /var/tmp    tmpfs    '"$tmpfs"',mode=1777         0 0' | tee -a "$fstab"
    echo 'tmpfs    /run/shm    tmpfs    '"$tmpfs"',mode=0755         0 0' | tee -a "$fstab"
    echo 'tmpfs    /dev/shm    tmpfs    '"$tmpfs"''"$devshm"',noexec'"$(if [ $level != high ] ; then echo ",nosuid" ; fi)"'  0 0' | tee -a "$fstab" #nosuid causes worstening of hackbench
    echo 'tmpfs    /var/lock   tmpfs    '"$tmpfs"',mode=1777         0 0' | tee -a "$fstab"
    echo 'tmpfs    /var/run    tmpfs    '"$tmpfs"',mode=0755         0 0' | tee -a "$fstab" ; fi)
    #echo 'tmpfs    /var/log    tmpfs    '"$tmpfs"',mode=1755,size=10m  0 0' | tee -a /etc/fstab
    #echo 'tmpfs    /var/spool  tmpfs    '"$tmpfs"',mode=1750,size=4m   0 0' | tee -a /etc/fstab
 ### check if zram to avoid tmpfs on ram
 # if [ dmesg | grep -q zram ] || [ grep -q swap /etc/fstab ]; then echo "*BLS*=ZRAM and or SWAP found, whatever adding tmpfs on ram despite. Too fast." && $tmpfsadd ; else $tmpfsadd ; fi ### dont add additional flags for tmpfs, will slow it down

 $tmpfsadd # and then there was tmpfs for all.
  fi
  ### update tmpfs values
    sed -i 's/\/tmp        tmpfs.*/\/tmp        tmpfs    '"$tmpfs"',mode=1777          0 0/g' "$fstab"
    sed -i 's/\/var\/tmp    tmpfs.*/\/var\/tmp    tmpfs    '"$tmpfs"',mode=1777          0 0/g' "$fstab"
    sed -i 's/\/run\/shm    tmpfs.*/\/run\/shm    tmpfs    '"$tmpfs"',mode=0755          0 0/g' "$fstab"
    sed -i 's/\/dev\/shm    tmpfs.*/\/dev\/shm    tmpfs    '"$tmpfs"''"$devshm"',noexec'"$(if [ $level != high ] ; then echo ",nosuid" ; fi)"'    0 0/g' "$fstab"
    sed -i 's/\/var\/lock   tmpfs.*/\/var\/lock   tmpfs    '"$tmpfs"',mode=1777          0 0/g' "$fstab"
    sed -i 's/\/var\/run   tmpfs.*/\/var\/run   tmpfs    '"$tmpfs"',mode=0755             0 0/g' "$fstab"

    if $(lscpu | grep -q x86) ; then
    if [ $(uname -r | cut -c1-1) -gt 3 ] ; then
    "$bb"sed -i 's/ defaults / defaults,lazytime,noatime /g' "$fstab"
    else
    "$bb"sed -i 's/ defaults / defaults,noatime /g' "$fstab"
    fi ; fi



  "$bb"sed -i 's/ sw / sw,lazytime,noatime /g' "$fstab"

  if [ $(uname -r | cut -c1-1) -gt 3 ] ; then
    mkdir -p /mnt/huge
  if $(! grep -q hugetlbfs "$fstab") ; then echo 'hugetlbfs    /mnt/huge  hugetlbfs  '"$tmpfs"'               0 0' | tee -a "$fstab" ; fi
    #"$bb"sed -i 's/noatime/lazytime/g' "$fstab"
    "$bb"sed -i 's/nodiratime/lazytime,noatime/g' "$fstab"
    "$bb"sed -i 's/relatime/lazytime,noatime/g' "$fstab"
    "$bb"sed -i 's/ sw / sw,lazytime,noatime /g' "$fstab"
    else
    "$bb"sed -i 's/lazytime/noatime/g' "$fstab"
    "$bb"sed -i 's/nodiratime/noatime/g' "$fstab"
    "$bb"sed -i 's/relatime/noatime/g' "$fstab"
    "$bb"sed -i 's/ sw / sw,noatime /g' "$fstab"
    fi






  ### < ADDITIONAL LINUX CONFIG >
  # ssh
      if grep -q "Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com," $HOME/.ssh/config ; then
      echo "Flag exists"; else echo 'Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      Compression yes' | tee -a $HOME/.ssh/config /root/.ssh/config ; fi
      sed -i "/#PermitRootLogin prohibit-password/c\PermitRootLogin no" "$ifdr"/etc/ssh/sshd_config # configure some security which wont harm performance
      sed -i "/X11Forwarding yes/c\X11Forwarding no" "$ifdr"/etc/ssh/sshd_config
      sed -i "/#AllowTcpForwarding yes/c\AllowTcpForwarding no" "$ifdr"/etc/ssh/sshd_config
      sed -i "/#PermitTTY yes/c\PermitTTY no" "$ifdr"/etc/ssh/sshd_config


      ### amdgpu
 echo 1 | sudo tee /sys/class/drm/card*/device/power_dpm_force_performance_level
 echo $perfamdgpu > /sys/class/drm/card0/device/power_dpm_force_performance_level


  # samba
      if grep -q "deadtime = 30" "$ifdr"/etc/samba/smb.conf ; then echo "Flag exists" ; else echo 'deadtime = 30
      use sendfile = yes
      min receivefile size = 16384
      socket options = IPTOS_LOWDELAY TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072' | tee "$ifdr"/etc/samba/smb.conf ; fi


  # bluetooth
      sed -i 's/AutoEnable.*/AutoEnable=false/' "$ifdr"/etc/bluetooth/main.conf
      sed -i 's/#FastConnectable.*/FastConnectable=false/' "$ifdr"/etc/bluetooth/main.conf
      sed -i 's/ReconnectAttempts.*/ReconnectAttempts=1/' "$ifdr"/etc/bluetooth/main.conf
      sed -i 's/ReconnectIntervals.*/ReconnectIntervals=1/' "$ifdr"/etc/bluetooth/main.conf
     # if [ ! -f $droidprop ] ; then rm -rfd /var/lib/bluetooth/* ; fi


  # journaling and more
  if [ $level = high ] ; then
      if grep -q "Storage=none" /etc/systemd/journald.conf ; then echo "Flag exists" ; else echo "Storage=none" | tee -a /etc/systemd/journald.conf ; fi
      sed -i 's/\Storage=.*/Storage=none/g' /etc/systemd/coredump.conf
      sed -i 's/\Seal=.*/Seal=no/g' /etc/systemd/coredump.conf ; fi



  # preload
        sed -i 's/memfree =.*/memfree = 50/g' /etc/preload.conf
        sed -i 's/memcached =.*/memcached = 0/g' /etc/preload.conf
        sed -i 's/processes =.*/processes = 100/g' /etc/preload.conf
        sed -i 's/memtotal =.*/memtotal = -10/g' /etc/preload.conf
        sed -i 's/minsize =.*/minsize = 20000/g' /etc/preload.conf



  # hdparm

  if [ ! -f "$ifdr"/etc/pdparm.conf ] ; then touch "$ifdr"/etc/hdparm.conf &&
echo 'apm = 254
dma = on
write_cache = on
keep_settings_over_reset = on
keep_features_over_reset = on' | tee -a "$ifdr"/etc/hdparm.conf ; fi
      sed -i 's/#apm =.*/apm = 254/g' /etc/hdparm.conf
      sed -i 's/#dma =.*/dma = on/g' /etc/hdparm.conf
      sed -i 's/#keep_settings_over_reset =.*/keep_settings_over_reset = on/g' /etc/hdparm.conf
      sed -i 's/#keep_features_over_reset =.*/keep_features_over_reset = on/g' /etc/hdparm.conf
      sed -i 's/#write_cache =.*/write_cache = on/g' /etc/hdparm.conf
      if [ $level != high ] ; then sed -i 's/apm =.*//g' /etc/hdparm.conf ; fi





  # force apt only to use ipv4
    if [ ! $ipv6 = on ] ; then echo 'Acquire::ForceIPv4 "true";' | tee -a /etc/apt/apt.conf.d/99force-ipv4 ; else echo 'Acquire::ForceIPv4 "false";' | tee -a /etc/apt/apt.conf.d/99force-ipv4 ; fi
  # dont aquire translations for apt
    if grep -q 'Acquire::Languages "none";' /etc/apt/apt.conf.d/00aptitude; then echo "Flag exists"
    else echo 'Acquire::Languages "none";' | tee -a /etc/apt/apt.conf.d/00aptitude ; fi




  # selinux - we have apparmor, but leave this in passively config devices who have selinux instead - might break fedora/rhel/centos so just on android where older kernels are on selinux instead ( last time i tested it broke fedora, so ... havent tested ever since as i do not have a full-setup for fedora and do not plan on doing more effort )
 if [ -e $droidprop ] ; then
    sed -i "/SELINUX=permissive/c\SELINUX=enforcing" "$ifdr"/etc/selinux/config
    sed -i "/SELINUXTYPE=/c\SELINUXTYPE=mls" "$ifdr"/etc/selinux/config
    echo 1 > /sys/fs/selinux/enforce
    setenforce 1 ; fi




  # firewall
    sed -i "/shields-down/c\shields-down=public" "$ifdr"/etc/firewall/applet.conf #firewalld default preconfig
    sed -i "/shields-up/c\shields-up=block" "$ifdr"/etc/firewall/applet.conf
    sed -i "/DefaultZone/c\DefaultZone=block" "$ifdr"/etc/firewalld/firewalld.conf
    ufw deny 22/tcp # ufw not used in this setup but left in despite
    ufw deny 22/udp
    ufw deny 23/tcp
    ufw deny 23/udp
    #ufw deny 53/tcp
    #ufw deny 53/udp
    #ufw deny 80/tcp
    #ufw deny 80/udp
    #ufw deny 443/tcp
    #ufw deny 443/udp
    #ufw default deny incoming
    #ufw default allow outgoing
    #ufw deny in on lo
    #ufw deny out on lo
    sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'
if $(! grep -q 'order bind,hosts' "$ifdr"/etc/host.conf) ; then
echo 'order bind,hosts
multi on' | tee -a "$ifdr"/etc/host.conf ; fi



  # dns
    if $(! grep -q "$dns61" "$ifdr"/etc/resolv.conf) ; then
echo 'nameserver '"$dns1"'
nameserver '"$dns2"'
nameserver 127.0.0.1
#nameserver ::1
#nameserver '"$dns61"'
#nameserver '"$dns62"'
search lan local' | tee "$ifdr"/etc/resolv.conf ; fi

if [ $ipv6 = on ] ; then sed -i 's/#nameserver ::1
#nameserver '"$dns61"'
#nameserver '"$dns62"'/nameserver ::1
nameserver '"$dns61"'
nameserver '"$dns62"'/g' "$ifdr"/etc/resolv/conf ; fi

    if $(! grep -q edns0 "$ifdr"/etc/resolv.conf) ; then
    echo 'options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 single-request-reopen no-tld-query' | tee -a "$ifdr"/etc/resolv.conf ; fi



  if $(! grep -q "filterwin2k " "$ifdr"/etc/hosts) ; then
echo 'options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 single-request-reopen no-tld-query
127.0.0.1 localhost
::1 localhost' | tee -a "$ifdr"/etc/hosts ; fi
    if $(! grep -a "127.0.1.1 "$(cat "$ifdr"/etc/hostname)"" "$ifdr"/etc/hosts) ; then
    echo "127.0.1.1 "$(cat "$ifdr"/etc/hostname)"" | tee -a "$ifdr"/etc/hosts ; fi


  # clean
    rm -rf /var/crash/*



  # extras
    if $(! $wrt) ; then



  # dpkg
    dpkg --add-architecture i386

  # gpg workaround
    rsync --ignore-existing /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

  # hdd write caching and power management
  #for i in $storage ; do
  for i in $(find /dev/sd* ; find /dev/nvm* ; find /dev/hd*) ; do
  blktool $i wcache on
  blktool $i dma on
  blktool $i queue-depth 31
  blktool $i dev-keep-settings
  hdparm -a $i 8192
  hdparm -c 3 $i
  hdparm -A1 $i
  hdparm -d1 $i
  hdparm -W 1 $i
  if [ $level = high ] ; then hdparm -B 254 $i ; smartctl --smart=off $i ; fi
  hdparm -Q 32 $i
  hdparm -R0 $i
  hdparm -k1 $i
  hdparm -K1 $i
  done



  # more ALL RANDOM STUFF GOES HERE
  if $linux && [ $country != 00 ] ; then
  echo 'WIRELESS_REGDOM='"$country"'' | tee /etc/conf.d/wireless-regdom ; fi
  if $arch ; then
  if [ $level = high ] ; then extracflags=" -ffast-math -Wl,norelro -Ofast -funroll-loops -fomit-frame-pointer -fno-stack-protector -Wno-format-security -flto=auto -faggressive-loop-optimizations -funsafe-math-optimizations" ; else extracflags=" -D_FORTIFY_SOURCE=2 -Wl,relro -fstack-clash-protection -fcf-protection" ; fi
  sed -i 's/-mtune=generic/-fasynchronous-unwind-tables -feliminate-unused-debug-types -fforce-addr -fno-semantic-interposition -fno-signed-zeros -fno-strict-aliasing -fno-trapping-math -fopenmp -fwrapv -lcrypt -ldl -lhmmer -lm -lncurses -lpgcommon -lpgport -lpq -lpthread -lrt -lsquid -m64 -march=native -mcpu=native -mtune=native -pipe -pthread -g0 -fuse-linker-plugin -Wl,--as-needed -Wl,--sort-common  -Wl,-mcpu=native -Wl,--strip-debug -falign-functions=64 -O3 -fassociative-math -Wno-frame-address -Wno-trigraphs -Wundef -ffat-lto-objects -Wl,-O3 -fuse-ld=lld -fvpt -fpeel-loops -finline-functions -funswitch-loops -fgcse-after-reload -ftree-loop-distribute-patterns -Wp,-D_REENTRANT -ftree-loop-optimize -foptimize-sibling-calls -fdelete-null-pointer-checks -mprefer-vector-width=256 -Wl,--hash-style-gnu -fgraphite-identity -floop-block -floop-interchange -floop-nest-optimize -floop-optimize -floop-parallelize-all -floop-strip-mine -ftree-loop-vectorize -ftree-loop-distribution -fprefetch-loop-arrays'"$extracflags"' /g' /etc/makepkg.conf
  sed -i 's/!ccache/ccache/g' /etc/makepkg.conf
  sed -i 's/-O2/-O3/g' /etc/makepkg.conf
  sed -i 's/-O1/-O3/g' /etc/makepkg.conf
  sed -i 's/-Os/-O3/g' /etc/makepkg.conf
  sed -i 's/x86-64/native/g' /etc/makepkg.conf
  sed -i 's/DEBUG_CFLAGS=.*/DEBUG_CFLAGS="-g0"/g' /etc/makepkg.conf
  sed -i 's/ -fno-plt -fexceptions//g' /etc/makepkg.conf
  if [ $level = high ] ; then
  sed -i 's/-Wp,-D_FORTIFY_SOURCE=2 -Wformat -Werror=format-security/-Ofast/g' /etc/makepkg.conf
  sed -z -i -e 's/-fstack-clash-protection -fcf-protection/\n/g' /etc/makepkg.conf
  fi
   if ! grep -q CC=clang /etc/makepkg.conf ; then
echo '#export CC=clang
#export CXX=clang++
export CC_LD=lld
export CXX_LD=lld
export LD=ld.lld
export AR=llvm-ar
export NM=llvm-nm
export STRIP=llvm-strip
export OBJCOPY=llvm-objcopy
export OBJDUMP=llvm-objdump
export READELF=llvm-readelf
export RANLIB=llvm-ranlib
#export HOSTCC=clang
#export HOSTCXX=clang++
export HOSTAR=llvm-ar
NINJAFLAGS="-j'"$(nproc --all)"'"' | tee -a /etc/makepkg.conf
   fi
  sed -i 's/COMPRESSXZ=.*/COMPRESSXZ=(xz -c -z --threads=0 -)/g' /etc/makepkg.conf
  sed -i 's/COMPRESSZST=.*/COMPRESSZST=(zstd -c -z -q --threads=0 -)/g' /etc/makepkg.conf
  sed -i 's/COMPRESSBZ2=.*/COMPRESSBZ2=(pbzip2 -c -f)/g' /etc/makepkg.conf
  sed -i 's/COMPRESSGZ=.*/COMPRESSGZ=(pigz -c -f -n)/g' /etc/makepkg.conf
  sed -i 's/COMPERSSLZ=.*/COMPERSSLZ=(plzip -c -f)/g' /etc/makepkg.conf
  sed -i 's/PKGEXT=.*/PKGEXT=".pkg.tar.lz4"/g' /etc/makepkg.conf
  sed -i 's/#MAKEFLAGS=.*/MAKEFLAGS="-j'"$(nproc --all)"'"/g' /etc/makepkg.conf
  sed -i 's/#RUSTFLAGS="-C opt-level=2"/RUSTFLAGS="-C opt-level=3 -C target-cpu=native -Ztune-cpu=native"/g' /etc/makepkg.conf
  sed -i 's/LDFLAGS.*/LDFLAGS="--strip-debug -plugin-opt=-mcpu=native -plugin-opt=O3"/g' /etc/makepkg.conf
  fi
    systemctl set-default graphical.target
    if $(! grep -q experimental-features /etc/nix/nix.conf) ; then
    echo 'experimental-features = nix-command flakes' | tee -a /etc/nix/nix.conf ; fi
    if [ $level = high ] ; then 
    sed -i 's/^#ForwardToSyslog=yes/ForwardToSyslog=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToKMsg=yes/ForwardToKMsg=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToConsole=yes/ForwardToConsole=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToWall=yes/ForwardToWall=no/' /etc/systemd/journald.conf
    sed -i 's/^#DumpCore=.*/DumpCore=no/' /etc/systemd/system.conf /etc/systemd/user.conf
    sed -i 's/^#CrashShell=.*/CrashShell=no/' /etc/systemd/system.conf /etc/systemd/user.conf
    echo "kernel.core_pattern=/dev/null" | tee /etc/sysctl.d/50-coredump.conf
    else
    sed -i 's/^ForwardToSyslog=.*//' /etc/systemd/journald.conf
    sed -i 's/^ForwardToKMsg=.*//' /etc/systemd/journald.conf
    sed -i 's/^ForwardToConsole=.*//' /etc/systemd/journald.conf
    sed -i 's/^ForwardToWall=.*//' /etc/systemd/journald.conf 
    sed -i 's/^DumpCore=.*//' /etc/systemd/system.conf /etc/systemd/user.conf
    sed -i 's/^CrashShell=.*//' /etc/systemd/system.conf /etc/systemd/user.conf
    echo "" | tee /etc/sysctl.d/50-coredump.conf
    fi
    if grep -q DefaultTimeoutStopSec /etc/systemd/system.conf ; then
    sed -i 's/DefaultTimeoutStopSec/DefaultTimeoutStopSec=1s/' /etc/systemd/system.conf ; elif
    ! grep -q DefaultTimeoutStopSec /etc/systemd/system.conf ; then
    echo 'DefaultTimeoutStopSec=1s' | tee -a /etc/systemd/system.conf ; fi
    echo 'Dir::Log::Terminal "";' | tee /etc/apt/apt.conf.d/01disable-log
    #find /usr/share/doc/ -depth -type f ! -name copyright | xargs rm -f || true
    #find /usr/share/doc/ | egrep '\.gz' | xargs  rm -f
    #find /usr/share/doc/ | egrep '\.pdf' | xargs m -f
    #find /usr/share/doc/ | egrep '\.tex' | xargs rm -f
    #find /usr/share/doc/ -empty | xargs rmdir || true
    #rm -rfd /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* \
    #/usr/share/linda/* /var/cache/man/* /usr/share/man/*
    #find /usr/share/X11/locale/* -type f -not -name 'el_GR\|en_US' -delete
    sed -i 's/MODULES=.*/MODULES=dep/g' /etc/initramfs-tools/initramfs.conf
    sed -i 's/BUSYBOX=.*/BUSYBOX=y/g' /etc/initramfs-tools/initramfs.conf
    sed -i 's/COMPRESS=.*/COMPRESS=lz4/g' /etc/initramfs-tools/initramfs.conf
    #sed -i 's/# COMPRESSLEVEL=.*/COMPRESSLEVEL=9/g' /etc/initramfs-tools/initramfs.conf
    #sed -i 's/COMPRESSLEVEL=.*/COMPRESSLEVEL=9/g' /etc/initramfs-tools/initramfs.conf
    if $(! grep -q 'Unattended-Upgrade::AutoFixInterruptedDpkg "true";' /etc/apt/apt.conf.d/50unattended-upgrades) ; then
echo 'APT::Periodic::Unattended-Upgrade "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::Update-Package-Lists "1";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";' | tee -a /etc/apt/apt.conf.d/50unattended-upgrades ; fi
if $(! grep -q 'bantine = 1d' /etc/fail2ban/jail.local) ; then
echo '[DEFAULT]
banaction = nftables
banaction_allports = nftables[type=allports]
bantime = 1d
findtime = 600
maxretry = 5
enabled = true
[sshd]
enabled = true
filter    = sshd
banaction = iptables
backend   = systemd
maxretry  = 5
findtime  = 1d
bantime   = 2w
ignoreip  = 127.0.0.1/8' | tee /etc/fail2ban/jail.local ; fi
if $(! grep -q failregex /etc/fail2ban/filter.d/fwdrop.local) ; then
echo '[Definition]
failregex = ^.*DROP_.*SRC=<ADDR> DST=.*$
journalmatch = _TRANSPORT=kernel' | tee /etc/fail2ban/filter.d/fwdrop.local ; fi
    #sed -i 's/pam_permit.so/pam_limits.so/g' /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive
    sed -i 's/session    required.*/session    required   pam_limits.so/g' /etc/pam.d/login /etc/pam.d/common-session*
    if $(! grep -q "session required /lib/security/pam_limits.so" /etc/pam.d/login) ; then echo 'session required /lib/security/pam_limits.so' | tee -a /etc/pam.d/login ; fi
    sed -i 's/#LLMNR=yes/LLMNR=no/g' "$ifdr"/etc/systemd/resolved.conf
    sed -i 's/# SHA_CRYPT_MIN_ROUNDS 5000/SHA_CRYPT_MIN_ROUNDS 5000/g' "$ifdr"/etc/login.defs
    sed -i 's/# SHA_CRYPT_MAX_ROUNDS 5000/SHA_CRYPT_MAX_ROUNDS 50000/g' "$ifdr"/etc/login.defs
    sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' "$ifdr"/etc/sudoers
    chmod 0600 "$ifdr"/etc/hosts.allow
    chmod 0600 "$ifdr"/etc/hosts.deny ; chmod 0750 /home/* ; umask 0022 ; fi
    if $(! grep -q rngd "$ifdr"/etc/modules) ; then
    sed -i -r '/^fscache?/D' "$ifdr"/etc/modules
cat <<EOL>> "$ifdr"/etc/modules
jitterentropy-rngd
rngd
urngd
haveged
acpi_cpufreq
cpufreq_performance
#msr
processor
lz4
lz4_compress
#kvm
#fsache
EOL
if $(! grep -q lz4_compress /etc/initramfs-tools/modules) ; then
echo lz4 >> /etc/initramfs-tools/modules
echo lz4_compress >> /etc/initramfs-tools/modules ; fi
fi
        #sed -i 's/CONCURRENCY="none"/CONCURRENCY="makefile"/g' "$ifdr"/etc/init.d/rc
        # prevent bruteforce
 iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 60 \
 --hitcount 4 --rttl -j DROP
  iptables -A INPUT -p tcp --dport 23 -m recent --update --seconds 60 \
 --hitcount 4 --rttl -j DROP

if $arch ; then
mkdir -p /etc/pacman.d
echo '[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = '"$(which systemctl)"' restart systemd-boot-update.service' | tee /etc/pacman.d/hooks/95-systemd-boot.hook
fi

if [ $level = high ] ; then 
sysctl kernel.split_lock_mitigate=0
fi
    #scsiblack=$(if [ $scsi = off ] ; then
    #echo 'scsi_mod
#scsi_common
#sd_mod' ; fi)
    #cecblack=$(if [ $cec = off ] ; then echo "cec" ; fi)
sed -i 's/user_readenv=0/user_readenv=1/g' /etc/pam.d/polkit-1
if $(! grep -q /etc/environment /etc/pam.d/sddm) ; then echo exists ; else echo 'session       required   pam_env.so readenv=1 envfile=/etc/environment user_readenv=1' | tee -a /etc/pam.d/sddm ; fi



#echo 'udev_log="emergency"' /etc/udev/udev.conf

    sysctl -w vm.min_free_order_shift=4
    sysctl -w kernel.msgmni=32000
    sysctl -w kernel.msgmax=8192
    sysctl -w kernel.msgmnb=16384
    sysctl -w kernel.sem='250 32000 100 128'
    echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
    #echo "64" > /sys/kernel/mm/ksm/pages_to_scan
    #echo "500" > /sys/kernel/mm/ksm/sleep_millisecs

    #if $(! grep -q fscache /etc/initramfs-tools/modules) ; then
    #echo cachefiles >> /etc/initramfs-tools/modules
    #echo fscache >> /etc/initramfs-tools/modules
    #systemctl start --now cachefilesd
    #systemctl enable --now cachefilesd ; fi
    #sed -i 's/#RUN=.*/RUN=yes/g' /etc/default/cachefilesd
    if $(! grep -q jitterentropy /etc/initramfs-tools/modules) ; then
    echo jitterentropy-rngd >> /etc/initramfs-tools/modules
    echo haveged >> /etc/initramfs-tools/modules
    #echo kvm >> /etc/initramfs-tools/modules
    #echo msr >> /etc/initramfs-tools/modules
    echo acpi_cpufreq >> /etc/initramfs-tools/modules
    echo cpufreq_performance >> /etc/initramfs-tools/modules
    echo processor >> /etc/initramfs-tools/modules ; fi
    if dmesg | grep -q amdgpu && ! grep -q amdgpu /etc/initramfs-tools/modules ; then
    echo amdgpu >> /etc/initramfs-tools/modules ; elif dmesg | "$( ! grep -q amdgpu )" ; then sed -i 's/amdgpu//g' /etc/initramfs-tools/modules ; fi

    sed -i 's/managed=.*/managed=true/g' /etc/NetworkManager/NetworkManager.conf




    chmod 0655 /sys/module/*/parameters/*
    chown root /sys/module/*/parameters/*

echo 0 > /sys/module/ext4/parameters/mballoc_debug
echo Y > /sys/kernel/debug/ufshcd0/reset_controller
echo 150 > /sys/module/cpu_boost/parameters/min_input_interval
echo Y > /sys/module/cpu_boost/parameters/input_boost_enabled
echo Y > /sys/kernel/cpu_input_boost/enabled
echo 50 > /sys/devices/platform/kgsl/msm_kgsl/kgsl-3d0/io_fraction
echo Y > /sys/class/kgsl/kgsl-3d0/popp
echo 64 > /sys/class/kgsl/kgsl-3d0/idle_timer
echo N > /sys/class/kgsl/kgsl-3d0/throttling
echo N > /sys/module/mali/parameters/mali_debug_level
echo 250 > /sys/module/mali/parameters/mali_gpu_utilization_timeout
echo Y > /proc/mali/dvfs_enable
#echo 56 > /d/mdss_panel_fb0/intf0/min_refresh_rate
echo N > /sys/module/mmc_core/parameters/crc # check if theres support
echo N > /sys/module/mmc_core/parameters/removable
echo N > /sys/module/mmc_core/parameters/use_spi_crc
echo N > /sys/module/mmc_core/parameters/removable
echo 8192 > /sys/block/zram0/queue/read_ahead_kb
echo N > /sys/kernel/sched/gentle_fair_sleepers
echo Y > /sys/kernel/sched/arch_power
echo Y > /proc/sys/vm/highmem_is_dirtyable
echo N > /proc/sys/vm/compact_memory
echo Y > /proc/sys/vm/compact_unevictable_allowed
echo N > /proc/sys/kernel/softlockup_panic
echo N > /proc/sys/kernel/panic_on_oops
echo 3 > /sys/kernel/power_suspend/power_suspend_mode
echo 15000 > /sys/power/pm_freeze_timeout
#echo 5 > /proc/sys/kernel/sched_walt_init_task_load_pct
echo N > /proc/sys/kernel/sched_walt_rotate_big_tasks
echo 0 > /proc/sys/kernel/sched_tunable_scaling
if [ -f $droidprop ] ; then
echo Y > /proc/sys/kernel/sched_enable_power_aware ; echo Y > /proc/sys/kernel/power_aware_timer_migration ; else echo N > /proc/sys/kernel/sched_enable_power_aware ; echo N > /proc/sys/kernel/power_aware_timer_migration ; fi
echo N > /proc/sys/kernel/sched_smt_power_savings
echo N > /proc/sys/kernel/sched_mc_power_savings
echo 0 > /proc/sys/kernel/sched_ravg_hist_size
echo N > /proc/sys/kernel/sched_enable_thread_grouping
#echo N > /sys/module/msm_thermal/core_control/enabled
echo Y > /sys/module/msm_thermal/core_control/parameters/enabled
echo 10 > /sys/class/thermal/thermal_message/sconfig
echo Y > /sys/module/lowmemorykiller/parameters/lmk_fast_run
echo Y > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo Y > /sys/module/lowmemorykiller/parameters/oom_reaper
#echo 5000 > /sys/kernel/mm/uksm/sleep_millisecs
#echo 128 > /sys/kernel/mm/uksm/pages_to_scan
#echo Y > /sys/kernel/mm/uksm/deferred_timer
echo $ksm > /sys/kernel/mm/uksm/run
#echo 5000 > /sys/kernel/mm/ksm/sleep_millisecs
#echo 128 > /sys/kernel/mm/ksm/pages_to_scan
#echo Y > /sys/kernel/mm/ksm/deferred_timer
echo N > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_cmd
echo N > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_ctxt
echo N > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_drv
echo N > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_mem
echo N > /sys/kernel/debug/kgsl/kgsl-3d0/log_level_pwr




 echo "0" > /sys/devices/system/cpu/sched_mc_power_savings;
 echo "1024" > /dev/cpuctl/cpu.shares
 echo -1 > /dev/cpuctl/cpu.rt_runtime_us
 echo -1 > /dev/cpuctl/cpu.rt_period_us
 echo "62" > /dev/cpuctl/bg_non_interactive/cpu.shares
 echo -1 > /dev/cpuctl/bg_non_interactive/cpu.rt_runtime_us
 echo -1 > /dev/cpuctl/bg_non_interactive/cpu.rt_period_us
 echo "1" > /sys/fs/selinux/enforce
 echo "64" > /sys/module/lowmemorykiller/parameters/cost
 echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active
 echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
 echo "1" > /sys/kernel/fast_charge/force_fast_charge
 echo "1" > /sys/module/tpd_setting/parameters/tpd_mode
#echo "63" > /sys/module/hid_magicmouse/parameters/scroll_speed


echo "0-3, 6-$(nproc -all)" > /dev/cpuset/camera-daemon/cpus
echo "0-$(nproc -all)" > /dev/cpuset/top-app/cpus
echo "0-$(nproc -all)" /dev/cpuset/foreground/cpus
echo "0" > /dev/cpuset/restricted/cpus
#echo "0-7" /dev/cpuset/background/cpus
#echo "0-7" /dev/cpuset/system-background/cpus
#echo "0-3" > /dev/cpuset/kernel/cpus

echo "N" > /sys/module/workqueue/parameters/power_efficient
echo "Y" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "Y" > /sys/module/lpm_levels/parameters/cluster_use_deepest_state

echo N > /sys/module/lpm_levels/parameters/sleep_disabled
# write /sys/module/lpm_levels/parameters/sleep_disabled "N" 2>/dev/null

echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "64" > /sys/class/drm/card0/device/idle_timeout_ms

#echo 1 > /dev/stune/top-app/schedtune.prefer_idle
#echo 1 > /dev/stune/foreground/schedtune.prefer_idle
#echo 1 > /dev/stune/top-app/schedtune.prefer_idle
#echo 3 > /dev/stune/top-app/schedtune.sched_boost
#echo 1 > /dev/stune/top-app/schedtune.sched_boost_enabled

sysctl -w fs.inotify.max_queued_events=32768
sysctl -w fs.inotify.max_user_instances=256
sysctl -w fs.inotify.max_user_watches=16384
sysctl -w kernel.sched_scaling_enable=1




echo "1" /proc/sys/fs/leases-enable
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time
#echo 1 > /proc/sys/vm/overcommit_memory
#echo 80 > /proc/sys/vm/overcommit_ratio

echo "write through" | sudo tee /sys/block/*/queue/write_cache

#setprop MIN_HIDDEN_APPS false
#setprop ACTIVITY_INACTIVE_RESET_TIME false
#setprop MIN_RECENT_TASKS false
#setprop PROC_START_TIMEOUT false
#setprop CPU_MIN_CHECK_DURATION false
#setprop GC_TIMEOUT false
#setprop SERVICE_TIMEOUT false
#setprop MIN_CRASH_INTERVAL false
#setprop ENFORCE_PROCESS_LIMIT false


########################
#echo 0 > /dev/cpuctl/cgroup.clone_children
#echo 0 > /dev/cpuctl/cgroup.procs
#echo 0 > /dev/cpuctl/cgroup.sane_behavior
#echo 0 > /dev/cpuctl/cpu.rt_period_us
#echo 0 > /dev/cpuctl/cpu.rt_runtime_us
#echo 0 > /dev/cpuctl/cpu.shares
#echo 0 > /dev/cpuctl/notify_on_release
#echo 0 > /dev/cpuctl/release_agent
#echo 0 > /dev/cpuctl/tasks

#echo 0 > /dev/cpuset/cgroup.clone_children
#echo 0 > /dev/cpuset/cgroup.sane_behavior
#echo 0 > /dev/cpuset/notify_on_release

#echo 0 > /dev/stune/background/cgroup.clone_children
#echo 0 > /dev/stune/background/cgroup.procs
#echo 0 > /dev/stune/background/notify_on_release
#echo 0 > /dev/stune/background/schedtune.boost
#echo 0 > /dev/stune/background/schedtune.colocate
#echo 0 > /dev/stune/background/schedtune.prefer_idle
#echo 0 > /dev/stune/background/schedtune.sched_boost
#echo 0 > /dev/stune/background/schedtune.sched_boost_enabled
#echo 0 > /dev/stune/background/schedtune.sched_boost_no_override
#echo 0 > /dev/stune/background/tasks

#echo 0 > /dev/stune/cgroup.clone_children
#echo 0 > /dev/stune/cgroup.procs
#echo 0 > /dev/stune/cgroup.sane_behavior
#echo 0 > /dev/stune/notify_on_release
#echo 0 > /dev/stune/release_agent
#echo 0 > /dev/stune/schedtune.boost
#echo 0 > /dev/stune/schedtune.colocate
#echo 0 > /dev/stune/schedtune.prefer_idle
#echo 0 > /dev/stune/schedtune.sched_boost
#echo 0 > /dev/stune/schedtune.sched_boost_enabled
#echo 0 > /dev/stune/schedtune.sched_boost_no_override
#echo 0 > /dev/stune/tasks

#echo 0 > /dev/stune/foreground/cgroup.clone_children
#echo 0 > /dev/stune/foreground/cgroup.procs
#echo 0 > /dev/stune/foreground/notify_on_release
#echo 0 > /dev/stune/foreground/schedtune.boost
#echo 0 > /dev/stune/foreground/schedtune.colocate
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
#echo 1 > /dev/stune/foreground/schedtune.sched_boost
#echo 0 > /dev/stune/foreground/schedtune.sched_boost_enabled
#echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override
#echo 0 > /dev/stune/foreground/tasks

#echo 0 > /dev/stune/rt/cgroup.clone_children
#echo 0 > /dev/stune/rt/cgroup.procs
#echo 0 > /dev/stune/rt/notify_on_release
#echo 0 > /dev/stune/rt/schedtune.boost
#echo 0 > /dev/stune/rt/schedtune.colocate
#echo 0 > /dev/stune/rt/schedtune.prefer_idle
#echo 0 > /dev/stune/rt/schedtune.sched_boost
#echo 0 > /dev/stune/rt/schedtune.sched_boost_enabled
#echo 0 > /dev/stune/rt/schedtune.sched_boost_no_override
#echo 0 > /dev/stune/rt/tasks

#echo 0 > /dev/stune/top-app/cgroup.clone_children
#echo 0 > /dev/stune/top-app/cgroup.procs
#echo 0 > /dev/stune/top-app/notify_on_release
#echo 0 > /dev/stune/top-app/schedtune.boost
#echo 0 > /dev/stune/top-app/schedtune.colocate
echo 1 > /dev/stune/top-app/schedtune.prefer_idle
echo 3 > /dev/stune/top-app/schedtune.sched_boost
echo 1 > /dev/stune/top-app/schedtune.sched_boost_enabled
#echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override
#echo 0 > /dev/stune/top-app/tasks

sysctl -w kernel.sched_scaling_enable=1
echo 1 > /proc/sys/kernel/sched_scaling_enable
echo 0 > /proc/sys/kernel/sched_tunable_scaling
#echo 0 > /proc/sys/kernel/sched_boost
echo 1 > /proc/sys/kernel/sched_child_runs_first
##echo 2250000 > /proc/sys/kernel/sched_min_granularity_ns
#echo 980000 > /proc/sys/kernel/sched_rt_runtime_us
echo 40000 > /proc/sys/kernel/sched_latency_ns

#echo "0" > /sys/module/cpu_boost/parameters/dynamic_stune_boost
##echo '0:0' > /sys/module/cpu_boost/parameters/input_boost_freq
##echo '0:1324800' > /sys/module/cpu_boost/parameters/input_boost_freq
##echo '1:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
##echo '2:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
##echo '3:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
#echo 0 > /sys/module/cpu_boost/parameters/powerkey_input_boost_freq
echo 1200 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
#echo 0 > /sys/module/cpu_boost/parameters/sched_boost_on_input
#echo 0 > /sys/module/cpu_boost/parameters/shed_boost_on_powerkey_input


if [ $level = high ] ; then 
echo "0" > /sys/module/workqueue/parameters/power_efficient
fi
echo "0" > /sys/devices/system/cpu/cpu*/core_ctl/enable
echo $governor > /sys/devices/system/cpu/cpufreq/policy*/scaling_governor
#echo "1000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
#echo "5000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
##echo "1324800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo "100" > /sys/devices/system/cpu/cpufreq/policy*/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpufreq/policy*/schedutil/pl
echo "1" > /sys/devices/system/cpu/cpufreq/policy*/schedutil/iowait_boost_enable



echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks

##echo "0:300000" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "1:300000" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "2:300000" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "3:300000" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "4:825600" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "5:825600" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "6:825600" > /sys/module/msm_performance/parameters/cpu_min_freq
##echo "7:825600" > /sys/module/msm_performance/parameters/cpu_min_freq

##echo "825600" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
##echo "825600" > /sys/devices/system/cpu/cpu5/cpufreq/scaling_min_freq
##echo "825600" > /sys/devices/system/cpu/cpu6/cpufreq/scaling_min_freq
##echo "825600" > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq
##echo "300000" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
##echo "300000" > /sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq
##echo "300000" > /sys/devices/system/cpu/cpu2/cpufreq/scaling_min_freq
##echo "300000" > /sys/devices/system/cpu/cpu3/cpufreq/scaling_min_freq

#echo "Y" > /sys/module/lpm_levels/L3/cpu*/rail-pc/idle_enabled

#echo "Y" > /sys/module/lpm_levels/L3/l3-wfi/idle_enabled
#echo "Y" > /sys/module/lpm_levels/L3/llcc-off/idle_enabled

#echo "Y" > /sys/module/lpm_levels/L3/cpu*/pc/idle_enabled

echo "Y" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "Y" > /sys/module/lpm_levels/parameters/cluster_use_deepest_state

# write /sys/module/lpm_levels/parameters/sleep_disabled "N" 2>/dev/null

echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled

if [ $level = high ] ; then 
sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0
fi
chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
#echo "710000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
#echo "710000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
#echo "0" > /sys/class/kgsl/kgsl-3d0/max_pwrlvl
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on_enabled
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on_enabled
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "64" > /sys/class/drm/card0/device/idle_timeout_ms

########################
#echo "1" > /proc/sys/vm/overcommit_memory
#echo "0" > /proc/sys/vm/oom_dump_tasks
#echo "0" /proc/sys/vm/overcommit_ratio
echo "1" > /proc/sys/vm/compact_unevictable_allowed
#echo "40" > /proc/sys/vm/dirty_background_ratio
#echo "500" > /proc/sys/vm/dirty_expire_centisecs
#echo "50" > /proc/sys/vm/dirty_ratio
#echo "3000" > /proc/sys/vm/dirty_writeback_centisecs

echo "1" > /proc/sys/vm/oom_kill_allocating_task
#echo "1200" > /proc/sys/vm/stat_interval
#echo "0" > /proc/sys/vm/swap_ratio

echo "512" > /proc/sys/kernel/random/read_wakeup_threshold
echo "90" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "1024" > /proc/sys/kernel/random/write_wakeup_threshold

sysctl -e -w kernel.random.read_wakeup_threshold=512
sysctl -e -w kernel.random.write_wakeup_threshold=1024
sysctl -e -w kernel.random.urandom_min_reseed_secs=90

chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree

echo 1 > /proc/sys/kernel/sched_scaling_enable
echo 0 > /proc/sys/kernel/sched_tunable_scaling
#echo 0 > /proc/sys/kernel/sched_boost
echo 1 > /proc/sys/kernel/sched_child_runs_first
#echo 2250000 > /proc/sys/kernel/sched_min_granularity_ns
#echo 980000 > /proc/sys/kernel/sched_rt_runtime_us
echo 40000 > /proc/sys/kernel/sched_latency_ns
#echo '0:1324800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '1:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '2:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '3:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1200 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms


echo "Y" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "Y" > /sys/module/lpm_levels/parameters/cluster_use_deepest_state


echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled

sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0


chmod 0664 /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
#echo "710000000" > /sys/class/kgsl/kgsl-3d0/devfreq/max_freq
#echo "710000000" > /sys/class/kgsl/kgsl-3d0/max_gpuclk
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on
#echo "0" > /sys/class/kgsl/kgsl-3d0/max_pwrlvl
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on_enabled
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_rail_on_enabled
#echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "64" > /sys/class/drm/card0/device/idle_timeout_ms

chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree

echo "1" > /sys/kernel/fast_charge/force_fast_charge

echo "1" > /sys/kernel/sound_control/mic_gain

echo "1" > /proc/sys/dev/cnss/randomize_mac

#echo "mem" > /sys/power/autosleep

echo "deep" > /sys/power/mem_sleep

if [ $level = high ] ; then 
echo "10" > /sys/class/thermal/thermal_message/sconfig
fi
echo "0-3, 6-$(nproc -all)" > /dev/cpuset/camera-daemon/cpus
echo "0-$(nproc -all)" > /dev/cpuset/top-app/cpus
echo "0-$(nproc -all)" /dev/cpuset/foreground/cpus
echo "0" > /dev/cpuset/restricted/cpus
echo "0" > /sys/module/workqueue/parameters/power_efficient
echo "Y" > /sys/module/lpm_levels/parameters/lpm_prediction
echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "Y" > /sys/module/lpm_levels/parameters/cluster_use_deepest_state
echo N /sys/module/lpm_levels/parameters/sleep_disabled
echo "N" > /sys/module/lpm_levels/parameters/sleep_disabled
echo "0" > /sys/class/kgsl/kgsl-3d0/bus_split
echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo "64" > /sys/class/drm/card0/device/idle_timeout_ms

########################
echo userspace > /sys/class/devfreq/soc:qcom,l3-cdsp/governor
for cpubw in /sys/class/devfreq/*qcom,cpubw*
do
    echo "bw_hwmon" > $cpubw/governor
    echo 50 > $cpubw/polling_interval
    echo "2288 4577 6500 8132 9155 10681" > $cpubw/bw_hwmon/mbps_zones
    echo 4 > $cpubw/bw_hwmon/sample_ms
    echo 50 > $cpubw/bw_hwmon/io_percent
    echo 20 > $cpubw/bw_hwmon/hist_memory
    echo 10 > $cpubw/bw_hwmon/hyst_length
    echo 0 > $cpubw/bw_hwmon/guard_band_mbps
    echo 250 > $cpubw/bw_hwmon/up_scale
    echo 1600 > $cpubw/bw_hwmon/idle_mbps
done
for llccbw in /sys/class/devfreq/*qcom,llccbw*
do
    echo "bw_hwmon" > $llccbw/governor
    echo 50 > $llccbw/polling_interval
    echo "1720 2929 3879 5931 6881" > $llccbw/bw_hwmon/mbps_zones
    echo 4 > $llccbw/bw_hwmon/sample_ms
    echo 80 > $llccbw/bw_hwmon/io_percent
    echo 20 > $llccbw/bw_hwmon/hist_memory
    echo 10 > $llccbw/bw_hwmon/hyst_length
    echo 0 > $llccbw/bw_hwmon/guard_band_mbps
    echo 250 > $llccbw/bw_hwmon/up_scale
    echo 1600 > $llccbw/bw_hwmon/idle_mbps
done
for memlat in /sys/class/devfreq/*qcom,memlat-cpu*
do
    echo "mem_latency" > $memlat/governor
    echo 10 > $memlat/polling_interval
    echo 400 > $memlat/mem_latency/ratio_ceil
done
for memlat in /sys/class/devfreq/*qcom,l3-cpu*
do
    echo "mem_latency" > $memlat/governor
    echo 10 > $memlat/polling_interval
    echo 400 > $memlat/mem_latency/ratio_ceil
done
for l3cdsp in /sys/class/devfreq/*qcom,l3-cdsp*
do
    echo "userspace" > $l3cdsp/governor
    chown -h system $l3cdsp/userspace/set_freq
done
echo 4000 > /sys/class/devfreq/soc:qcom,l3-cpu4/mem_latency/ratio_ceil
echo "compute" > /sys/class/devfreq/soc:qcom,mincpubw/governor
echo 10 > /sys/class/devfreq/soc:qcom,mincpubw/polling_interval

chmod 0644 /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker
echo "898000.qcom,qup_uart;IPA_WS;NETLINK;[timerfd];c440000.qcom,spmi:qcom,pmi8998@2:qcom,qpnp-smb2;enable_ipa_ws;enable_netlink_ws;enable_netmgr_wl_ws;enable_qcom_rx_wakelock_ws;enable_timerfd_ws;enable_wlan_etscan_wl_ws;enable_wlan_wow_wl_ws;enable_wlan_ws;hal_bluetooth_lock;netmgr_wl;qcom_rx_wakelock;sensor_ind;wcnss_filtr_lock;wlan;wlan_extscan_wl;wlan_ipa;wlan_pno_wl;wlan_wow_wl;wcnss_filter_lock" > /sys/class/misc/boeffla_wakelock_blocker/wakelock_blocker
echo 8 > /sys/module/bcmdhd/parameters/wlrx_divide
echo 8 > /sys/module/bcmdhd/parameters/wlctrl_divide
echo Y > /sys/module/wakeup/parameters/enable_bluetooth_timer
echo N > /sys/module/wakeup/parameters/enable_wlan_ipa_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_pno_wl_ws
echo N > /sys/module/wakeup/parameters/enable_wcnss_filter_lock_ws
echo N > /sys/module/wakeup/parameters/wlan_wake
echo N > /sys/module/wakeup/parameters/wlan_ctrl_wake
echo N > /sys/module/wakeup/parameters/wlan_rx_wake
echo N > /sys/module/wakeup/parameters/enable_msm_hsic_ws
echo N > /sys/module/wakeup/parameters/enable_si_ws
echo N > /sys/module/wakeup/parameters/enable_si_ws
echo N > /sys/module/wakeup/parameters/enable_bluedroid_timer_ws
echo N > /sys/module/wakeup/parameters/enable_ipa_ws
echo N > /sys/module/wakeup/parameters/enable_netlink_ws
echo N > /sys/module/wakeup/parameters/enable_netmgr_wl_ws
echo N > /sys/module/wakeup/parameters/enable_qcom_rx_wakelock_ws
echo N > /sys/module/wakeup/parameters/enable_timerfd_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_extscan_wl_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_rx_wake_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_wake_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_wow_wl_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_ws
echo N > /sys/module/wakeup/parameters/enable_wlan_ctrl_wake_ws

#if [ -f $droidprop ] ; then
#su -c "pm enable com.google.android.gms"
#su -c "pm enable com.google.android.gsf"
#su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
#su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
#su -c "pm enable com.google.android.gms/.update.SystemUpdateServiceActiveReceiver"
#su -c "pm enable com.google.android.gms/.update.SystemUpdateServiceReceiver"
#su -c "pm enable com.google.android.gms/.update.SystemUpdateServiceSecretCodeReceiver"
#su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
#su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
#su -c "pm enable com.google.android.gsf/.update.SystemUpdateService" ; fi

#echo 0 > /sys/module/binder/parameters/debug_mask
echo Y > /sys/module/bluetooth/parameters/disable_ertm
echo Y > /sys/module/bluetooth/parameters/disable_esco
echo 0 > /sys/module/debug/parameters/enable_event_log
echo 0 > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo 0 > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ce
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ue
#echo 0 > /sys/module/glink/parameters/debug_mask
echo N > /sys/module/hid_magicmouse/parameters/emulate_3button
echo N > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo 0 > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo 0 > /sys/module/mdss_fb/parameters/backlight_dimmer
#echo 0 > /sys/module/msm_show_resume_irq/parameters/debug_mask
#echo 0 > /sys/module/msm_smd/parameters/debug_mask
#echo 0 > /sys/module/msm_smem/parameters/debug_mask
echo N > /sys/module/otg_wakelock/parameters/enabled
echo 0 > /sys/module/service_locator/parameters/enable
echo N > /sys/module/sit/parameters/log_ecn_error
echo 0 > /sys/module/smem_log/parameters/log_enable
#echo 0 > /sys/module/smp2p/parameters/debug_mask
echo Y > /sys/module/sync/parameters/fsync_enabled
#echo 0 > /sys/module/touch_core_base/parameters/debug_mask
echo 0 > /sys/module/usb_bam/parameters/enable_event_log
echo Y > /sys/module/printk/parameters/console_suspend
#echo 0 > /sys/module/wakelock/parameters/debug_mask
#echo 0 > /sys/module/userwakelock/parameters/debug_mask
#echo 0 > /sys/module/earlysuspend/parameters/debug_mask
#echo 0 > /sys/module/alarm/parameters/debug_mask
#echo 0 > /sys/module/alarm_dev/parameters/debug_mask
#echo 0 > /sys/module/binder/parameters/debug_mask
echo 0 > /sys/devices/system/edac/cpu/log_ce
echo 0 > /sys/devices/system/edac/cpu/log_ue


#for i in $( find /sys/ -name debug_mask) ; do
 echo 0 > $i
#done
if [ $level = high ] ; then 
if [ -e /sys/module/logger/parameters/log_mode ] ; then
 echo $loglevel > /sys/module/logger/parameters/log_mode
fi
fi
echo 1 > /sys/devices/platform/soc/$(getprop ro.boot.bootdevice)/ufstw_lu0/tw_enable
echo 0 > /sys/module/mmc_core/parameters/use_spi_crc
#settings put global device_idle_constants light_after_inactive_to=5000,light_pre_idle_to=10000,light_max_idle_to=86400000,light_idle_to=43200000,light_idle_maintenance_max_budget=20000,light_idle_maintenance_min_budget=5000,min_time_to_alarm=60000,inactive_to=120000,motion_inactive_to=120000,idle_after_inactive_to=5000,locating_to=2000,sensing_to=120000,idle_to=7200000,wait_for_unlock=true


#adb -d shell pm grant org.kde.kdeconnect_tp android.permission.READ_LOGS;
##adb -d shell appops set org.kde.kdeconnect_tp SYSTEM_ALERT_WINDOW allow;
##adb -d shell am force-stop org.kde.kdeconnect_tp;


# above from old android scripts, need to sort all and put correct values thats why i left them up here for now.






if [ $level = high ] ; then 



  ### < START PARAMETER CONFIG >
##########################################################################################################
# legacy dump from 3.x kernel for compatibility
# command for you: grep -H '' $(ls /sys/module/*/parameters/*) | sed 's/:/ /g' | awk '{print "echo",  $2, ">", $1}'
echo N > /sys/module/cfg80211/parameters/cfg80211_disable_40mhz_24ghz
echo $country > /sys/module/cfg80211/parameters/ieee80211_regdom
echo 0 > /sys/module/dns_resolver/parameters/debug
echo 0 > /sys/module/dsscomp/parameters/debug
echo 0 > /sys/module/ehci_hcd/parameters/log2_irq_thresh
echo 0 > /sys/module/hid/parameters/debug
echo null > /sys/module/hid_prodikeys/parameters/id
echo $( if [ $ipv6 = on ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/autoconf
echo $( if [ $ipv6 = off ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/disable
echo $( if [ $ipv6 = off ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/disable_ipv6
echo N > /sys/module/kernel/parameters/initcall_debug
echo 0 > /sys/module/kernel/parameters/panic
echo 0 > /sys/module/kernel/parameters/pause_on_oops
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo N > /sys/module/nf_conntrack/parameters/acct
echo N > /sys/module/otg_wakelock/parameters/enabled
echo N > /sys/module/pl2303/parameters/debug
echo 0 > /sys/module/pvrsrvkm/parameters/gPVRDebugLevel
echo 0 > /sys/module/scsi_mod/parameters/scsi_logging_level
echo Y > /sys/module/snd_usb_audio/parameters/ignore_ctl_error
echo Y > /sys/module/spurious/parameters/noirqdebug
#echo 0 > /sys/module/usbhid/parameters/mousepoll
echo N > /sys/module/usbserial/parameters/debug





### kernel 6.x underneath
# systunedump --all | sed 's/:/ /g' | awk '{print "echo "$2" > "$1}' > text
# just dumped this still needs editing
echo 120 > /sys/fs/f2fs/*/cp_interval
echo 20 > /sys/fs/f2fs/*/ram_thresh
echo 0 > proc/sys/vm/block_dump
echo 0 > /sys/module/ext4/parameters/mballoc_debug
echo 0 > /proc/sys/abi/vsyscall32
echo 0 > /proc/sys/debug/exception-trace
echo 1 > /proc/sys/debug/kprobes-optimization
echo 0 > /proc/sys/dev/scsi/logging_level
echo 1 > /proc/sys/dev/tty/ldisc_autoload
echo 1048576 > /proc/sys/fs/aio-max-nr
#echo enabled > /proc/sys/fs/binfmt_misc/status
echo 0 > /proc/sys/fs/dir-notify-enable
echo 435556 > /proc/sys/fs/epoll/max_user_watches
echo 16384 > /proc/sys/fs/fanotify/max_queued_events
echo 128 > /proc/sys/fs/fanotify/max_user_groups
echo 15849 > /proc/sys/fs/fanotify/max_user_marks
echo 2097152 > /proc/sys/fs/file-max
echo 16384 > /proc/sys/fs/inotify/max_queued_events
echo 128 > /proc/sys/fs/inotify/max_user_instances
echo 14905 > /proc/sys/fs/inotify/max_user_watches
echo 20 > /proc/sys/fs/lease-break-time
echo 1 > /proc/sys/fs/leases-enable
echo 100000 > /proc/sys/fs/mount-max
echo 10 > /proc/sys/fs/mqueue/msg_default
echo 10 > /proc/sys/fs/mqueue/msg_max
echo 8192 > /proc/sys/fs/mqueue/msgsize_default
echo 8192 > /proc/sys/fs/mqueue/msgsize_max
echo 256 > /proc/sys/fs/mqueue/queues_max
echo 1048576 > /proc/sys/fs/nr_open
echo 1048576 > /proc/sys/fs/pipe-max-size
echo 0 > /proc/sys/fs/pipe-user-pages-hard
echo 16384 > /proc/sys/fs/pipe-user-pages-soft
echo 1 > /proc/sys/fs/protected_fifos
echo 1 > /proc/sys/fs/protected_hardlinks
echo 2 > /proc/sys/fs/protected_regular
echo 1 > /proc/sys/fs/protected_symlinks
echo 1 > /proc/sys/fs/quota/warnings
echo 0 > /proc/sys/fs/suid_dumpable
echo 0 > /proc/sys/fs/verity/require_signatures
echo 0 > /proc/sys/fs/xfs/error_level
echo 30000 > /proc/sys/fs/xfs/filestream_centisecs
echo 1 > /proc/sys/fs/xfs/inherit_noatime
echo 0 > /proc/sys/fs/xfs/inherit_nodefrag
echo 1 > /proc/sys/fs/xfs/inherit_nodump
echo 0 > /proc/sys/fs/xfs/inherit_nosymlinks
echo 1 > /proc/sys/fs/xfs/inherit_sync
echo 0 > /proc/sys/fs/xfs/irix_sgid_inherit
echo 0 > /proc/sys/fs/xfs/irix_symlink_mode
echo 0 > /proc/sys/fs/xfs/panic_mask
echo 1 > /proc/sys/fs/xfs/rotorstep
echo 300 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
echo 300 > /proc/sys/fs/xfs/speculative_prealloc_lifetime
echo 0 > /proc/sys/fs/xfs/stats_clear
echo 30000 > /proc/sys/fs/xfs/xfssyncd_centisecs
echo 4 > /proc/sys/kernel/acct
echo 0 > /proc/sys/kernel/acpi_video_flags
echo 0 > /proc/sys/kernel/apparmor_display_secid_mode
echo 0 > /proc/sys/kernel/auto_msgmni
echo 0 > /proc/sys/kernel/bpf_stats_enabled
echo 1 > /proc/sys/kernel/cad_pid
if [ $loglevel = 0 ] ; then 
echo |/bin/false > /proc/sys/kernel/core_pattern 
fi
echo 0 > /proc/sys/kernel/core_pipe_limit
echo 1 > /proc/sys/kernel/core_uses_pid
#echo 0 > /proc/sys/kernel/ctrl-alt-del
echo 1 > /proc/sys/kernel/dmesg_restrict
echo none > /proc/sys/kernel/domainname
echo 0 > /proc/sys/kernel/firmware_config/force_sysfs_fallback
echo 0 > /proc/sys/kernel/firmware_config/ignore_sysfs_fallback
echo 0 > /proc/sys/kernel/ftrace_dump_on_oops
echo 0 > /proc/sys/kernel/ftrace_enabled
echo 0 > /proc/sys/kernel/hardlockup_all_cpu_backtrace
echo 0 > /proc/sys/kernel/hardlockup_panic
echo 0 > /proc/sys/kernel/hung_task_all_cpu_backtrace
echo 4194304 > /proc/sys/kernel/hung_task_check_count
echo 0 > /proc/sys/kernel/hung_task_check_interval_secs
echo 0 > /proc/sys/kernel/hung_task_panic
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
echo 10 > /proc/sys/kernel/hung_task_warnings
echo 3 > /proc/sys/kernel/io_delay_type
echo 0 > /proc/sys/kernel/kexec_load_disabled
echo 300 > /proc/sys/kernel/keys/gc_delay
echo 20000 > /proc/sys/kernel/keys/maxbytes
echo 200 > /proc/sys/kernel/keys/maxkeys
echo 259200 > /proc/sys/kernel/keys/persistent_keyring_expiry
echo 25000000 > /proc/sys/kernel/keys/root_maxbytes
echo 1000000 > /proc/sys/kernel/keys/root_maxkeys
echo 0 > /proc/sys/kernel/kptr_restrict
echo 1024 > /proc/sys/kernel/max_lock_depth
echo 0 > /proc/sys/kernel/max_rcu_stall_to_panic
#echo /sbin/modprobe > /proc/sys/kernel/modprobe
echo 0 > /proc/sys/kernel/modules_disabled
echo 8192 > /proc/sys/kernel/msgmax
echo 16384 > /proc/sys/kernel/msgmnb
echo 32000 > /proc/sys/kernel/msgmni
echo 0 > /proc/sys/kernel/nmi_watchdog
echo 44389 > /proc/sys/kernel/ns_last_pid
echo 0 > /proc/sys/kernel/numa_balancing
#echo 65536 > /proc/sys/kernel/numa_balancing_promote_rate_limit_MBps
echo 0 > /proc/sys/kernel/oops_all_cpu_backtrace
echo 65534 > /proc/sys/kernel/overflowgid
echo 65534 > /proc/sys/kernel/overflowuid
echo 0 > /proc/sys/kernel/panic
echo 0 > /proc/sys/kernel/panic_on_io_nmi
echo 0 > /proc/sys/kernel/panic_on_oops
echo 0 > /proc/sys/kernel/panic_on_rcu_stall
echo 0 > /proc/sys/kernel/panic_on_unrecovered_nmi
echo 0 > /proc/sys/kernel/panic_on_warn
echo 0 > /proc/sys/kernel/panic_print
echo 10 > /proc/sys/kernel/perf_cpu_time_max_percent
echo 8 > /proc/sys/kernel/perf_event_max_contexts_per_stack
echo 100000 > /proc/sys/kernel/perf_event_max_sample_rate
echo 127 > /proc/sys/kernel/perf_event_max_stack
echo 516 > /proc/sys/kernel/perf_event_mlock_kb
echo -1 > /proc/sys/kernel/perf_event_paranoid
echo 4194304 > /proc/sys/kernel/pid_max
#echo /sbin/poweroff > /proc/sys/kernel/poweroff_cmd
echo 0 > /proc/sys/kernel/print-fatal-signals
echo 0 > /proc/sys/kernel/printk
echo 0 > /proc/sys/kernel/printk_delay
echo off > /proc/sys/kernel/printk_devkmsg
echo 5 > /proc/sys/kernel/printk_ratelimit
echo 10 > /proc/sys/kernel/printk_ratelimit_burst
echo 4096 > /proc/sys/kernel/pty/max
echo 1024 > /proc/sys/kernel/pty/reserve
echo 60 > /proc/sys/kernel/random/urandom_min_reseed_secs
echo 256 > /proc/sys/kernel/random/write_wakeup_threshold
echo $ranvasp > /proc/sys/kernel/randomize_va_space
echo 0 > /proc/sys/kernel/real-root-dev
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
echo 500 > /proc/sys/kernel/sched_cfs_bandwidth_slice_us
echo 1 > /proc/sys/kernel/sched_child_runs_first
echo 500000 > /proc/sys/kernel/sched_deadline_period_max_us
echo 100 > /proc/sys/kernel/sched_deadline_period_min_us
echo 0 > /proc/sys/kernel/sched_energy_aware
echo -1 > /proc/sys/kernel/sched_rr_timeslice_ms
echo -1 > /proc/sys/kernel/sched_rt_period_us
echo -1 > /proc/sys/kernel/sched_rt_runtime_us
echo 0 > /proc/sys/kernel/sched_schedstats
echo NONE > /proc/sys/kernel/seccomp/actions_logged
echo 32000 > /proc/sys/kernel/sem
echo 0 > /proc/sys/kernel/shm_rmid_forced
#echo 350000000 > /proc/sys/kernel/shmall
#echo 1000000000 > /proc/sys/kernel/shmmax
#echo 4096 > /proc/sys/kernel/shmmni
echo 0 > /proc/sys/kernel/soft_watchdog
echo 0 > /proc/sys/kernel/softlockup_all_cpu_backtrace
echo 0 > /proc/sys/kernel/softlockup_panic
echo 0 > /proc/sys/kernel/stack_tracer_enabled
echo 1 > /proc/sys/kernel/sysctl_writes_strict
echo 0 > /proc/sys/kernel/sysrq
echo 0 > /proc/sys/kernel/tainted
echo 0 > /proc/sys/kernel/task_delayacct
echo 12800 > /proc/sys/kernel/threads-max
echo 0 > /proc/sys/kernel/timer_migration
echo 0 > /proc/sys/kernel/traceoff_on_warning
echo 0 > /proc/sys/kernel/tracepoint_printk
echo 0 > /proc/sys/kernel/unknown_nmi_panic
echo 2 > /proc/sys/kernel/unprivileged_bpf_disabled
echo 1 > /proc/sys/kernel/unprivileged_userns_apparmor_policy
echo 1 > /proc/sys/kernel/unprivileged_userns_clone
echo 4294967295 > /proc/sys/kernel/usermodehelper/bset
echo 4294967295 > /proc/sys/kernel/usermodehelper/inheritable
echo 0 > /proc/sys/kernel/watchdog
echo 0 > /proc/sys/kernel/watchdog_cpumask
echo 60 > /proc/sys/kernel/watchdog_thresh
echo 0 > /proc/sys/kernel/yama/ptrace_scope
echo 8192 > /proc/sys/vm/admin_reserve_kbytes
echo 1 > /proc/sys/vm/compact_unevictable_allowed
echo 0 > /proc/sys/vm/compaction_proactiveness
#echo 0 > /proc/sys/vm/dirty_background_bytes
echo 40 > /proc/sys/vm/dirty_background_ratio
#echo 0 > /proc/sys/vm/dirty_bytes
echo 500 > /proc/sys/vm/dirty_expire_centisecs
echo 50 > /proc/sys/vm/dirty_ratio
echo 1000 > /proc/sys/vm/dirty_writeback_centisecs
echo 43200 > /proc/sys/vm/dirtytime_expire_seconds
echo 750 > /proc/sys/vm/extfrag_threshold
echo 1 > /proc/sys/vm/hugetlb_optimize_vmemmap
echo 1 > /proc/sys/vm/hugetlb_shm_group
echo 0 > /proc/sys/vm/laptop_mode
echo 0 > /proc/sys/vm/legacy_va_layout
echo 8 > /proc/sys/vm/lowmem_reserve_ratio
echo 1600000 > /proc/sys/vm/max_map_count
echo 1 > /proc/sys/vm/memory_failure_early_kill
echo 1 > /proc/sys/vm/memory_failure_recovery
echo 45056 > /proc/sys/vm/min_free_kbytes
echo 30 > /proc/sys/vm/min_slab_ratio
echo 1 > /proc/sys/vm/min_unmapped_ratio
echo 65536 > /proc/sys/vm/mmap_min_addr
echo 28 > /proc/sys/vm/mmap_rnd_bits
echo 8 > /proc/sys/vm/mmap_rnd_compat_bits
#echo 32 > /proc/sys/vm/nr_hugepages
#echo 32 > /proc/sys/vm/nr_hugepages_mempolicy
echo $hoverc > /proc/sys/vm/nr_overcommit_hugepages
echo 0 > /proc/sys/vm/numa_stat
echo Node > /proc/sys/vm/numa_zonelist_order
echo 1 > /proc/sys/vm/oom_dump_tasks
echo 1 > /proc/sys/vm/oom_kill_allocating_task
#echo 0 > /proc/sys/vm/overcommit_kbytes
echo $overcommit > /proc/sys/vm/overcommit_memory
echo $oratio > /proc/sys/vm/overcommit_ratio
echo $pagec > /proc/sys/vm/page-cluster
echo 1 > /proc/sys/vm/pagecache
echo 1 > /proc/sys/vm/page_lock_unfairness
echo 0 > /proc/sys/vm/panic_on_oom
echo 0 > /proc/sys/vm/percpu_pagelist_high_fraction
echo 60 > /proc/sys/vm/stat_interval
echo $swappiness > /proc/sys/vm/swappiness
echo 0 > /proc/sys/vm/unprivileged_userfaultfd
echo 60896 > /proc/sys/vm/user_reserve_kbytes
echo $cpress > /proc/sys/vm/vfs_cache_pressure
echo 15000 > /proc/sys/vm/watermark_boost_factor
echo 200 > /proc/sys/vm/watermark_scale_factor
echo 0 > /proc/sys/vm/zone_reclaim_mode










## ❯ grep -H '' /sys/module/*/parameters/*  | sed 's/:/ /g' | awk '{print "echo " $2, "> " $1}' > txt
echo 1 > /sys/module/8250/parameters/nr_uarts
echo 1 > /sys/module/8250/parameters/share_irqs
echo 1 > /sys/module/8250/parameters/skip_txen_test
echo 0 > /sys/module/acpi_cpufreq/parameters/acpi_pstate_strict
echo 0 > /sys/module/acpi/parameters/aml_debug_output
echo N > /sys/module/acpi/parameters/ec_busy_polling
echo 500 > /sys/module/acpi/parameters/ec_delay
echo query > /sys/module/acpi/parameters/ec_event_clearing
echo N > /sys/module/acpi/parameters/ec_freeze_events
echo 16 > /sys/module/acpi/parameters/ec_max_queries
echo N > /sys/module/acpi/parameters/ec_no_wakeup
echo 550 > /sys/module/acpi/parameters/ec_polling_guard
echo 8 > /sys/module/acpi/parameters/ec_storm_threshold
echo Y > /sys/module/acpi/parameters/immediate_undock
echo N > /sys/module/acpi/parameters/prefer_microsoft_dsm_guid
echo N > /sys/module/acpi/parameters/sleep_no_lps0
echo N > /sys/module/acpiphp/parameters/disable
echo 0 > /sys/module/ahci/parameters/marvell_enable
echo 0 > /sys/module/ahci/parameters/mobile_lpm_policy
echo normal > /sys/module/apparmor/parameters/audit
echo Y > /sys/module/apparmor/parameters/audit_header
echo N > /sys/module/apparmor/parameters/debug
echo Y > /sys/module/apparmor/parameters/enabled
echo Y > /sys/module/apparmor/parameters/export_binary
echo Y > /sys/module/apparmor/parameters/hash_policy
echo N > /sys/module/apparmor/parameters/lock_policy
echo N > /sys/module/apparmor/parameters/logsyscall
echo enforce > /sys/module/apparmor/parameters/mode
echo Y > /sys/module/apparmor/parameters/paranoid_load
echo 8192 > /sys/module/apparmor/parameters/path_max
echo -1 > /sys/module/apparmor/parameters/rawdata_compression_level
echo N > /sys/module/blk_cgroup/parameters/blkcg_debug_stats
echo 2000 > /sys/module/block/parameters/events_dfl_poll_msecs
echo ignore > /sys/module/button/parameters/lid_init_state
echo 500 > /sys/module/button/parameters/lid_report_interval
echo 0 > /sys/module/cec/parameters/debug
echo N > /sys/module/cec/parameters/debug_phys_addr
echo 1000 > /sys/module/cfg80211/parameters/bss_entries_limit
echo N > /sys/module/cfg80211/parameters/cfg80211_disable_40mhz_24ghz
echo 2 > /sys/module/clocksource/parameters/max_cswd_read_retries
echo 8 > /sys/module/clocksource/parameters/verify_n_cpus
echo 0 > /sys/module/coretemp/parameters/tjmax
echo 0 > /sys/module/cpufreq/parameters/off
echo N > /sys/module/cpuidle_haltpoll/parameters/force
echo 0 > /sys/module/cpuidle/parameters/off
echo fallback > /sys/module/crc64_rocksoft/parameters/transform
echo crct10dif-generic > /sys/module/crc_t10dif/parameters/transform
echo Y > /sys/module/cryptomgr/parameters/notests
echo N > /sys/module/cryptomgr/parameters/panic_on_fail
echo 60 > /sys/module/cxl_core/parameters/media_ready_timeout
echo N > /sys/module/device_hmem/parameters/disable
echo 10 > /sys/module/drm_display_helper/parameters/dp_aux_i2c_speed_khz
echo 16 > /sys/module/drm_display_helper/parameters/dp_aux_i2c_transfer_size
echo 1 > /sys/module/drm_display_helper/parameters/drm_dp_cec_unregister_delay
echo 100 > /sys/module/drm_kms_helper/parameters/drm_fbdev_overalloc
echo N > /sys/module/drm_kms_helper/parameters/fbdev_emulation
echo N > /sys/module/drm_kms_helper/parameters/poll
echo 0x0 > /sys/module/drm/parameters/debug
echo 6 > /sys/module/drm/parameters/edid_fixup
echo 20 > /sys/module/drm/parameters/timestamp_precision_usec
echo 5000 > /sys/module/drm/parameters/vblankoffdelay
echo 0 > /sys/module/dynamic_debug/parameters/verbose
echo 0 > /sys/module/edac_core/parameters/check_pci_errors
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ce
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ue
echo 0 > /sys/module/edac_core/parameters/edac_mc_panic_on_ue
echo 1000 > /sys/module/edac_core/parameters/edac_mc_poll_msec
echo 0 > /sys/module/edac_core/parameters/edac_pci_panic_on_pe
echo N > /sys/module/ehci_hcd/parameters/ignore_oc
echo 0 > /sys/module/ehci_hcd/parameters/log2_irq_thresh
echo 0 > /sys/module/ehci_hcd/parameters/park
echo N > /sys/module/fb/parameters/lockless_register_fb
#echo  > /sys/module/firmware_class/parameters/path
echo 0 > /sys/module/fscache/parameters/debug
echo 32 > /sys/module/fscrypto/parameters/num_prealloc_crypto_pages
echo N > /sys/module/fuse/parameters/allow_sys_admin_access
echo 1281 > /sys/module/fuse/parameters/max_user_bgreq
echo 1281 > /sys/module/fuse/parameters/max_user_congthresh
echo null > /sys/module/gpiolib_acpi/parameters/ignore_interrupt
echo null > /sys/module/gpiolib_acpi/parameters/ignore_wake
echo 1 > /sys/module/gpiolib_acpi/parameters/run_edge_events_on_boot
echo 0 > /sys/module/hid/parameters/debug
echo 1 > /sys/module/hid/parameters/ignore_special_drivers
echo 0 > /sys/module/i2c_algo_bit/parameters/bit_test
echo 0 > /sys/module/i2c_i801/parameters/disable_features
echo N > /sys/module/i8042/parameters/debug
echo N > /sys/module/i8042/parameters/unmask_kbd_data
echo 4096 > /sys/module/ima/parameters/ahash_bufsize
echo 0 > /sys/module/ima/parameters/ahash_minsize
echo 9 > /sys/module/intel_idle/parameters/max_cstate
echo N > /sys/module/intel_idle/parameters/no_acpi
echo 0 > /sys/module/intel_idle/parameters/preferred_cstates
echo 0 > /sys/module/intel_idle/parameters/states_off
echo N > /sys/module/intel_idle/parameters/use_acpi
echo 0 > /sys/module/ip_set/parameters/max_sets
echo 0 > /sys/module/kernel/parameters/consoleblank
echo N > /sys/module/kernel/parameters/crash_kexec_post_notifiers
echo N > /sys/module/kernel/parameters/ignore_rlimit_data
echo N > /sys/module/kernel/parameters/initcall_debug
echo null > /sys/module/kernel/parameters/module_blacklist
echo 0 > /sys/module/kernel/parameters/panic
echo 0 > /sys/module/kernel/parameters/panic_on_warn
echo 0 > /sys/module/kernel/parameters/panic_print
echo 0 > /sys/module/kernel/parameters/pause_on_oops
echo 1 > /sys/module/keyboard/parameters/brl_nbchords
echo 300 > /sys/module/keyboard/parameters/brl_timeout
echo Y > /sys/module/kvm/parameters/eager_page_split
echo Y > /sys/module/kvm/parameters/enable_pmu
echo N > /sys/module/kvm/parameters/enable_vmware_backdoor
echo N > /sys/module/kvm/parameters/flush_on_reuse
echo 0 > /sys/module/kvm/parameters/force_emulation_prefix
echo 200000 > /sys/module/kvm/parameters/halt_poll_ns
echo 2 > /sys/module/kvm/parameters/halt_poll_ns_grow
echo 10000 > /sys/module/kvm/parameters/halt_poll_ns_grow_start
echo 0 > /sys/module/kvm/parameters/halt_poll_ns_shrink
echo N > /sys/module/kvm/parameters/ignore_msrs
echo Y > /sys/module/kvm/parameters/kvmclock_periodic_sync
echo -1 > /sys/module/kvm/parameters/lapic_timer_advance_ns
echo 200 > /sys/module/kvm/parameters/min_timer_period_us
echo Y > /sys/module/kvm/parameters/mmio_caching
echo N > /sys/module/kvm/parameters/nx_huge_pages
echo 0 > /sys/module/kvm/parameters/nx_huge_pages_recovery_period_ms
echo 60 > /sys/module/kvm/parameters/nx_huge_pages_recovery_ratio
echo -1 > /sys/module/kvm/parameters/pi_inject_timer
echo Y > /sys/module/kvm/parameters/report_ignored_msrs
echo Y > /sys/module/kvm/parameters/tdp_mmu
echo 250 > /sys/module/kvm/parameters/tsc_tolerance_ppm
echo Y > /sys/module/kvm/parameters/vector_hashing
echo Y > /sys/module/libahci/parameters/ahci_em_messages
echo 1000 > /sys/module/libahci/parameters/devslp_idle_timeout
echo 1 > /sys/module/libahci/parameters/ignore_sss
echo 0 > /sys/module/libahci/parameters/skip_host_reset
echo 7 > /sys/module/libata/parameters/acpi_gtf_filter
echo 0 > /sys/module/libata/parameters/allow_tpm
echo 0 > /sys/module/libata/parameters/atapi_an
echo 0 > /sys/module/libata/parameters/atapi_dmadir
echo 0 > /sys/module/libata/parameters/atapi_enabled
echo 1 > /sys/module/libata/parameters/atapi_passthru16
echo 0 > /sys/module/libata/parameters/ata_probe_timeout
echo 7 > /sys/module/libata/parameters/dma
echo 0 > /sys/module/libata/parameters/fua
echo 0 > /sys/module/libata/parameters/ignore_hpa
echo 0 > /sys/module/libata/parameters/noacpi
echo 30 > /sys/module/libata/parameters/zpodd_poweroff_delay
echo 0 > /sys/module/lockd/parameters/nlm_grace_period
echo 1024 > /sys/module/lockd/parameters/nlm_max_connections
echo 0 > /sys/module/lockd/parameters/nlm_tcpport
echo 10 > /sys/module/lockd/parameters/nlm_timeout
echo 0 > /sys/module/lockd/parameters/nlm_udpport
echo N > /sys/module/lockd/parameters/nsm_use_hostnames
echo Y > /sys/module/memory_hotplug/parameters/auto_movable_numa_aware
echo 301 > /sys/module/memory_hotplug/parameters/auto_movable_ratio
echo N > /sys/module/memory_hotplug/parameters/memmap_on_memory
echo contig-zones > /sys/module/memory_hotplug/parameters/online_policy
echo N > /sys/module/module/parameters/async_probe
echo N > /sys/module/module/parameters/sig_enforce
echo 200 > /sys/module/mousedev/parameters/tap_time
echo 1024 > /sys/module/mousedev/parameters/xres
echo 768 > /sys/module/mousedev/parameters/yres
echo default > /sys/module/msr/parameters/allow_writes
echo 0 > /sys/module/netfs/parameters/debug
echo 4 > /sys/module/netpoll/parameters/carrier_timeout
echo N > /sys/module/nf_conntrack/parameters/acct
echo 512 > /sys/module/nf_conntrack/parameters/expect_hashsize
echo 16384 > /sys/module/nf_conntrack/parameters/hashsize
echo N > /sys/module/nf_conntrack/parameters/tstamp
echo 0 > /sys/module/nfs/parameters/callback_nr_threads
echo 0 > /sys/module/nfs/parameters/callback_tcpport
echo Y > /sys/module/nfs/parameters/enable_ino64
echo 16 > /sys/module/nfs/parameters/max_session_cb_slots
echo 64 > /sys/module/nfs/parameters/max_session_slots
echo Y > /sys/module/nfs/parameters/nfs4_disable_idmapping
#echo  > /sys/module/nfs/parameters/nfs4_unique_id
echo 4194304 > /sys/module/nfs/parameters/nfs_access_max_cachesize
echo 600 > /sys/module/nfs/parameters/nfs_idmap_cache_timeout
echo 500 > /sys/module/nfs/parameters/nfs_mountpoint_expiry_timeout
echo N > /sys/module/nfs/parameters/recover_lost_locks
echo 1 > /sys/module/nfs/parameters/send_implementation_id
echo N > /sys/module/nmi_backtrace/parameters/backtrace_idle
echo 60 > /sys/module/nvme_core/parameters/admin_timeout
echo 15000 > /sys/module/nvme_core/parameters/apst_primary_latency_tol_us
echo 100 > /sys/module/nvme_core/parameters/apst_primary_timeout_ms
echo 100000 > /sys/module/nvme_core/parameters/apst_secondary_latency_tol_us
echo 2000 > /sys/module/nvme_core/parameters/apst_secondary_timeout_ms
echo 0 > /sys/module/nvme_core/parameters/default_ps_max_latency_us
echo N > /sys/module/nvme_core/parameters/force_apst
#echo numa > /sys/module/nvme_core/parameters/iopolicy
echo 30 > /sys/module/nvme_core/parameters/io_timeout
echo 5 > /sys/module/nvme_core/parameters/max_retries
echo Y > /sys/module/nvme_core/parameters/multipath
echo 5 > /sys/module/nvme_core/parameters/shutdown_timeout
echo N > /sys/module/page_alloc/parameters/shuffle
echo 11 > /sys/module/page_reporting/parameters/page_reporting_order
echo [performance] > /sys/module/pcie_aspm/parameters/policy
echo N > /sys/module/pciehp/parameters/pciehp_poll_mode
echo 0 > /sys/module/pciehp/parameters/pciehp_poll_time
echo N > /sys/module/pci_hotplug/parameters/debug
echo N > /sys/module/pci_hotplug/parameters/debug_acpi
echo N > /sys/module/printk/parameters/always_kmsg_dump
echo Y > /sys/module/printk/parameters/console_no_auto_verbose
echo Y > /sys/module/printk/parameters/console_suspend
echo N > /sys/module/printk/parameters/ignore_loglevel
echo Y > /sys/module/printk/parameters/time
echo Y > /sys/module/processor/parameters/bm_check_disable
echo 1 > /sys/module/processor/parameters/ignore_tpc
#echo 1 > /sys/module/processor/parameters/ignore_ppc
echo $max_cstate > /sys/module/processor/parameters/max_cstate
echo N > /sys/module/processor/parameters/nocst
echo N > /sys/module/psmouse/parameters/a4tech_workaround
echo -1 > /sys/module/psmouse/parameters/elantech_smbus
echo auto > /sys/module/psmouse/parameters/proto
echo 100 > /sys/module/psmouse/parameters/rate
echo 5 > /sys/module/psmouse/parameters/resetafter
echo 200 > /sys/module/psmouse/parameters/resolution
echo 0 > /sys/module/psmouse/parameters/resync_time
echo Y > /sys/module/psmouse/parameters/smartscroll
echo -1 > /sys/module/psmouse/parameters/synaptics_intertouch
echo null > /sys/module/pstore/parameters/backend
echo deflate > /sys/module/pstore/parameters/compress
echo -1 > /sys/module/pstore/parameters/update_ms
echo 0 > /sys/module/random/parameters/ratelimit_disable
echo 0 > /sys/module/rcupdate/parameters/rcu_cpu_stall_ftrace_dump
echo 0 > /sys/module/rcupdate/parameters/rcu_cpu_stall_suppress
echo 0 > /sys/module/rcupdate/parameters/rcu_cpu_stall_suppress_at_boot
echo 21 > /sys/module/rcupdate/parameters/rcu_cpu_stall_timeout
echo 0 > /sys/module/rcupdate/parameters/rcu_exp_cpu_stall_timeout
echo 1 > /sys/module/rcupdate/parameters/rcu_expedited
echo 0 > /sys/module/rcupdate/parameters/rcu_normal
echo 0 > /sys/module/rcupdate/parameters/rcu_normal_after_boot
echo 10 > /sys/module/rcupdate/parameters/rcu_task_collapse_lim
echo 100 > /sys/module/rcupdate/parameters/rcu_task_contend_lim
echo 1 > /sys/module/rcupdate/parameters/rcu_task_enqueue_lim
echo 0 > /sys/module/rcupdate/parameters/rcu_task_ipi_delay
echo 2500 > /sys/module/rcupdate/parameters/rcu_task_stall_info
echo 3 > /sys/module/rcupdate/parameters/rcu_task_stall_info_mult
echo 150000 > /sys/module/rcupdate/parameters/rcu_task_stall_timeout
echo 10 > /sys/module/rcutree/parameters/blimit
echo N > /sys/module/rcutree/parameters/dump_tree
echo 0 > /sys/module/rcutree/parameters/gp_cleanup_delay
echo 0 > /sys/module/rcutree/parameters/gp_init_delay
echo 0 > /sys/module/rcutree/parameters/gp_preinit_delay
echo 1 > /sys/module/rcutree/parameters/jiffies_till_first_fqs
echo 1 > /sys/module/rcutree/parameters/jiffies_till_next_fqs
echo 18446744073709551615 > /sys/module/rcutree/parameters/jiffies_till_sched_qs
echo 25 > /sys/module/rcutree/parameters/jiffies_to_sched_qs
#echo 0 > /sys/module/rcutree/parameters/kthread_prio
echo 10000 > /sys/module/rcutree/parameters/qhimark
echo 100 > /sys/module/rcutree/parameters/qlowmark
echo 20000 > /sys/module/rcutree/parameters/qovld
echo 5000 > /sys/module/rcutree/parameters/rcu_delay_page_cache_fill_msec
echo 7 > /sys/module/rcutree/parameters/rcu_divisor
echo N > /sys/module/rcutree/parameters/rcu_fanout_exact
echo 16 > /sys/module/rcutree/parameters/rcu_fanout_leaf
echo N > /sys/module/rcutree/parameters/rcu_kick_kthreads
echo 5 > /sys/module/rcutree/parameters/rcu_min_cached_objs
echo -1 > /sys/module/rcutree/parameters/rcu_nocb_gp_stride
echo 3000000 > /sys/module/rcutree/parameters/rcu_resched_ns
echo N > /sys/module/rcutree/parameters/sysrq_rcu
echo Y > /sys/module/rcutree/parameters/use_softirq
echo 0 > /sys/module/rfkill/parameters/default_state
echo 0 > /sys/module/rng_core/parameters/current_quality
echo 0 > /sys/module/rng_core/parameters/default_quality
echo N > /sys/module/rtc_cmos/parameters/use_acpi_alarm
echo 0 > /sys/module/scsi_mod/parameters/default_dev_flags
echo -1 > /sys/module/scsi_mod/parameters/eh_deadline
echo 20 > /sys/module/scsi_mod/parameters/inq_timeout
echo 512 > /sys/module/scsi_mod/parameters/max_luns
echo async > /sys/module/scsi_mod/parameters/scan
echo 0 > /sys/module/scsi_mod/parameters/scsi_logging_level
echo N > /sys/module/secretmem/parameters/enable
echo 0 > /sys/module/sg/parameters/allow_dio
echo 32768 > /sys/module/sg/parameters/def_reserved_size
echo 32768 > /sys/module/sg/parameters/scatter_elem_sz
echo N > /sys/module/shpchp/parameters/shpchp_debug
echo N > /sys/module/shpchp/parameters/shpchp_poll_mode
echo 0 > /sys/module/shpchp/parameters/shpchp_poll_time
echo Y > /sys/module/snd_hda_codec_hdmi/parameters/enable_acomp
echo N > /sys/module/snd_hda_codec_hdmi/parameters/enable_all_pins
echo N > /sys/module/snd_hda_codec_hdmi/parameters/enable_silent_stream
echo N > /sys/module/snd_hda_codec_hdmi/parameters/static_hdmi_pcm
echo -1 > /sys/module/snd_hda_codec/parameters/dump_coef
echo -1 > /sys/module/snd_hda_intel/parameters/align_buffer_size
echo -1 > /sys/module/snd_hda_intel/parameters/bdl_pos_adj
echo N > /sys/module/snd_hda_intel/parameters/beep_mode
echo N > /sys/module/snd_hda_intel/parameters/dmic_detect
#echo Y > /sys/module/snd_hda_intel/parameters/enable
echo -1 > /sys/module/snd_hda_intel/parameters/enable_msi
echo null > /sys/module/snd_hda_intel/parameters/id
echo -1 > /sys/module/snd_hda_intel/parameters/index
echo 0 > /sys/module/snd_hda_intel/parameters/jackpoll_ms
echo null > /sys/module/snd_hda_intel/parameters/model
echo null > /sys/module/snd_hda_intel/parameters/patch
echo Y > /sys/module/snd_hda_intel/parameters/pm_blacklist
echo -1 > /sys/module/snd_hda_intel/parameters/position_fix
echo 1 > /sys/module/snd_hda_intel/parameters/power_save
echo Y > /sys/module/snd_hda_intel/parameters/power_save_controller
echo -1 > /sys/module/snd_hda_intel/parameters/probe_mask
echo 0 > /sys/module/snd_hda_intel/parameters/probe_only
echo -1 > /sys/module/snd_hda_intel/parameters/single_cmd
echo -1 > /sys/module/snd_hda_intel/parameters/snoop
echo 0 > /sys/module/snd_intel_dspcfg/parameters/dsp_driver
echo 0 > /sys/module/snd_intel_sdw_acpi/parameters/sdw_link_mask
echo 1 > /sys/module/snd/parameters/cards_limit
echo 116 > /sys/module/snd/parameters/major
echo 8388608 > /sys/module/snd/parameters/max_user_ctl_alloc_size
echo null > /sys/module/snd/parameters/slots
echo 33554432 > /sys/module/snd_pcm/parameters/max_alloc_per_card
echo 4 > /sys/module/snd_pcm/parameters/maximum_substreams
echo 1 > /sys/module/snd_pcm/parameters/preallocate_dma
echo N > /sys/module/snd_seq_dummy/parameters/duplex
echo 1 > /sys/module/snd_seq_dummy/parameters/ports
echo -1 > /sys/module/snd_seq/parameters/seq_client_load
echo -1 > /sys/module/snd_seq/parameters/seq_default_timer_card
echo 1 > /sys/module/snd_seq/parameters/seq_default_timer_class
echo 3 > /sys/module/snd_seq/parameters/seq_default_timer_device
echo 0 > /sys/module/snd_seq/parameters/seq_default_timer_resolution
echo 0 > /sys/module/snd_seq/parameters/seq_default_timer_sclass
echo 0 > /sys/module/snd_seq/parameters/seq_default_timer_subdevice
echo 4 > /sys/module/snd_timer/parameters/timer_limit
echo 1 > /sys/module/snd_timer/parameters/timer_tstamp_monotonic
echo 0 > /sys/module/soundcore/parameters/preclaim_oss
echo 4096 > /sys/module/spidev/parameters/bufsiz
echo 0 > /sys/module/spurious/parameters/irqfixup
echo Y > /sys/module/spurious/parameters/noirqdebug
echo 128 > /sys/module/srcutree/parameters/big_cpu_lim
echo 16 > /sys/module/srcutree/parameters/convert_to_big
echo 4611686018427387903 > /sys/module/srcutree/parameters/counter_wrap_check
echo 25000 > /sys/module/srcutree/parameters/exp_holdoff
echo 100 > /sys/module/srcutree/parameters/small_contention_lim
echo 1000 > /sys/module/srcutree/parameters/srcu_max_nodelay
echo 1000 > /sys/module/srcutree/parameters/srcu_max_nodelay_phase
echo 5 > /sys/module/srcutree/parameters/srcu_retry_check_delay
echo 16 > /sys/module/sunrpc/parameters/auth_hashtable_size
echo 18446744073709551615 > /sys/module/sunrpc/parameters/auth_max_cred_cachesize
echo 1023 > /sys/module/sunrpc/parameters/max_resvport
echo 665 > /sys/module/sunrpc/parameters/min_resvport
echo global > /sys/module/sunrpc/parameters/pool_mode
echo 0 > /sys/module/sunrpc/parameters/svc_rpc_per_connection_limit
echo 65536 > /sys/module/sunrpc/parameters/tcp_max_slot_table_entries
echo 2 > /sys/module/sunrpc/parameters/tcp_slot_table_entries
echo 16 > /sys/module/sunrpc/parameters/udp_slot_table_entries
echo 5 > /sys/module/suspend/parameters/pm_test_delay
echo N > /sys/module/syscall/parameters/x32
echo 0 > /sys/module/sysrq/parameters/sysrq_downtime_ms
echo 717 > /sys/module/tcp_cubic/parameters/beta
echo 41 > /sys/module/tcp_cubic/parameters/bic_scale
echo 1 > /sys/module/tcp_cubic/parameters/fast_convergence
echo 1 > /sys/module/tcp_cubic/parameters/hystart
echo 2000 > /sys/module/tcp_cubic/parameters/hystart_ack_delta_us
echo 2 > /sys/module/tcp_cubic/parameters/hystart_detect
echo 16 > /sys/module/tcp_cubic/parameters/hystart_low_window
echo 0 > /sys/module/tcp_cubic/parameters/initial_ssthresh
echo 1 > /sys/module/tcp_cubic/parameters/tcp_friendliness
echo 0 > /sys/module/thermal/parameters/act
echo 0 > /sys/module/thermal/parameters/crt
echo 0 > /sys/module/thermal/parameters/psv
echo 0 > /sys/module/thermal/parameters/tzp
echo 0 > /sys/module/tpm/parameters/suspend_pcr
echo N > /sys/module/tpm_tis/parameters/force
echo  > /sys/module/tpm_tis/parameters/hid
echo -1 > /sys/module/tpm_tis/parameters/interrupts
echo N > /sys/module/tpm_tis/parameters/itpm
echo 524288 > /sys/module/ttm/parameters/dma32_pages_limit
echo 502497 > /sys/module/ttm/parameters/page_pool_size
echo 502497 > /sys/module/ttm/parameters/pages_limit
echo 0 > /sys/module/uhci_hcd/parameters/debug
echo N > /sys/module/uhci_hcd/parameters/ignore_oc
echo -1 > /sys/module/usbcore/parameters/authorized_default
echo 2 > /sys/module/usbcore/parameters/autosuspend
echo N > /sys/module/usbcore/parameters/blinkenlights
echo 5000 > /sys/module/usbcore/parameters/initial_descriptor_timeout
echo N > /sys/module/usbcore/parameters/nousb
echo N > /sys/module/usbcore/parameters/old_scheme_first
echo p > /sys/module/usbcore/parameters/quirks
echo 16 > /sys/module/usbcore/parameters/usbfs_memory_mb
echo N > /sys/module/usbcore/parameters/usbfs_snoop
echo 65536 > /sys/module/usbcore/parameters/usbfs_snoop_max
echo Y > /sys/module/usbcore/parameters/use_both_schemes
echo 0 > /sys/module/usbhid/parameters/ignoreled
echo 0 > /sys/module/usbhid/parameters/jspoll
echo 0 > /sys/module/usbhid/parameters/kbpoll
echo null > /sys/module/usbhid/parameters/quirks
echo 1 > /sys/module/usb_storage/parameters/delay_use
echo 1 > /sys/module/usb_storage/parameters/option_zero_cd
echo p > /sys/module/usb_storage/parameters/quirks
echo 1 > /sys/module/usb_storage/parameters/swi_tru_install
echo N > /sys/module/video/parameters/allow_duplicates
echo Y > /sys/module/video/parameters/brightness_switch_enabled
echo N > /sys/module/video/parameters/device_id_scheme
echo -1 > /sys/module/video/parameters/hw_changes_brightness
echo 0 > /sys/module/video/parameters/only_lcd
echo 8 > /sys/module/video/parameters/register_backlight_delay
echo -1 > /sys/module/video/parameters/report_key_events
echo 7 > /sys/module/vt/parameters/color
echo 2 > /sys/module/vt/parameters/cur_default
echo 0,0,0,0,170,170,170,170,85,85,85,85,255,255,255,255 > /sys/module/vt/parameters/default_blu
echo 0,0,170,85,0,0,170,170,85,85,255,255,85,85,255,255 > /sys/module/vt/parameters/default_grn
echo 0,170,0,170,0,170,0,170,85,255,85,255,85,255,85,255 > /sys/module/vt/parameters/default_red
echo 1 > /sys/module/vt/parameters/default_utf8
echo 1 > /sys/module/vt/parameters/global_cursor_default
echo 2 > /sys/module/vt/parameters/italic
echo 3 > /sys/module/vt/parameters/underline
echo N > /sys/module/wmi/parameters/debug_dump_wdg
echo N > /sys/module/wmi/parameters/debug_event
echo N > /sys/module/workqueue/parameters/debug_force_rr_cpu
echo Y > /sys/module/workqueue/parameters/disable_numa
echo N > /sys/module/workqueue/parameters/power_efficient
echo 800,600 > /sys/module/xen_kbdfront/parameters/ptr_size
echo 180 > /sys/module/xen/parameters/balloon_boot_timeout
echo 10 > /sys/module/xen/parameters/event_eoi_delay
echo 2 > /sys/module/xen/parameters/event_loop_timeout
echo 0 > /sys/module/xt_recent/parameters/ip_list_gid
echo 128 > /sys/module/xt_recent/parameters/ip_list_hash_size
echo 420 > /sys/module/xt_recent/parameters/ip_list_perms
echo 100 > /sys/module/xt_recent/parameters/ip_list_tot
echo 0 > /sys/module/xt_recent/parameters/ip_list_uid
echo 0 > /sys/module/xt_recent/parameters/ip_pkt_list_tot


fi








if [ $level = high ] ; then 


#
echo 1 > /sys/devices/system/cpu/cpufreq/boost
#
echo "N" > /sys/module/rt2800soc/parameters/nohwcrypt
echo "N" > /sys/module/watchdog/parameters/handle_boot_enabled
echo "1" > /sys/module/watchdog/parameters/stop_on_reboot
echo "Y" > /sys/module/mac80211/parameters/minstrel_vht_only
echo '1' > /proc/sys/crypto/fips_enabled


echo $cpumaxcstate > /sys/module/processor/parameters/max_cstate
echo 1 > /sys/module/processor/parameters/bm_check_disable
if [ $cpumaxcstate = 0 ] ; then
echo 1 > /sys/module/processor/parameters/latency_factor
fi
echo 1 > /sys/module/processor/parameters/ignore_tpc
#echo 0 > /sys/module/processor/parameters/nocst

echo $ksm > /sys/kernel/mm/ksm/run
echo 1 > /sys/kernel/mm/ksm/merge_across_nodes



echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work

echo null > /sys/kernel/cgroup/features


#
echo "1" > /sys/kernel/fast_charge/force_fast_charge
echo "1" > /sys/kernel/sound_control/mic_gain
echo "1" > /proc/sys/dev/cnss/randomize_mac

# amdgpu
if dmesg | grep -q amdgpu ; then
# command to dump yours: for i in $(ls /sys/module/amdgpu/parameters) ; do echo "#echo -1 > /sys/module/amdgpu/parameters/$i" ; done
# more info: https://www.kernel.org/doc/html/v4.20/gpu/amdgpu.html
#echo -1 > /sys/module/amdgpu/parameters/abmlevel
echo 1 > /sys/module/amdgpu/parameters/aspm
#echo -1 > /sys/module/amdgpu/parameters/async_gfx_ring
#echo -1 > /sys/module/amdgpu/parameters/audio
#echo -1 > /sys/module/amdgpu/parameters/backlight
#echo -1 > /sys/module/amdgpu/parameters/bad_page_threshold
#echo -1 > /sys/module/amdgpu/parameters/bapm
echo 0xffffffff > /sys/module/amdgpu/parameters/cg_mask
echo -1 > /sys/module/amdgpu/parameters/cik_support
echo 1 > /sys/module/amdgpu/parameters/compute_multipipe
echo 1 > /sys/module/amdgpu/parameters/cwsr_enable
echo 1 > /sys/module/amdgpu/parameters/dc
#echo -1 > /sys/module/amdgpu/parameters/dcdebugmask
echo 0xffffffff > /sys/module/amdgpu/parameters/dcfeaturemask
#echo -1 > /sys/module/amdgpu/parameters/debug_evictions
echo 1 > /sys/module/amdgpu/parameters/debug_largebar
echo 1 > /sys/module/amdgpu/parameters/deep_color
#echo -1 > /sys/module/amdgpu/parameters/disable_cu
#echo -1 > /sys/module/amdgpu/parameters/discovery
#echo -1 > /sys/module/amdgpu/parameters/disp_priority
echo 1 > /sys/module/amdgpu/parameters/dpm
#echo -1 > /sys/module/amdgpu/parameters/emu_mode
echo 1 > /sys/module/amdgpu/parameters/exp_hw_support
#echo -1 > /sys/module/amdgpu/parameters/force_asic_type
#echo -1 > /sys/module/amdgpu/parameters/forcelongtraining
#echo -1 > /sys/module/amdgpu/parameters/fw_load_type
#echo -1 > /sys/module/amdgpu/parameters/gartsize
#echo -1 > /sys/module/amdgpu/parameters/gpu_recovery
#echo -1 > /sys/module/amdgpu/parameters/gttsize
#echo -1 > /sys/module/amdgpu/parameters/halt_if_hws_hang
echo 1 > /sys/module/amdgpu/parameters/hw_i2c
echo 1 > /sys/module/amdgpu/parameters/hws_gws_support
#echo -1 > /sys/module/amdgpu/parameters/hws_max_conc_proc
#echo -1 > /sys/module/amdgpu/parameters/ignore_crat
echo 0xffffffff > /sys/module/amdgpu/parameters/ip_block_mask
#echo -1 > /sys/module/amdgpu/parameters/job_hang_limit
#echo -1 > /sys/module/amdgpu/parameters/lbpw
#echo -1 > /sys/module/amdgpu/parameters/lockup_timeout
#echo -1 > /sys/module/amdgpu/parameters/max_num_of_queues_per_device
#echo -1 > /sys/module/amdgpu/parameters/mcbp
#echo -1 > /sys/module/amdgpu/parameters/mes
#echo -1 > /sys/module/amdgpu/parameters/mes_kiq
#echo -1 > /sys/module/amdgpu/parameters/moverate
echo -1 > /sys/module/amdgpu/parameters/msi
echo 1 > /sys/module/amdgpu/parameters/ngg
#echo -1 > /sys/module/amdgpu/parameters/no_queue_eviction_on_vm_fault
#echo -1 > /sys/module/amdgpu/parameters/noretry
#echo -1 > /sys/module/amdgpu/parameters/no_system_mem_limit
#echo -1 > /sys/module/amdgpu/parameters/num_kcq
#echo 0 > /sys/module/amdgpu/parameters/pcie_gen2
#echo -1 > /sys/module/amdgpu/parameters/pcie_gen_cap
#echo -1 > /sys/module/amdgpu/parameters/pcie_lane_cap
echo 0xffffffff > /sys/module/amdgpu/parameters/pg_mask
echo 0xffffffff > /sys/module/amdgpu/parameters/ppfeaturemask
#echo -1 > /sys/module/amdgpu/parameters/queue_preemption_timeout_ms
echo 1 > /sys/module/amdgpu/parameters/ras_enable
echo 0xffffffff > /sys/module/amdgpu/parameters/ras_mask
#echo -1 > /sys/module/amdgpu/parameters/reset_method
#echo -1 > /sys/module/amdgpu/parameters/runpm
#echo -1 > /sys/module/amdgpu/parameters/sched_hw_submission
echo 64 > /sys/module/amdgpu/parameters/sched_jobs
echo 0 > /sys/module/amdgpu/parameters/sched_policy
#echo -1 > /sys/module/amdgpu/parameters/sdma_phase_quantum
#echo -1 > /sys/module/amdgpu/parameters/send_sigterm
echo -1 > /sys/module/amdgpu/parameters/si_support
#echo -1 > /sys/module/amdgpu/parameters/smu_memory_pool_size
#echo -1 > /sys/module/amdgpu/parameters/smu_pptable_id
#echo -1 > /sys/module/amdgpu/parameters/timeout_fatal_disable
#echo -1 > /sys/module/amdgpu/parameters/timeout_period
#echo -1 > /sys/module/amdgpu/parameters/tmz
#echo -1 > /sys/module/amdgpu/parameters/use_xgmi_p2p
echo 0 > /sys/module/amdgpu/parameters/vcnfw_log
#echo -1 > /sys/module/amdgpu/parameters/virtual_display
#echo -1 > /sys/module/amdgpu/parameters/visualconfirm
#echo -1 > /sys/module/amdgpu/parameters/vis_vramlimit
#echo -1 > /sys/module/amdgpu/parameters/vm_block_size
echo 0 > /sys/module/amdgpu/parameters/vm_debug
echo 0 > /sys/module/amdgpu/parameters/vm_fault_stop
#echo -1 > /sys/module/amdgpu/parameters/vm_fragment_size
#echo -1 > /sys/module/amdgpu/parameters/vm_size
#echo -1 > /sys/module/amdgpu/parameters/vm_update_mode
#echo -1 > /sys/module/amdgpu/parameters/vramlimit
elif dmesg | grep -q radeon ; then
echo 0 > /sys/module/radeon/parameters/agpmode
echo 1 > /sys/module/radeon/parameters/aspm
#echo 0 > /sys/module/radeon/parameters/audio
#echo -1 > /sys/module/radeon/parameters/auxch
#echo -1 > /sys/module/radeon/parameters/backlight
#echo -1 > /sys/module/radeon/parameters/bapm
echo 0 > /sys/module/radeon/parameters/benchmark
echo -1 > /sys/module/radeon/parameters/cik_support
#echo -1 > /sys/module/radeon/parameters/connector_table
echo 1 > /sys/module/radeon/parameters/deep_color
#echo -1 > /sys/module/radeon/parameters/disp_priority
echo 1 > /sys/module/radeon/parameters/dpm
#echo -1 > /sys/module/radeon/parameters/dynclks
echo 1 > /sys/module/radeon/parameters/fastfb
#echo -1 > /sys/module/radeon/parameters/gartsize
#echo -1 > /sys/module/radeon/parameters/hard_reset
echo 1 > /sys/module/radeon/parameters/hw_i2c
#echo -1 > /sys/module/radeon/parameters/lockup_timeout
echo 1 > /sys/module/radeon/parameters/modeset
echo 1 > /sys/module/radeon/parameters/msi
#echo -1 > /sys/module/radeon/parameters/no_wb
#echo -1 > /sys/module/radeon/parameters/pcie_gen2
#echo -1 > /sys/module/radeon/parameters/r4xx_atom
#echo -1 > /sys/module/radeon/parameters/runpm
echo -1 > /sys/module/radeon/parameters/si_support
echo 0 > /sys/module/radeon/parameters/test
echo 0 > /sys/module/radeon/parameters/tv
#echo -1 > /sys/module/radeon/parameters/use_pflipirq
#echo -1 > /sys/module/radeon/parameters/uvd
#echo -1 > /sys/module/radeon/parameters/vce
#echo -1 > /sys/module/radeon/parameters/vm_block_size
#echo -1 > /sys/module/radeon/parameters/vm_size
#echo -1 > /sys/module/radeon/parameters/vramlimit
fi

if echo $zswap | grep -q "zswap.enabled=1" ; then
echo 90 > /sys/module/zswap/parameters/accept_threshold_percent
echo lz4 > /sys/module/zswap/parameters/compressor
echo Y > /sys/module/zswap/parameters/enabled
echo $zpoolpercent > /sys/module/zswap/parameters/max_pool_percent
echo Y > /sys/module/zswap/parameters/non_same_filled_pages_enabled
echo Y > /sys/module/zswap/parameters/same_filled_pages_enabled
echo $zpool > /sys/module/zswap/parameters/zpool ; else
echo N > /sys/module/zswap/parameters/enabled
fi

if [ $ipv6 = off ] && $(! $wrt) ; then
echo 0 > /sys/module/ipv6/parameters/autoconf
echo 1 > /sys/module/ipv6/parameters/disable
echo 1 > /sys/module/ipv6/parameters/disable_ipv6
fi

echo 0 > /sys/module/cachefiles/parameters/debug
echo 1 > /sys/module/apparmor/parameters/enabled
echo 0 > /sys/module/apparmor/parameters/logsyscall
echo 100 > /sys/module/drm_kms_helper/parameters/drm_fbdev_overalloc
echo N > /sys/module/drm_kms_helper/parameters/poll
echo N > /sys/module/fscache/parameters/debug
echo N > //sys/module/fuse/parameters/allow_sys_admin_access
echo N > /sys/module/i2c_algo_bit/parameters/bit_test
echo N > /sys/module/i8042/parameters/debug
echo $cpumaxcstate > /sys/module/intel_idle/parameters/max_cstate
echo N > /sys/module/kernel/parameters/initcall_debug
echo N > /sys/module/kvm/parameters/flush_on_reuse
echo Y > /sys/module/kvm/parameters/mmio_caching
echo N > /sys/module/netfs/parameters/debugtriple
if [ $ignoreloglevel = yes ] ; then
echo N > /sys/module/printk/parameters/ignore_loglevel ; fi
echo Y >  /sys/module/random/parameters/ratelimit_disable
echo 1 > /sys/module/rcupdate/parameters/rcu_expedited
echo 0 > /sys/module/rcupdate/parameters/rcu_normal
#echo 99 > /sys/module/rcutree/parameters/kthread_prio
echo -1 > /sys/module/rcutree/parameters/rcu_sched_ns
echo 0 > /sys/module/scsi_mod/parameters/scsi_logging_level
echo N > /sys/module/snd_hda_codec_hdmi/parameters/enable_silent_stream
echo Y > /sys/module/snd_hda_intel/parameters/power_save
echo N > /sys/module/shpchp/parameters/shpchp_debug
echo Y > /sys/module/snd_usb_audio/parameters/lowlatency
echo Y > /sys/module/snd_usb_audio/parameters/use_vmalloc
echo Y > /sys/module/snd_usb_audio/parameters/ignore_ctl_error
echo 1 > /sys/module/spurious/parameters/noirqdebug
echo N > /sys/module/syscall/parameters/x32
echo p > /sys/module/usbcore/parameters/quirks
echo N > /sys/module/wmi/parameters/debug*
echo Y > /sys/module/workqueue/parameters/disable_numa
echo N > /sys/module/workqueue/parameters/power_efficient
echo Y > /sys/module/dm_mod/parameters/use_bulk_mq
echo N > /sys/module/edac_core/parameters/check_pci_errors
echo 0 > /sys/kernel/profiling
echo $hoverc > /sys/kernel/mm/hugepages/hugepages*/nr_overcommit_hugepages
echo Y > /sys/kernel/mm/lru_gen/enabled
echo false > /sys/kernel/mm/numa/demotion_enabled

#echo 1 > /sys/kernel/reboot/cpu
#echo 1 > /sys/kernel/reboot/force
echo warm > /sys/kernel/reboot/mode
#echo triple > /sys/kernel/reboot/type

echo 0xffffff > /sys/kernel/security/apparmor/capability

echo tsc > /sys/devices/system/clocksource/clocksource*/current_clocksource
echo 0 > /sys/module/drm_kms_helper/parameters/poll
echo N > /sys/module/cfg80211/parameters/cfg80211_disable_40mhz_24ghz
echo N > /sys/module/device_hmem/parameters/disable
echo N > /sys/module/drm_kms_helper/parameters/fbdev_emulation
echo N > /sys/module/wmi/parameters/debug*
echo N > /sys/kernel/debug/sched/verbose
echo full > /sys/kernel/debug/sched/preempt

echo Y > /sys/kernel/debug/tracing/set_ftrace_notrace


echo N > /sys/module/ip6_gre/parameters/log_ecn_error
echo N > /sys/module/ip_gre/parameters/log_ecn_error
echo N > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo N > /sys/module/sit/parameters/log_ecn_error

echo N > /sys/module/ehci_hcd/parameters/log2_irq_thresh
echo N > /sys/module/nmi_backtrace/parameters/backtrace_idle
echo N > /sys/module/ramoops/parameters/ftrace_size
echo 99999999999999999999999999999999 > /sys/module/pstore/parameter/update_ms
echo null > /sys/module/pstore/parameters/backend

# general and omit debugging android, x86 and more
if [ $loglevel = 0 ] ; then
/etc/init.d/syslogd stop ; fi
sysctl dev.em.0.debug=0
echo Y > /sys/module/8250/parameters/skip_txen_test
echo 0 > /proc/sys/kernel/tracepoint_printk
echo 0 > /sys/kernel/profiling
echo 0 > /sys/kernel/tracing/tracing_on
echo "$loglevel $loglevel $loglevel $loglevel" > /proc/sys/kernel/printk
echo "0" > /proc/sys/debug/exception-trace
echo "0" > /proc/sys/kernel/sched_schedstats
echo "0" > /sys/module/diagchar/parameters/diag_mask_clear_param
#echo "0" > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
#echo "0" > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
#echo "0" > /sys/module/icnss/parameters/dynamic_feature_mask
echo "0" > /sys/module/msm_poweroff/parameters/download_mode
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/service_locator/parameters/enable
echo "1" > /sys/module/hid/parameters/ignore_special_drivers
echo "1" > /sys/module/printk/parameters/console_suspend
echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work
echo "N" > /proc/sys/kernel/ftrace_enabled
echo "N" > /proc/sys/kernel/schedstats
echo "N" > /sys/kernel/debug/debug_enabled
echo "N" > /sys/module/apparmor/parameters/audit
echo "N" > /sys/module/apparmor/parameters/debug
echo "N" > /sys/module/blk_cgroup/parameters/blkcg_debug_stats
#echo "N" > /sys/module/cifs/parameters/enable_oplocks
echo "N" > /sys/module/dns_resolver/parameters/debug
echo "N" > /sys/module/drm/parameters/debug
echo "N" > /sys/module/drm_kms_helper/parameters/poll
echo "N" > /sys/module/printk/parameters/always_kmsg_dump
echo "Y" > /sys/module/bluetooth/parameters/disable_ertm
echo "Y" > /sys/module/bluetooth/parameters/disable_esco
echo "Y" > /sys/module/cryptomgr/parameters/notests
echo "Y" > /sys/module/printk/parameters/console_suspend
echo '0' > /sys/devices/virtual/block/zram0/debug_stat
echo '0' > /sys/module/acpi/parameters/aml_debug_output
#echo '0' > /sys/module/amdgpu/parameters/debug_evictions
#echo '0' > /sys/module/amdgpu/parameters/debug_largebar
echo '0' > /sys/module/amdgpu/parameters/vm_debug
echo '0' > /sys/module/apparmor/parameters/debug
echo '0' > /sys/module/cec/parameters/debug
echo '0' > /sys/module/cec/parameters/debug_phys_addr
echo '0' > /sys/module/drm/parameters/debug
echo 'N' > /sys/module/dynamic_debug/parameters/verbose
echo '0' > /sys/module/hid/parameters/debug
echo '0' > /sys/module/i8042/parameters/debug
echo '0' > /sys/module/kernel/parameters/initcall_debug
echo '0' > /sys/module/pci_hotplug/parameters/debug
echo '0' > /sys/module/pci_hotplug/parameters/debug_acpi
echo '0' > /sys/module/shpchp/parameters/shpchp_debug
echo '0' > /sys/module/uhci_hcd/parameters/debug
#echo '0' > /sys/module/workqueue/parameters/debug_force_rr_cpu
#echo 'N' > /sys/module/amdgpu/parameters/dcdebugmask
echo 'Y' > /sys/module/spurious/parameters/noirqdebug
for i in $(find /sys/ -name debug_mask); do echo "0" > $i; done
for i in $(find /sys/ -name debug_level); do echo "0" > $i; done
for i in $(find /sys/ -name edac_mc_log_ce); do echo "0" > $i; done
for i in $(find /sys/ -name edac_mc_log_ue); do echo "0" > $i; done
for i in $(find /sys/ -name enable_event_log); do echo "0" > $i; done
for i in $(find /sys/ -name log_ecn_error); do echo "0" > $i; done
for i in $(find /sys/ -name snapshot_crashdumper); do echo "0" > $i; done
echo "0" > /sys/module/logger/parameters/log_mode
echo "0" > /sys/kernel/logger_mode/logger_mode

fi




for i in $(find /sys/block - type l) ; do
echo 31 > $i/device/queue_depth ; done

### CLR-POWER-TWEAKS

echo 50 > /proc/sys/vm/dirty_ratio  
echo 1 > /proc/sys/kernel/unprivileged_bpf_disabled 

## start IO at 5% not 1%... start IO a little earlier asynchronously since memory sizes are bigger now
echo 40 > /proc/sys/vm/dirty_background_ratio 
## 15 seconds before the VM starts writeback allowing the FS to deal with this better
#echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
#echo 10 > /proc/sys/vm/swappiness 
echo 30000 > /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs
echo 0 > /sys/devices/virtual/graphics/fbcon/cursor_blink  
#echo 0 > /sys/kernel/rcu_expedited  
echo 65536 > /proc/sys/vm/mmap_min_addr  

## oom less
echo 100 > /proc/sys/vm/extfrag_threshold  
echo 4000 > /sys/kernel/mm/ksm/sleep_millisecs 

## w /sys/kernel/mm/ksm/run - - - - 
echo 1000 > /sys/kernel/mm/ksm/pages_to_scan 
#echo 1703936 > /proc/sys/net/core/rmem_max  
#echo 1703936 > /proc/sys/net/core/wmem_max  
echo 1 > /proc/sys/net/core/high_order_alloc_disable 

## This tuneable decides the minimum time a task will be be allowed to
## run on CPU before being pre-empted out
echo 2250000 > /proc/sys/kernel/sched_min_granularity_ns 
echo 50000 > /proc/sys/kernel/sched_migration_cost_ns 

## Ability of tasks being woken to preempt the current task
echo 15000000 > /proc/sys/kernel/sched_wakeup_granularity_ns 

## sched_autogroup would improve interactive desktop performance in the face of
## multi‐ process CPU-intensive workloads. Whereas it would harm performance
## thus disable it on Server
echo 0 > /proc/sys/kernel/sched_autogroup_enabled  

## audio pm
echo 1 > /sys/module/snd_hda_intel/parameters/power_save 

## P state stuff
#echo performance > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 

## we want at least half performance this helps us in race-to-halt and
## to give us reasonable responses
echo 50 > /sys/devices/system/cpu/intel_pstate/min_perf_pct 
#echo fq > /proc/sys/net/core/default_qdisc 

## Disable acceptance of all ICMP redirected packets on all interfaces.
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects  
echo 0 > /proc/sys/net/ipv6/conf/all/accept_redirects  
echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects  
echo 0 > /proc/sys/net/ipv6/conf/default/accept_redirects  

## Disables sending of all IPv4 ICMP redirected packets on all interfaces.
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects  
echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects  

## Disables acceptance of secure ICMP redirected packets on all interfaces.
echo 0 > /proc/sys/net/ipv4/conf/all/secure_redirects  
echo 0 > /proc/sys/net/ipv4/conf/default/secure_redirects  

## SATA link power management
echo med_power_with_dipm > /sys/class/scsi_host/*/link_power_management_policy  

## Performance tuning for SATA and NVME storage
#echo bfq > /sys/block/sd*/queue/scheduler  
echo 4096 > /sys/block/sd*/queue/nr_requests 
#echo 1024 > /sys/block/sd*/queue/read_ahead_kb  
echo 1 > /sys/block/sd*/queue/add_random 

## For server prefer mq-deadline to max throughput
#echo mq-deadline > /sys/block/nvme*/queue/scheduler 

## For desktop prefer bfq low_latency
#echo bfq > /sys/block/nvme*/queue/scheduler
echo 1 > /sys/block/nvme*/queue/iosched/low_latency

#echo 2048 > /sys/block/nvme*/queue/nr_requests 
#echo 1024 > /sys/block/nvme*/queue/read_ahead_kb 
#echo 1 > /sys/block/nvme*/queue/add_random 

## Enable turbo mode max
echo 1 > /proc/sys/kernel/sched_itmt_enabled 

## Reload the microcode at boot (disabled)
echo 0 > /sys/devices/system/cpu/microcode/reload 
echo performance > /sys/devices/system/cpu/cpu/power/energy_perf_bias   

echo 0 > /proc/sys/kernel/nmi_watchdog  
echo 0 > /sys/block/sdmmcnvme*/queue/iosched/slice_idle 




### io scheduler, governor and more
#scheduler
if [ ! -f  $droidprop ] ; then
# nvme
for i in $(find /sys/block -type l); do
  echo "$sched" > $i/queue/scheduler;
  echo "1" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "4096" > $i/queue/nr_requests
  echo "8192" > $i/queue/read_ahead_kb
  echo "0" > $i/queue/rotational
  echo "2" > $i/queue/rq_affinity
  echo "write through" > $i/queue/write_cache
  echo "4" > $i/queue/iosched/quantum
  echo "80" > $i/queue/iosched/fifo_expire_sync
  echo "330" > $i/queue/iosched/fifo_expire_async
  echo "12582912" > $i/queue/iosched/back_seek_max
  echo "1" > $i/queue/iosched/back_seek_penalty
  echo "60" > $i/queue/iosched/slice_sync
  echo "50" > $i/queue/iosched/slice_async
  echo "2" > $i/queue/iosched/slice_async_rq
  echo "0" > $i/queue/iosched/slice_idle
  echo "0" > $i/queue/iosched/group_idle
  echo "1" > $i/queue/iosched/low_latency
  echo "150" > $i/queue/iosched/target_latency
  echo "0" > $i/queue/iosched/slice_idle_us
  echo "0" > $i/queue/iosched/strict_guarantees
  echo "10" > $i/queue/iosched/timeout_sync
  echo "0" > $i/queue/iosched/max_budget
#echo "0" > $i/queue/chunk_sectors
#echo "0" > $i/queue/dax
#echo "0" > $i/queue/discard_granularity
#echo "0" > $i/queue/discard_max_bytes
#echo "0" > $i/queue/discard_max_hw_bytes
#echo "0" > $i/queue/discard_zeroes_data
#echo "0" > $i/queue/dma_alignment
#echo "0" > $i/queue/fua
#echo "0" > $i/queue/hw_sector_size
#echo "0" > $i/queue/io_poll_delay
#echo "0" > $i/queue/io_timeout
#echo "0" > $i/queue/logical_block_size
#echo "0" > $i/queue/max_discard_segments
#echo "0" > $i/queue/max_hw_sectors_kb
#echo "0" > $i/queue/max_integrity_segments
#echo "0" > $i/queue/max_sectors_kb
#echo "0" > $i/queue/max_segments
#echo "0" > $i/queue/max_segment_size
#echo "0" > $i/queue/minimum_io_size
#echo "0" > $i/queue/nr_zones
#echo "0" > $i/queue/optimal_io_size
#echo "0" > $i/queue/physical_block_size
#echo "0" > $i/queue/stable_writes
#echo "0" > $i/queue/virt_boundary_mask
#echo "0" > $i/queue/wbt_lat_usec
#echo "0" > $i/queue/write_same_max_bytes
#echo "0" > $i/queue/write_zeroes_max_bytes
#echo "0" > $i/queue/zone_append_max_bytes
#echo "0" > $i/queue/zoned
#echo "0" > $i/queue/zone_write_granularity
done;

# ssd hdd
for i in $(find /sys/block/sd*); do
  echo "$sdsched" > $i/queue/scheduler;
  echo "1" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "4096" > $i/queue/nr_requests
  echo "8192" > $i/queue/read_ahead_kb
  echo "0" > $i/queue/rotational
  echo "2" > $i/queue/rq_affinity
  echo "write through" > $i/queue/write_cache
  echo "4" > $i/queue/iosched/quantum
  echo "80" > $i/queue/iosched/fifo_expire_sync
  echo "330" > $i/queue/iosched/fifo_expire_async
  echo "12582912" > $i/queue/iosched/back_seek_max
  echo "1" > $i/queue/iosched/back_seek_penalty
  echo "60" > $i/queue/iosched/slice_sync
  echo "50" > $i/queue/iosched/slice_async
  echo "2" > $i/queue/iosched/slice_async_rq
  echo "0" > $i/queue/iosched/slice_idle
  echo "0" > $i/queue/iosched/group_idle
  echo "1" > $i/queue/iosched/low_latency
  echo "150" > $i/queue/iosched/target_latency
  echo "5" > $i/queue/iosched/slice_idle_us
  echo "0" > $i/queue/iosched/strict_guarantees
  echo "10" > $i/queue/iosched/timeout_sync
  echo "0" > $i/queue/iosched/max_budget
#echo "0" > $i/queue/chunk_sectors
#echo "0" > $i/queue/dax
#echo "0" > $i/queue/discard_granularity
#echo "0" > $i/queue/discard_max_bytes
#echo "0" > $i/queue/discard_max_hw_bytes
#echo "0" > $i/queue/discard_zeroes_data
#echo "0" > $i/queue/dma_alignment
#echo "0" > $i/queue/fua
#echo "0" > $i/queue/hw_sector_size
#echo "0" > $i/queue/io_poll_delay
#echo "0" > $i/queue/io_timeout
#echo "0" > $i/queue/logical_block_size
#echo "0" > $i/queue/max_discard_segments
#echo "0" > $i/queue/max_hw_sectors_kb
#echo "0" > $i/queue/max_integrity_segments
#echo "0" > $i/queue/max_sectors_kb
#echo "0" > $i/queue/max_segments
#echo "0" > $i/queue/max_segment_size
#echo "0" > $i/queue/minimum_io_size
#echo "0" > $i/queue/nr_zones
#echo "0" > $i/queue/optimal_io_size
#echo "0" > $i/queue/physical_block_size
#echo "0" > $i/queue/stable_writes
#echo "0" > $i/queue/virt_boundary_mask
#echo "0" > $i/queue/wbt_lat_usec
#echo "0" > $i/queue/write_same_max_bytes
#echo "0" > $i/queue/write_zeroes_max_bytes
#echo "0" > $i/queue/zone_append_max_bytes
#echo "0" > $i/queue/zoned
#echo "0" > $i/queue/zone_write_granularity
done;
fi
# mtd
for i in $(find /sys/block/mtd*); do
  echo "$mtdsched" > $i/queue/scheduler;
  echo "1" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "4096" > $i/queue/nr_requests
  echo "4096" > $i/queue/read_ahead_kb
  echo "0" > $i/queue/rotational
  echo "2" > $i/queue/rq_affinity
  echo "write through" > $i/queue/write_cache
  echo "4" > $i/queue/iosched/quantum
  echo "80" > $i/queue/iosched/fifo_expire_sync
  echo "330" > $i/queue/iosched/fifo_expire_async
  echo "12582912" > $i/queue/iosched/back_seek_max
  echo "1" > $i/queue/iosched/back_seek_penalty
  echo "60" > $i/queue/iosched/slice_sync
  echo "50" > $i/queue/iosched/slice_async
  echo "2" > $i/queue/iosched/slice_async_rq
  echo "0" > $i/queue/iosched/slice_idle
  echo "0" > $i/queue/iosched/group_idle
  echo "1" > $i/queue/iosched/low_latency
  echo "150" > $i/queue/iosched/target_latency
  echo "10" > $i/queue/iosched/slice_idle_us
  echo "0" > $i/queue/iosched/strict_guarantees
  echo "10" > $i/queue/iosched/timeout_sync
  echo "0" > $i/queue/iosched/max_budget
#echo "0" > $i/queue/chunk_sectors
#echo "0" > $i/queue/dax
#echo "0" > $i/queue/discard_granularity
#echo "0" > $i/queue/discard_max_bytes
#echo "0" > $i/queue/discard_max_hw_bytes
#echo "0" > $i/queue/discard_zeroes_data
#echo "0" > $i/queue/dma_alignment
#echo "0" > $i/queue/fua
#echo "0" > $i/queue/hw_sector_size
#echo "0" > $i/queue/io_poll_delay
#echo "0" > $i/queue/io_timeout
#echo "0" > $i/queue/logical_block_size
#echo "0" > $i/queue/max_discard_segments
#echo "0" > $i/queue/max_hw_sectors_kb
#echo "0" > $i/queue/max_integrity_segments
#echo "0" > $i/queue/max_sectors_kb
#echo "0" > $i/queue/max_segments
#echo "0" > $i/queue/max_segment_size
#echo "0" > $i/queue/minimum_io_size
#echo "0" > $i/queue/nr_zones
#echo "0" > $i/queue/optimal_io_size
#echo "0" > $i/queue/physical_block_size
#echo "0" > $i/queue/stable_writes
#echo "0" > $i/queue/virt_boundary_mask
#echo "0" > $i/queue/wbt_lat_usec
#echo "0" > $i/queue/write_same_max_bytes
#echo "0" > $i/queue/write_zeroes_max_bytes
#echo "0" > $i/queue/zone_append_max_bytes
#echo "0" > $i/queue/zoned
#echo "0" > $i/queue/zone_write_granularity
done;

# mmc
for i in $(find /sys/block/mmc*); do
  echo "$mmcsched" > $i/queue/scheduler;
  echo "1" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "4096" > $i/queue/nr_requests
  echo "2048" > $i/queue/read_ahead_kb
  echo "0" > $i/queue/rotational
  echo "2" > $i/queue/rq_affinity
  echo "write through" > $i/queue/write_cache
  echo "4" > $i/queue/iosched/quantum
  echo "80" > $i/queue/iosched/fifo_expire_sync
  echo "330" > $i/queue/iosched/fifo_expire_async
  echo "12582912" > $i/queue/iosched/back_seek_max
  echo "1" > $i/queue/iosched/back_seek_penalty
  echo "60" > $i/queue/iosched/slice_sync
  echo "50" > $i/queue/iosched/slice_async
  echo "2" > $i/queue/iosched/slice_async_rq
  echo "0" > $i/queue/iosched/slice_idle
  echo "0" > $i/queue/iosched/group_idle
  echo "1" > $i/queue/iosched/low_latency
  echo "150" > $i/queue/iosched/target_latency
  echo "5" > $i/queue/iosched/slice_idle_us
  echo "0" > $i/queue/iosched/strict_guarantees
  echo "10" > $i/queue/iosched/timeout_sync
  echo "0" > $i/queue/iosched/max_budget
#echo "0" > $i/queue/chunk_sectors
#echo "0" > $i/queue/dax
#echo "0" > $i/queue/discard_granularity
#echo "0" > $i/queue/discard_max_bytes
#echo "0" > $i/queue/discard_max_hw_bytes
#echo "0" > $i/queue/discard_zeroes_data
#echo "0" > $i/queue/dma_alignment
#echo "0" > $i/queue/fua
#echo "0" > $i/queue/hw_sector_size
#echo "0" > $i/queue/io_poll_delay
#echo "0" > $i/queue/io_timeout
#echo "0" > $i/queue/logical_block_size
#echo "0" > $i/queue/max_discard_segments
#echo "0" > $i/queue/max_hw_sectors_kb
#echo "0" > $i/queue/max_integrity_segments
#echo "0" > $i/queue/max_sectors_kb
#echo "0" > $i/queue/max_segments
#echo "0" > $i/queue/max_segment_size
#echo "0" > $i/queue/minimum_io_size
#echo "0" > $i/queue/nr_zones
#echo "0" > $i/queue/optimal_io_size
#echo "0" > $i/queue/physical_block_size
#echo "0" > $i/queue/stable_writes
#echo "0" > $i/queue/virt_boundary_mask
#echo "0" > $i/queue/wbt_lat_usec
#echo "0" > $i/queue/write_same_max_bytes
#echo "0" > $i/queue/write_zeroes_max_bytes
#echo "0" > $i/queue/zone_append_max_bytes
#echo "0" > $i/queue/zoned
#echo "0" > $i/queue/zone_write_granularity
done;

for i in $(echo sd*[!0-9] ; echo hd*[!0-9] ; echo nvme*[!0-9]) ; do
echo 32 | tee /sys/block/$i/queue/iosched/fifo_batch ; done




echo 'options usbhid mousepoll=4' | tee /etc/modprobe.d/usbhid.conf

#if $(! grep -q "options processor ignore_ppc=1" /etc/modprobe.d/ignore_ppc.conf) ; then
#echo 'options processor ignore_ppc=1' | tee /etc/modprobe.d/ignore_ppc.conf ; fi


if $(! grep -q acpi-cpufreq /etc/modules) ; then
echo acpi-cpufreq >> /etc/modules ; fi

if $(! grep -q "options acpi-cpufreq force=1" /etc/modprobe.d/acpi-cpufreq.modprobe) ; then
echo "options acpi-cpufreq force=1" >> /etc/modprobe.d/acpi-cpufreq.modprobe ; fi
cpufreq-set -r -g $governor
cpupower frequency-set -g $governor

echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo 1 > /sys/devices/system/cpu/cpufreq/boost
x86_energy_perf_policy --all 1 --force
x86_energy_perf_policy --turbo-enable 1 --force
x86_energy_perf_policy --hwp-enable --force

echo $governor > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# governor
for i in $(find /sys/devices/system/cpu/cpufreq); do
  echo "$governor" > $i/scaling_governor;
done;

echo "$governor" > /sys/module/cpufreq/parameters/default_governor
echo "GOVERNOR="$governor"" | tee /etc/default/cpufrequtils

if [ $level = high ] ; then 
# more
chmod 666 /sys/module/workqueue/parameters/power_efficient
chown root /sys/module/workqueue/parameters/power_efficient
bash -c 'echo "N"  > /sys/module/workqueue/parameters/power_efficient'
echo "N" > /sys/module/workqueue/parameters/power_efficient
echo "deep" > /sys/power/mem_sleep



#
echo 0 > /proc/sys/kernel/task_delayacct
echo 0 > /proc/sys/kernel/ftrace_enabled
echo 0 > /proc/sys/kernel/bpf_stats_enabled
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
echo 0 > /proc/sys/kernel/stack_tracer_enabled
echo 0 > /proc/sys/kernel/nmi_watchdog
echo $ksm > /sys/kernel/mm/ksm/run
echo "1" > /sys/kernel/rcu_expedited
echo "0" > /sys/kernel/rcu_normal
echo "512" > /proc/sys/kernel/random/read_wakeup_threshold
echo "96" > /proc/sys/kernel/random/urandom_min_reseed_secs
echo "1024" > /proc/sys/kernel/random/write_wakeup_threshold
sysctl -e -w kernel.random.read_wakeup_threshold=512
sysctl -e -w kernel.random.write_wakeup_threshold=1024
sysctl -e -w kernel.random.urandom_min_reseed_secs=96
echo 1 > /proc/sys/kernel/sched_child_runs_first
echo 0 > /proc/sys/kernel/sched_autogroup_enabled
echo 500 > /proc/sys/kernel/sched_cfs_bandwidth_slice_us
echo 40000 > /sys/kernel/debug/sched/latency_ns
echo 50000 > /sys/kernel/debug/sched/migration_cost_ns
echo 2250000 > /sys/kernel/debug/sched/min_granularity_ns
echo 15000000 > /sys/kernel/debug/sched/wakeup_granularity_ns
echo 128 > /sys/kernel/debug/sched/nr_migrate

# different path under 5.10
sysctl -w kernel.sched_scaling_enable=1
sysctl /proc/sys/kernel/sched_scaling_enable=1
sysctl /proc/sys/kernel/sched_tunable_scaling=0
sysctl /proc/sys/kernel/sched_child_runs_first=1
sysctl /proc/sys/kernel/sched_min_granularity_ns=2250000
sysctl /proc/sys/kernel/sched_wakeup_granularity_ns=15000000
sysctl /proc/sys/kernel/sched_latency_ns=40000
sysctl /proc/sys/kernel/debug/sched/scaling_enable=1
sysctl /proc/sys/kernel/debug/sched/tunable_scaling=0
sysctl /proc/sys/kernel/debug/sched/child_runs_first=1
sysctl /proc/sys/kernel/debug/sched/min_granularity_ns=2250000
sysctl /proc/sys/kernel/debug/sched/wakeup_granularity_ns=5000000
sysctl /proc/sys/kernel/debug/sched/latency_ns=40000
echo '0' > /sys/kernel/debug/tunable_scaling
echo '2250000' > /sys/kernel/debug/sched/min_granularity_ns
echo '5000000' > /sys/kernel/debug/sched/wakeup_granularity_ns
echo '40000' > /sys/kernel/debug/sched/latency_ns
echo 0 > /proc/sys/kernel/debug/sched/min_task_util_for_colocation
echo 128 > /proc/sys/kernel/debug/sched/nr_migrate
echo 0 > /proc/sys/kernel/sched_min_task_util_for_colocation
echo 128 > /proc/sys/kernel/sched_nr_migrate
echo off > /proc/sys/kernel/printk_devkmsg

echo "15000" > /sys/power/pm_freeze_timeout

echo 0 > /d/tracing/events/ext4/enable
echo 0 > /d/tracing/events/xfs/enable
echo 0 > /d/tracing/events/f2fs/enable
echo 0 > /d/tracing/events/block/enable
echo 0 > /sys/kernel/debug/tracing/events/ext4/enable
echo 0 > /sys/kernel/debug/tracing/events/xfs/enable
echo 0 > /sys/kernel/debug/tracing/events/f2fs/enable
echo 0 > /sys/kernel/debug/tracing/events/block/enable

fi

# some paths changed since 5.10 so double
# there are more than listed here though:
# https://github.com/torvalds/linux/blob/master/kernel/sched/features.h
for i in /sys/kernel/debug/sched/ /sys/kernel/debug/sched_ ; do
echo START_DEBIT >> "$i"features
echo LAST_BUDDY >> "$i"features
echo CACHE_HOT_BUDDY >> "$i"features
echo NO_HRTICK >> "$i"features
echo NO_HRTICK_DL >> "$i"features
echo NO_DOUBLE_TICK >> "$i"features
echo NONTASK_CAPACITY >> "$i"features
echo NO_TTWU_QUEUE >> "$i"features
echo NO_SIS_PROP >> "$i"features
echo SIS_UTIL >> "$i"features
echo NO_WARN_DOUBLE_CLOCK >> "$i"features
echo RT_PUSH_IPI >> "$i"features
echo NO_RT_RUNTIME_SHARE >> "$i"features
echo LB_MIN >> "$i"features
echo ATTACH_AGE_LOAD >> "$i"features
echo WA_IDLE >> "$i"features
echo WA_WEIGHTv >> "$i"features
echo WA_BIAS >> "$i"features
echo UTIL_EST >> "$i"features
echo UTIL_EST_FASTUP >> "$i"features
echo NO_LATENCY_WARN >> "$i"features
echo ALT_PERIOD >> "$i"features
echo BASE_SLICE >> "$i"features
echo NO_FBT_STRICT_ORDER >> "$i"features
echo NEXT_BUDDY >> "$i"features
echo NO_GENTLE_FAIR_SLEEPERS >> "$i"features
echo NO_LB_BIAS >> "$i"features
echo NO_ENERGY_AWARE >> "$i"features
echo WAKEUP_PREEMPTION >> "$i"features
echo AFFINE_WAKEUPS  >> "$i"features
echo NO_NORMALIZED_SLEEPERS >> "$i"features
echo RT_RUNTIME_GREED >> "$i"features
echo ARCH_POWER >> "$i"features
echo NO_FORCE_SD_OVERLAP >> "$i"features
echo NO_NEW_FAIR_SLEEPERS >> "$i"features
echo NONTASK_POWER >> "$i"features
echo NO_OWNER_SPIN >> "$i"features
echo NO_WAKEUP_OVERLAP >> "$i"features
echo ARCH_CAPACITY >> "$i"features
echo NO_MIN_CAPACITY_CAPPING >> "$i"features
echo N > "$i"debug
#echo ? > "$i"idle_min_granularity_ns
echo 40000 > "$i"latency_ns
#echo ? > "$i"latency_warn_ms
#echo ? > "$i"latency_warn_once
echo 50000 > "$i"migration_cost_ns
echo 2250000 > "$i"min_granularity_ns
echo 128 > "$i"nr_migrate
echo full > "$i"preempt
echo 0 > "$i"tunable_scaling
echo N > "$i"verbose
echo 5000000 > "$i"wakeup_granularity_ns
#echo ? > "$i"cpu*
#echo ? > "$i"hot_threshold_ms
#echo ? > "$i"scan_delay_ms
#echo ? > "$i"scan_period_max_ms
#echo ? > "$i"scan_period_min_ms
#echo ? > "$i"scan_size_mb
done

if [ -f $droidprop ] && $(! grep -q tv $droidprop) ; then
for i in /sys/kernel/debug/sched/ /sys/kernel/debug/sched_ ; do
echo ENERGY_AWARE >> "$i"features ; done ; fi

echo 3 > /sys/bus/workqueue/devices/writeback/cpumask
echo 3 > /sys/devices/virtual/workqueue/cpumask

#echo 2 > /proc/irq/49/smp_affinity
#echo 2 > /proc/irq/50/smp_affinity
### fs & vm etc
echo 1 > /proc/sys/vm/page_lock_unfairness
echo 0 > /proc/sys/vm/zone_reclaim_mode
echo $overcommit > /proc/sys/vm/overcommit_memory
echo $oratio > /proc/sys/vm/overcommit_ratio
echo "1" /proc/sys/fs/leases-enable
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time
echo "1" > /proc/sys/vm/compact_unevictable_allowed
#echo "40" > /proc/sys/vm/dirty_background_ratio
echo "500" > /proc/sys/vm/dirty_expire_centisecs
#echo "50" > /proc/sys/vm/dirty_ratio
echo "1000" > /proc/sys/vm/dirty_writeback_centisecs
echo "1" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "60" > /proc/sys/vm/stat_interval
echo $cpress > /proc/sys/vm/vfs_cache_pressure
echo $swappiness > /proc/sys/vm/swappiness
echo 0 > /proc/sys/vm/compaction_proactiveness
sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0
sysctl fs.file-max=2097152
sysctl fs.xfs.xfssyncd_centisecs=30000


# lmk
echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "1" > /sys/module/lowmemorykiller/parameters/lmk_fast_run
echo "1" > /sys/module/lowmemorykiller/parameters/oom_reaper
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo '2181,2908,3636,4363,5090,6181' > /sys/module/lowmemorykiller/parameters/minfree



sysctl kernel.ftrace_enabled=0




sysctl fs.file-max=2097152







### < NETWORK INTERFACES > - will automatically apply to present devices no need for manual application
# - interfaces - interfaces vary across devices make sure to scroll down and check your ifconfig for double check left many values intentionally
#iface="$(ifconfig | grep "UP\|RUNNING" | awk '{print $1}' | grep ':' | tr -d ':' | grep -v lo)"
#iface="$(ifconfig | awk '{print $1}' | grep -v "UP\|RX\|inet\|TX\|collisions\|Interrupt\|lo\|ether" | tr -d ':' )"
#iface=$(ip link | grep 'UP\,LOWER_UP' | grep -v lo | awk '{print $2}' | sed 's/:\+$//;s/\@.*//')
#iface="$(ifconfig | grep 'flags\|Link' | grep -v lo | awk '{print $1}' | sed 's/:\+$//;s/\@.*//')"
#iface=$(ip -o link | awk -F ':' '{print $2}')

iw reg set $country
iw reg reload
echo $country > /sys/module/cfg80211/parameters/ieee80211_regdom

echo $qdisc > /proc/sys/net/core/default_qdisc

ethtool -K tx-checksum-ipv4 $fl
ethtool -K tx-checksum-ipv6 $fl


iface=$(ip -o link | awk '{print $2}' | sed 's/:\+$//;s/\@.*//')
for i in $iface ; do
macchanger -rbe $i
ethtool -s $i wol d
ethtool -G $i rx $rx tx $tx
ethtool -K $i rx $fl tx $fl sg $fl tso $fl ufo $fl gso $fl gro $fl lro $fl rxvlan $fl txvlan $fl rxhash $fl ntuple $fl
ethtool -s $i duplex $duplex autoneg $autoneg
ethtool --negotiate $i
ethtool -r $i
iw dev $i set beacon_int $beacons
iw dev $i set txpwr $txpower
iw dev $i set power_save $pwrsave
iwconfig $i txpower $txpower
iwconfig $i power $pwrsave
iwconfig $i rts $rts
iwconfig $i frag $frag
iwconfig $i commit ; done


if ip -o link | grep -q wlan ; then
for i in wlan0 wlan1 phy0-ap0 phy0-ap1 ; do
iw dev $i set beacon_int $beacons
iw dev $i set txpwr $txpower
iw dev $i set power_save $pwrsave ; done

for i in phy0 phy1 ; do
iw phy $i set beacon_int $beacons
iw phy $i set txpwr $txpower
iw phy $i set power_save $pwrsave
iw phy $i set distance $distance
iw phy $i set rts $rts
iw phy $i set frag $frag ; done ; fi

if $linux ; then
ether=$(ip -o link | grep -v ppp | grep ether | awk '{print $2}' |  sed 's/:\+$//;s/\@.*//')
for i in $ether ; do
ifconfig $ether mtu $mtu ; done ; fi

for i in $(find /sys/class/net -type l); do
  echo $txqueuelen > $i/tx_queue_len;
done;

wl -i $iface
ifconfig $iface txqueuelen $txqueuelen

# skip disk defragment & fstrim on every boot
#xfs_fsr $rootfs
#fstrim /
touch /etc/rc.local
touch /etc/sysctl.conf


sysctl -w kernel.sched_schedstats=0







if [ $level = high ] && [ $firstrun = yes ] ; then 



### SYSCTL.CONF IN SAME FILE
### values for sysctl.conf ( /etc/sysctl.conf is a replica of /etc/rc.local and bound to it as well just for convenience)
if $(! $wrt) ; then
sysc32="abi.vsyscall32 = 0"
fi

if [ $cpumaxcstate = 0 ] ; then
flat='force_latency = 1'
fi


echo '# sysctl

#
# more
'"$flat"'
'"$sysc32"'
kernel.shmall = '"$shmall"'
kernel.shmmax = '"$shmmax"'
kernel.shmmni = '"$shmmni"'
#vm.nr_hugepages = '"$hugepages"'
vm.nr_hugepages_mempolicy = '"$hugepages"'

crypto.fips_enabled = 1
debug.exception-trace = 0
debug.kprobes-optimization = 1
dev.cdrom.debug = 0
#dev.hpet.max-user-freq = 64
dev.i915.perf_stream_paranoid = 0
dev.scsi.logging_level = 0
dev.tty.ldisc_autoload = 1
energy_perf_bias = performance

fs.aio-max-nr = 1048576
fs.binfmt_misc.status = enabled
fs.dentry-state = 65495 42448   45      0       39102   0
fs.dir-notify-enable = 0
fs.epoll.max_user_watches = 435556
fs.fanotify.max_queued_events = 16384
fs.fanotify.max_user_groups = 128
fs.fanotify.max_user_marks = 15849
fs.file-max = 2097152
fs.file-nr = 7328	0	2097152
fs.inode-nr = 68180	78
fs.inode-state = 68180	78	0	0	0	0	0
fs.inotify.max_queued_events = 16384
fs.inotify.max_user_instances = 128
fs.inotify.max_user_watches = 14905
fs.lease-break-time = 20
fs.leases-enable = 1
fs.mount-max = 100000
fs.mqueue.msg_default = 10
fs.mqueue.msg_max = 10
fs.mqueue.msgsize_default = 8192
fs.mqueue.msgsize_max = 8192
fs.mqueue.queues_max = 256
fs.nr_open = 1048576
fs.pipe-max-size = 1048576
fs.pipe-user-pages-hard = 0
fs.pipe-user-pages-soft = 16384
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
fs.quota.allocated_dquots = 0
fs.quota.cache_hits = 0
fs.quota.drops = 0
fs.quota.free_dquots = 0
fs.quota.lookups = 0
fs.quota.reads = 0
fs.quota.syncs = 0
fs.quota.warnings = 1
fs.quota.writes = 0
fs.suid_dumpable = 0
fs.verity.require_signatures = 0
fs.xfs.error_level = 0
fs.xfs.filestream_centisecs = 30000
fs.xfs.inherit_noatime = 1
fs.xfs.inherit_nodefrag = 0
fs.xfs.inherit_nodump = 1
fs.xfs.inherit_nosymlinks = 0
fs.xfs.inherit_sync = 1
fs.xfs.irix_sgid_inherit = 0
fs.xfs.irix_symlink_mode = 0
fs.xfs.panic_mask = 0
fs.xfs.rotorstep = 1
fs.xfs.speculative_cow_prealloc_lifetime = 300
fs.xfs.speculative_prealloc_lifetime = 300
fs.xfs.stats_clear = 1
fs.xfs.xfssyncd_centisecs = 30000
fs.xfs.xfsbufd_centisecs = 3000
governor = '"$governor"'
kernel.acct = 4 2       30
kernel.acpi_video_flags = 0
kernel.apparmor_display_secid_mode = 0
kernel.auto_msgmni = 0
kernel.bpf_stats_enabled = 0
kernel.cad_pid = 1
kernel.cap_last_cap = 40
kernel.core_pipe_limit = 0
kernel.core_uses_pid = 1
kernel.ctrl-alt-del = 0
kernel.dmesg_restrict = 1
kernel.domainname = none
kernel.firmware_config.force_sysfs_fallback = 0
kernel.firmware_config.ignore_sysfs_fallback = 0
kernel.ftrace_dump_on_oops = 0
kernel.ftrace_enabled = 0
kernel.hardlockup_all_cpu_backtrace = 0
kernel.hardlockup_panic = 0
kernel.hung_task_all_cpu_backtrace = 0
kernel.hung_task_check_count = 4194304
kernel.hung_task_check_interval_secs = 0
kernel.hung_task_panic = 0
kernel.hung_task_timeout_secs = 0
kernel.hung_task_warnings = 10
kernel.io_delay_type = 3
kernel.kexec_load_disabled = 0
kernel.keys.gc_delay = 300
kernel.keys.maxbytes = 20000
kernel.keys.maxkeys = 200
kernel.keys.persistent_keyring_expiry = 259200
kernel.keys.root_maxbytes = 25000000
kernel.keys.root_maxkeys = 1000000
kernel.kptr_restrict = 0
kernel.max_lock_depth = 1024
kernel.max_rcu_stall_to_panic = 0
kernel.modprobe = /sbin/modprobe
kernel.modules_disabled = 0
kernel.msg_next_id = -1
kernel.msgmax = 8192
kernel.msgmnb = 16384
kernel.msgmni = 32000
kernel.ngroups_max = 65536
kernel.nmi_watchdog = 0
kernel.ns_last_pid = 12630
kernel.numa_balancing = 0
kernel.numa_balancing_promote_rate_limit_MBps = 65536
kernel.oops_all_cpu_backtrace = 0
kernel.ostype = Linux
kernel.overflowgid = 65534
kernel.panic = 0
kernel.panic_on_io_nmi = 0
kernel.panic_on_oops = 0
kernel.panic_on_rcu_stall = 0
kernel.panic_on_unrecovered_nmi = 0
kernel.panic_on_warn = 0
kernel.panic_print = 0
kernel.perf_cpu_time_max_percent = 10
kernel.perf_event_max_contexts_per_stack = 8
kernel.perf_event_max_sample_rate = 100000
kernel.perf_event_max_stack = 127
kernel.perf_event_mlock_kb = 516
kernel.perf_event_paranoid = -1
kernel.pid_max = 4194304
kernel.poweroff_cmd = /sbin/poweroff
kernel.print-fatal-signals = 0
kernel.printk = 0       0       0       0
kernel.printk_delay = 0
kernel.printk_devkmsg = off
kernel.printk_ratelimit = 5
kernel.printk_ratelimit_burst = 10
kernel.pty.max = 4096
kernel.pty.nr = 2
kernel.pty.reserve = 1024
kernel.random.entropy_avail = 4096
kernel.random.poolsize = 4096
kernel.random.urandom_min_reseed_secs = 96
kernel.random.write_wakeup_threshold = 1024
kernel.randomize_va_space = '"$ranvasp"'
kernel.real-root-dev = 0
kernel.sched_autogroup_enabled = 0
kernel.sched_cfs_bandwidth_slice_us = 500
kernel.sched_child_runs_first = 1
kernel.sched_compat_yield = 0
kernel.sched_deadline_period_max_us = 500000
kernel.sched_deadline_period_min_us = 100
kernel.sched_energy_aware = 0
kernel.sched_latency_ns = 40000
kernel.sched_migration_cost_ns = 50000
kernel.sched_min_granularity_ns = 2250000
kernel.sched_min_task_util_for_colocation = 0
kernel.sched_nr_migrate = 128
kernel.sched_rr_timeslice_ms = -1
kernel.sched_rt_period_us = -1
kernel.sched_rt_runtime_us = -1
kernel.sched_scaling_enable = 1
kernel.sched_schedstats = 0
kernel.sched_tunable_scaling = 0
kernel.sched_wakeup_granularity_ns = 15000000
kernel.sem = 32000      1024000000      500     32000
kernel.shm_next_id = -1
kernel.shm_rmid_forced = 0
kernel.soft_watchdog = 0
kernel.softlockup_all_cpu_backtrace = 0
kernel.softlockup_panic = 0
kernel.stack_tracer_enabled = 0
kernel.sysctl_writes_strict = 1
kernel.sysrq = 0
kernel.tainted = 0
kernel.task_delayacct = 0
kernel.threads-max = 12800
kernel.timer_migration = 0
kernel.traceoff_on_warning = 0
kernel.tracepoint_printk = 0
kernel.unknown_nmi_panic = 0
kernel.unprivileged_bpf_disabled = 2
kernel.unprivileged_userns_apparmor_policy = 1
kernel.unprivileged_userns_clone = 1
kernel.usermodehelper.bset = 4294967295 511
kernel.usermodehelper.inheritable = 4294967295  511
kernel.watchdog = 0
kernel.watchdog_cpumask = 0-'"$(nproc --all)"'
kernel.watchdog_thresh = 60
kernel.yama.ptrace_scope = 0
min_perf_pct = 100
net.core.default_qdisc = '"$qdisc"'
net.ipv4.tcp_congestion_control = '"$tcp_con"'
#user.max_cgroup_namespaces = 7642
#user.max_fanotify_groups = 128
#user.max_fanotify_marks = 15849
#user.max_inotify_instances = 128
#user.max_inotify_watches = 14905
#user.max_ipc_namespaces = 7642
#user.max_mnt_namespaces = 7642
#user.max_net_namespaces = 7642
#user.max_pid_namespaces = 7642
#user.max_time_namespaces = 7642
#user.max_user_namespaces = 7642
#user.max_uts_namespaces = 7642
vm.admin_reserve_kbytes = 8192
vm.block_dump = 0
vm.compact_unevictable_allowed = 1
vm.compaction_proactiveness = 0
vm.dirty_background_ratio = 40
vm.dirty_expire_centisecs = 500
vm.dirty_ratio = 50
vm.dirty_writeback_centisecs = 1000
#vm.dirtytime_expire_seconds = 43200
vm.extfrag_threshold = 750
vm.hugetlb_optimize_vmemmap = 1
vm.hugetlb_shm_group = 1
vm.laptop_mode = 0
vm.legacy_va_layout = 0
vm.lowmem_reserve_ratio = 8   4     2      0       0
vm.max_map_count = 8192000
vm.memory_failure_early_kill = 1
vm.memory_failure_recovery = 1
vm.min_free_kbytes = 5571
vm.min_slab_ratio = 30
vm.min_unmapped_ratio = 1
vm.mmap_min_addr = 65536
vm.mmap_rnd_bits = 28
vm.mmap_rnd_compat_bits = 8
vm.nr_overcommit_hugepages = '"$hoverc"'
vm.numa_stat = 0
vm.numa_zonelist_order = Node
vm.oom_dump_tasks = 1
vm.oom_kill_allocating_task = 1
#vm.overcommit_kbytes = 0
vm.overcommit_memory = '"$overcommit"'
vm.overcommit_ratio = '"$oratio"'
vm.page-cluster = '"$pagec"'
vm.pagecache = 1
vm.page_lock_unfairness = 1
vm.panic_on_oom = 0
vm.percpu_pagelist_high_fraction = 0
vm.reap_mem_on_sigkill = 1
vm.stat_interval = 60
vm.swappiness = '"$swappiness"'
vm.unprivileged_userfaultfd = 0
vm.user_reserve_kbytes = 60896
vm.vfs_cache_pressure = '"$cpress"'
vm.watermark_boost_factor = 15000
vm.watermark_scale_factor = 200
vm.zone_reclaim_mode = 0
vm.nr_pdflush_threads = 0
stack_erasing = 0
net.core.bpf_jit_enable = 1
net.core.bpf_jit_harden = 2
net.core.bpf_jit_kallsyms = 0
kernel.unprivileged_bpf_disabled = 1
net.ipv4.tcp_mem = 22740 30320 45480
net.ipv4.udp_mem = 45480 60640 90960
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_fack = 1
net.ipv4.tcp_no_metrics_save = 1 \r
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_sack = 0
net.ipv4.tcp_frto = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_rfc1337 = 1
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.core.optmem_max = 65536
net.core.somaxconn = 8192
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_mtu_probing = 1
net.ipv4.ip_local_port_range = 30000 65535
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.rp_filter = 1

net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

net.ipv4.icmp_echo_ignore_all = 1
net.ipv6.icmp.echo_ignore_all = 1
net.ipv4.ping_group_range = 100 100

net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.default.forwarding = 0
sk_rcvbuf = 125336
net.core.busy_poll = 50

net.mptcp.add_addr_timeout = 120
net.mptcp.allow_join_initial_addr_port = 1
net.mptcp.checksum_enabled = 0
net.mptcp.enabled = 1
net.mptcp.pm_type = 0
net.mptcp.stale_loss_cnt = 4


net.core.enable_tcp_offloading = 1

kernel.split_lock_mitigate = 0

#vm.dirty_background_bytes = 4194
#vm.dirty_bytes = 4194

vm.max_map_count=512000

' | tee "$ifdr"/etc/sysctl.conf "$ifdr"/etc/sysctl.d/sysctl.conf

if [ $loglevel = 0 ] ; then 
echo 'net.netfilter.nf_conntrack_acct = 0
net.netfilter.nf_log.0 = NONE
net.netfilter.nf_log.1 = NONE
net.netfilter.nf_log.10 = NONE
net.netfilter.nf_log.2 = NONE
net.netfilter.nf_log.3 = NONE
net.netfilter.nf_log.4 = NONE
net.netfilter.nf_log.5 = NONE
net.netfilter.nf_log.6 = NONE
net.netfilter.nf_log.7 = NONE
net.netfilter.nf_log.8 = NONE
net.netfilter.nf_log.9 = NONE
kernel.core_pattern = |/bin/false
kernel.seccomp.actions_avail = NONE
kernel.seccomp.actions_logged = NONE' | tee -a "$ifdr"/etc/sysctl.conf "$ifdr"/etc/sysctl.d/sysctl.conf

sysctl -w kernel.core_pattern=|/bin/false
fi

sysctl net.ipv4.ip_local_port_range=30000 65535
echo $tcp_con > /proc/sys/net/ipv4/tcp_congestion_control
echo $qdisc > /proc/sys/net/core/default_qdisc
sysctl net.ipv4.conf.all.rp_filter

echo Y > /sys/module/tcp_bbr2/parameters/ecn_enable
echo N > /sys/module/tcp_bbr2/parameters/debug_ftrace
echo Y > /sys/module/tcp_bbr2/parameters/fast_path

echo 2 > /sys/module/tcp_cubic/parameters/hystart_detect


sysctl net/core/bpf_jit_enable=1
echo 1 > /proc/sys/net/core/bpf_jit_enable
echo 0 > /proc/sys/net/netfilter/nf_conntrack_acct


echo 1 > /proc/sys/net/core/enable_tcp_offloading



fi


# these settings might be problematic with connection on certain hardware... switch on top
if $(! $wrt) && [ $unsafesysctl = yes ]; then




sysctl net.ipv4.ip_local_port_range=30000 65535
sysctl net.ipv4.tcp_fin_timeout=15
sysctl net.ipv4.tcp_keepalive_time=300
sysctl net.ipv4.tcp_keepalive_probes=5
sysctl net.ipv4.tcp_keepalive_intvl=15
sysctl net.core.somaxconn=1000
sysctl net.core.netdev_max_backlog=5000
sysctl net.core.rmem_max=16777216
sysctl net.core.wmem_max=16777216
sysctl net.ipv4.tcp_wmem=4096 12582912 16777216
sysctl net.ipv4.tcp_rmem=4096 12582912 16777216
sysctl net.ipv4.tcp_max_syn_backlog=8096
sysctl net.ipv4.tcp_tw_reuse=1
sysctl net.ipv4.tcp_slow_start_after_idle=0
sysctl -w net.core.rmem_max=16777216
sysctl.net.core.busy_poll=50
sysctl net.ipv4.tcp_fastopen=3




sysctl net.core.somaxconn=1000


echo 0 > /proc/sys/net/core/bpf_jit_harden
echo 0 > /proc/sys/net/core/bpf_jit_kallsyms

if [ $loglevel = 0 ] ; then
echo NONE > /proc/sys/net/netfilter/nf_log/0
echo NONE > /proc/sys/net/netfilter/nf_log/1
echo NONE > /proc/sys/net/netfilter/nf_log/10
echo NONE > /proc/sys/net/netfilter/nf_log/2
echo NONE > /proc/sys/net/netfilter/nf_log/3
echo NONE > /proc/sys/net/netfilter/nf_log/4
echo NONE > /proc/sys/net/netfilter/nf_log/5
echo NONE > /proc/sys/net/netfilter/nf_log/6
echo NONE > /proc/sys/net/netfilter/nf_log/7
echo NONE > /proc/sys/net/netfilter/nf_log/8
echo NONE > /proc/sys/net/netfilter/nf_log/9 ; fi

#echo "0" >/proc/sys/net/ipv4/conf/default/secure_redirects
#echo "0" >/proc/sys/net/ipv4/conf/default/accept_redirects
#echo "0" >/proc/sys/net/ipv4/conf/default/accept_source_route
#echo "0" >/proc/sys/net/ipv4/conf/all/secure_redirects
#echo "0" >/proc/sys/net/ipv4/conf/all/accept_redirects
#echo "0" >/proc/sys/net/ipv4/conf/all/accept_source_route
#echo "0" >/proc/sys/net/ipv4/ip_forward
#echo "0" >/proc/sys/net/ipv4/ip_dynaddr
#echo "0" >/proc/sys/net/ipv4/ip_no_pmtu_disc
#echo "0" >/proc/sys/net/ipv4/tcp_ecn
#echo "0" >/proc/sys/net/ipv4/tcp_timestamps
echo "1" >/proc/sys/net/ipv4/tcp_tw_reuse
echo "1" >/proc/sys/net/ipv4/tcp_fack
echo "0" >/proc/sys/net/ipv4/tcp_sack
echo "1" >/proc/sys/net/ipv4/tcp_dsack
echo "1" >/proc/sys/net/ipv4/tcp_rfc1337
echo "1" >/proc/sys/net/ipv4/tcp_tw_recycle
echo "1" >/proc/sys/net/ipv4/tcp_window_scaling
echo "1" >/proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo "1" >/proc/sys/net/ipv4/tcp_no_metrics_save
echo "2" >/proc/sys/net/ipv4/tcp_synack_retries
echo "2" >/proc/sys/net/ipv4/tcp_syn_retries
echo "5" >/proc/sys/net/ipv4/tcp_keepalive_probes
echo "30" >/proc/sys/net/ipv4/tcp_keepalive_intvl
echo "30" >/proc/sys/net/ipv4/tcp_fin_timeout
echo "1800" >/proc/sys/net/ipv4/tcp_keepalive_time
#echo "261120" >/proc/sys/net/core/rmem_max
#echo "261120" >/proc/sys/net/core/wmem_max
#echo "261120" >/proc/sys/net/core/rmem_default
#echo "261120" >/proc/sys/net/core/wmem_default
sysctl net.ipv4.tcp_dsack=1
sysctl net.ipv4.tcp_tw_recycle=1
sysctl net.ipv4.tcp_tw_reuse=1
echo "128" > /proc/sys/net/core/netdev_max_backlog
echo "0" > /proc/sys/net/core/netdev_tstamp_prequeue
echo "0" > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv4/cipso_cache_enable
echo "0" > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo "0" > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo "24" > /proc/sys/net/ipv4/ipfrag_time
echo "1" > /proc/sys/net/ipv4/tcp_ecn
echo "0" > /proc/sys/net/ipv4/tcp_fwmark_accept
echo "320" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "21600" > /proc/sys/net/ipv4/tcp_keepalive_time
echo "1800" > /proc/sys/net/ipv4/tcp_probe_interval
echo "1" > /proc/sys/net/ipv4/tcp_no_metrics_save
echo "0" > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo "0" > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo "0" > /proc/sys/net/ipv6/calipso_cache_enable
echo "48" > /proc/sys/net/ipv6/ip6frag_time
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_rfc1337
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_window_scaling
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_workaround_signed_windows
echo "0" > /proc/sys/net/ipv4/net.ipv4.tcp_sack
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_fack
echo "0" > /proc/sys/net/ipv4/net.ipv4.ip_no_pmtu_disc
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_mtu_probing
echo "2" > /proc/sys/net/ipv4/net.ipv4.tcp_frto
echo "2" > /proc/sys/net/ipv4/net.ipv4.tcp_frto_response
echo "1" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo 1 > /sys/module/printk/parameters/console_no_auto_verbose

echo 262144 > /proc/sys/net/core/rmem_max
echo 262144 > /proc/sys/net/core/wmem_max
echo "4096 16384 262144" > /proc/sys/net/ipv4/tcp_wmem
echo "4096 87380 262144" > /proc/sys/net/ipv4/tcp_rmem
echo 1000 > /proc/sys/net/core/netdev_max_backlog
echo 16384 > /proc/sys/net/ipv4/netfilter/ip_conntrack_max
echo 16384 > /sys/module/nf_conntrack/parameters/hashsize
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_low_latency

echo '#net.ipv4.tcp_timestamps = # problematic
#net.core.busy_read = 50 #
#net.ipv4.conf.all.send_redirects = 0
#net.ipv4.conf.default.send_redirects = 0
#net.ipv4.conf.all.accept_redirects = 0
#net.ipv4.conf.default.accept_redirects = 0
#net.ipv4.conf.all.secure_redirects = 0
#net.ipv4.conf.default.secure_redirects = 0
net.ipv4.tcp_early_demux = 1
net.ipv4.tcp_early_retrans = 2
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_ehash_entries = 16384
net.ipv4.tcp_fastopen_blackhole_timeout_sec = 0
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_frto_response = 2
net.ipv4.tcp_fwmark_accept = 0
net.ipv4.tcp_invalid_ratelimit = 500
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_l3mdev_accept = 0
net.ipv4.tcp_limit_output_bytes = 1048576
net.ipv4.tcp_max_orphans = 16384
net.ipv4.tcp_max_reordering = 300
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_migrate_req = 0
net.ipv4.tcp_min_rtt_wlen = 300
net.ipv4.tcp_min_snd_mss = 48
net.ipv4.tcp_min_tso_segs = 2
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_mtu_probe_floor = 48
net.ipv4.tcp_no_ssthresh_metrics_save = 1
net.ipv4.tcp_notsent_lowat = 4294967295
net.ipv4.tcp_orphan_retries = 0
net.ipv4.tcp_pacing_ca_ratio = 120
net.ipv4.tcp_pacing_ss_ratio = 200
net.ipv4.tcp_probe_interval = 1800
net.ipv4.tcp_probe_threshold = 8
net.ipv4.tcp_recovery = 1
net.ipv4.tcp_reflect_tos = 0
net.ipv4.tcp_reordering = 3
net.ipv4.tcp_retrans_collapse = 1
net.ipv4.tcp_retries1 = 3
net.ipv4.tcp_retries2 = 15
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_thin_dupack = 1
net.ipv4.tcp_thin_linear_timeouts = 0
net.ipv4.tcp_tso_rtt_log = 0
net.ipv4.tcp_tso_win_divisor = 3
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.udp_early_demux = 1
net.ipv4.udp_l3mdev_accept = 0
net.ipv4.udp_rmem_min = 4096
net.ipv4.udp_wmem_min = 8192
net.ipv4.xfrm4_gc_thresh = 32768
net.ipv4.conf.default.rp_filter=2
net.ipv4.conf.all.rp_filter=2
net.ipv4.tcp_abort_on_overflow = 0
net.ipv4.tcp_adv_win_scale = 1
#net.ipv4.tcp_allowed_congestion_control = reno cubic bbr
net.ipv4.tcp_app_win = 31
net.ipv4.tcp_autocorking = 0
#net.ipv4.tcp_available_congestion_control = reno cubic bbr
net.ipv4.tcp_available_ulp = mptcp
net.ipv4.tcp_base_mss = 1024
net.ipv4.tcp_challenge_ack_limit = 2147483647
net.ipv4.tcp_child_ehash_entries = 0
net.ipv4.tcp_comp_sack_delay_ns = 1000000
net.ipv4.tcp_comp_sack_nr = 44
net.ipv4.tcp_comp_sack_slack_ns = 100000

net.netfilter.nf_log_all_netns = 0
net.nf_conntrack_max = 65536
net.unix.max_dgram_qlen = 512
net.netfilter.nf_conntrack_buckets = 16384
net.netfilter.nf_conntrack_checksum = 0
net.netfilter.nf_conntrack_count = 30
net.netfilter.nf_conntrack_dccp_loose = 1
net.netfilter.nf_conntrack_dccp_timeout_closereq = 64
net.netfilter.nf_conntrack_dccp_timeout_closing = 64
net.netfilter.nf_conntrack_dccp_timeout_open = 43200
net.netfilter.nf_conntrack_dccp_timeout_partopen = 480
net.netfilter.nf_conntrack_dccp_timeout_request = 240
net.netfilter.nf_conntrack_dccp_timeout_respond = 480
net.netfilter.nf_conntrack_dccp_timeout_timewait = 240
net.netfilter.nf_conntrack_events = 2
net.netfilter.nf_conntrack_expect_max = 1024
net.netfilter.nf_conntrack_frag6_high_thresh = 4194304
net.netfilter.nf_conntrack_frag6_low_thresh = 3145728
net.netfilter.nf_conntrack_frag6_timeout = 60
net.netfilter.nf_conntrack_generic_timeout = 600
net.netfilter.nf_conntrack_gre_timeout = 30
net.netfilter.nf_conntrack_gre_timeout_stream = 180
net.netfilter.nf_conntrack_icmp_timeout = 30
net.netfilter.nf_conntrack_icmpv6_timeout = 30
net.netfilter.nf_conntrack_log_invalid = 0
net.netfilter.nf_conntrack_max = 1638400
net.netfilter.nf_conntrack_sctp_timeout_closed = 10
net.netfilter.nf_conntrack_sctp_timeout_cookie_echoed = 3
net.netfilter.nf_conntrack_sctp_timeout_cookie_wait = 3
net.netfilter.nf_conntrack_sctp_timeout_established = 432000
net.netfilter.nf_conntrack_sctp_timeout_heartbeat_acked = 210
net.netfilter.nf_conntrack_sctp_timeout_heartbeat_sent = 30
net.netfilter.nf_conntrack_sctp_timeout_shutdown_ack_sent = 3
net.netfilter.nf_conntrack_sctp_timeout_shutdown_recd = 0
net.netfilter.nf_conntrack_sctp_timeout_shutdown_sent = 0
net.netfilter.nf_conntrack_tcp_be_liberal = 0
net.netfilter.nf_conntrack_tcp_ignore_invalid_rst = 0
net.netfilter.nf_conntrack_tcp_loose = 1
net.netfilter.nf_conntrack_tcp_max_retrans = 3
net.netfilter.nf_conntrack_tcp_timeout_close = 10
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_established = 7440
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 30
net.netfilter.nf_conntrack_tcp_timeout_max_retrans = 300
net.netfilter.nf_conntrack_tcp_timeout_syn_recv = 60
net.netfilter.nf_conntrack_tcp_timeout_syn_sent = 120
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_unacknowledged = 300
net.netfilter.nf_conntrack_timestamp = 0
net.netfilter.nf_conntrack_udp_timeout = 30
net.netfilter.nf_conntrack_udp_timeout_stream = 120
net.netfilter.nf_flowtable_tcp_timeout = 30
net.netfilter.nf_hooks_lwtunnel = 0
net.ipv4.route.gc_elasticity = 8
net.ipv4.route.gc_interval = 60
net.ipv4.route.gc_min_interval = 0
net.ipv4.route.gc_min_interval_ms = 500
net.ipv4.route.gc_thresh = -1
net.ipv4.route.gc_timeout = 300
net.ipv4.cipso_cache_bucket_size = 0
net.ipv4.cipso_cache_enable = 0
net.ipv4.cipso_rbm_optfmt = 0
net.ipv4.cipso_rbm_strictvalid = 0
net.core.bpf_jit_limit = 264241152
net.core.dev_weight = 64
net.core.dev_weight_rx_bias = 1
net.core.devconf_inherit_init_net = 0
net.core.fb_tunnels_only_for_init_net = 0
net.core.flow_limit_cpu_bitmap = 0
net.core.flow_limit_table_len = 4096
net.core.gro_normal_batch = 8
net.core.high_order_alloc_disable = 0
net.core.max_skb_frags = 17
net.core.message_burst = 10
net.core.message_cost = 5
net.core.netdev_budget = 300
net.core.netdev_budget_usecs = 8000
net.core.netdev_max_backlog = 5000
net.core.netdev_tstamp_prequeue = 0
net.core.netdev_unregister_timeout_secs = 10
net.core.optmem_max = 65536
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.rps_sock_flow_entries = 0
net.core.skb_defer_max = 64
net.core.somaxconn = 1000
net.core.tstamp_allow_data = 1
net.core.txrehash = 1
net.core.warnings = 0
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.xfrm_acq_expires = 30
net.core.xfrm_aevent_etime = 10
net.core.xfrm_aevent_rseqth = 2
net.core.xfrm_larval_drop = 1
net.ipv4.conf.all.accept_local = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.all.arp_accept = 0
net.ipv4.conf.all.arp_announce = 0
net.ipv4.conf.all.arp_evict_nocarrier = 1
net.ipv4.conf.all.arp_filter = 0
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.all.arp_notify = 0
net.ipv4.conf.all.bc_forwarding = 0
net.ipv4.conf.all.bootp_relay = 0
net.ipv4.conf.all.disable_policy = 0
net.ipv4.conf.all.disable_xfrm = 0
net.ipv4.conf.all.drop_gratuitous_arp = 0
net.ipv4.conf.all.drop_unicast_in_l2_multicast = 0
#net.ipv4.conf.all.force_igmp_version = 0
net.ipv4.conf.all.forwarding = 1
#net.ipv4.conf.all.igmpv2_unsolicited_report_interval = 10000
#net.ipv4.conf.all.igmpv3_unsolicited_report_interval = 1000
#net.ipv4.conf.all.ignore_routes_with_linkdown = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.all.mc_forwarding = 0
#net.ipv4.conf.all.medium_id = 0
net.ipv4.conf.all.promote_secondaries = 0
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.proxy_arp_pvlan = 0
net.ipv4.conf.all.route_localnet = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.shared_media = 1
net.ipv4.conf.all.src_valid_mark = 0
net.ipv4.conf.all.tag = 0
net.ipv4.fib_multipath_hash_fields = 7
net.ipv4.fib_multipath_hash_policy = 0
net.ipv4.fib_multipath_use_neigh = 0
net.ipv4.fib_notify_on_flag_change = 0
net.ipv4.fib_sync_mem = 524288
net.ipv4.fwmark_reflect = 0
net.ipv4.icmp_echo_enable_probe = 0
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_errors_use_inbound_ifaddr = 0
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.icmp_msgs_burst = 0
net.ipv4.icmp_msgs_per_sec = 0
net.ipv4.icmp_ratelimit = 0
net.ipv4.icmp_ratemask = 0
net.ipv4.igmp_link_local_mcast_reports = 0
net.ipv4.igmp_max_memberships = 100
net.ipv4.igmp_max_msf = 10
#net.ipv4.igmp_qrv = 2
net.ipv4.inet_peer_maxttl = 600
net.ipv4.inet_peer_minttl = 120
net.ipv4.inet_peer_threshold = 65664
net.ipv4.ip_autobind_reuse = 0
net.ipv4.ip_default_ttl = 64
net.ipv4.ip_dynaddr = 0
net.ipv4.ip_early_demux = 1
net.ipv4.ip_forward = 1
net.ipv4.ip_forward_update_priority = 1
net.ipv4.ip_forward_use_pmtu = 0
net.ipv4.ip_local_port_range = 30000 65535
#net.ipv4.ip_local_reserved_ports =
net.ipv4.ip_no_pmtu_disc = 0
net.ipv4.ip_nonlocal_bind = 0
net.ipv4.ip_unprivileged_port_start = 1024
net.ipv4.ipfrag_high_thresh = 4194304
net.ipv4.ipfrag_low_thresh = 446464
net.ipv4.ipfrag_max_dist = 64
net.ipv4.ipfrag_secret_interval = 0
net.ipv4.ipfrag_time = 24
net.ipv4.neigh.default.anycast_delay = 100
net.ipv4.neigh.default.app_solicit = 0
net.ipv4.neigh.default.base_reachable_time_ms = 30000
net.ipv4.neigh.default.delay_first_probe_time = 5
net.ipv4.neigh.default.gc_interval = 30
net.ipv4.neigh.default.gc_stale_time = 60
net.ipv4.neigh.default.gc_thresh1 = 32
net.ipv4.neigh.default.gc_thresh2 = 1024
net.ipv4.neigh.default.gc_thresh3 = 2048
net.ipv4.neigh.default.interval_probe_time_ms = 5000
net.ipv4.neigh.default.locktime = 100
net.ipv4.neigh.default.mcast_resolicit = 0
net.ipv4.neigh.default.mcast_solicit = 3
net.ipv4.neigh.default.proxy_delay = 80
net.ipv4.neigh.default.proxy_qlen = 64
net.ipv4.neigh.default.retrans_time_ms = 1000
net.ipv4.neigh.default.ucast_solicit = 3
net.ipv4.neigh.default.unres_qlen = 101
net.ipv4.neigh.default.unres_qlen_bytes = 212992
net.ipv4.nexthop_compat_mode = 1
net.ipv4.ping_group_range = 100 100
net.ipv4.raw_l3mdev_accept = 1
net.ipv4.route.error_burst = 1250
net.ipv4.route.error_cost = 250
net.ipv4.route.max_size = 2147483647
net.ipv4.route.min_adv_mss = 256
net.ipv4.route.min_pmtu = 552
net.ipv4.route.mtu_expires = 600
net.ipv4.route.redirect_load = 5
net.ipv4.route.redirect_number = 9
net.ipv4.route.redirect_silence = 5120
#net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0' | tee -a "$ifdr"/etc/sysctl.conf "$ifdr"/etc/sysctl.d/sysctl.conf


### network

echo 0 > /proc/sys/net/netfilter/nf_log_all_netns
echo 65536 > /proc/sys/net/nf_conntrack_max
echo 512 > /proc/sys/net/unix/max_dgram_qlen

#echo 7670 > /proc/sys/user/max_cgroup_namespaces
echo 128 > /proc/sys/user/max_fanotify_groups
echo 15849 > /proc/sys/user/max_fanotify_marks
echo 128 > /proc/sys/user/max_inotify_instances
echo 14905 > /proc/sys/user/max_inotify_watches
#echo 7670 > /proc/sys/user/max_ipc_namespaces
#echo 7670 > /proc/sys/user/max_mnt_namespaces
#echo 7670 > /proc/sys/user/max_net_namespaces
#echo 7670 > /proc/sys/user/max_pid_namespaces
#echo 7670 > /proc/sys/user/max_time_namespaces
#echo 7670 > /proc/sys/user/max_user_namespaces
#echo 7670 > /proc/sys/user/max_uts_namespaces

echo 0 > /proc/sys/net/ipv4/tcp_tso_rtt_log
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all



sysctl -w net.ipv4.tcp_moderate_rcvbuf=2
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 0 > /proc/sys/net/ipv4/icmp_errors_use_inbound_ifaddr
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
echo 0 > /proc/sys/net/ipv4/icmp_msgs_burst
echo 0 > /proc/sys/net/ipv4/icmp_msgs_per_sec
echo 0 > /proc/sys/net/ipv4/icmp_ratelimit
echo 0 > /proc/sys/net/ipv4/icmp_ratemask
echo 0 > /proc/sys/net/ipv4/icmp_echo_enable_probe
echo 60 > /proc/sys/net/ipv4/tcp_default_init_rwnd
echo 264241152 > /proc/sys/net/core/bpf_jit_limit
echo 50 > /proc/sys/net/core/busy_poll
echo 50 > /proc/sys/net/core/busy_read
echo 64 > /proc/sys/net/core/dev_weight
echo 1 > /proc/sys/net/core/dev_weight_rx_bias
echo 1 > /proc/sys/net/core/dev_weight_tx_bias
echo 0 > /proc/sys/net/core/devconf_inherit_init_net
echo 0 > /proc/sys/net/core/fb_tunnels_only_for_init_net
echo 0 > /proc/sys/net/core/flow_limit_cpu_bitmap
echo 4096 > /proc/sys/net/core/flow_limit_table_len
echo 8 > /proc/sys/net/core/gro_normal_batch
echo 0 > /proc/sys/net/core/high_order_alloc_disable
echo 17 > /proc/sys/net/core/max_skb_frags
echo 10 > /proc/sys/net/core/message_burst
echo 5 > /proc/sys/net/core/message_cost
echo 300 > /proc/sys/net/core/netdev_budget
echo 8000 > /proc/sys/net/core/netdev_budget_usecs
echo 5000 > /proc/sys/net/core/netdev_max_backlog
echo 0 > /proc/sys/net/core/netdev_tstamp_prequeue
echo 10 > /proc/sys/net/core/netdev_unregister_timeout_secs
echo 65536 > /proc/sys/net/core/optmem_max
echo 1048576 > /proc/sys/net/core/rmem_default
echo 16777216 > /proc/sys/net/core/rmem_max
echo 0 > /proc/sys/net/core/rps_sock_flow_entries
echo 64 > /proc/sys/net/core/skb_defer_max
echo 1000 > /proc/sys/net/core/somaxconn
echo 1 > /proc/sys/net/core/tstamp_allow_data
echo 1 > /proc/sys/net/core/txrehash
echo 0 > /proc/sys/net/core/warnings
echo 1048576 > /proc/sys/net/core/wmem_default
echo 16777216 > /proc/sys/net/core/wmem_max
echo 30 > /proc/sys/net/core/xfrm_acq_expires
echo 10 > /proc/sys/net/core/xfrm_aevent_etime
echo 2 > /proc/sys/net/core/xfrm_aevent_rseqth
echo 1 > /proc/sys/net/core/xfrm_larval_drop
echo 0 > /proc/sys/net/ipv4/cipso_cache_bucket_size
echo 0 > /proc/sys/net/ipv4/cipso_cache_enable
echo 0 > /proc/sys/net/ipv4/cipso_rbm_optfmt
echo 0 > /proc/sys/net/ipv4/cipso_rbm_strictvalid
echo 0 > /proc/sys/net/ipv4/conf/all/accept_local
echo 0 > /proc/sys/net/ipv4/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/all/arp_accept
echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/all/arp_evict_nocarrier
echo 0 > /proc/sys/net/ipv4/conf/all/arp_filter
echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/all/arp_notify
echo 0 > /proc/sys/net/ipv4/conf/all/bc_forwarding
echo 0 > /proc/sys/net/ipv4/conf/all/bootp_relay
echo 0 > /proc/sys/net/ipv4/conf/all/disable_policy
echo 0 > /proc/sys/net/ipv4/conf/all/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/all/drop_gratuitous_arp
echo 0 > /proc/sys/net/ipv4/conf/all/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv4/conf/all/force_igmp_version
echo 1 > /proc/sys/net/ipv4/conf/all/forwarding
echo 10000 > /proc/sys/net/ipv4/conf/all/igmpv2_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv4/conf/all/igmpv3_unsolicited_report_interval
echo 0 > /proc/sys/net/ipv4/conf/all/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv4/conf/all/log_martians
echo 0 > /proc/sys/net/ipv4/conf/all/medium_id
echo 0 > /proc/sys/net/ipv4/conf/all/promote_secondaries
echo 0 > /proc/sys/net/ipv4/conf/all/proxy_arp
echo 0 > /proc/sys/net/ipv4/conf/all/proxy_arp_pvlan
echo 0 > /proc/sys/net/ipv4/conf/all/route_localnet
echo 2 > /proc/sys/net/ipv4/conf/all/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/all/secure_redirects
echo 0 > /proc/sys/net/ipv4/conf/all/send_redirects
echo 1 > /proc/sys/net/ipv4/conf/all/shared_media
echo 0 > /proc/sys/net/ipv4/conf/all/src_valid_mark
echo 0 > /proc/sys/net/ipv4/conf/all/tag
echo 7 > /proc/sys/net/ipv4/fib_multipath_hash_fields
echo 0 > /proc/sys/net/ipv4/fib_multipath_hash_policy
echo 0 > /proc/sys/net/ipv4/fib_multipath_use_neigh
echo 0 > /proc/sys/net/ipv4/fib_notify_on_flag_change
echo 524288 > /proc/sys/net/ipv4/fib_sync_mem
echo 0 > /proc/sys/net/ipv4/fwmark_reflect
echo 0 > /proc/sys/net/ipv4/icmp_echo_enable_probe
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 0 > /proc/sys/net/ipv4/icmp_errors_use_inbound_ifaddr
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
echo 0 > /proc/sys/net/ipv4/icmp_msgs_burst
echo 0 > /proc/sys/net/ipv4/icmp_msgs_per_sec
echo 0 > /proc/sys/net/ipv4/icmp_ratelimit
echo 0 > /proc/sys/net/ipv4/icmp_ratemask
echo 0 > /proc/sys/net/ipv4/igmp_link_local_mcast_reports
echo 100 > /proc/sys/net/ipv4/igmp_max_memberships
echo 10 > /proc/sys/net/ipv4/igmp_max_msf
echo 2 > /proc/sys/net/ipv4/igmp_qrv
echo 600 > /proc/sys/net/ipv4/inet_peer_maxttl
echo 120 > /proc/sys/net/ipv4/inet_peer_minttl
echo 65664 > /proc/sys/net/ipv4/inet_peer_threshold
echo 0 > /proc/sys/net/ipv4/ip_autobind_reuse
echo 64 > /proc/sys/net/ipv4/ip_default_ttl
echo 0 > /proc/sys/net/ipv4/ip_dynaddr
echo 1 > /proc/sys/net/ipv4/ip_early_demux
echo 1 > /proc/sys/net/ipv4/ip_forward
echo 1 > /proc/sys/net/ipv4/ip_forward_update_priority
echo 0 > /proc/sys/net/ipv4/ip_forward_use_pmtu
echo 30000 > /proc/sys/net/ipv4/ip_local_port_range
echo 0 > /proc/sys/net/ipv4/ip_no_pmtu_disc
echo 0 > /proc/sys/net/ipv4/ip_nonlocal_bind
echo 1024 > /proc/sys/net/ipv4/ip_unprivileged_port_start
echo 4194304 > /proc/sys/net/ipv4/ipfrag_high_thresh
echo 446464 > /proc/sys/net/ipv4/ipfrag_low_thresh
echo 64 > /proc/sys/net/ipv4/ipfrag_max_dist
echo 0 > /proc/sys/net/ipv4/ipfrag_secret_interval
echo 24 > /proc/sys/net/ipv4/ipfrag_time
echo 100 > /proc/sys/net/ipv4/neigh/default/anycast_delay
echo 0 > /proc/sys/net/ipv4/neigh/default/app_solicit
echo 30 > /proc/sys/net/ipv4/neigh/default/base_reachable_time
echo 30000 > /proc/sys/net/ipv4/neigh/default/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv4/neigh/default/delay_first_probe_time
echo 30 > /proc/sys/net/ipv4/neigh/default/gc_interval
echo 60 > /proc/sys/net/ipv4/neigh/default/gc_stale_time
echo 32 > /proc/sys/net/ipv4/neigh/default/gc_thresh1
echo 1024 > /proc/sys/net/ipv4/neigh/default/gc_thresh2
echo 2048 > /proc/sys/net/ipv4/neigh/default/gc_thresh3
echo 5000 > /proc/sys/net/ipv4/neigh/default/interval_probe_time_ms
echo 100 > /proc/sys/net/ipv4/neigh/default/locktime
echo 0 > /proc/sys/net/ipv4/neigh/default/mcast_resolicit
echo 3 > /proc/sys/net/ipv4/neigh/default/mcast_solicit
echo 80 > /proc/sys/net/ipv4/neigh/default/proxy_delay
echo 64 > /proc/sys/net/ipv4/neigh/default/proxy_qlen
echo 100 > /proc/sys/net/ipv4/neigh/default/retrans_time
echo 1000 > /proc/sys/net/ipv4/neigh/default/retrans_time_ms
echo 3 > /proc/sys/net/ipv4/neigh/default/ucast_solicit
echo 101 > /proc/sys/net/ipv4/neigh/default/unres_qlen
echo 212992 > /proc/sys/net/ipv4/neigh/default/unres_qlen_bytes
echo 100 > /proc/sys/net/ipv4/neigh/eth0/anycast_delay
echo 0 > /proc/sys/net/ipv4/neigh/eth0/app_solicit
echo 30 > /proc/sys/net/ipv4/neigh/eth0/base_reachable_time
echo 30000 > /proc/sys/net/ipv4/neigh/eth0/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv4/neigh/eth0/delay_first_probe_time
echo 60 > /proc/sys/net/ipv4/neigh/eth0/gc_stale_time
echo 5000 > /proc/sys/net/ipv4/neigh/eth0/interval_probe_time_ms
echo 100 > /proc/sys/net/ipv4/neigh/eth0/locktime
echo 0 > /proc/sys/net/ipv4/neigh/eth0/mcast_resolicit
echo 3 > /proc/sys/net/ipv4/neigh/eth0/mcast_solicit
echo 80 > /proc/sys/net/ipv4/neigh/eth0/proxy_delay
echo 64 > /proc/sys/net/ipv4/neigh/eth0/proxy_qlen
echo 100 > /proc/sys/net/ipv4/neigh/eth0/retrans_time
echo 1000 > /proc/sys/net/ipv4/neigh/eth0/retrans_time_ms
echo 3 > /proc/sys/net/ipv4/neigh/eth0/ucast_solicit
echo 101 > /proc/sys/net/ipv4/neigh/eth0/unres_qlen
echo 212992 > /proc/sys/net/ipv4/neigh/eth0/unres_qlen_bytes
echo 100 > /proc/sys/net/ipv4/neigh/lo/anycast_delay
echo 0 > /proc/sys/net/ipv4/neigh/lo/app_solicit
echo 30 > /proc/sys/net/ipv4/neigh/lo/base_reachable_time
echo 30000 > /proc/sys/net/ipv4/neigh/lo/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv4/neigh/lo/delay_first_probe_time
echo 60 > /proc/sys/net/ipv4/neigh/lo/gc_stale_time
echo 5000 > /proc/sys/net/ipv4/neigh/lo/interval_probe_time_ms
echo 100 > /proc/sys/net/ipv4/neigh/lo/locktime
echo 0 > /proc/sys/net/ipv4/neigh/lo/mcast_resolicit
echo 3 > /proc/sys/net/ipv4/neigh/lo/mcast_solicit
echo 80 > /proc/sys/net/ipv4/neigh/lo/proxy_delay
echo 64 > /proc/sys/net/ipv4/neigh/lo/proxy_qlen
echo 100 > /proc/sys/net/ipv4/neigh/lo/retrans_time
echo 1000 > /proc/sys/net/ipv4/neigh/lo/retrans_time_ms
echo 3 > /proc/sys/net/ipv4/neigh/lo/ucast_solicit
echo 101 > /proc/sys/net/ipv4/neigh/lo/unres_qlen
echo 212992 > /proc/sys/net/ipv4/neigh/lo/unres_qlen_bytes
echo 1 > /proc/sys/net/ipv4/nexthop_compat_mode
echo 100 > /proc/sys/net/ipv4/ping_group_range
echo 1 > /proc/sys/net/ipv4/raw_l3mdev_accept
echo 1250 > /proc/sys/net/ipv4/route/error_burst
echo 250 > /proc/sys/net/ipv4/route/error_cost
echo 8 > /proc/sys/net/ipv4/route/gc_elasticity
echo 60 > /proc/sys/net/ipv4/route/gc_interval
echo 0 > /proc/sys/net/ipv4/route/gc_min_interval
echo 500 > /proc/sys/net/ipv4/route/gc_min_interval_ms
echo -1 > /proc/sys/net/ipv4/route/gc_thresh
echo 300 > /proc/sys/net/ipv4/route/gc_timeout
echo 2147483647 > /proc/sys/net/ipv4/route/max_size
echo 256 > /proc/sys/net/ipv4/route/min_adv_mss
echo 552 > /proc/sys/net/ipv4/route/min_pmtu
echo 600 > /proc/sys/net/ipv4/route/mtu_expires
echo 5 > /proc/sys/net/ipv4/route/redirect_load
echo 9 > /proc/sys/net/ipv4/route/redirect_number
echo 5120 > /proc/sys/net/ipv4/route/redirect_silence
echo 0 > /proc/sys/net/ipv4/tcp_abort_on_overflow
echo 1 > /proc/sys/net/ipv4/tcp_adv_win_scale
#echo $tcp_con > /proc/sys/net/ipv4/tcp_allowed_congestion_control
echo 31 > /proc/sys/net/ipv4/tcp_app_win
echo 0 > /proc/sys/net/ipv4/tcp_autocorking
echo 1024 > /proc/sys/net/ipv4/tcp_base_mss
echo 2147483647 > /proc/sys/net/ipv4/tcp_challenge_ack_limit
echo 0 > /proc/sys/net/ipv4/tcp_child_ehash_entries
echo 1000000 > /proc/sys/net/ipv4/tcp_comp_sack_delay_ns
echo 44 > /proc/sys/net/ipv4/tcp_comp_sack_nr
echo 100000 > /proc/sys/net/ipv4/tcp_comp_sack_slack_ns
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 1 > /proc/sys/net/ipv4/tcp_early_demux
echo 2 > /proc/sys/net/ipv4/tcp_early_retrans
echo 1 > /proc/sys/net/ipv4/tcp_ecn
echo 1 > /proc/sys/net/ipv4/tcp_ecn_fallback
echo 1 > /proc/sys/net/ipv4/tcp_fack
echo 3 > /proc/sys/net/ipv4/tcp_fastopen
echo 0 > /proc/sys/net/ipv4/tcp_fastopen_blackhole_timeout_sec
echo 15 > /proc/sys/net/ipv4/tcp_fin_timeout
echo 1 > /proc/sys/net/ipv4/tcp_frto
echo 0 > /proc/sys/net/ipv4/tcp_fwmark_accept
echo 500 > /proc/sys/net/ipv4/tcp_invalid_ratelimit
echo 15 > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo 5 > /proc/sys/net/ipv4/tcp_keepalive_probes
echo 300 > /proc/sys/net/ipv4/tcp_keepalive_time
echo 0 > /proc/sys/net/ipv4/tcp_l3mdev_accept
echo 1048576 > /proc/sys/net/ipv4/tcp_limit_output_bytes
echo 1 > /proc/sys/net/ipv4/tcp_low_latency
echo 16384 > /proc/sys/net/ipv4/tcp_max_orphans
echo 300 > /proc/sys/net/ipv4/tcp_max_reordering
echo 8096 > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo 2000000 > /proc/sys/net/ipv4/tcp_max_tw_buckets
echo 22740 > /proc/sys/net/ipv4/tcp_mem
echo 0 > /proc/sys/net/ipv4/tcp_migrate_req
echo 300 > /proc/sys/net/ipv4/tcp_min_rtt_wlen
echo 48 > /proc/sys/net/ipv4/tcp_min_snd_mss
echo 2 > /proc/sys/net/ipv4/tcp_min_tso_segs
echo 1 > /proc/sys/net/ipv4/tcp_moderate_rcvbuf
echo 48 > /proc/sys/net/ipv4/tcp_mtu_probe_floor
echo 1 > /proc/sys/net/ipv4/tcp_mtu_probing
echo 1 > /proc/sys/net/ipv4/tcp_no_metrics_save
echo 1 > /proc/sys/net/ipv4/tcp_no_ssthresh_metrics_save
echo 4294967295 > /proc/sys/net/ipv4/tcp_notsent_lowat
echo 0 > /proc/sys/net/ipv4/tcp_orphan_retries
echo 120 > /proc/sys/net/ipv4/tcp_pacing_ca_ratio
echo 200 > /proc/sys/net/ipv4/tcp_pacing_ss_ratio
echo 1800 > /proc/sys/net/ipv4/tcp_probe_interval
echo 8 > /proc/sys/net/ipv4/tcp_probe_threshold
echo 1 > /proc/sys/net/ipv4/tcp_recovery
echo 0 > /proc/sys/net/ipv4/tcp_reflect_tos
echo 3 > /proc/sys/net/ipv4/tcp_reordering
echo 1 > /proc/sys/net/ipv4/tcp_retrans_collapse
echo 3 > /proc/sys/net/ipv4/tcp_retries1
echo 15 > /proc/sys/net/ipv4/tcp_retries2
echo 1 > /proc/sys/net/ipv4/tcp_rfc1337
echo 4096 > /proc/sys/net/ipv4/tcp_rmem
echo 0 > /proc/sys/net/ipv4/tcp_sack
echo 0 > /proc/sys/net/ipv4/tcp_slow_start_after_idle
echo 0 > /proc/sys/net/ipv4/tcp_stdurg
echo 2 > /proc/sys/net/ipv4/tcp_syn_retries
echo 2 > /proc/sys/net/ipv4/tcp_synack_retries
echo 0 > /proc/sys/net/ipv4/tcp_syncookies
echo 0 > /proc/sys/net/ipv4/tcp_thin_linear_timeouts
#echo 0 > /proc/sys/net/ipv4/tcp_timestamps
echo 0 > /proc/sys/net/ipv4/tcp_tso_rtt_log
echo 3 > /proc/sys/net/ipv4/tcp_tso_win_divisor
echo 1 > /proc/sys/net/ipv4/tcp_tw_reuse
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling
echo 4096 > /proc/sys/net/ipv4/tcp_wmem
echo 0 > /proc/sys/net/ipv4/tcp_workaround_signed_windows
echo 1 > /proc/sys/net/ipv4/udp_early_demux
echo 0 > /proc/sys/net/ipv4/udp_l3mdev_accept
echo 45480 > /proc/sys/net/ipv4/udp_mem
echo 4096 > /proc/sys/net/ipv4/udp_rmem_min
echo 8192 > /proc/sys/net/ipv4/udp_wmem_min
echo 32768 > /proc/sys/net/ipv4/xfrm4_gc_thresh
echo 0 > /proc/sys/net/ipv6/anycast_src_echo_reply
echo 1 > /proc/sys/net/ipv6/auto_flowlabels
echo 0 > /proc/sys/net/ipv6/bindv6only
echo 0 > /proc/sys/net/ipv6/calipso_cache_bucket_size
echo 0 > /proc/sys/net/ipv6/calipso_cache_enable
echo 0 > /proc/sys/net/ipv6/conf/all/accept_dad
echo 0 > /proc/sys/net/ipv6/conf/all/accept_ra
echo 1 > /proc/sys/net/ipv6/conf/all/accept_ra_defrtr
echo 0 > /proc/sys/net/ipv6/conf/all/accept_ra_from_local
echo 1 > /proc/sys/net/ipv6/conf/all/accept_ra_min_hop_limit
echo 1 > /proc/sys/net/ipv6/conf/all/accept_ra_mtu
echo 1 > /proc/sys/net/ipv6/conf/all/accept_ra_pinfo
echo 0 > /proc/sys/net/ipv6/conf/all/accept_ra_rt_info_max_plen
echo 0 > /proc/sys/net/ipv6/conf/all/accept_ra_rt_info_min_plen
echo 1 > /proc/sys/net/ipv6/conf/all/accept_ra_rtr_pref
echo 0 > /proc/sys/net/ipv6/conf/all/accept_redirects
echo 0 > /proc/sys/net/ipv6/conf/all/accept_source_route
echo 0 > /proc/sys/net/ipv6/conf/all/accept_untracked_na
echo 0 > /proc/sys/net/ipv6/conf/all/addr_gen_mode
echo 1 > /proc/sys/net/ipv6/conf/all/autoconf
echo 1 > /proc/sys/net/ipv6/conf/all/dad_transmits
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 0 > /proc/sys/net/ipv6/conf/all/disable_policy
echo 0 > /proc/sys/net/ipv6/conf/all/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv6/conf/all/drop_unsolicited_na
echo 1 > /proc/sys/net/ipv6/conf/all/enhanced_dad
echo 0 > /proc/sys/net/ipv6/conf/all/force_mld_version
echo 0 > /proc/sys/net/ipv6/conf/all/force_tllao
echo 0 > /proc/sys/net/ipv6/conf/all/forwarding
echo 64 > /proc/sys/net/ipv6/conf/all/hop_limit
echo 0 > /proc/sys/net/ipv6/conf/all/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv6/conf/all/ioam6_enabled
echo 65535 > /proc/sys/net/ipv6/conf/all/ioam6_id
echo 4294967295 > /proc/sys/net/ipv6/conf/all/ioam6_id_wide
echo 0 > /proc/sys/net/ipv6/conf/all/keep_addr_on_down
echo 16 > /proc/sys/net/ipv6/conf/all/max_addresses
echo 600 > /proc/sys/net/ipv6/conf/all/max_desync_factor
echo 10000 > /proc/sys/net/ipv6/conf/all/mldv1_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv6/conf/all/mldv2_unsolicited_report_interval
echo 1280 > /proc/sys/net/ipv6/conf/all/mtu
echo 1 > /proc/sys/net/ipv6/conf/all/ndisc_evict_nocarrier
echo 0 > /proc/sys/net/ipv6/conf/all/ndisc_notify
echo 0 > /proc/sys/net/ipv6/conf/all/ndisc_tclass
echo 0 > /proc/sys/net/ipv6/conf/all/optimistic_dad
echo 0 > /proc/sys/net/ipv6/conf/all/proxy_ndp
echo 1024 > /proc/sys/net/ipv6/conf/all/ra_defrtr_metric
echo 3 > /proc/sys/net/ipv6/conf/all/regen_max_retry
echo 60 > /proc/sys/net/ipv6/conf/all/router_probe_interval
echo 1 > /proc/sys/net/ipv6/conf/all/router_solicitation_delay
echo 4 > /proc/sys/net/ipv6/conf/all/router_solicitation_interval
echo 3600 > /proc/sys/net/ipv6/conf/all/router_solicitation_max_interval
echo -1 > /proc/sys/net/ipv6/conf/all/router_solicitations
echo 0 > /proc/sys/net/ipv6/conf/all/rpl_seg_enabled
echo 0 > /proc/sys/net/ipv6/conf/all/seg6_enabled
echo 0 > /proc/sys/net/ipv6/conf/all/seg6_require_hmac
echo 1 > /proc/sys/net/ipv6/conf/all/suppress_frag_ndisc
echo 86400 > /proc/sys/net/ipv6/conf/all/temp_prefered_lft
echo 604800 > /proc/sys/net/ipv6/conf/all/temp_valid_lft
echo 0 > /proc/sys/net/ipv6/conf/all/use_oif_addrs_only
echo 0 > /proc/sys/net/ipv6/conf/all/use_optimistic
echo 1 > /proc/sys/net/ipv6/conf/all/use_tempaddr
echo 7 > /proc/sys/net/ipv6/fib_multipath_hash_fields
echo 0 > /proc/sys/net/ipv6/fib_multipath_hash_policy
echo 0 > /proc/sys/net/ipv6/fib_notify_on_flag_change
echo 1 > /proc/sys/net/ipv6/flowlabel_consistency
echo 0 > /proc/sys/net/ipv6/flowlabel_reflect
echo 0 > /proc/sys/net/ipv6/flowlabel_state_ranges
echo 0 > /proc/sys/net/ipv6/fwmark_reflect
echo 1 > /proc/sys/net/ipv6/icmp/echo_ignore_all
echo 0 > /proc/sys/net/ipv6/icmp/echo_ignore_anycast
echo 0 > /proc/sys/net/ipv6/icmp/echo_ignore_multicast
echo 1000 > /proc/sys/net/ipv6/icmp/ratelimit
echo 0-1,3-127 > /proc/sys/net/ipv6/icmp/ratemask
echo 1 > /proc/sys/net/ipv6/idgen_delay
echo 3 > /proc/sys/net/ipv6/idgen_retries
echo 16777215 > /proc/sys/net/ipv6/ioam6_id
echo 72057594037927935 > /proc/sys/net/ipv6/ioam6_id_wide
echo 4194304 > /proc/sys/net/ipv6/ip6frag_high_thresh
echo 3145728 > /proc/sys/net/ipv6/ip6frag_low_thresh
echo 0 > /proc/sys/net/ipv6/ip6frag_secret_interval
echo 48 > /proc/sys/net/ipv6/ip6frag_time
echo 0 > /proc/sys/net/ipv6/ip_nonlocal_bind
echo 2147483647 > /proc/sys/net/ipv6/max_dst_opts_length
echo 8 > /proc/sys/net/ipv6/max_dst_opts_number
echo 2147483647 > /proc/sys/net/ipv6/max_hbh_length
echo 8 > /proc/sys/net/ipv6/max_hbh_opts_number
echo 64 > /proc/sys/net/ipv6/mld_max_msf
echo 2 > /proc/sys/net/ipv6/mld_qrv
echo 100 > /proc/sys/net/ipv6/neigh/default/anycast_delay
echo 0 > /proc/sys/net/ipv6/neigh/default/app_solicit
echo 30 > /proc/sys/net/ipv6/neigh/default/base_reachable_time
echo 30000 > /proc/sys/net/ipv6/neigh/default/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv6/neigh/default/delay_first_probe_time
echo 30 > /proc/sys/net/ipv6/neigh/default/gc_interval
echo 60 > /proc/sys/net/ipv6/neigh/default/gc_stale_time
echo 128 > /proc/sys/net/ipv6/neigh/default/gc_thresh1
echo 512 > /proc/sys/net/ipv6/neigh/default/gc_thresh2
echo 1024 > /proc/sys/net/ipv6/neigh/default/gc_thresh3
echo 5000 > /proc/sys/net/ipv6/neigh/default/interval_probe_time_ms
echo 0 > /proc/sys/net/ipv6/neigh/default/locktime
echo 0 > /proc/sys/net/ipv6/neigh/default/mcast_resolicit
echo 3 > /proc/sys/net/ipv6/neigh/default/mcast_solicit
echo 80 > /proc/sys/net/ipv6/neigh/default/proxy_delay
echo 64 > /proc/sys/net/ipv6/neigh/default/proxy_qlen
echo 250 > /proc/sys/net/ipv6/neigh/default/retrans_time
echo 1000 > /proc/sys/net/ipv6/neigh/default/retrans_time_ms
echo 3 > /proc/sys/net/ipv6/neigh/default/ucast_solicit
echo 101 > /proc/sys/net/ipv6/neigh/default/unres_qlen
echo 212992 > /proc/sys/net/ipv6/neigh/default/unres_qlen_bytes
echo 100 > /proc/sys/net/ipv6/neigh/eth0/anycast_delay
echo 0 > /proc/sys/net/ipv6/neigh/eth0/app_solicit
echo 30 > /proc/sys/net/ipv6/neigh/eth0/base_reachable_time
echo 30000 > /proc/sys/net/ipv6/neigh/eth0/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv6/neigh/eth0/delay_first_probe_time
echo 60 > /proc/sys/net/ipv6/neigh/eth0/gc_stale_time
echo 5000 > /proc/sys/net/ipv6/neigh/eth0/interval_probe_time_ms
echo 0 > /proc/sys/net/ipv6/neigh/eth0/locktime
echo 0 > /proc/sys/net/ipv6/neigh/eth0/mcast_resolicit
echo 3 > /proc/sys/net/ipv6/neigh/eth0/mcast_solicit
echo 80 > /proc/sys/net/ipv6/neigh/eth0/proxy_delay
echo 64 > /proc/sys/net/ipv6/neigh/eth0/proxy_qlen
echo 250 > /proc/sys/net/ipv6/neigh/eth0/retrans_time
echo 1000 > /proc/sys/net/ipv6/neigh/eth0/retrans_time_ms
echo 3 > /proc/sys/net/ipv6/neigh/eth0/ucast_solicit
echo 101 > /proc/sys/net/ipv6/neigh/eth0/unres_qlen
echo 212992 > /proc/sys/net/ipv6/neigh/eth0/unres_qlen_bytes
echo 100 > /proc/sys/net/ipv6/neigh/lo/anycast_delay
echo 0 > /proc/sys/net/ipv6/neigh/lo/app_solicit
echo 30 > /proc/sys/net/ipv6/neigh/lo/base_reachable_time
echo 30000 > /proc/sys/net/ipv6/neigh/lo/base_reachable_time_ms
echo 5 > /proc/sys/net/ipv6/neigh/lo/delay_first_probe_time
echo 60 > /proc/sys/net/ipv6/neigh/lo/gc_stale_time
echo 5000 > /proc/sys/net/ipv6/neigh/lo/interval_probe_time_ms
echo 0 > /proc/sys/net/ipv6/neigh/lo/locktime
echo 0 > /proc/sys/net/ipv6/neigh/lo/mcast_resolicit
echo 3 > /proc/sys/net/ipv6/neigh/lo/mcast_solicit
echo 80 > /proc/sys/net/ipv6/neigh/lo/proxy_delay
echo 64 > /proc/sys/net/ipv6/neigh/lo/proxy_qlen
echo 250 > /proc/sys/net/ipv6/neigh/lo/retrans_time
echo 1000 > /proc/sys/net/ipv6/neigh/lo/retrans_time_ms
echo 3 > /proc/sys/net/ipv6/neigh/lo/ucast_solicit
echo 101 > /proc/sys/net/ipv6/neigh/lo/unres_qlen
echo 212992 > /proc/sys/net/ipv6/neigh/lo/unres_qlen_bytes
echo 9 > /proc/sys/net/ipv6/route/gc_elasticity
echo 30 > /proc/sys/net/ipv6/route/gc_interval
echo 0 > /proc/sys/net/ipv6/route/gc_min_interval
echo 500 > /proc/sys/net/ipv6/route/gc_min_interval_ms
echo 1024 > /proc/sys/net/ipv6/route/gc_thresh
echo 60 > /proc/sys/net/ipv6/route/gc_timeout
echo 4096 > /proc/sys/net/ipv6/route/max_size
echo 1220 > /proc/sys/net/ipv6/route/min_adv_mss
echo 600 > /proc/sys/net/ipv6/route/mtu_expires
echo 0 > /proc/sys/net/ipv6/route/skip_notify_on_dev_down
echo 0 > /proc/sys/net/ipv6/seg6_flowlabel
echo 32768 > /proc/sys/net/ipv6/xfrm6_gc_thresh
echo 120 > /proc/sys/net/mptcp/add_addr_timeout
echo 1 > /proc/sys/net/mptcp/allow_join_initial_addr_port
echo 0 > /proc/sys/net/mptcp/checksum_enabled
echo 1 > /proc/sys/net/mptcp/enabled
echo 0 > /proc/sys/net/mptcp/pm_type
echo 4 > /proc/sys/net/mptcp/stale_loss_cnt
echo 16384 > /proc/sys/net/netfilter/nf_conntrack_buckets
echo 1 > /proc/sys/net/netfilter/nf_conntrack_checksum
echo 1 > /proc/sys/net/netfilter/nf_conntrack_dccp_loose
echo 64 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_closereq
echo 64 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_closing
echo 43200 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_open
echo 480 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_partopen
echo 240 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_request
echo 480 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_respond
echo 240 > /proc/sys/net/netfilter/nf_conntrack_dccp_timeout_timewait
echo 2 > /proc/sys/net/netfilter/nf_conntrack_events
echo 1024 > /proc/sys/net/netfilter/nf_conntrack_expect_max
echo 4194304 > /proc/sys/net/netfilter/nf_conntrack_frag6_high_thresh
echo 3145728 > /proc/sys/net/netfilter/nf_conntrack_frag6_low_thresh
echo 60 > /proc/sys/net/netfilter/nf_conntrack_frag6_timeout
echo 600 > /proc/sys/net/netfilter/nf_conntrack_generic_timeout
echo 30 > /proc/sys/net/netfilter/nf_conntrack_gre_timeout
echo 180 > /proc/sys/net/netfilter/nf_conntrack_gre_timeout_stream
echo 30 > /proc/sys/net/netfilter/nf_conntrack_icmp_timeout
echo 30 > /proc/sys/net/netfilter/nf_conntrack_icmpv6_timeout
echo 0 > /proc/sys/net/netfilter/nf_conntrack_log_invalid
echo 65536 > /proc/sys/net/netfilter/nf_conntrack_max
echo 10 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_closed
echo 3 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_cookie_echoed
echo 3 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_cookie_wait
echo 432000 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_established
echo 210 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_heartbeat_acked
echo 30 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_heartbeat_sent
echo 3 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_shutdown_ack_sent
echo 0 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_shutdown_recd
echo 0 > /proc/sys/net/netfilter/nf_conntrack_sctp_timeout_shutdown_sent
echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_be_liberal
echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_ignore_invalid_rst
echo 1 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
echo 3 > /proc/sys/net/netfilter/nf_conntrack_tcp_max_retrans
echo 10 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close
echo 60 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_close_wait
echo 432000 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
echo 120 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_fin_wait
echo 30 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_last_ack
echo 300 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_max_retrans
echo 60 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_recv
echo 120 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_syn_sent
echo 120 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_time_wait
echo 300 > /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_unacknowledged
echo 0 > /proc/sys/net/netfilter/nf_conntrack_timestamp
echo 30 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
echo 120 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream
echo 30 > /proc/sys/net/netfilter/nf_flowtable_tcp_timeout
echo 30 > /proc/sys/net/netfilter/nf_flowtable_udp_timeout
echo 0 > /proc/sys/net/netfilter/nf_hooks_lwtunnel



fi


if dmesg | grep -q raid ; then
sysctl -w dev.raid.speed_limit_min=1000000
sysctl -w dev.raid.speed_limit_max=1000000
echo 8 > /sys/block/md0/md/group_thread_cnt; fi



#if $(! $wrt) ; then
#sysctl -w net.ipv4.conf.all.accept_source_route=0
#sysctl -w net.ipv4.conf.all.forwarding=0
#sysctl -w net.ipv6.conf.all.forwarding=0
#sysctl -w net.ipv4.conf.all.mc_forwarding=0
#sysctl -w net.ipv6.conf.all.mc_forwarding=0
#sysctl -w net.ipv4.conf.all.accept_redirects=0
#sysctl -w net.ipv6.conf.all.accept_redirects=0
#sysctl -w net.ipv4.conf.all.secure_redirects=0
#sysctl -w net.ipv4.conf.all.send_redirects=0
#sysctl -w net.ipv4.conf.default.send_redirects=0 ; fi



#################################################################################################

# debian stuff
if $linux ; then



if [ ! -f /home/"$himri"/.config/brave-flags.conf ] ; then
echo "--type=renderer --event-path-policy=0 --change-stack-guard-on-fork=enable --num-raster-threads=$(nproc --all) --enable-zero-copy --disable-partial-raster --enable-features=CanvasOopRasterization,CastStreamingAv1,CastStreamingVp9,EnableDrDc,ForceGpuMainThreadToNormalPriorityDrDc,ParallelDownloading,RawDraw,Vp9kSVCHWDecoding,WindowsScrollingPersonality,enable-pixel-canvas-recording.enable-accelerated-video-encode --ignore-gpu-blacklist --enable-webgl --force-device-scale-factor=1.00 --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-zero-copy --enable-accelerated-mjpeg-decode --enable-accelerated-video --use-gl=egl --disable-gpu-driver-bug-workarounds --enable-features=UseOzonePlatform --ozone-platform=x11 --smooth-scrolling --enable-quic --enable-raw-draw --canvas-oop-rasterization --force-gpu-main-thread-to-normal-priority-drdc --enable-drdc --enable-vp9-kSVC-decode-acceleration --windows-scrolling-personality --back-forward-cache --enable-pixel-canvas-recording --enable-accelerated-video-encode --memlog-sampling-rate=5242880 --enable-parallel-downloading --enable-features=VaapiVideoDecoder --use-gl=desktop" | tee /home/"$himri"/.config/brave-flags.conf /home/"$himri"/.config/chromium-flags.conf ; fi

#if $(! grep -q getent /etc/chromium.d/default-flags) ; then
#echo 'export CHROMIUM_FLAGS="$CHROMIUM_FLAGS $(cat /home/$(getent passwd | grep 1000 | awk -F '\'':'\'' '\''{print $1}'\'')/.config/chromium-flags.conf)"' | tee -a /etc/chromium.d/default-flags ; fi

if [ $firstrun = yes ] && [ $script_autoupdate = yes ] ; then
mkdir -p tmp
mkdir -p /home/$himri/.config/BraveSoftware/Brave-Browser-Nightly/Default
mkdir -p /home/$himri/.config/chromium/Default
su $himri -c "mkcomposecache en_US.UTF-8 /var/tmp/buildroot/usr/share/X11/locale/en_US.UTF-8/Compose /var/tmp/buildroot/var/X11R6/compose_cache /usr/share/X11/locale/en_US.UTF-8/Compose"
wget https://raw.githubusercontent.com/freedesktop/xorg-mkcomposecache/master/mkallcomposecaches.sh -O tmp/mkcache.sh ; chmod +x tmp/mkcache.sh ; sh tmp/mkcache.sh ; su $himri -c 'sh tmp/mkcache.sh'
wget ${rawlink}/.basicsetup/.mozilla/firefox/.default-release/prefs.js -O tmp/firefox.js ; if [ -e tmp/firefox.js ] ; then cp -f tmp/firefox.js /etc/firefox/firefox.js ; fi
wget ${rawlink}/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Default/Preferences -O tmp/Preferences ; if [ -e tmp/Preferences ] ; then cp -f tmp/Preferences /home/$himri/.config/BraveSoftware/Brave-Browser-Nightly/Default/Preferences ; cp -f Preferences tmp/Local State" "/home/$himri/.config/chromium/Default/Preferences
wget ${rawlink}/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Local%20State -O "tmp/Local State" ; if [ -e "tmp/Local State" ] ; then cp -f "tmp/Local State" "/home/$himri/.config/BraveSoftware/Brave-Browser-Nightly/Local State" ; cp -f "tmp/Local State" "/home/$himri/.config/chromium/Local State" ; fi ; fi ; fi



sed -i 's/StartServer=.*/StartServer=false/g' /home/$himri/.config/akonadi/akonadiserverrc # kde bloat harming performance 




if dmesg | grep -q amdgpu && ! grep -q amdgpu /etc/modules ; then echo 'amdgpu' | tee -a /etc/modules ; fi

if [ ! -f /etc/dxvk.conf ] ; then wget https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/dxvk.conf ; fi


echo '[Theme]
CursorTheme=Vimix-cursors
Font=Noto Sans,10,-1,5,50,0,0,0,0,0,Condensed

[X11]
ServerArguments=-nolisten tcp -nolisten udp' | tee /etc/sddm.conf.d/kde_settings.conf # attempt to make xserver local and block udp tcp however using `local "$@"'` here as well makes xserver unable to start



echo '#!/bin/sh
exec /usr/bin/X -nolisten tcp -nolisten udp -nolisten local "$@"' | tee /etc/X11/xinit/xserverrc  # attempt to make xserver local and block udp tcp

# pulseaudio
 sed -i 's|load-module module-switch-on-connect|#load-module module-switch-on-connect|g' /etc/pulse/default.pa
 sed -i 's|load-module module-esound-protocol-unix|#load-module module-esound-protocol-unix|g' /etc/pulse/default.pa




# debian extra conf
sed -i 's/3/2/g' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
echo "options iwlwifi 11n_disable=8" | tee /etc/modprobe.d/iwlwifi-speed.conf
sed --in-place 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
rm -f /etc/xdg/autostart/tracker-miner-fs-3.desktop /etc/xdg/autostart/snap-userd-autostart.desktop /etc/xdg/autostart/gnome-keyring*.desktop /etc/xdg/autostart/geoclue-demo-agent.desktop /etc/xdg/autostart/org.kde.kdeconnect.daemon.desktop /etc/xdg/autostart/baloo_file.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.DiskUtilityNotify.desktop /etc/xdg/autostart/org.kde.discover.notifier.desktop /etc/xdg/autostart/printer-applet.desktop /etc/xdg/autostart/konqy_preload.desktop /etc/xdg/autostart/powerdevil.desktop /etc/xdg/autostart/orca-autostart.desktop /etc/xdg/autostart/firewall-applet.desktop /etc/xdg/autostart/kup-daemon.desktop /etc/xdg/autostart/ org.kde.kalendarac.desktop






# drirc
#if $(! grep -q "<vblank_mode>" /etc/drirc) ; then

echo '<driconf>
<device driver="amdgpu">
<application name="Default">
<option name="adaptive_sync" type="bool" value="true"/>
<option name="allow_draw_out_of_order" type="bool" default="true" value="true"/>
<option name="allow_extra_pp_tokens" value="false"/>
<option name="allow_glsl_120_subset_in_110" value="true"/>
<option name="allow_glsl_builtin_const_expression" value="false"/>
<option name="allow_glsl_builtin_variable_redeclaration" value="true"/>
<option name="allow_glsl_compat_shaders" value="false"/>
<option name="allow_glsl_cross_stage_interpolation_mismatch" value="true"/>
<option name="allow_glsl_extension_directive_midshader" value="false"/>
<option name="allow_glsl_relaxed_es" value="true"/>
<option name="allow_higher_compat_version" value="true"/>
<option name="allow_invalid_glx_destroy_window" type="bool" default="false"/>
<option name="allow_rgb10_configs" type="bool" default="true"/>
<option name="always_have_depth_buffer" type="bool" default="true"/>
<option name="disable_arb_gpu_shader5" value="0"/>
<option name="disable_blend_func_extended" value="false"/>
<option name="disable_glsl_line_continuations" value="false"/>
<option name="do_dce_before_clip_cull_analysis" value="true"/>
<option name="force_compat_profile" type="bool" default="false"/>
<option name="force_compat_shaders" type="bool" default="false"/>
<option name="force_direct_glx_context" type="bool" default="true" value="true"/>
<option name="force_gl_map_buffer_synchronized" type="bool" default="false"/>
<option name="force_gl_names_reuse" value="false"/>
<option name="force_gl_renderer" type="string" default=""/>
<option name="force_gl_vendor" type="string" default=""/>
<option name="force_glsl_abs_sqrt" value="false"/>
<option name="force_glsl_extensions_warn" value="false"/>
<option name="force_glsl_version" value="4.6"/>
<option name="force_integer_tex_nearest" type="bool" default="false"/>
<option name="force_protected_content_check" type="bool" default="false"/>
<option name="force_s3tc_enable" value="true"/>
<option name="fragment_shader" value="true"/>
<option name="fthrottle_mode" value="1"/>
<option name="glsl_correct_derivatives_after_discard" value="false"/>
<option name="glsl_ignore_write_to_readonly_var" default="false"/>
<option name="glsl_zero_init" type="bool" default="false"/>
<option name="glthread_nop_check_framebuffer_status" type="bool" default="false"/>
<option name="glx_extension_override" type="string" default=""/>
<option name="ignore_map_unsynchronized" type="bool" default="false"/>
<option name="indirect_gl_extension_override" type="string" default=""/>
<option name="keep_native_window_glx_drawable" type="bool" default="false"/>
<option name="mesa_extension_override" type="string" default=""/>
<option name="mesa_glthread" value="true"/>
<option name="mesa_no_error" value="true"/>
<option name="override_vram_size" type="int" default="-1" valid="-1:2147483647"/>
<option name="pp_celshade" value="0"/>
<option name="pp_jimenezmlaa" value="0"/>
<option name="pp_jimenezmlaa_color" value="0"/>
<option name="precise_trig" value="true"/>
<option name="radeonsi_aux_debug" value="false"/>
<option name="radeonsi_clamp_div_by_zero" type="bool" default="false"/>
<option name="radeonsi_dcc_msaa" value="true"/>
<option name="radeonsi_debug_disassembly" value="false"/>
<option name="radeonsi_disable_sam" value="false"/>
<option name="radeonsi_dump_shader_binary" value="false"/>
<option name="radeonsi_enable_sam" value="true"/>
<option name="radeonsi_force_use_fma32" default="false"/>
<option name="radeonsi_fp16" type="bool" default="true"/>
<option name="radeonsi_halt_shaders" value="false"/>
<option name="radeonsi_inline_uniforms" value="true"/>
<option name="radeonsi_mall_noalloc" value="false"/>
<option name="radeonsi_max_vram_map_size" type="int" default="8196" valid="-2147483648:2147483647"/>
<option name="radeonsi_no_infinite_interp" type="bool" default="false"/>
<option name="radeonsi_sync_compile" value="false"/>
<option name="radeonsi_tc_max_cpu_storage_size" type="int" default="2500" valid="-2147483648:2147483647"/>
<option name="radeonsi_vrs2x2" value="true"/>
<option name="radeonsi_vs_fetch_always_opencode" value="false"/>
<option name="radeonsi_zerovram" value="false"/>
<option name="stub_occlusion_query" value="true"/>
<option name="tcl_mode" value="3"/>
<option name="transcode_astc" type="bool" default="false"/>
<option name="transcode_etc" type="bool" default="false"/>
<option name="vblank_mode" value="0"/>
<option name="vs_position_always_invariant" type="bool" default="false"/>
<option name="vs_position_always_precise" type="bool" default="false"/>
</application>
</device>
</driconf>' | tee /home/$(ls /home)/.drirc /root/.drirc /etc/drirc
if dmesg | grep -q nvidia ; then sed -i 's/<device driver="amdgpu">/<device driver="nvidia">/g' /home/$(ls /home)/.drirc /root/.drirc /etc/drirc ; elif dmesg | grep -q iris ; then sed -i 's/<device driver="amdgpu">/<device driver="iris">/g' /home/$(ls /home)/.drirc /root/.drirc /etc/drirc ; fi # ; fi





# prevent motd news
sed -i -e 's/ENABLED=.*/ENABLED=0/' /etc/default/motd-news

        git config --global http.sslverify "true"
        git config --global init.defaultBranch master
        git config --global color.diff auto
        git config --global color.status auto
        git config --global color.branch auto
        git config --global lfs.allowincompletepush true
        git config --global apply.ignoreWhitespace
        git config --global rerere.enabled true
        git config --global credential.helper cache
        git config --global credential.credentialStore cache


if grep -q btrfs /etc/fstab ; then
# btrfs tweaks if disk is
systemctl enable btrfs-scrub@home.timer
systemctl enable btrfs-scrub@-.timer
btrfs balance start -musage=0 -dusage=50 / ; fi





# mpv video player codec stuff
echo 'vo=gpu
profile=opengl-hq
hwdec=auto
hwdec-codecs=all
scale=ewa_lanczossharp
cscale=ewa_lanczossharp
interpolation
tscale=oversample' | tee /etc/.config/mpv/mpv.conf


if $(! grep -q "xrandr --auto" /etc/X11/xinit/xinitrc) ; then
echo 'xrandr --auto' | tee -a /etc/X11/xinit/xinitrc ; fi


# kde config linux, debian
mkdir -p /home/"$himri"/.config/plasma-workspace/env






# disable polling gpu
if $(! grep -q poll=0 /etc/modprobe.d/modprobe.conf) ; then
echo 'options drm_kms_helper poll=0' | tee -a /etc/modprobe.d/modprobe.conf ; fi





# enable kde compose cache on disk
mkdir -p /var/cache/libx11/compose
mkdir -p /home/"$himri"/.compose-cache
touch /home/"$himri"/.XCompose
mkdir -p $HOME/.compose-cache
touch $HOME/.XCompose



# stop akonadi-server
sed -i 's/StartServer.*/StartServer=false/' /home/"$himri"/.config/akonadi/akonadiserverrc

#resolution=$(echo $(xrandr --current | head -n 6 | tail -n 1 | awk '{print $1}'))
#resolution=$(echo $(xrandr --current | grep current | awk '{print $8$9$10}' | sed 's/\,.*//'))






# xorg screen
echo 'Section "Screen"
       Identifier     "Screen"
       DefaultDepth    24
       SubSection      "Display"
       Depth           24
       Option "NoAccel" "false"
       Option "Accel" "true"
       Option "DPMS" "true"
       EndSubSection
EndSection' | tee /etc/X11/xorg.conf.d/10-screen.conf

#echo 'Section "Monitor"
#    Identifier     "Monitor0"
#    Option         "DPMS"
#EndSection' | tee /etc/X11/xorg.conf.d/10-monitor.conf



# enable dri 3
# https://manpages.ubuntu.com/manpages/kinetic/en/man4/intel.4.html
# https://manpages.ubuntu.com/manpages/kinetic/en/man5/xorg.conf.5.html
if glxinfo | grep -qi amdgpu ; then
for i in $( echo *nvidia* ; echo *intel*) ; do rm -rf /usr/share/X11/xorg.conf.d/$i /etc/X11/xorg.conf.d/$i ; done
#if $(! grep -q 'DDC' /usr/share/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) /etc/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu)) ; then
echo 'Section "OutputClass"
  Identifier "AMDgpu"
  MatchDriver "amdgpu"
  Driver "amdgpu"
  Option "DRI2" "0"
  Option "DRI" "3"
  Option "DRI3" "1"
  Option "TearFree" "true"
  Option "SwapbuffersWait" "true"
  Option "EnablePageFlip" "on"
  Option "NoAccel" "false"
  Option "Accel" "true"
  Option "TripleBuffer" "true"
  Option "Present" "true"
  Option "FallbackDebug" "false"
  Option "DebugFlushBatches" "false"
  Option "DebugFlushCaches" "false"
  Option "DebugWait" "false"
  Option "HWRotation" "true"
  Option "PageFlip" "true"
  Option "Tiling" "true"
  Option "RelaxedFencing" "true"
  Option "Throttle" "true"
  Option "HotPlug" "true"
  Option "DDC" "true"
  Option "Dac6Bit" "true"
  Option "VariableRefresh" "true"
  Option "ForceCompositionPipeline" "on"
  Option "AllowIndirectGLXProtocol" "off"
  Option "SWcursor" "off"
  Option "HWCursor" "on"
  Option "FastVram" "on"
  Option "DPMS" "on"
  Option "FramebufferCompression" "true"
  Option "AccelMethod" "glamor"
  #Option "CacheLines" "256"
  Option "RenderAccel" "true"
  Option "AllowGLXWithComposite" "true"
EndSection' | tee /usr/share/X11/xorg.conf.d/10-amdgpu.conf /etc/X11/xorg.conf.d/10-amdgpu.conf
#tee /usr/share/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) /etc/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) # ; fi


echo 'Section "OutputClass"
  Identifier "Radeon"
  MatchDriver "radeon"
  Driver "radeon"
  Option "DRI2" "0"
  Option "DRI" "3"
  Option "DRI3" "1"
  Option "TearFree" "true"
  Option "SwapbuffersWait" "true"
  Option "EnablePageFlip" "on"
  Option "NoAccel" "false"
  Option "Accel" "true"
  Option "TripleBuffer" "true"
  Option "Present" "true"
  Option "FallbackDebug" "false"
  Option "DebugFlushBatches" "false"
  Option "DebugFlushCaches" "false"
  Option "DebugWait" "false"
  Option "HWRotation" "true"
  Option "PageFlip" "true"
  Option "Tiling" "true"
  Option "RelaxedFencing" "true"
  Option "Throttle" "true"
  Option "HotPlug" "true"
  Option "DDC" "true"
  Option "Dac6Bit" "true"
  Option "VariableRefresh" "true"
  Option "ForceCompositionPipeline" "on"
  Option "AllowIndirectGLXProtocol" "off"
  Option "SWcursor" "off"
  Option "HWCursor" "on"
  Option "FastVram" "on"
  Option "DPMS" "on"
  Option "FramebufferCompression" "true"
  Option "AccelMethod" "glamor"
  #Option "CacheLines" "256"
  Option "RenderAccel" "true"
  Option "AllowGLXWithComposite" "true"
EndSection' | tee /usr/share/X11/xorg.conf.d/10-radeon.conf /etc/X11/xorg.conf.d/10-radeon.conf
#tee /usr/share/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep radeon) $(if $(ls /usr/share/X11/xorg.conf.d | grep -q radeon) ; then echo "/etc/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep radeon)" ; fi)
fi

if glxinfo | grep -qi intel ; then
for i in $( echo *amdgpu* ; echo *radeon* ; echo *nvidia*) ; do rm -rf /usr/share/X11/xorg.conf.d/$i /etc/X11/xorg.conf.d/$i ; done
echo 'Section "OutputClass"
  Identifier "Intel Graphics"
  MatchDriver "intel"
  Driver "intel"
  Option "DRI2" "0"
  Option "DRI" "3"
  Option "DRI3" "1"
  Option "TearFree" "true"
  Option "SwapbuffersWait" "true"
  Option "EnablePageFlip" "on"
  Option "NoAccel" "false"
  Option "Accel" "true"
  Option "TripleBuffer" "true"
  Option "Present" "true"
  Option "FallbackDebug" "false"
  Option "DebugFlushBatches" "false"
  Option "DebugFlushCaches" "false"
  Option "DebugWait" "false"
  Option "HWRotation" "true"
  Option "PageFlip" "true"
  Option "Tiling" "true"
  Option "RelaxedFencing" "true"
  Option "Throttle" "true"
  Option "HotPlug" "true"
  Option "DDC" "true"
  Option "Dac6Bit" "true"
  Option "VariableRefresh" "true"
  Option "ForceCompositionPipeline" "on"
  Option "AllowIndirectGLXProtocol" "off"
  Option "SWcursor" "off"
  Option "HWCursor" "on"
  Option "FastVram" "on"
  Option "DPMS" "on"
  Option "FramebufferCompression" "true"
  Option "AccelMethod" "glamor"
  #Option "CacheLines" "256"
  Option "RenderAccel" "true"
  Option "AllowGLXWithComposite" "true"
EndSection' | tee /usr/share/X11/xorg.conf.d/10-intel.conf /etc/X11/xorg.conf.d/10-intel.conf
fi

if glxinfo | grep -qi nvidia ; then
for i in $( echo *amdgpu* ; echo *radeon* ; echo *intel*) ; do rm -rf /usr/share/X11/xorg.conf.d/$i /etc/X11/xorg.conf.d/$i ; done
echo 'Section "OutputClass"
  Identifier "NVIDIA Card"
  MatchDriver "nvidia"
  Driver "nvidia"
  VendorName "NVIDIA Corporation"
  Option "DRI2" "0"
  Option "DRI" "3"
  Option "DRI3" "1"
  Option "TearFree" "true"
  Option "SwapbuffersWait" "true"
  Option "EnablePageFlip" "on"
  Option "NoAccel" "false"
  Option "Accel" "true"
  Option "TripleBuffer" "true"
  Option "Present" "true"
  Option "FallbackDebug" "false"
  Option "DebugFlushBatches" "false"
  Option "DebugFlushCaches" "false"
  Option "DebugWait" "false"
  Option "HWRotation" "true"
  Option "PageFlip" "true"
  Option "Tiling" "true"
  Option "RelaxedFencing" "true"
  Option "Throttle" "true"
  Option "HotPlug" "true"
  Option "DDC" "true"
  Option "Dac6Bit" "true"
  Option "VariableRefresh" "true"
  Option "ForceCompositionPipeline" "on"
  Option "AllowIndirectGLXProtocol" "off"
  Option "SWcursor" "off"
  Option "HWCursor" "on"
  Option "FastVram" "on"
  Option "DPMS" "on"
  Option "FramebufferCompression" "true"
  Option "AccelMethod" "glamor"
  #Option "CacheLines" "256"
  Option "RenderAccel" "true"
  Option "AllowGLXWithComposite" "true"
EndSection' | tee /usr/share/X11/xorg.conf.d/10-nvidia.conf /etc/X11/xorg.conf.d/10-nvidia.conf
fi

echo 'Section "Extensions"
        Option "DPMS" "Enable"
        Option "COMPOSITE" "Enable"
        Option "Composite" "Enable"
        Option "DRI3" "Enable"
        Option "record" "Disable"
        Option "MIT-SHM" "Enable"
        Option "XVideo-MotionCompensation" "Enable"
EndSection' | tee /etc/X11/xorg.conf.d/1-extensions.conf

echo 'Section "ServerFlags"
      Option "DontVTSwitch" "false"
      Option "AllowNonLocalXvidtune" "false"
      Option "DontZap" "true"
      Option "IndirectGLX" "false"
      Option "DRI2" "off"
      Option "DRI3" "on"
EndSection' | tee /etc/X11/xorg.conf.d/1-server.conf

echo 'Section "Module"
	Disable  "record"
EndSection' | tee /etc/X11/xorg.conf.d/1-module.conf


echo '[connection]
# 0 (default) 1 (ignore) 2 (disable) 3 (enable)
wifi.powersave = 2' | tee /etc/NetworkManager/conf.d/wifi-powersave-off.conf



# also has mitigations=off option for videocard btw... not needed for me
if glxinfo | grep -q Intel ; then
echo 'options i915 $mitigations='"$inteligpumitigations"' enable_fbc=1 fastboot=1 modeset=1 enable_guc=2 enable_dc=1 mmio_debug=0 guc_log_level=0 enable_dp_mst=1 memtest=0 enable_ips=1 enable_gvt=1 enable_psr=1 psr_safest_params=0 enable_psr2_sel_fetch=1 verbose_state_checks=0
options snd_hda_intel power_save=1' | tee /etc/modprobe.d/i915.conf
fi

echo 'options usbcore autosuspend=5
#options snd_ac97_codec power_save=1' | tee /etc/modprobe.d/suspend.conf

if ip -o link | grep -q wlan ; then
echo 'options rfkill default_state=0 master_switch_mode=1' | tee /etc/modprobe.d/wlanextra.conf
fi

if [ $level = high ] ; then 

echo 'options usbhid mousepoll=4
options ahci mobile_lpm_policy=0
options cec debug=0
options cryptomgr notests
options kvm mmu_audit=0
options libahci ignore_sss=1
options libata force=udma'"$(dmesg | grep 'configured for UDMA' | awk -F 'UDMA' '{print $2}')"',ncq,dma,nodmalog,noiddevlog,nodirlog,lpm,setxfer
options nf_conntrack acct=0
options nfs enable_ino64=1
options pstore backend=null
options scsi_mod use_blk_mq=1 scsi_logging_level=0
options uhci-hcd debug=0
options usb-storage quirks=p
options usbcore usbfs_snoop=0
options drm_kms_helper poll=0
options tcp_bbr2 debug_port_mask=0 debug_ftrace=N debug_with_printk=N ecn_enable=Y fast_path=Y fast_ack_mode=1
options usbcore autosuspend=5
options snd_hda_intel power_save=1
options snd_ac97_codec power_save=1' | tee /etc/modprobe.d/general.conf
fi

if $(find /sys/block/nvme*) ; then
echo 'options nvme_core default_ps_max_latency_us=0' | tee /etc/modprobe.d/nvme.conf
fi


if glxinfo | grep -qi radeon ; then
echo 'options radeon modeset=1 benchmark=0 dynclks=1 tv=0 test=0 disp_priority=2 hw_i2c=1 pcie_gen2=-1 msi=1 fastfb=1 dpm=1 aspm=1 runpm=1 deep_color=1 auxch=1 uvd=1 vce=1 si_support=-1 cik_support=-1' | tee /etc/modprobe.d/radeon.conf
fi

if glxinfo | grep -qi amdgpu ; then
echo ' options amdgpu moverate=-1 disp_priority=2 hw_i2c=1 pcie_gen2=-1 msi=1 dpm=1 aspm=1 runpm=1 bapm=1 sched_jobs=64 deep_color=1 vm_debug=1 exp_hw_support=1 dc=1 ppfeauturemask=0xffffffff cg_mask=0xffffffff pg_mask=0xffffffff lbpw=1 compute_multipipe=1 gpu_recovery=1 ras_enable=1 ras_mask=0xffffffff si_support=-1 cik_support=-1 async_gfx_ring=1 mcbp=1 discovery=1 mes=1 mes_kiq=1 sched_policy=0 cwsr_enable=1 debug_largebar=1 hws_gws_support=1 debug_evictions=false no_system_mem_limit=true tmz=1 ip_block_mask=0xffffffff vcnfw_log=0' | tee /etc/modprobe.d/amdgpu.conf
fi





# xrandr auto scaling
for output in $(xrandr --prop | grep -E -o -i "^[A-Z\-]+-[0-9]+"); do xrandr --output "$output" --set "scaling mode" "Full aspect"; done








# disable x11 running on root
if $(! grep -q 'needs_root_rights = no' /etc/X11/Xwrapper.config) ; then echo 'needs_root_rights = no' | tee -a /etc/X11/Xwrapper.config ; fi



if [ $raid = yes ] ; then systemctl enable $(systemctl list-unit-files | grep mda | awk '{print $1}' | awk -v RS=  '{$1=$1}1' | sed 's/\mdadm-waitidle.service//') ; fi

#if $(! grep QT_NO_GLIB /etc/xdg/autostart/pulseaudio.desktop) ; then
#sed -i 's/Exec=start-pulseaudio-x11/Exec=QT_NO_GLIB=0 start-pulseaudio-x11/g' /etc/xdg/autostart/pulseaudio.desktop ; fi


#GLMode=TFP
#GLVSync=true
#GLPlatformInterface=
#RefreshRate=
#HiddenPreviews=0


# $HOME/.config/kwinrc
echo '[$Version]
update_info=kwin.upd:replace-scalein-with-scale,kwin.upd:port-minimizeanimation-effect-to-js,kwin.upd:port-scale-effect-to-js,kwin.upd:port-dimscreen-effect-to-js,kwin.upd:auto-bordersize,kwin.upd:animation-speed,kwin.upd:desktop-grid-click-behavior,kwin.upd:no-swap-encourage,kwin.upd:make-translucency-effect-disabled-by-default,kwin.upd:remove-flip-switch-effect,kwin.upd:remove-cover-switch-effect,kwin.upd:remove-cubeslide-effect,kwin.upd:remove-xrender-backend,kwin.upd:enable-scale-effect-by-default,kwin.upd:overview-group-plugin-id,kwin.upd:animation-speed-cleanup

[Compositing]
AllowTearing=false
AnimationSpeed=0
Backend=QPainter
CheckIsSafe=false
DisableChecks=true
Enabled=true
GLColorCorrection=false
GLCore=true
GLDirect=true
GLLegacy=false
GLPreferBufferSwap=e
GLStrictBinding=true
GLTextureFilter=0
GraphicsSystem=native
HiddenPreviews=0
LatencyPolicy=Medium
MaxFPS='"$maxframes"'
OpenGLIsUnsafe=true
RenderTimeEstimator=Minimum
UnredirectFullscreen=false
WindowsBlockCompositing=true
XRenderSmoothScale=false

[Desktops]
Name_2[$d]
Number=1
Rows=1

[DrmOutputs]
Scale=1

[Effect-PresentWindows]
BorderActivateAll=9

[Effect-kwin4_effect_translucency]
ComboboxPopups=95
Dialogs=95
DropdownMenus=95
IndividualMenuConfig=true
Menus=95
MoveResize=95
PopupMenus=95
TornOffMenus=95

[Effect-presentwindows]
BorderActivateAll=9

[Effect-windowview]
BorderActivateAll=9

[NightColor]
Active=true
NightTemperature=4000

[Plugins]
autocomposerEnabled=true
blurEnabled=false
contrastEnabled=false
desktopgridEnabled=false
forceblurEnabled=false
kwin-system76-scheduler-integrationEnabled=true
kwin4_effect_dialogparentEnabled=false
kwin4_effect_fadingpopupsEnabled=false
kwin4_effect_frozenappEnabled=false
kwin4_effect_fullscreenEnabled=false
kwin4_effect_loginEnabled=false
kwin4_effect_logoutEnabled=false
kwin4_effect_maximizeEnabled=false
kwin4_effect_morphingpopupsEnabled=false
kwin4_effect_rubberband_maximizeEnabled=false
kwin4_effect_scaleEnabled=false
kwin4_effect_squashEnabled=false
kwin4_effect_translucencyEnabled=true
kwin4_effect_windowapertureEnabled=false
overviewEnabled=false
screenedgeEnabled=false
slideEnabled=false
slidingpopupsEnabled=false
windowviewEnabled=false
wobblywindowsEnabled=true
zoomEnabled=false

[Script-desktopchangeosd]
TextOnly=true

[TabBox]
AutogroupSimilarWindows=true
BorderActivate=9
DesktopLayout=org.kde.breeze.desktop
DesktopListLayout=org.kde.breeze.desktop
LayoutName=org.kde.breeze.desktop
TouchBorderActivate=9

[Windows]
BorderlessMaximizedWindows=false
ElectricBorders=1

[org.kde.kdecoration2]
BorderSize=Large
BorderSizeAuto=false
ButtonsOnLeft=MS
ButtonsOnRight=HIAX
CloseOnDoubleClickOnMenu=false
ShowToolTips=true
library=org.kde.kwin.aurorae
theme=__aurorae__svg__ChromeOS-dark' | tee /home/"$himri"/.config/kwinrc




if grep -q "/usr/bin/gdm3" /etc/X11/default-display-manager ; then
# gnome section - extra
rm -rfd /etc/gdm{3}/custom.conf
rm -rfd /etc/dconf/db/gdm{3}.d/01-logo
rm -rfd /var/lib/gdm{3}/.cache/*
gsettings set org.gnome.system.location enabled false
gsettings set org.gnome.desktop.privacy disable-camera true
gsettings set org.gnome.desktop.privacy disable-microphone true
gsettings set org.gnome.desktop.privacy remember-recent-files false
gsettings set org.gnome.desktop.privacy hide-identity true
gsettings set org.gnome.desktop.privacy report-technical-problems false
gsettings set org.gnome.desktop.privacy send-software-usage-stats false
gsettings set org.gnome.login-screen allowed-failures 100
gsettings set org.gnome.desktop.screensaver user-switch-enabled false
gsettings set org.gnome.SessionManager logout-prompt false
gsettings set org.gnome.desktop.media-handling autorun-never true
gsettings set org.gnome.desktop.sound event-sounds false
gsettings set org.gnome.settings-daemon.plugins.media-keys max-screencast-length 0
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
gsettings set org.gnome.desktop.interface enable-animations false
gsettings set org.gnome.desktop.interface scaling-factor 1
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2
gsettings set org.gnome.mutter experimental-features "['x11-randr-fractional-scaling'"', '"'scale-monitor-framebuffer']"
gsettings set org.gnome.settings-daemon.plugins.xsettings antialiasing 'none'
gsettings set org.gnome.settings-daemon.plugins.xsettings hinting 'full'
gsettings set org.gnome.desktop.peripherals.keyboard delay 500
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 100
gsettings set org.gnome.desktop.peripherals.mouse accel-profile flat
gsettings set org.gtk.Settings.FileChooser show-hidden true
gsettings set org.gnome.mutter attach-modal-dialogs false
gsettings set org.gnome.shell.overrides attach-modal-dialogs false
gsettings set org.gnome.shell.overrides edge-tiling true
gsettings set org.gnome.mutter edge-tiling true
gsettings set org.gnome.desktop.background color-shading-type vertical
gsettings set org.gnome.mutter experimental-features '["dma-buf-screen-sharing"]'



sed -e s/TLP_ENABLE=.*$/TLP_ENABLE=1/g -i /etc/default/tlp
sed -e s/\#CPU_SCALING_GOVERNOR_ON_AC=.*$/CPU_SCALING_GOVERNOR_ON_AC=performance/g -i /etc/default/tlp
sed -e s/\#CPU_SCALING_GOVERNOR_ON_BAT=.*$/CPU_SCALING_GOVERNOR_ON_BAT=powersave/g -i /etc/default/tlp
sed -e s/\#CPU_BOOST_ON_AC=.*$/CPU_BOOST_ON_AC=1/g -i /etc/default/tlp
sed -e s/\#CPU_BOOST_ON_BAT=.*$/CPU_BOOST_ON_BAT=0/g -i /etc/default/tlp
if [ ! $bluetooth = on ] ; then
sed -e s/\#DEVICES_TO_DISABLE_ON_STARTUP=.*$/DEVICES_TO_DISABLE_ON_STARTUP=\"bluetooth\"/g -i /etc/default/tlp
elif [ $bluetooth = on ] ; then
sed -e s/\DEVICES_TO_DISABLE_ON_STARTUP=.*$/DEVICES_TO_DISABLE_ON_STARTUP=/g -i /etc/default/tlp
fi
#sed -e s/\#DEVICES_TO_ENABLE_ON_STARTUP=.*$/DEVICES_TO_ENABLE_ON_STARTUP=\"wifi\"/g -i /etc/default/tlp
fi







if [ $ipv6 = on ]
then
sed -i 's/user_pref("network.dns.disableIPv6", true);/user_pref("network.dns.disableIPv6", false);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
sed -i 's/user_pref("network.notify.IPv6", false);/user_pref("network.notify.IPv6", true);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
else
sed -i 's/user_pref("network.dns.disableIPv6", false);/user_pref("network.dns.disableIPv6", true);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
sed -i 's/user_pref("network.notify.IPv6", true);/user_pref("network.notify.IPv6", false);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js ; fi



#if [ $firstrun = yes ] ; then
#sudo apt -y install uuid-gen # not available in debian repos

#echo '[main]
#plugins=ifupdown,keyfile
#dns=none
#rc-manager=unmanaged
#systemd-resolved=false

#[ifupdown]
#managed=true' | tee /etc/NetworkManager/NetworkManager.conf



#        rm -rf "/etc/NetworkManager/system-connections/*"
#        rm -rf '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
#        touch '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
#        chown root '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
#        chmod 0666 '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'


#        uuidgen="$(uuidgen)"



#echo '[connection]
#id=802-11-wireless connection 1
#uuid=
#type=wifi
#metered=2
#zone=block

#[wifi]
# cloned-mac-address=1A:76:38:6B:A9:A1 # leave disabled handled by macchanger
#mode=infrastructure
#ssid=YourWifiHere

#[ipv4]
#dns='"$dns1"';'"$dns2"';
#dns-search=lan
#ignore-auto-dns=true
#method=auto

#[ipv6]
#addr-gen-mode=stable-privacy
#method=disabled

#[proxy]' | tee '/etc/NetworkManager/system-connections/802-11-wireless connection 1'



#        sed -i '/uuid/c\uuid='"$uuidgen"'' "/etc/NetworkManager/system-connections/802-11-wireless connection 1"




#echo '[connection]
#id=Wired connection 1
#uuid=
#type=ethernet
#metered=2
#zone=block

#[ethernet]
#mtu='"$mtu"'
# cloned-mac-address=CA:11:D1:A5:7E:1D # leave disabled handled by macchanger

#[ipv4]
#dns='"$dns1"';'"$dns2"';
#dns-search=lan
#ignore-auto-dns=true
#method=auto

#[ipv6]
#addr-gen-mode=stable-privacy
#method=disabled

#[proxy]' | tee '/etc/NetworkManager/system-connections/Wired connection 1'



#        sed -i 's/uuid/uuid='"$uuidgen"'/g' '/etc/NetworkManager/system-connections/Wired connection 1'



#        chown root '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'
#        chmod 0600 '/etc/NetworkManager/system-connections/Wired connection 1' '/etc/NetworkManager/system-connections/802-11-wireless connection 1'

#fi



fi
#########  DEBIAN ONLY SECTION STOPPED HERE ###############




















if $(! $wrt) ; then
if [ $safeconfig = no ] ; then
if grep -q preload=yes /etc/bak/dontdelete ; then ld_preload='LD_PRELOAD=' ; fi
fi

if grep -q preload=yes /etc/bak/dontdelete ; then linker="LD=mold" ; fi


if $linux ; then
  # ccache & path
    if $(! sudo grep -q "USE_CCACHE=1" $HOME/.zshrc) ; then
    sed -i "\$aUSE_CCACHE=1" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc
    sed -i "\$aCCACHE_RECACHE=yes" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc
        sed -i "\$aUSE_PREBUILT_CACHE=1" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc
    sed -i "\$aPREBUILT_CACHE_DIR=~/.ccache" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc
    sed -i "\$aCCACHE_DIR=~/.ccache" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc
    sed -i "\$accache -M 30G >/dev/null" $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc ; fi ; fi
    if $(! sudo grep -q 'LD_LIBRARY_PATH' $HOME/.zshrc) ; then
    #echo "$ld_preload" | tee -a /home/"$himri"/.xsessionrc /root/.xsessionrc
    clang=$(ls /usr/lib | grep 'llvm-' | tail -n 1 | rev | cut -c-3 | rev)
    echo 'PATH=/usr/lib/ccache/bin:/lib/x86_64-linux-gnu:/usr/lib/llvm'"$clang"'/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/usr/local/games:/usr/games
    LD_LIBRARY_PATH=$PATH/../lib:$PATH/../lib64:/usr/lib/llvm'"$clang"'/lib:/lib/x86_64-linux-gnu:/usr/lib/jvm/default/lib/server:$LD_LIBRARY_PATH
    '"$ld_preload"'' | tee -a $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc ; elif [ $safeconfig = yes ] ; then sed -i 's/LD_PRELOAD=/#LD_PRELOAD=/g' /etc/environment $HOME/.zshrc $HOME/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc /home/"$himri"/.xsessionrc /root/.xsessionrc /home/"$himri"/.profile /root/.profile ; fi

#if $(! grep -q LD_PRELOAD $HOME/.zshrc) ; then echo "$ld_preload" | tee -a /root/.zshrc /root/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc ; fi

#if $(! grep -q /etc/environment /root/.zshrc) ; then echo '#for i in $(cat /etc/environment | grep -v "-" | grep -v "if" | sed '\''s/\[//g'\'' | sed '\''s/|//g'\'' | awk '\''{print $2}'\'') ; do export $i >/dev/null ; done' | tee -a /root/.zshrc /root/.bashrc /home/"$himri"/.zshrc /home/"$himri"/.bashrc ; fi

# smcr info to check if your hardware is capable
#ld_preload="export LD_PRELOAD=libtrick.so:libmkl_core.so:libomp"$cclm".so.5:libmkl_def.so:libhugetlbfs.so.0:libmimalloc.so.2:libeatmydata.so:libsmc-preload.so.1:libmkl_vml_avx2.so:libmkl_intel_lp64.so:libmkl_intel_thread.so$(if dmesg | grep -q amdgpu ; then echo ":libomptarget.rtl.amdgpu.so.$cclm" | sed 's/-//g'
export PATH="/usr/lib/ccache/bin${PATH:+:}${PATH}"
export CCACHE_DIR="~/.ccache"
#chown $himri ~/.ccache ; chmod 777 ~/.ccache
mkdir -p /home/$himri/.ccache 
mkdir -p /root/.ccache
echo 'max_size = 30G
cache_dir = ~/.ccache
debug = false
umask = 0022
compiler_check = %compiler% -dumpversion
cache_dir_levels = 5
hash_dir = false
compression = true
compression_level = 1
#base_dir = 
#compiler =
#cpp_extension =
depend_mode = false
direct_mode = true
disable = false
#extra_files_to_hash = 
hard_link = false
#hash_dir = true
#ignore_headers_in_manifest = 
keep_comments_cpp = false
limit_multiple = 0.8
log_file = 
#max_files = 0
path = /usr/bin:/usr/local/bin
#log_file = /var/tmp/ccache/ccache.log
#temporary_dir = /tmp/ccache
pch_external_checksum = false
#prefix_command = 
#prefix_command_cpp = 
read_only = false
read_only_direct = false
recache = true
#run_second_cpp = true
stats = true
inode_cache = true
sloppiness = locale,time_macros,file_stat_matches,include_file_ctime,include_file_mtime' | tee /home/$himri/.ccache/ccache.conf /root/.ccache/ccache.conf /var/cache/ccache/ccache.conf

# kde environment variables
kdeenv='__GL_FSAA_MODE=0
__GL_LOG_MAX_ANISO=0
__GL_YIELD=USLEEP
DOTNET_CLI_TELEMETRY_OPTOUT=1
KWIN_TRIPLE_BUFFER=1
KDE_DEBUG=0
KDE_IS_PRELINKED=1
KDE_MALLOC=1
KDE_NO_IPV6=1
KDE_NOUNLOAD=1
KDE_USE_IPV6=no
KDE_UTF8_FILENAMES=1
KWIN_DIRECT_GL=1
KWIN_DRM_PREFER_COLOR_DEPTH=24
KWIN_EXPLICIT_SYNC=0
KWIN_GL_DEBUG=0
KWIN_NO_REMOTE=1
KWIN_NO_XI2=1
KWIN_PERSISTENT_VBO=1
KWIN_USE_BUFFER_AGE=1
LIBGL_DEBUG=0
PLASMA_ENABLE_QML_DEBUG=0
PLASMA_PRELOAD_POLICY=none
POWERSHELL_TELEMETRY_OPTOUT=1
WAYLAND_DEBUG=0
KWIN_USE_INTEL_SWAP_EVENT=1'

#KDEWM='"$windowmanager"'
#DESKTOP_SESSION=plasmawayland
#KDE_FAILSAFE=1
#KDE_FULL_SESSION=true
#KWIN_COMPOSE=Q
#KWIN_FORCE_LANCZOS=0
#KWIN_OPENGL_INTERFACE=egl
#KWIN_OPENGL_INTERFACE=egl_wayland
#QT_AUTO_SCREEN_SCALE_FACTOR=0
#QT_QPA_PLATFORM=wayland-egl
#QT_WAYLAND_FORCE_DPI=$kcmfonts_general_forcefontdpiwayland
#XDG_CURRENT_DESKTOP=KDE
#XDG_SESSION_TYPE=wayland
#XLIB_SKIP_ARGB_VISUALS=0

#XDG vars only work for de, root doesnt run a de
if [ $compositor = x11 ] ; then
xdgidri='OPENGL_PROFILE=xorg-x11
MOZ_X11_EGL=1
EGL_PLATFORM=x11
CLUTTER_BACKEND=x11
MOZ_ENABLE_WAYLAND=0
SDL_VIDEODRIVER=x11
GDK_BACKEND=x11'
if [ ! -z /etc/sddm.conf.d/10-wayland.conf ] ; then rm -f /etc/sddm.conf.d/10-wayland.conf ; fi
elif [ $compositor = wayland ] ; then
xdgidri='MOZ_ENABLE_WAYLAND=1
MOZ_X11_EGL=0
SDL_VIDEODRIVER=wayland
GDK_BACKEND=wayland'
if [ ! -f /etc/sddm.conf.d/10-wayland.conf ] ; then
mkdir -p /etc/sddm.conf.d
echo '[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
CompositorCommand=kwin_wayland --no-lockscreen' | tee /etc/sddm.conf.d/10-wayland.conf ; fi
fi

if [ $(awk '/ID=/{print}' /etc/os-release | cut -d '=' -f 2 | head -n1) = arch ] || [ $(awk '/ID=/{print}' /etc/os-release | cut -d '=' -f 2 | head -n1) = debian ] ; then
posix='LC_ALL=C
LANG=C
LC_COLLATE=C'
fi

#if $arch && ldconfig -p | grep -q libmimalloc ; then ld_preload="LD_PRELOAD=$(ldconfig -p | grep libmimalloc | head -n1 | awk -F '>' '{print $2}')" ; fi

if [ $level = high ] ; then 
# /etc/environment variables
# test what works for you, kde desktop runs on opengl backend. turning all these on makes it lag.
# for more info: https://docs.mesa3d.org/envvars.html
# https://cgit.freedesktop.org/mesa/mesa/tree/docs/features.txt?h=staging/22.3
echo '#!/bin/sh -x
PATH=/usr/lib/ccache/bin:/lib/x86_64-linux-gnu:/usr/lib/llvm*/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/usr/local/games:/usr/games
LD_LIBRARY_PATH='"$PATH"'/../lib:'"$PATH"'/../lib64:/usr/lib/llvm*/lib:/lib/x86_64-linux-gnu:/usr/lib/jvm/default/lib/server 
LDPATH='"$PATH"'/../lib:'"$PATH"'/../lib64:/usr/lib/llvm*/lib
'"$ld_preload"'
'"$linker"'
'"$kdeenv"'
'"$xdgidri"'
'"$posix"'
LD='"$(which mold)"'
XIM_GLOBAL_CACHE_DIR=/var/cache/libx11/compose
XCOMPOSEFILE=~/.XCompose
XCOMPOSECACHE=~/.compose-cache
WLR_RENDERER=vulkan
WLR_DRM_NO_MODIFIERS=1
WLR_DRM_NO_ATOMIC=1
WL_OUTPUT_SUBPIXEL_NONE=none
WINIT_HIDPI_FACTOR=2
WINEPREFIX=~/.wine
WINEFSYNC_SPINCOUNT=24
WINEFSYNC_FUTEX2=1
WINEFSYNC=1
WINEESYNC=1
WINE_VK_USE_FSR=1
WINE_SKIP_MONO_INSTALLATION=1
WINE_SKIP_GECKO_INSTALLATION=1
WINE_LARGE_ADDRESS_AWARE=1
WINE_FULLSCREEN_STR=1
WINE_FULLSCREEN_FSR=1
WINE_FSR_OVERRIDE=1
WGL_SWAP_INTERVAL=1
WGL_FORCE_MSAA=0
VKD3D_CONFIG=no_upload_hvv
VGL_READBACK=pbo
VDPAU_DRIVER=va_gl
VAAPI_MPEG4_ENABLED=1
tlink="'"${rawlink}"'/'"${file}"'"
TCMALLOC_MEMFS_MALLOC_PATH=/tmp
SYSTEMD_SECCOMP='"$seccomp"'
SYSTEMD_PROC_CMDLINE="'"$par"'"
SYSTEMD_EFI_OPTIONS="'"$par"'"
SYSTEMD_LOG_SECCOMP=0
SYSTEMD_LIST_NON_UTF8_LOCALES=0
SYSTEMCTL_SKIP_SYSV=1
#STRIP=llvm-strip'"$cclm"'
STEAM_FRAME_FORCE_CLOSE=0
STAGING_WRITECOPY=1
STAGING_SHARED_MEMORY=1
STAGING_RT_PRIORITY_SERVER=90
STAGING_RT_PRIORITY_SERVER=4
STAGING_RT_PRIORITY_BASE=2
STAGING_AUDIO_PERIOD=13333
SOFTPIPE_USE_LLVM=1
SMC_DEBUG=0
SDL_VIDEO_YUV_HWACCEL=1
SDL_VIDEO_X11_DGAMOUSE=0
SDL_VIDEO_FULLSCREEN_HEAD=0
RUN_MKCONFIG=true
RTLD_NODELETE=1
RTLD_NEXT=1
RTLD_LAZY=1
RTLD_GLOBAL=1
#READELF=llvm-readelf'"$cclm"'
RADV_TEX_ANISO=0
RADV_PERFTEST=aco,sam,nggc,rt,dccmsaa
RADV_FORCE_VRS=2x2
RADV_DEBUG=novrsflatshading
QT_DBUS=1
QT_WEBENGINE_DISABLE_WAYLAND_WORKAROUND=1
QT_STYLE_OVERRIDE=kvantum
QT_OPENGL_4_3=1
QT_NO_WIDGETS=1
QT_NO_NATIVE_GESTURES=1
QT_NO_EVENTFD=1
QT_NO_CUPS=1
QT_MEEGO_EXPERIMENTAL_SHADERCACHE=1
QT_LOGGING_RULES='\''*=false'\''
QT_LINKED_OPENSSL=1
QT_LARGEFILE_SUPPORT=64
QT_GRAPHICSSYSTEM=raster
QT_EVDEV=0
QT_DEBUG_PLUGINS=0
QML_IMPORT_TRACE=0
QML_FORCE_DISK_CACHE=1
QML_DISABLE_DISK_CACHE=0
QML_DEBUG=0
QMAKE_LFLAGS_BSYMBOLIC_FUNC=1
PULSE_LATENCY_MSEC=100
PROTON_USE_WINED3D=1
PROTON_NO_ESYNC=1
PROTON_LOG=0
PROTON_FSYNC=1
PROTON_ESYNC=0
PROTON_FORCE_LARGE_ADDRESS_AWARE=1
POWERSHELL_UPDATECHECK=Off
POWERSHELL_TELEMETRY_OPTOUT=1
POL_IgnoreWineErrors=True
PIPEWIRE_PROFILE_MODULES=default,rtkit
PIPEWIRE_LINK_PASSIVE=1
PIPEWIRE_LATENCY=512/48000
PAGER="less -R --use-color -Dd+r -Du+b"
MANPAGER="less -R --use-color -Dd+r -Du+b"
OMP_TARGET_OFFLOAD=MANDATORY
OMP_NUM_THREADS='"$(nproc)"'
OMP_DYNAMIC=true
OMP_DEBUG=disabled
OBS_USE_EGL=1
#OBJSIZE=llvm-size'"$cclm"'
#OBJDUMP=llvm-objdump'"$cclm"'
#OBJCOPY=llvm-objcopy'"$cclm"'
#NM=llvm-nm'"$cclm"'
MKL_THREADING_LAYER=sequential
MKL_ENABLE_INSTRUCTIONS=AVX2
MKL_DEBUG_CPU_TYPE=5
MKL_CBWR=auto
MIMALLOC_VERBOSE=0
MIMALLOC_SHOW_STATS=0
MIMALLOC_SHOW_ERRORS=0
MIMALLOC_RESERVE_HUGE_OS_PAGES=0
MIMALLOC_PAGE_RESET=0
MIMALLOC_LARGE_OS_PAGES=1
MIMALLOC_EAGER_COMMIT_DELAY=4
MESA_SHADER_CACHE_DISABLE=false
MESA_NO_ERROR=1
MESA_NO_DITHER=1
mesa_glthread=true
MESA_GLSL_CACHE_DISABLE=false
#MESA_GL_VERSION_OVERRIDE=4.6
MESA_DEBUG=silent
MALLOC_ARENA_MAX=1
LP_PERF=no_mipmap,no_linear,no_mip_linear,no_tex,no_blend,no_depth,no_alphatest
LP_NO_RAST=1
LLVM_ENABLE_RUNTIMES=”openmp”
LLVM_ENABLE_PROJECTS=ON
LLVM_ENABLE_ASSERTIONS=ON
LLVM_CCACHE_BUILD=ON
LIBOMPTARGET_OMPT_SUPPORT=1
LIBGL_THROTTLE_REFRESH=1
LIBGL_NO_DRAWARRAYS=1
LIBGL_DRI2_DISABLE=1
LIBGL_DEBUG=0
LIBGL_ALWAYS_SOFTWARE=0
LESSSECURE=1
LESSHISTSIZE=0
LESSHISTFILE=-
LDFLAGS="-Ofast -function-sections --gc-sections -data-sections --new-pass-manager -mcpu=native --hash-style=gnu -z,now --as-needed --no-copy-dt-needed-entries --sort-common -mbranches-within-32B-boundaries -z,now --as-needed --no-copy-dt-needed-entries --sort-common"
LDFLAGS_MODULE=--strip-debug
LD_DEBUG_OUTPUT=0
LD_BIND_NOW=0
KIRIGAMI_LOWPOWER_HARDWARE=1
KEYTIMEOUT=1
INTEL_BATCH=1
IGNORE_CC_MISMATCH=1
HUGETLB_VERBOSE=0
HUGETLB_MORECORE=yes
HUGETLB_ELFMAP=RW
#HOSTCC=clang'"$cclm"'
HISTSIZE=0
HISTCONTROL=ignoreboth
GTK_USE_PORTAL=1
GST_VAAPI_ALL_DRIVERS=1
GST_AUDIO_RESAMPLER_QUALITY_DEFAULT=9
GNUTLS_CPUID_OVERRIDE=0x1
GLSLC=glslc
GDK_GL=gles
ELM_ACCEL=opengl
DXVK_LOG_LEVEL=none
DXVK_FAKE_DX11_SUPPORT=1
DXVK_FAKE_DX10_SUPPORT=1
DXVK_CONFIG_FILE=/etc/dxvk.conf
DXVK_ASYNC=1
DRI_NO_MSAA=1
DRAW_USE_LLVM=1
DRAW_NO_FSE=1
DOTNET_CLI_TELEMETRY_OPTOUT=1
CONFIG_SND_HDA_PREALLOC_SIZE=16
COMMAND_NOT_FOUND_INSTALL_PROMPT=1
COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer
CCACHE_SLOPPINESS=locale,time_macros,file_stat_matches,include_file_ctime,include_file_mtime
CCACHE_DIR=~/.ccache
PREBUILT_CACHE_DIR=~/.ccache
CCACHE_UMASK=0022
USE_CCACHE=1
USE_RECACHE=yes
#CC=clang'"$cclm"'
BROWSER='"$(which firefox)"'
#AR=llvm-ar'"$cclm"'
ANV_ENABLE_PIPELINE_CACHE=1
AMD_VULKAN_ICD=amdvlk
__NV_PRIME_RENDER_OFFLOAD=1
__GLX_VENDOR_LIBRARY_NAME=mesa
__GL_YIELD=USLEEP
__GL_VRR_ALLOWED=1
__GL_THREADED_OPTIMIZATIONS=1
__GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
__GL_SHADER_DISK_CACHE=1
__GL_MaxFramesAllowed='"$maxframes"'
__GL_LOG_MAX_ANISO=0
__GL_FSAA_MODE=0
amdgpusi_enable_nir=true
radeonsi_enable_nir=true
EDITOR='"$(which vim)"'
GCM_CREDENTIAL_STORE=cache
GCC_SPECS=""
' | tee /etc/environment /home/"$himri"/.config/plasma-workspace/env/kwin_env.sh /etc/profile.d/kwin.sh /home/"$himri"/.xsessionrc /root/.xsessionrc /etc/init.d/environment.sh /home/"$himri"/.profile /root/.profile /etc/environment.d/env.conf /home/"$himri"/.xserverrc /root/.xserverrc ; fi

fi

if [ $ipv6 = on ]
then
sed -i '/export KDE_NO_IPV6=/c\export KDE_NO_IPV6=1' /etc/environment /home/"$himri"/.config/plasma-workspace/env/kwin_env.sh /etc/profile.d/kwin.sh /home/"$himri"/.xsessionrc /root/.xsessionrc /etc/init.d/environment.sh /home/"$himri"/.profile /root/.profile /etc/environment.d/env.conf /home/"$himri"/.xserverrc /root/.xserverrc
sed -i '/export KDE_USE_IPV6=/c\export KDE_USE_IPV6=no' /etc/environment /home/"$himri"/.config/plasma-workspace/env/kwin_env.sh /etc/profile.d/kwin.sh /home/"$himri"/.xsessionrc /root/.xsessionrc /etc/init.d/environment.sh /home/"$himri"/.profile /root/.profile /etc/environment.d/env.conf /home/"$himri"/.xserverrc /root/.xserverrc
else
sed -i '/export KDE_NO_IPV6=/c\export KDE_NO_IPV6=0' /etc/environment /home/"$himri"/.config/plasma-workspace/env/kwin_env.sh /etc/profile.d/kwin.sh /home/"$himri"/.xsessionrc /root/.xsessionrc /etc/init.d/environment.sh /home/"$himri"/.profile /root/.profile /etc/environment.d/env.conf /home/"$himri"/.xserverrc /root/.xserverrc
sed -i '/export KDE_USE_IPV6=/c\export KDE_USE_IPV6=yes' /etc/environment /home/"$himri"/.config/plasma-workspace/env/kwin_env.sh /etc/profile.d/kwin.sh /home/"$himri"/.xsessionrc /root/.xsessionrc /etc/init.d/environment.sh /home/"$himri"/.profile /root/.profile /etc/environment.d/env.conf /home/"$himri"/.xserverrc /root/.xserverrc ; fi


#MESA_BACK_BUFFER=ximage
#DRI_PRIME=1
#LD_DEBUG=0
#QSG_RHI_BACKEND=vulkan
#QSG_RHI=1
#QSG_RENDERER_BUFFER_STRATEGY=dynamic
#__GL_SYNC_TO_VBLANK=1
#__GLVND_DISALLOW_PATCHING=0
#DXVK_HUD=compile
#ENABLE_VKBASALT=1
#GOMP_CPU_AFFINITY="N-M"
#GST_GL_API=gles2
#GTK_DEBUG=0
#HUGETLB_DEBUG=0
#KMP_AFFINITY=granularity=fine,compact,1,0
#KMP_BLOCKTIME=1
#KWIN_OPENGL_INTERFACE=egl
#LD_AUDIT=0
#LD_TRACE_LOADED_OBJECTS=0
#LIBGL_DRI3_DISABLE=1
#LIBOMPTARGET_KERNEL_TRACE=1
#MESA_LOADER_DRIVER_OVERRIDE=radeon
#OMP_PROC_BIND=CLOSE
#OMP_SCHEDULE=STATIC
#QT_NO_GLIB=1
#QT_ONSCREEN_PAINT=1
#QT_OPENGL_ES_3_2=1
#QT_QPA_PLATFORM=EGL
#QT_QPA_PLATFORMTHEME=qt6ct
#QT_SELECT=6
#QT_SQL_MYSQL=0
#vblank_mode=1
#VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json
#VDPAU_DRIVER=$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)si
#LIBVA_DRIVER_NAME=$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)si
#VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)_icd.i686.json:/usr/share/vulkan/icd.d/$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)_icd.x86_64.json
#for i in "$(cat /etc/profile.d/kwin.sh | awk '\''{print $2}'\'')" ; do export $i ; done









### IF ANDROID
# android props etc
# since script aims for broad range of devices legacy props included
# wont get applied on newer devices anyway. no harm. these are bullshit though. only the dalvik vm shit probably works. most i will be disabled by default. check what is used for your device
# leave gpu rendering disabled in developers options
if [ -f $droidprop ] ; then
if [ $androidbuildprop = yes ] ; then
prop='#####################################
# these are added
#####################################

####
# dalvik


dalvik.vm.dex2oat-backend=Quick
dalvik.vm.dex2oat-thread_count=4
pm.dexopt.shared quicken
dalvik.vm.heapmaxfree=2m
dalvik.vm.heapminfree=512k
dalvik.vm.heaptargetutilization=0.75
dalvik.gc.type=precise
dalvik.vm.check-dex-sum=false
dalvik.vm.checkjni=false
dalvik.vm.deadlock-predict=off
dalvik.vm.debug.alloc=0
dalvik.vm.dex2oat-filter=speed
dalvik.vm.dex2oat-flags=--no-watch-dog
dalvik.vm.dex2oat-minidebuginfo=false
dalvik.vm.dex2oat-swap=true
dalvik.vm.dex2oat64.enabled=true
dalvik.vm.dexopt-data-only=1
dalvik.vm.dexopt-flags=m=y,v=n,o=y,u=n
dalvik.vm.dexopt.secondary=true
dalvik.vm.execution-mode=int:jit
dalvik.vm.heapgrowthlimit=512m
dalvik.vm.heapsize=1024m
dalvik.vm.heapstartsize=8m
dalvik.vm.heaptargetutilization=0.75
dalvik.vm.heaputilization=0.75
dalvik.vm.image-dex2oat-filter=--no-watch-dog
dalvik.vm.jniopts=forcecopy
dalvik.vm.lockprof.threshold=500
dalvik.vm.usejit=true
dalvik.vm.verify-bytecode=false
pm.dexopt.bg-dexopt=speed
pm.dexopt.shared=speed
persist.sys.dalvik.hyperthreading=true
persist.sys.dalvik.multithread=true
pm.dexopt.first-boot=interpret-only
pm.dexopt.boot=verify-profile
pm.dexopt.install=interpret-only
pm.dexopt.bg-dexopt=speed-profile
pm.dexopt.ab-ota=speed-profile
pm.dexopt.nsys-library=speed
pm.dexopt.shared-apk=speed
pm.dexopt.forced-dexopt=speed
pm.dexopt.core-app=speed
#dalvik.vm.image-dex2oat-Xms=64m
#dalvik.vm.image-dex2oat-Xmx=64m
#dalvik.vm.dex2oat-Xms=64m
#dalvik.vm.dex2oat-Xmx=512m
ro.dalvik.vm.native.bridge=0
dalvik.vm.usejit=true
dalvik.vm.usejitprofiles=true
dalvik.vm.appimageformat=lz4
debug.atrace.tags.enableflags=0

####
# vm

vm.dirty_background_ratio=40
vm.dirty_ratio=50
ro.config.low_ram=true
#vm.min_free_kbytes=4096
vm.vfs_cache_pressure=50
ro.vold.umsdirtyratio=90

####
# debugging and stuff

profiler.force_disable_err_rpt=true
profiler.force_disable_ulog=true
profiler.hung.dumpdobugreport=false
profiler.launch=false
vidc.debug.level=0
foreground_service_starts_logging_enabled=0
wifi_verbose_logging_enabled=1
window_orientation_listener_log=0
user_log_enabled=0
upload_debug_log_pref=0
upload_log_pref=0
activity_starts_logging_enabled=0
debug.atrace.tags.enableflags=0
debug.mdpcomp.logs=0
debugtool.anrhistory=0
dk_log_level=0
enable_diskstats_logging=0
libc.debug.malloc=0
logcat.live=disable
logd.logpersistd.enable=false
persist.service.lgospd.enable=0
persist.service.pcsync.enable=0
ro.debuggable=0
profiler.debugmonitor=false
persist.wpa_supplicant.debug=false
ro.lmk.log_stats=0
profiler.force_disable_ulog=true
trustkernel.log.state=disable
sys_traced=0
send_action_app_error=0
send_security_reports=0
vendor.vidc.debug.level=0
vendor.swvdec.log.level=0

####

ro.ril.set.mtu1492=1
net.dns1='"$dns1"'
net.dns2='"$dns2"'
net.ppp0.dns1='"$dns1"'
net.ppp0.dns2='"$dns2"'
net.rmnet0.dns1='"$dns1"'
net.rmnet0.dns2='"$dns2"'
net.wlan0.dns1='"$dns1"'
net.wlan0.dns2='"$dns2"'
net.eth0.dns1='"$dns1"'
net.eth0.dns2='"$dns2"'
net.gprs.dns1='"$dns1"'
net.gprs.dns2='"$dns2"'
net.tcp.buffersize.default=6144,87380,1048576,6144,87380,524288
net.tcp.buffersize.edge=6144,87380,524288,6144,16384,262144
net.tcp.buffersize.evdo_b=6144,87380,1048576,6144,87380,1048576
net.tcp.buffersize.gprs=6144,87380,1048576,6144,87380,524288
net.tcp.buffersize.hsdpa=6144,87380,1048576,6144,87380,1048576
net.tcp.buffersize.hspa=6144,87380,524288,6144,16384,262144
net.tcp.buffersize.lte=524288,1048576,2097152,524288,1048576,2097152
net.tcp.buffersize.umts=6144,87380,1048576,6144,87380,524288
net.tcp.buffersize.wifi=524288,1048576,2097152,524288,1048576,2097152
net.ipv4.ip_no_pmtu_disc=0
net.ipv4.route.flush=1
net.ipv4.tcp_ecn=0
net.ipv4.tcp_fack=1
net.ipv4.tcp_mem=187000 187000 187000
net.ipv4.tcp_moderate_rcvbuf=1
net.ipv4.tcp_no_metrics_save=1
net.ipv4.tcp_rfc1337=1
net.ipv4.tcp_rmem=4096 39000 187000
net.ipv4.tcp_sack=1
#net.ipv4.tcp_timestamps=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_wmem=4096 39000 18700
wifi.supplicant_scan_interval=180
persist.telephony.support.ipv6=0
persist.telephony.support.ipv4=1

####
# some of these do work but cause drainage

#BOARD_EGL_NEEDS_LEGACY_FB=false
#POWER_SAVE_PRE_CLEAN_MEMORY_TIME=1800
#CPU_MIN_CHECK_DURATION=false
#CONTENT_APP_IDLE_OFFSET=false
#EMPTY_APP_IDLE_OFFSET=false
#ENFORCE_PROCESS_LIMIT=false
#MAX_SERVICE_INACTIVITY=false
#MIN_CRASH_INTERVAL=false
#MIN_HIDDEN_APPS=false
#MIN_RECENT_TASKS=false
#GC_TIMEOUT=false
#PROC_START_TIMEOUT=false
#APP_SWITCH_DELAY_TIME=false
#ACTIVITY_INACTIVE_RESET_TIME=false
#ACTIVITY_INACTIVITY_RESET_TIME=false

####
# deprecated mostly so disabled

#persist.sys.oem_smooth=1
#cpu.fps=auto
#debug.cpurend.vsync=true
#debug.egl.buffcount=3
#debug.egl.hw=1
#debug.egl.profiler=1
#debug.egl.swapinterval=1
#debug.enable.sglscale=1
#debug.gr.numframebuffers=3
#debug.gr.swapinterval=1
#debug.gralloc.enable_fb_ubwc=1
#debug.hwui.render_dirty_regions=false
#debug.hwui.show_dirty_regions=false
#debug.hwui.swap_with_damage=true
debug.hwui.use_buffer_age=true
#debug.hwui.use_gpu_pixel_buffers=true
#debug.overlayui.enable=1
#debug.performance.tuning=1
#debug.qc.hardware=true
#debug.qctwa.preservebuf=1
#debug.qctwa.statusbar=1
#debug.sf.disable_backpressure=0
debug.sf.disable_client_composition_cache=0
#debug.sf.enable_gl_backpressure=1
#debug.sf.enable_hwc_vds=1
#debug.sf.hw=1
#debug.sf.latch_unsignaled=1
#debug.sf.recomputecrop=0
#force_hw_ui=true
#hw2d.force=1
#hw3d.force=1
#hwui.text_gamma.black_threshold=64
#hwui.text_gamma.white_threshold=192
#hwui.text_gamma=1.4
#hwui.text_gamma_correction=lookup
#persist.sys.NV_FPSLIMIT=244
#persist.sys.NV_POWERMODE=1
#persist.sys.ui.hw=1
#ro.HOME_APP_ADJ=1
#support_highfps=1
#sys.display-size=3840x2160
#sys.sysctl.tcp_def_init_rwnd=60
#sys_vdso=1
#vendor.debug.egl.swapinterval=1
#vendor.display.disable_metadata_dynamic_fps=1
#vendor.display.enable_optimize_refresh=1
#vendor.display.enhance_idle_time=1
#vendor.display.idle_time=0
#vendor.display.idle_time_inactive=0
#vidc.debug.perf.mode=2
#vidc.enc.dcvs.extra-buff-count=3
#windowsmgr.max_events_per_sec=244
persist.sys.scrollingcache=3
persist.sys.use_16bpp_alpha=1
persist.sys.use_dithering=0
#sem_enhanced_cpu_responsiveness=1
#speed_mode=1
#speed_mode_enable=1
#speed_mode_on=1
#sys.use_fifo_ui=1
video.accelerate.hw=1
#ro.fb.mode=1
#debug.sf.enable_hwc_vds=1
#debug.sf.latch_unsignaled=1
#debug.gralloc.enable_fb_ubwc=1
#dev.pm.dyn_samplingrate=1
#persist.sys.composition.type=vulkan
#debug.composition.type=vulkan
#debug.hwui.renderer=vulkan

media.stagefright.enable-aac=true
media.stagefright.enable-fma2dp=true
media.stagefright.enable-http=true
media.stagefright.enable-meta=true
media.stagefright.enable-player=true
media.stagefright.enable-qcp=true
media.stagefright.enable-record=true
media.stagefright.enable-scan=true
media.stagefright.thumbnail.prefer_hw_codecs=true
media.stagefright.use-awesome=true


#audio.deep_buffer.media=true
#audio.offload.buffer.size.kb=32
#audio.offload.gapless.enabled=true
#audio.offload.pcm.16bit.enable=true
#audio.offload.pcm.24bit.enable=true
#audio.offload.track.enable=true
#audio.offload.video=true


#debug.doze.component=0
#app_auto_restriction_enabled=1
#app_restriction_enabled=true
#app_standby_enabled=1
#cached_apps_freezer=enabled
#debug.kill_allocating_task=1
#usb_wakeup=enable
#ro.ksm.default='"$ksm"'

#adaptive_battery_management_enabled=1
#ro.board_ram_size=low
#ro.config.low_ram=true

#window_animation_scale=0.0
#view.scroll_friction=0
#view.touch_slop=1
#animator_duration_scale=0.0
#debug.hwui.force_dark=true
#debug.hwui.level=0
#transition_animation_scale=0.0
#slider_animation_duration=0
#tap_duration_threshold=0.0
#touch.distance.scale=0
#touch.pressure.scale=0.1
#touch.size.bias=0
#touch_blocking_period=0.0
#sys.disable_ext_animation=1
#ro.sf.lcd_density=500
#ro.DontUseAnimate=true

#persist.sys.purgeable_assets=1
#persist.sys.root_access=1
#boot.fps=20
#debug.sf.nobootanimation=1
#font_scale=1.25
#k2hd_effect=1
#lmk.autocalc=false
#persist.sys.force_highendgfx=true
#ro.bq.gpu_to_cpu_unsupported=1
#ro.build.selinux=1
#ro.config.zram.support=false
#ro.config.zram=false
#tunnel.decode=false
#persist.sys.shutdown.mode=hibernate
#thermal_limit_refresh_rate=0
#tube_amp_effect=1
#vnswap.enabled=false
#zram.disksize=0
#debug.hwc.otf=1
#debug.hwc.winupdate=1
#ro.qualcomm.perf.cores_online=2
#ro.sys.fw.bg_apps_limit=78
#ro.vendor.qti.am.reschedule_service=true
#ro.vendor.qti.sys.fw.bservice_age=5000
#ro.vendor.qti.sys.fw.bservice_enable true
#ro.vendor.qti.sys.fw.bservice_limit=5
#ro.zygote.disable_gl_preload=false
#ro.zygote.preload.disable=false
sys.config.samp_enable=false
sys.config.samp_spcm_enable=false
#ro.hwui.disable_scissor_opt=false
#ro.hwui.drop_shadow_cache_size=2
#ro.hwui.gradient_cache_size=64k
#ro.hwui.layer_cache_size=16
#ro.hwui.patch_cache_size=128
#ro.hwui.path_cache_size=4
#ro.hwui.r_buffer_cache_size=2
#ro.hwui.shape_cache_size=1
#ro.hwui.text_large_cache_height=512
#ro.hwui.text_large_cache_width=2048
#ro.hwui.text_small_cache_height=256
#ro.hwui.text_small_cache_width=1024
#ro.hwui.texture_cache_flush_rate=0.6
#ro.hwui.texture_cache_size=24





mmp.enable.3g2=true
#af.fast_track_multiplier=1
ble_scan_always_enabled=0
config.disable_consumerir=true
#debug.enabletr=true
#debug.sf.ddms=0
#debug.sf.swaprect=1
#debug.sf.use_phase_offsets_as_durations=1
#debug.sqlite.syncmode=1
debug.stagefright.ccodec=1
#dev.bootcomplete=0
#dev.pm.dyn_samplingrate=1
#display_color_mode=0
#doze.pickup.vibration.threshold=2000
#doze.pulse.brightness=15
#doze.pulse.delay.in=200
#doze.pulse.duration.in=1000
#doze.pulse.duration.out=1000
#doze.pulse.duration.visible=5000
#doze.pulse.notifications=0
#doze.pulse.notifications=true
#doze.pulse.proxcheck=0
#doze.pulse.schedule.resets=3
#doze.pulse.schedule=1s,10s,30s,60s,120s
#doze.pulse.sigmotion=0
#doze.shake.acc.threshold=10
#doze.use.accelerometer=0
#doze.vibrate.sigmotion=0
#drm.service.enabled=true
#enhanced_processing=1
#fancy_ime_animations=0
#forced_app_standby_enabled=1
#fstrim_mandatory_interval=1
#game_driver_all_apps=1
#hwui.disable_vsync=false
#hwui.render_dirty_regions=false
#intelligent_sleep_mode=0
keep_profile_in_background=0
#long_press_timeout=250
master_motion=0
media.xloud.enable=0
#media.xloud.supported=true
#min_refresh_rate=1.0
#mm.enable.smoothstreaming=true
mobile_data_always_on=0
mot.proximity.delay=25
mpq.audio.decode=true
#multi_press_timeout=250
#multicore_packet_scheduler=1
omap.enhancement=true
#persist.adb.notify=0
persist.android.strictmode=0
#persist.audio.hifi=true
#persist.bootanim.preload=1
#persist.cust.tel.eons=1
#persist.device_config.runtime_native.usap_pool_enabled=true
#persist.device_config.runtime_native_boot.iorap_perfetto_enable=true
#persist.device_config.runtime_native_boot.iorap_readahead_enable=true
#persist.dpm.feature=1
#persist.mm.enable.prefetch=true
#persist.preload.common=1
persist.radio.add_power_save=1
#persist.radio.data_no_toggle=1
persist.radio.ramdump=0
#persist.ril.uart.flowctrl=
persist.sampling_profiler=0
persist.service.xloud.enable=0
persist.speaker.prot.enable=false
persist.sys.binary_xml=false
persist.sys.job_delay=false
#persist.sys.lowcost=1
#persist.sys.purgeable_assets=1
#persist.sys.sf.color_saturation=1.25
persist.sys.ssr.enable_ramdumps=0
#persist.sys.storage_preload=1
persist.traced.enable=0
persist.vendor.sys.ssr.enable_ramdumps=0
#persyst.sys.usb.config=mtp,adb
#pm.sleep_mode=1
#power.saving.mode=1
#power_supply.wakeup=enable
rakuten_denwa=0
#ram_expand_size_list=1
#refresh_rate_mode=2
remote_control=0
#restricted_device_performance=1.0
#ro.allow.mock.location=1
#ro.am.reschedule_service=true
#ro.audio.flinger_standbytime_ms=300
ro.boot.warranty_bit=0
#ro.bq.gpu_to_cpu_unsupported=1
ro.camcorder.videoModes=true
#ro.charger.disable_init_blank=true
ro.com.google.locationfeatures=0
ro.com.google.networklocation=0
ro.compcache.default=1
#ro.config.combined_signal=true
#ro.config.dha_tunnable=1
#ro.config.disable.hw_accel=false
#ro.config.ehrpd=true
#ro.config.enable.hw_accel=true
#ro.config.fha_enable=true
#ro.config.htc.nocheckin=1
#ro.config.hw_fast_dormancy=1
#ro.config.hw_power_saving=true
#ro.config.hw_quickpoweron=true
#ro.config.low_mem=true
#ro.config.low_ram.mod=true
#ro.config.low_ram=true
#ro.config.nocheckin=1
#ro.config.rm_preload_enabled=1
#ro.fast.dormancy=1
#ro.floatingtouch.available=1
#ro.hwui.disable_scissor_opt=false
#ro.hwui.drop_shadow_cache_size=6
#ro.hwui.gradient_cache_size=0.1
#ro.hwui.gradient_cache_size=1
#ro.hwui.layer_cache_size=48
#ro.hwui.path_cache_size=32
#ro.hwui.r_buffer_cache_size=8
#ro.hwui.text_large_cache_height=1024
#ro.hwui.text_large_cache_width=2048
#ro.hwui.text_small_cache_height=1024
#ro.hwui.text_small_cache_width=1024
#ro.hwui.texture_cache_flush_rate=0.5
#ro.hwui.texture_cache_flushrate=0.4
#ro.hwui.texture_cache_size=20
#ro.hwui.texture_cache_size=72
#ro.kernel.android.checkjni=0
#ro.kernel.checkjni=0
#ro.lge.proximity.delay=25
ro.malloc.impl=jemalloc
#ro.max.fling_velocity=12000
#ro.media.cam.preview.fps=0
#ro.media.capture.fast.fps=4
#ro.media.capture.flash=led
#ro.media.capture.flashIntensity=70
#ro.media.capture.flashMinV=3300000
#ro.media.capture.maxres=8m
#ro.media.capture.slow.fps=244
#ro.media.capture.torchIntensity=40
ro.media.codec_priority_for_thumb=so
ro.media.dec.aud.mp3.enabled=1
ro.media.dec.aud.wma.enabled=1
ro.media.dec.jpeg.memcap=8000000
ro.media.dec.vid.mp4.enabled=1
ro.media.dec.vid.wmv.enabled=1
ro.media.enc.aud.mp3.enabled=1
ro.media.enc.aud.wma.enabled=1
ro.media.enc.hprof.vid.bps=8000000
ro.media.enc.hprof.vid.fps=244
ro.media.enc.jpeg.quality=100
ro.media.enc.vid.mp4.enabled=1
ro.media.enc.vid.wmv.enabled=1
#ro.media.panorama.defres=3264x1840
#ro.media.panorama.frameres=1280x720
#ro.min.fling_velocity=900
#ro.min_pointer_dur=1
#ro.mot.eri.losalert.delay=1000
ro.mtk_perfservice_support=0
#ro.product.gpu.driver=1
ro.recentMode=0
#ro.ril.disable.power.collapse=1
#ro.ril.enable.3g.prefix=1
#ro.ril.enable.a52=1
#ro.ril.enable.a53=1
#ro.ril.enable.amr.wideband=1
#ro.ril.enable.dtm=1
#ro.ril.enable.fd.plmn.prefix=23402,23410,23411
#ro.ril.enable.gea3=1
#ro.ril.enable.sdr=0
#ro.ril.fast.dormancy.rule=1
#ro.ril.gprsclass=12
#ro.ril.hep=1
#ro.ril.hsdpa.category=28
#ro.ril.hsupa.category=7
#ro.ril.hsxpa=3
#ro.ril.htcmaskw1.bitmask=4294967295
#ro.ril.htcmaskw1=14449
#ro.ril.power_collapse=0
#ro.ril.sensor.sleep.control=1
ro.secure=0
#ro.semc.sound_effects_enabled=true
#ro.semc.xloud.supported=true
ro.service.remove_unused=1
ro.sf.compbypass.enable=0
#ro.sf.disable_triple_buffer=0
#ro.storage_manager.enabled=true
#ro.support.signalsmooth=true
#ro.surface_flinger.has_wide_color_display=false
#ro.surface_flinger.use_content_detection_for_refresh_rate=true
#ro.sys.fw.bservice_enable=true
#ro.sys.fw.use_trim_settings=true
#ro.tb.mode=1
#ro.telephony.call_ring.delay=0
#ro.telephony.call_ring.multiple=0
#ro.tether.denied=false
#ro.trim.config=true
#ro.trim.memory.font_cache=1
#ro.trim.memory.launcher=1
#ro.vendor.perf.scroll_opt=true
ro.warmboot.capability=1
ro.warranty_bit=0
ro.wmt.blcr.enable=0
#screen_auto_brightness_adj=0
#sys.config.activelaunch_enable=true
#sys.config.phone_start_early=true
#unused_static_shared_lib_min_cache_period_ms=3600
#persist.sys.usb.config=adb
'

#if [ -f $droidprop ] && ! grep -q "net.dns1" $droidprop ; then
#echo "$prop" >> $droidprop ; fi
if [ -e /system/etc/bak/system/build.prop ] ; then
cat /system/etc/bak/system/build.prop | tee $droidprop
echo "$prop" >> $droidprop ; fi


sed -i 's/dalvik.vm.heaptargetutilization=.*/dalvik.vm.heaptargetutilization=0.75/g' $droidprop
sed -i 's/dalvik.vm.dexopt-flags=.*/dalvik.vm.dexopt-flags=m=y,v=n,o=y,u=n/g' $droidprop
sed -i 's/dalvik.vm.heapstartsize=.*/dalvik.vm.heapstartsize=8m/g' $droidprop


if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 6500000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=768m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=1566m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 10000000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=1024m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=2048m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -ge 29000000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=2048m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=4096m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 4400000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=256m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=512m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 2200000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=128m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=512m/g' $droidprop

fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 1200000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=64m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=192m/g' $droidprop
sed -i 's/dalvik.vm.heapstartsize=.*/dalvik.vm.heapstartsize=5m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 550000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=64m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=128m/g' $droidprop
sed -i 's/dalvik.vm.heapstartsize=.*/dalvik.vm.heapstartsize=5m/g' $droidprop
fi

setprop net.tcp.buffersize.default 6144,87380,1048576,6144,87380,524288
setprop net.tcp.buffersize.wifi 524288,1048576,2097152,524288,1048576,2097152
setprop net.tcp.buffersize.umts 6144,87380,1048576,6144,87380,524288
setprop net.tcp.buffersize.gprs 6144,87380,1048576,6144,87380,524288
setprop net.tcp.buffersize.edge 6144,87380,524288,6144,16384,262144
setprop net.tcp.buffersize.hspa 6144,87380,524288,6144,16384,262144
setprop net.tcp.buffersize.lte 524288,1048576,2097152,524288,1048576,2097152
setprop net.tcp.buffersize.hsdpa 6144,87380,1048576,6144,87380,1048576
setprop net.tcp.buffersize.evdo_b 6144,87380,1048576,6144,87380,1048576
setprop persist.radio.add_power_save 1
setprop video.accelerate.hw 1

if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -ge 11 ] ; then
setprop debug.hwui.renderer vulkan
fi


if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -ge 10 ] ; then
sed -i 's/#sys.use_fifo_ui=.*/sys.use_fifo_ui=1/g' $droidprop
setprop sys.use_fifo_ui 1
fi

if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 9 ] ; then
setprop debug.hwui.renderer skiagl
sed -i 's/vulkan/skiagl/g' $droidprop
fi

if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 7  ]; then
setprop debug.hwui.renderer opengl
#sed -i 's/#debug.hwui.renderer=.*/debug.hwui.renderer=opengl/g' $droidprop
#sed -i 's/#debug.egl.hw=.*/debug.egl.hw=1/g' $droidprop
#sed -i 's/#debug.egl.profiler=.*/debug.egl.profiler=1/g' $droidprop
#sed -i 's/#debug.egl.buffcount=.*/debug.egl.buffcount=3/g' $droidprop
#sed -i 's/#debug.composition.type=.*/debug.composition.type=c2d/g' $droidprop
#sed -i 's/#persist.sys.composition.type=.*/persist.sys.composition.type=c2d/g' $droidprop
#sed -i 's/#debug.sf.enable_gl_backpressure=.*/debug.sf.enable_gl_backpressure=1/g' $droidprop
#sed -i 's/#debug.gr.numframebuffers=.*/debug.gr.numframebuffers=3/g' $droidprop
#sed -i 's/#debug.enable.sglscale=.*/debug.enable.sglscale=1/g' $droidprop
#sed -i 's/#BOARD_EGL_NEEDS_LEGACY_FB=.*/BOARD_EGL_NEEDS_LEGACY_FB=false/g' $droidprop
#sed -i 's/#ro.hwui.disable_scissor_opt=.*/ro.hwui.disable_scissor_opt=false/g' $droidprop
#sed -i 's/#ro.hwui.drop_shadow_cache_size=.*/
#sed -i 's/#ro.hwui.gradient_cache_size=.*/
#sed -i 's/#ro.hwui.layer_cache_size=.*/
#sed -i 's/#ro.hwui.patch_cache_size=.*/
#sed -i 's/#ro.hwui.path_cache_size=.*/
#sed -i 's/#ro.hwui.r_buffer_cache_size=.*/
#sed -i 's/#ro.hwui.shape_cache_size=.*/
#sed -i 's/#ro.hwui.texture_cache_flush_rate=.*/
#sed -i 's/#ro.hwui.texture_cache_size=.*/
#sed -i 's/#ro.hwui.text_large_cache_height=.*/
#sed -i 's/#ro.hwui.text_large_cache_width=.*/
#sed -i 's/#ro.hwui.text_small_cache_height=.*/
#sed -i 's/#ro.hwui.text_small_cache_width=.*/
#sed -i 's/#ro.zygote.disable_gl_preload=.*/ro.zygote.disable_gl_preload=false/g' $droidprop
#sed -i 's/#debug.hwui.swap_with_damage=.*/#debug.hwui.swap_with_damage=true/g' $droidprop
#sed -i 's/#hwui.text_gamma.black_threshold=.*
#sed -i 's/#hwui.text_gamma.white_threshold=.*
#sed -i 's/#hwui.text_gamma=.*
#sed -i 's/#hwui.text_gamma_correction=.*
#sed -i 's/vidc.debug.perf.mode=.*/#vidc.debug.perf.mode=#/g' $droidprop # slows down playback on old devices, probably worth for newer if it saves energy consumption if these legacy props even apply at all on new devices
#sed -i 's/#hwui.use_gpu_pixel_buffers=.*/hwui.use_gpu_pixel_buffers=true/g' $droidprop

if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 5 ] && "$(! grep -q "persist.sys.dalvik.vm.lib.2=libart.so" $droidprop)" ; then if [ -f /system/apex/com.android.runtime.release/lib64/libart.so ] || [ -f /system/lib64/libart.so ] || [ -f /system/lib/libart.so ] ; then echo "persist.sys.dalvik.vm.lib.2=libart.so" | tee -a $droidprop ; fi ; fi
fi

#if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 6  ]; then
#setprop debug.hwui.renderer gpu
#sed -i 's/debug.hwui.renderer=.*/debug.hwui.renderer=gpu/g' $droidprop
#fi

#if [ $testing = yes ] ; then echo "skip..." ; else

# setprop breaks system i remember from past as well with some flags so leave them in build.prop only. depending on rom ofcourse.
#"$bb"sh -cx 'for i in $(cat /system/build.prop) ; do
#"$(setprop $(echo "$i" | sed '\''s/=/ /g'\'' | grep -v "#" | awk '\''{print $1, $2}'\'' ))"
#done'
# afai remember works good on high end device only
#setprop sys.use_fifo_ui 1

#fi

# stop ril services for wifi-only device


if $(getprop ro.carrier | $(grep -q wifi-only)) ; then
on property:ro.carrier=wifi-only
    stop ril-daemon
    stop qmuxd
    stop netmgrd
    setprop ro.radio.noril 1
    fi

if [ $fstab = /vendor/fstab.qcom ] ; then
setprop qcom.hw.aac.encoder true
setprop ro.qcom.ad.calib.data /system/etc/ad_calib.cfg
setprop ro.qcom.ad 1
setprop debug.qc.hardware true
setprop debug.qctwa.preservebuf 1
setprop debug.qctwa.statusbar 1
fi

# echo 10 > /sys/class/thermal/thermal_message/sconfig

killall -9 android.process.media
killall -9 mediaserver




#for part in system data
#do if mount | grep -q "/$part" ; then mount -o rw,remount "/$part" "/$part" && ui_print "/$part remounted rw"
#else mount -o rw "/$part" && ui_print "/$part mounted rw" || ex "/$part cannot mounted" ; fi ; done

"$bb"fstrim /data
"$bb"fstrim /cache
"$bb"fstrim /system


settings put global window_animation_scale 0.0
settings put global transition_animation_scale 0.0
settings put global animator_duration_scale 0.0
fi
if [ $firstrun = yes ] && [ $debloatandroid = yes ] ; then
for i in android.autoinstalls.config.Xiaomi.pine AR coloros.gamespaceui com.alibaba.aliexpresshd com.allgoritm.youla com.android.apps.tag com.android.bbklog com.android.bbkmusic com.android.bbksoundrecorder com.android.bips com.android.bookmarkprovider com.android.browser com.android.calllogbackup com.android.documentsui com.android.egg com.android.email com.android.exchange com.android.hotwordenrollment.okgoogle com.android.hotwordenrollment.xgoogle com.android.localtransport com.android.location.fused com.android.mms com.android.mms.service com.android.partnerbrowsercustomizations com.android.providers.downloads.ui com.android.providers.partnerbookmarks com.android.providers.userdictionary com.android.sharedstoragebackup com.android.soundrecorder com.android.thememanager com.android.thememanager.module com.app.market com.asurion.android.protech.att com.asurion.android.verizon.vms com.att.android.attsmartwifi com.att.dh com.att.dtv.shaderemote com.att.myWireless com.att.tv com.audible.application com.aura.oobe.samsung com.baidu.duersdk.opensdk com.bbk.account com.bbk.cloud com.bbk.iqoo.logsystem com.bbk.photoframewidget com.bbk.scene.indoor com.bbk.SuperPowerSave com.bbk.theme com.bbk.theme.resources com.bleacherreport.android.teamstream com.booking com.coloros.activation com.coloros.activation.overlay.common com.coloros.aftersalesservice com.coloros.appmanager com.coloros.assistantscreen com.coloros.athena com.coloros.avastofferwall com.coloros.backuprestore com.coloros.backuprestore.remoteservice com.coloros.bootreg com.coloros.childrenspace com.coloros.cloud com.coloros.compass2 com.coloros.encryption com.coloros.floatassistant com.coloros.focusmode com.coloros.gallery3d com.coloros.gamespace com.coloros.healthcheck com.coloros.healthservice com.coloros.music com.coloros.musiclink com.coloros.oppomultiapp com.coloros.oshare com.coloros.phonenoareainquire com.coloros.pictorial com.coloros.resmonitor com.coloros.safesdkproxy com.coloros.sauhelper com.coloros.sceneservice com.coloros.securepay com.coloros.smartdrive com.coloros.smartsidebar com.coloros.soundrecorder com.coloros.speechassist com.coloros.translate.engine com.coloros.video com.coloros.wallet com.coloros.weather.service com.coloros.weather2 com.coloros.widget.smallweather com.coloros.wifibackuprestore com.diotek.sec.lookup.dictionary com.drivemode com.dropboxchmod com.dsi.ant.plugins.antplus com.dsi.ant.sample.acquirechannels com.dsi.ant.server com.dsi.ant.service.socket com.duokan.phone.remotecontroller com.enhance.gameservice com.facemoji.lite.xiaomi com.foxnextgames.m3 com.gameloft.android.GloftANPH com.gameloft.android.GloftDBMF com.gameloft.android.GloftDMKF com.gameloft.android.GloftPDMF com.gameloft.android.GloftSMIF com.google.android.apps.docs com.google.android.apps.docs.editors.docs com.google.android.apps.docs.editors.sheets com.google.android.apps.docs.editors.slides com.google.android.apps.genie.geniewidget com.google.android.apps.maps com.google.android.apps.restore com.google.android.apps.tachyon com.google.android.apps.work.oobconfig com.google.android.feedback com.google.android.gm com.google.android.gms.location.history com.google.android.googlequicksearchbox com.google.android.keep com.google.android.marvin.talkback com.google.android.music com.google.android.partnersetup com.google.android.printservice.recommendation com.google.android.setupwizard com.google.android.syncadapters.calendar com.google.android.syncadapters.contacts com.google.android.talk com.google.android.tts com.google.android.videos com.google.ar.core com.google.audio.hearing.visualization.accessibility.scribe com.google.vr.vrcorr com.greatbigstory.greatbigstory com.gsn.android.tripeaks com.heytap.browser com.heytap.cloud com.heytap.colorfulengine com.heytap.datamigration com.heytap.habit.analysis com.heytap.market com.heytap.mcs com.heytap.openid com.heytap.pictorial com.heytap.themestore com.heytap.usercenter com.heytap.usercenter.overlay com.hiya.star com.honor.global com.huaqin.diaglogger com.huawei.android.thememanager com.huawei.android.tips com.huawei.android.wfdft com.huawei.himovie com.huawei.KoBackup com.hunge.app com.ibimuyu.lockscreen com.innogames.foeandroid com.iqoo.engineermode com.iqoo.secure com.linkedin.android com.mediatek.gnssdebugreport com.mediatek.mdmlsample com.mediatek.mtklogger com.mediatek.omacp com.mi.android.globalminusscreen com.mi.globalbrowser com.mi.globallayout com.mi.globalTrendNews com.mi.webkit.core com.microsoft.appmanager com.microsoft.office.excel com.microsoft.office.officehubrow com.microsoft.office.outlook com.microsoft.office.powerpoint com.microsoft.office.word com.microsoft.skydrive com.milink.service com.mipay.wallet.id com.miui.analytics com.miui.android.fashiongallery com.miui.aod com.miui.audiomonitor com.miui.backup com.miui.bugreport com.miui.cloudbackup com.miui.contentcatcher com.miui.daemon com.miui.enbbs com.miui.extraphoto com.miui.face com.miui.freeform com.miui.global.packageinstaller com.miui.miservice com.miui.mishare.connectivity com.miui.misound com.miui.msa.global com.miui.phrase com.miui.player com.miui.powerkeeper com.miui.providers.weather com.miui.securityadd com.miui.smsextra com.miui.sysopt com.miui.touchassistant com.miui.userguide com.miui.videoplayer com.miui.virtualsim com.miui.vsimcore com.miui.whetstone com.miui.wmsvc com.mobeam.barcodeService com.mobiletools.systemhelper com.motricity.verizon.ssodownloadable com.mygalaxy com.nearme.atlas com.nearme.browser com.nearme.gamecenter com.nearme.statistics.rom com.nearme.themestore com.netflix.mediaclient com.netflix.partner.activation com.opera.browser com.opera.preinstall com.oppo.aod com.oppo.atlas com.oppo.bttestmode com.oppo.criticallog com.oppo.gestureservice com.oppo.gmail.overlay com.oppo.lfeh com.oppo.logkit com.oppo.logkitservice com.oppo.market com.oppo.mimosiso com.oppo.music com.oppo.nw com.oppo.operationmanual com.oppo.ovoicemanager com.oppo.partnerbrowsercustomizations com.oppo.qualityprotect com.oppo.quicksearchbox com.oppo.rftoolkit com.oppo.ScoreAppMonitor com.oppo.sos com.oppo.startlogkit com.oppo.tzupdate com.oppo.usageDump com.oppo.usercenter com.oppo.webview com.oppo.wifirf com.oppoex.afterservice com.osp.app.signin com.pandora.android com.playstudios.popslots com.playwing.acu.huawei com.qti.dpmserviceapp com.qti.qualcomm.datastatusnotification com.qti.qualcomm.deviceinfo com.qti.xdivert com.qualcomm.embms com.qualcomm.location com.qualcomm.qti.autoregistration com.qualcomm.qti.callfeaturessetting com.qualcomm.qti.cne com.qualcomm.qti.dynamicddsservice com.qualcomm.qti.ims com.qualcomm.qti.lpa com.qualcomm.qti.modemtestmode com.qualcomm.qti.performancemode com.qualcomm.qti.poweroffalarm com.qualcomm.qti.qdma com.qualcomm.qti.qmmi com.qualcomm.qti.seccamservice com.qualcomm.qti.uceShimService com.qualcomm.qti.uim com.qualcomm.qti.uimGbaApp com.qualcomm.uimremoteclient com.qualcomm.uimremoteserver com.realme.logtool com.redteamobile.roaming com.redteamobile.roaming.deamon com.samsung.android.allshare.service.mediashare com.samsung.android.app.aodservice com.samsung.android.app.appsedge com.samsung.android.app.camera.sticker.facearavatar.preload com.samsung.android.app.dressroom com.samsung.android.app.galaxyfinder com.samsung.android.app.ledbackcover com.samsung.android.app.omcagent com.samsung.android.app.reminder com.samsung.android.app.routines com.samsung.android.app.sbrowseredge com.samsung.android.app.settings.bixby com.samsung.android.app.simplesharing com.samsung.android.app.social com.samsung.android.app.spage com.samsung.android.app.tips com.samsung.android.app.vrsetupwizardstub com.samsung.android.app.watchmanager com.samsung.android.app.watchmanagerstub com.samsung.android.ardrawing com.samsung.android.aremoji com.samsung.android.aremojieditor com.samsung.android.arzone com.samsung.android.authfw com.samsung.android.beaconmanager com.samsung.android.bixby.agent com.samsung.android.bixby.agent.dummy com.samsung.android.bixby.service com.samsung.android.bixby.wakeup com.samsung.android.bixbyvision.framework com.samsung.android.cameraxservice com.samsung.android.da.daagent com.samsung.android.drivelink.stub com.samsung.android.dsms com.samsung.android.easysetup com.samsung.android.email.provider com.samsung.android.emojiupdater com.samsung.android.forest com.samsung.android.game.gamehome com.samsung.android.game.gametools com.samsung.android.game.gos com.samsung.android.gametuner.thin com.samsung.android.hmt.vrshell com.samsung.android.hmt.vrsvc com.samsung.android.honeyboard com.samsung.android.keyguardmgsupdator com.samsung.android.kidsinstaller com.samsung.android.knox.analytics.uploader com.samsung.android.livestickers com.samsung.android.mateagent com.samsung.android.mfi com.samsung.android.mobileservice com.samsung.android.networkdiagnostic com.samsung.android.oneconnect com.samsung.android.rubin.app com.samsung.android.samsungpass com.samsung.android.samsungpassautofill com.samsung.android.scloud com.samsung.android.sdk.handwriting com.samsung.android.sdk.professionalaudio.utility.jammonitor com.samsung.android.sdm.config com.samsung.android.service.aircommand com.samsung.android.service.livedrawing com.samsung.android.service.peoplestripe com.samsung.android.setupindiaservicestnc com.samsung.android.spay com.samsung.android.spayfw com.samsung.android.spaymini com.samsung.android.spdf com.samsung.android.svcagent com.samsung.android.svoiceime com.samsung.android.themestore com.samsung.android.universalswitch com.samsung.android.visionarapps com.samsung.android.visioncloudagent com.samsung.android.visionintelligence com.samsung.android.voc com.samsung.android.widgetapp.yahooedge.finance com.samsung.android.widgetapp.yahooedge.sport com.samsung.app.highlightplayer com.samsung.attvvm com.samsung.desktopsystemui com.samsung.ecomm.global com.samsung.hiddennetworksetting com.samsung.knox.securefolder com.samsung.safetyinformation com.samsung.sree com.samsung.storyservice com.samsung.systemui.bixby2 com.samsung.vmmhux com.samsung.vvm com.sec.android.app.billing com.sec.android.app.camera com.sec.android.app.clockpackage com.sec.android.app.desktoplauncher com.sec.android.app.dexonpc com.sec.android.app.kidshome com.sec.android.app.popupcalculator com.sec.android.app.samsungapps com.sec.android.app.sbrowser com.sec.android.app.setupwizardlegalprovider com.sec.android.app.shealth com.sec.android.app.voicenote com.sec.android.cover.ledcover com.sec.android.daemonapp com.sec.android.desktopmode.uiservice com.sec.android.easyMover.Agent com.sec.android.easyonehand com.sec.android.gallery3d com.sec.android.mimage.avatarstickers com.sec.android.service.health com.sec.android.splitsound com.sec.android.widgetapp.samsungapps com.sec.android.widgetapp.webmanual com.sec.location.nsflp2 com.sec.penup com.sec.spp.push com.synchronoss.dcs.att.r2g com.ted.number com.tencent.soter.soterserver com.trustonic.teeservice com.vcast.mediamanager com.vivo.appfilter com.vivo.appstore com.vivo.assistant com.vivo.browser com.vivo.carmode com.vivo.collage com.vivo.compass com.vivo.doubleinstance com.vivo.doubletimezoneclock com.vivo.dream.music com.vivo.dream.weather com.vivo.easyshar com.vivo.email com.vivo.ewarranty com.vivo.favorite com.vivo.floatingball com.vivo.fuelsummary com.vivo.gamewatch com.vivo.globalsearch com.vivo.hiboard com.vivo.magazine com.vivo.mediatune com.vivo.minscreen com.vivo.motormode com.vivo.numbermark com.vivo.pushservice com.vivo.setupwizard com.vivo.smartmultiwindow com.vivo.smartshot com.vivo.translator com.vivo.unionpay com.vivo.video.floating com.vivo.videoeditor com.vivo.vivokaraoke com.vivo.weather com.vivo.weather.provider com.vivo.website com.vivo.widget.calendar com.vzw.hs.android.modlite com.vzw.hss.myverizon com.wavemarket.waplauncher com.wb.goog.dcuniverse com.wb.goog.got.conquest com.wsomacp com.xiaomi.ab com.xiaomi.account com.xiaomi.bsp.gps.nps com.xiaomi.discover com.xiaomi.finddevice com.xiaomi.location.fused com.xiaomi.micloud.sdk com.xiaomi.midrop com.xiaomi.miplay_client com.xiaomi.powerchecker com.xiaomi.providers.appindex com.xiaomi.simactivate.service com.xiaomi.upnp com.xiaomi.xmsf com.xiaomi.xmsfkeeper Emoji flipboard.boxer.app jp.gocro.smartnews.android net.aetherpal.device om.oppo.aod org.kman.AquaMail Samsung se.dirac.acs vendor.qti.hardware.cacert.server
do pm disable-user --user 0 $i ; done

for i in com.alibaba.aliexpresshd com.android.galaxy4 com.android.stk com.android.stk2 com.android.thememanager com.android.thememanager.module com.android.traceur com.autonavi.minimap com.ebay.carrier com.ebay.mobile com.facebook.appmanager com.facebook.katana com.facebook.services com.facebook.system com.google.android.apps.docs com.google.android.apps.googleassistant com.google.android.apps.magazines com.google.android.apps.maps com.google.android.apps.podcasts com.google.android.apps.subscriptions.red com.google.android.apps.tachyon com.google.android.apps.wellbeing com.google.android.apps.youtube.music com.google.android.googlequicksearchbox com.google.android.marvin.talkback com.google.android.music com.google.android.onetimeinitializer com.google.android.play.games com.google.android.projection.gearhead com.google.android.tts com.google.android.videos com.huaqin.wifibtrxtx com.mfashiongallery.emag com.mi.android.globalminusscreen com.mi.android.globalpersonalassistant com.mi.AutoTest com.mi.global.bbs com.mi.global.shop com.mi.globalbrowser com.micredit.in com.mipay.wallet.id com.mipay.wallet.in com.miui.cloudservice com.miui.cloudservice.sysbase com.miui.compass com.miui.gallery com.miui.huanji com.miui.hybrid com.miui.hybrid.accessory com.miui.klo.bugreport com.miui.micloudsync com.miui.newmidrive com.miui.player com.miui.translation.kingsoft com.miui.translation.youdao com.miui.translationservice com.miui.videoplayer com.miui.weather2 com.miui.yellowpage com.monotype.android.font.foundation com.monotype.android.font.samsungone com.netflix.mediaclient com.netflix.partner.activation com.opera.browser com.opera.preinstall com.samsung.android.wellbeing com.spotify.music com.swiftkey.swiftkeyconfigurator com.touchtype.swiftkey com.xiaomi.glgm com.xiaomi.joyose com.xiaomi.mbnloader com.xiaomi.mi_connect_service com.xiaomi.midrop com.xiaomi.mipicks com.xiaomi.mirecycle com.xiaomi.oversea.ecom com.xiaomi.payment com.yandex.zen com.yandex.zenkitpartnerconfig com.zhiliaoapp.musically in.amazon.mShop.android.shopping ru.yandex.money ru.yandex.money.service ru.yandex.searchplugin uninstall.voice.activation
do pm uninstall -k --user 0 $i ; done
 
     cmd shortcut reset-all-throttling
     pm bg-dexopt-job
     pm compile -a -f --check-prof false --compile-layouts
     pm compile -a -f --check-prof false -m speed; fi
 fi



### ANDROID SECTION STOPPED HERE






usermod -a -G video $LOGNAME









if [ ! -f /sbin/f2fs-hot.list ] && grep -q f2fs "$fstab" && [ $firstrun = yes ] ; then
echo '# video
avi
divx
flv
m2ts
m4p
m4v
mkv
mov
ts
vob
webm

# audio
aac
ac3
dts
flac
m4a
mka
wav

# image
bmp
gif
png
svg
webp

# archive
7z
# a -
deb
gz
iso
jar
lzma
rar
tgz
txz
udf
xz
zip

# other
pdf
# Python bytecode
pyc
ttf
ttc

# common prefix
# Covers jpg, jpeg, jp2
jp
# Covers mp3, mp4, mpeg, mpg
mp
# Covers oga, ogg, ogm, ogv
og
# Covers wma, wmb, wmv
wm

# android
apk
# Image alias
cnt
# YouTube
exo
# Android RunTime
odex
vdex
so' | tee /sbin/f2fs-cold.list

echo 'db' | tee /sbin/f2fs-hot.list

find /sys/fs/f2fs* -name extension_list | while read list; do
  echo "Updating extensions list for $list"

  echo "Removing previous extensions list"

  HOT=$(cat $list | grep -n 'hot file extension' | cut -d : -f 1)
  COLD=$(($(cat $list | wc -l) - $HOT))

  COLDLIST=$(head -n$(($HOT - 1)) $list | grep -v ':')
  HOTLIST=$(tail -n$COLD $list)

  echo $COLDLIST | tr ' ' '\n' | while read cold; do
    echo "[c]!$cold"
    echo "[c]!$cold" > $list
  done

  echo $HOTLIST | tr ' ' '\n' | while read hot; do
    echo "[h]!$hot"
    echo "[h]!$hot" > $list
  done

  echo "Writing new extensions list"

  cat /sbin/f2fs-cold.list | grep -v '#' | while read cold; do
    if [ ! -z $cold ]; then
      echo "[c]$cold"
      echo "[c]$cold" > $list
    fi
  done

  cat /sbin/f2fs-hot.list | while read hot; do
    if [ ! -z $hot ]; then
      echo "[h]$hot"
      echo "[h]$hot" > $list
    fi
  done
done

fi

chmod 666 /sys/module/sync/parameters/fsync_enabled
chown root /sys/module/sync/parameters/fsync_enabled
echo "Y" > /sys/module/sync/parameters/fsync_enabled



# setup uses firewalld not both anymore since ufw caused regression on latency in older hardware, leave this in despite but change to performance mode just in case
#if [ $level = high ] && [ $loglevel = 0 ] ; then
#ufw logging off
#else ufw logging on ; fi

# hindsight disable it alltogether since we dont use it...










# IRQ
# manually set irq but not working for me - but already set as kernel parameter in bootargs so delete irqbalance. hijacking /proc/cmdline probably doesnt do anything on other devices. unless the kernel is compiled with support to pickup on parameters which isnt the case of openwrt. double check if parameters get applied. otherwise its only true for x86
#for i in /proc/irq/*; do $(if [ -d $i ]; then echo '1' | sudo tee $i/smp_affinity || true ; else echo '1' | sudo tee $i || true ; fi) ; done






    ### < RANDOM PER DEVICE STUFF >


    ### modprobe kmods
#modprobe deflate crypto_acompress zlib_deflate zlib_inflate configs nft_numgen nls_utf8 dns_resolver cryptodev jitterentropy_rng xt_FLOWOFFLOAD tcp_bbr bfq nft_flow_offload loop rng urngd urandom_seed nf_flow_table_inet nf_flow_table_ipv4 #cachefiles fscache
#if ifconfig | grep -q "phy\|wlan\|radio" ; then modprobe lib80211_crypt_ccmp cfg80211 mac80211 lib80211 ; fi

if $wrt && grep -q "ppp" $iface ; then modprobe pppox pppoe ppp_mppe ppp_generic ppp_async ralink-gdma ; fi


# blacklist
#if $(! grep -q mac_hid /etc/modprobe.d/nomisc.conf) ; then
echo 'blacklist pcspkr
blacklist snd_pcsp
blacklist lpc_ich
blacklist gpio-ich
blacklist iTCO_wdt
blacklist joydev
blacklist mousedev
blacklist mac_hid
blacklist uvcvideo
blacklist parport_pc
blacklist parport
blacklist lp
blacklist ppdev
blacklist sunrpc
blacklist floppy
blacklist arkfb
blacklist aty128fb
blacklist atyfb
blacklist radeonfb
blacklist cirrusfb
blacklist cyber2000fb
blacklist kyrofb
blacklist matroxfb_base
blacklist mb862xxfb
blacklist neofb
blacklist pm2fb
blacklist pm3fb
blacklist s3fb
blacklist savagefb
blacklist sisfb
blacklist tdfxfb
blacklist tridentfb
blacklist vt8623fb
blacklist sp5100-tco
blacklist pcmcia
blacklist yenta_socket
'"$scsiblack"'
'"$cecblack"'' | tee /etc/modprobe.d/nomisc.conf # ; fi

if $(! grep ktune "$ifdr"/etc/ppp/options) ; then
### pppd config
echo '#debug
logfile /dev/null
noipdefault
lock
maxfail 0
modem
asyncmap 0
crtscts
ktune
mtu 1492
default-mru
bsdcomp 15,15
deflate 15,15
predictor1
sync' | tee "$ifdr"/etc/ppp/options ; fi



echo '# Defaults for kexec initscript
# sourced by /etc/init.d/kexec and /etc/init.d/kexec-load

# Load a kexec kernel (true/false)
LOAD_KEXEC=true

# Kernel and initrd image
KERNEL_IMAGE="'"$(find /boot/EFI/Linux/*clrxt* | head -n 1)"'"
#INITRD="/initrd.img"

# If empty, use current /proc/cmdline
#APPEND=""
APPEND="'"$par"'"

# Load the default kernel from grub config (true/false)
USE_GRUB_CONFIG=false' | tee /etc/default/kexec

  #
    systemctl daemon-reload
    pkill -f systemd-corecump


# if anacron no cron
if $(! $linux) && [ $firstrun = yes ] ; then
if systemctl list-unit-files | grep -q anacron ; then systemctl disable cron && systemctl mask cron ; else systemctl start cron && systemctl enable cron && /etc/init.d/cron start && /etc/initd.cron enable; fi ; fi









# stop some kmod for all but wrt again
if $(! $wrt) && [ ! $ipv6 = on ] ; then echo "blacklist ipv6" | sudo tee /etc/modprobe.d/blacklist-ipv6.conf ; elif [ $ipv6 = on ] ; then rm -rf /etc/modprobe.d/blacklist-ipv6.conf ; fi


# blacklist old radeon cards - if you cant boot remove this blacklist
#if $(! grep -q "blacklist radeon" /etc/modprobe.d/radeon.conf) ; then echo "blacklist radeon" | sudo tee /etc/modprobe.d/radeon.conf ; fi




# if dbusbroker stop dbus - buggy for me
# if systemctl list-unit-files | grep dbus-broker ; then systemctl enable dbus-broker && systemctl start dbus-broker && systemctl disable dbus && systemctl mask dbus ; fi






# daily fstrim weekly xfs defragment
if $(! $wrt && systemctl list-unit-files | grep -q anacron) ; then if $(! grep -q fstrim /etc/anacrontabs) ; then echo "@daily fstrim /" | tee -a /etc/anacrontabs ; if grep -q xfs /etc/fstab && ! grep -q xfs_fsr /etc/anacrontabs ; then echo '@weekly for i in $(blkid | grep xfs | awk -F : '\''{print $1}'\'') ; do xfs_fsr -f $i >/dev/null' | tee -a /etc/anacrontabs ; elif $(! grep -q fstrim /etc/crontab /etc/crontabs/root) ; then echo "02 4 * * * root fstrim /" | tee /etc/crontab /etc/crontabs/root ;  fi ; fi ; fi



# nougat is stubborn - leave all this and let user enable init.d themselves instead if needed whatsoever
#if [ -f $droidprop ] && [ -f /system/xbin/sh ] ; then if [ -f /system/etc/init.d/*userinit* ] ; then sed -i 's/\/system\/bin\/sh/\'"$droidshell"'/g' /system/etc/init.d/*userinit* ; elif [ -f $droidprop ] ; then echo 'call userinit.sh and/or userinit.d/* scripts if present in /data/local

#if [ -e /data/local/userinit.sh ];
#then
#   log -p i -t userinit "Executing /data/local/userinit.sh";
#   logwrapper '"$bb"'sh /data/local/userinit.sh;
#   setprop cm.userinit.active 1;
#fi;
#
#if [ -d /data/local/userinit.d ];
#then
#   logwrapper toybox run-parts /data/local/userinit.d;
#   setprop cm.userinit.active 1;
#fi;' | tee /system/etc/init.d/userinit ; fi ; fi





# skip this underneath... kexec does it hopefully
# compare par to cmdline, if not equal update. fkn bugs everywhere
#grubpar=$(awk '/GRUB_CMDLINE_LINUX_DEFAULT/ { print }' /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT="//g' | sed 's/"//g')
#cmdlinepar=$(cat /proc/cmdline)
if [ $firstrun = yes ] ; then update-grub ; grub-mkconfig ; udevadm control --reload ; udevadm trigger ; fi #elif [ ! $firstrun = yes ] && [ ! "$grubpar" = "$cmdlinepar" ] ; then update-grub ; grub-mkconfig ; udevadm control --reload ; udevadm trigger ; fi

scriptdir=$(echo "$( pwd; )/$( basename -- "$0"; )")

if [ $override = yes ] ; then
sed 's/script_autoupdate=.*/script_autoupdate=no/g' "$scriptdir"
if [ -e $droidprop ] ; then \cp -f "$scriptdir" /etc/bak/data/adb/service.d
if $(! grep -q mitigations /proc/cmdline) ; then ln -s "$scriptdir" /etc/init.d/${file} ; fi ; fi
\cp -f "$scriptdir" /etc/rc.local ; fi










#service procps force-reload






# disable bluetooth for all but android
if [ $firstrun = yes ] ; then
if [ ! -f $droidprop ] && [ ! $bluetooth = on ] ; then
systemctl disable bluetooth && systemctl mask bluetooth ; else echo "blacklist btusb\nblacklist hci_uart" | sudo tee /etc/modprobe.d/blacklist-bluetooth.conf ; fi
fi


if [ $bluetooth = on ] ; then
rm -f /etc/modprobe.d/blacklist-bluetooth.conf
fi









if [ $firstrun = yes ] && $linux ; then

  ### some more firstrun stuff
  #aptitude search '~i!~Nlib(~Dqt|~Dkde)'
  mkdir -p tmp
  cd tmp
  if $debian ; then
  sudo wget ${rawlink}/kdebugsettings_22.12.0-2.1_amd64.deb ; sudo dpkg -i kdebugsettings*.deb
  sudo wget ${rawlink}/.basicsetup/mkcomposecache_1.2.2-2.4_amd64.deb ; sudo dpkg -i mkcomposecache*.deb
  # sudo wget ${rawlink}/.basicsetup/libtrick.so ; cp libtrick.so /usr/lib/x86_64-linux-gnu/libtrick.so ; rm -f libtrick.so # library for amdcpus fooling intel math kernel libraries by spoofing amd as intel cpu, probably doesnt work on their latest releases and MKL disabled cause only AVX512 instructionset capable cpu's benefit from it and well. its closed source.
  sudo wget ${rawlink}/.basicsetup/system76-scheduler_1.2.1-2_amd64.deb ; sudo dpkg -i system76-scheduler*.deb ; rm -rf system76*scheduler*.deb # these binaries arent in debian nor can be found as deb. had to convert rpm packages.
  fi

  if $arch ; then sudo wget ${rawlink}/.basicsetup/system76-scheduler-1.2.1-1-x86_64.pkg.tar.zst ; sudo pacman -U --noconfirm --needed system76-scheduler-1.2.1-1-x86_64.pkg.tar.zst ; rm -rf system76-scheduler*.pkg.tar.zst
  fi

  sudo wget ${rawlink}/.basicsetup/kscripts.zip ; mkdir -p /home/$himri/.local/share/kwin/scripts ; cp -f kscripts.zip /home/$himri/.local/share/kwin/scripts ; unzip -u /home/$himri/.local/share/kwin/scripts/kscripts.zip ; rm -rf /home/$himri/.local/share/kwin/scripts/kscripts.zip ; sudo systemctl enable com.system76.Scheduler.service



  if [ ! -f /home/$himri/.local/share/kwin/scripts/kwin-system76-scheduler-integration/contents/code/main.js ] ; then
mkdir -p /home/$himri/.local/share/kwin/scripts/kwin-system76-scheduler-integration/contents/code
echo 'workspace.clientActivated.connect(function(client) {
    callDBus("com.system76.Scheduler", "/com/system76/Scheduler", "com.system76.Scheduler", "SetForegroundProcess", client.pid);
})' | tee /home/$himri/.local/share/kwin/scripts/kwin-system76-scheduler-integration/contents/code/main.js
echo '[Desktop Entry]
Name=System76 Scheduler Integration
Comment=Notify System76 Scheduler which app has focus so it can be prioritized
Icon=pop-os

X-KDE-PluginInfo-Author=Maximiliano Bertacchini
X-KDE-PluginInfo-Email=maxiberta@gmail.com
X-KDE-PluginInfo-Name=kwin-system76-scheduler-integration
X-KDE-PluginInfo-Version=0.1
X-KDE-PluginInfo-License=MIT

Type=Service
X-KDE-ServiceTypes=KWin/Script
X-Plasma-API=javascript
X-Plasma-MainScript=code/main.js' | tee /home/$himri/.local/share/kwin/scripts/kwin-system76-scheduler-integration/metadata.desktop ; fi

if [ $level = high ] ; then 
 # wget ${rawlink}/.basicsetup/smc-tools_1.8.2_amd64.deb -O tmp/smc-tools.deb ; dpkg -i tmp/smc-tools.deb
 # wget ${rawlink}/.basicsetup/libsmc-preload32.so -O /usr/lib/libsmc-preload32.so
 if $debian && [ $microcode = off ] ; then apt -f -y remove intel-microcode amd-microcode iucode-tool ; elif $debian && [ microcode = on ] ; then apt -f -y install intel-microcode amd-microcode iucode-tool ; fi
 
  if $arch && [ $microcode = off ] ; then pacman -Rscn --noconfirm intel-ucode ; pacman -Rscn --noconfirm amd-ucode ; pacman -Rscn --noconfirm iucode-tool ; elif $arch && [ microcode = on ] ; then pacman -S --noconfirm amd-ucode intel-ucode iucode-tool ; fi
 
 $s 
$s pacman -Rscn --noconfirm amd-ucode
  if $debian ; then apt -f -y install blktool mold hdparm lz4 macchanger net-tools wireless-tools iw preload ethtool kexec-tools ; dpkg-reconfigure dash kexec-tools ; fi
  if $arch ; then pacman -S --noconfirm --needed hdparm lz4 macchanger mold net-tools wireless_tools iw dash kexec-tools ; fi
  
  if $linux ; then
  if $(grep -q "/usr/bin/sddm" /etc/X11/default-display-manager) ; then
  apt -f -y install kdebugsettings ; fi
  apt -f -y install mold
  if [ $? -eq 0 ] ; then preload=yes ; echo "preload=yes" | tee /etc/bak/dontdelete ; fi
                      ### disable and mask unneeded services

for i in configure-printer@.service exim4.service quotaon.service rdma-load-modules@.service rdma-ndd.servicerdma-ndd.service exim4-base.timer systemd-coredump@.service plymouth-log pulseaudio-enable-autospawn uuidd x11-common bluetooth gdomap smartmontools speech-dispatcher bluetooth.service cron ifupdown-wait-online.service geoclue.service keyboard-setup.service logrotate.service ModemManager.service NetworkManager-wait-online.service plymouth-quit-wait.service plymouth-log.service pulseaudio-enable-autospawn.service remote-fs.service smartmontools.service speech-dispatcher.service speech-dispatcherd.service systemd-networkd-wait-online.service x11-common.service uuidd.service syslog.socket bluetooth.target remote-fs-pre.target remote-fs.target rpcbind.target printer.target cups systemd-pstore.service cups.socket drkonqi-coredump-processor@.service cups.path smartd ; do
  systemctl disable $i ; systemctl mask $i ; done

if [ $loglevel = 0 ] ; then systemctl disable rsyslog.service ; systemctl mask rsyslog.service ; else systemctl unmask rsyslog.service ; systemctl enable rsyslog.service ; fi
systemctl enable reflector.timer
systemctl enable pacman-filesdb-refresh.timer

if [ $bluetooth = on ] ; then
systemctl unmask bluetooth ; systemctl enable bluetooth
fi

    if [ ! $raid = no ] ; then for i in mdmonitor.service mdmonitor-oneshot.service mdcheck_start.service mdcheck_continue.service mdadm.service mdadm-shutdown.service lvm2-monitor.service lvm2-lvmpolld.service lvm2-lvmpolld.socket dm-event.socket mdadm-grow-continue@.service mdadm-last-resort@.service mdadm-last-resort@.timer ; do
    systemctl disable $i ; systemctl mask $i ; done ; fi
fi

  rm -rf $HOME/.config/kdeconnect /home/$himri/.config/kdeconnect

 "$bb"sh -x "$ifdr"/etc/update_hosts.sh



        ### < SERVICES >

      ### services to disable and start. more at end of this script but are device dependent so no need for doubles here. this only disables services it finds active of the list underneath. for the rest manually use 'rcconf'. underneath works with regex too since being grep. careful, add exclusions if necessary.
    disable_services="plymouth-quit-wait.service\|cgroupfs-mount\|cron\|cups\|pulseaudio-enable-autospawn\|rsync\|exim4\|saned\|smartmontools\|speech-dispatcher\|x11-common\|lynis\|wait-online\|printer\|journal\|log\|rpcbind\|remote-fs\|upower\|pstore\|drkonqi-coredump-processor@.service"

    enable_services="firewalld\|apparmor\|run-shm.mount\|snapd.apparmor.service\|fstrim.timer\|dbus-broker\|alsa-utils\|cronie\|preload\|thermald\|rngd\|haveged"
    # for accidental protection
    exclude_from_disabling="sudo\|alsa\|anacron\|apparmor\|firewalld\|ufw\|run-shm.mount\|rtkit\|alsa-utils\|virt\|cronie"

disableserv=$(systemctl list-unit-files | grep "$disable_services" | grep enabled | awk -F '.' '{print $1}' | grep -v "$exclude_from_disabling" | awk -v RS=  '{$1=$1}1')
maskdisable=$(systemctl list-unit-files | grep "$disable_services" | grep enabled | grep -v "mask" | awk -F '.' '{print $1}' | grep -v "$exclude_from_disabling" | awk -v RS=  '{$1=$1}1')

startserv=$(systemctl list-unit-files | grep "$enable_services" | grep disabled | awk '{print $1}')
maskenable=$(systemctl list-unit-files | grep "$enable_services" | grep "disabled\|mask" | awk '{print $1}')

# dunno if mdadm is needed for raid. checkout to be sure
if $(! $wrt) ; then  systemctl disable ModemManager ; systemctl mask ModemManager ;
systemctl stop $disableserv
systemctl disable $disableserv
systemctl mask $maskdisable

systemctl unmask $maskenable
systemctl enable $startserv


fi
fi
echo '[Unit]
Description=Set sched_latency_ns in accordance with basic-linux-setup
After=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target

[Service]
User=root
ExecStart=/usr/sbin/bls-schedlatency.bash
Type=simple
Restart=always
Environment="DISPLAY=:0"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target suspend.target hibernate.target hybrid-sleep.target suspend-then-hibernate.target' | sudo tee /usr/lib/systemd/system/bls-schedlatency.service

echo '#!/bin/bash
if [ -e /sys/kernel/debug/sched/latency_ns ] 
then
echo 40000 > /sys/kernel/debug/sched/latency_ns 
elif [ -e /proc/sys/kernel/sched_latency_ns ] 
then 
echo 40000 > /proc/sys/kernel/sched_latency_ns
fi' | sudo tee /usr/sbin/bls-schedlatency.bash
sudo chmod +x /usr/sbin/bls-schedlatency.bash
sudo systemctl enable bls-schedlatency
sudo systemctl start bls-schedlatency


fi









#if [ $ipv6 = on ] ; then
#sysctl -w net.ipv6.conf.lo.disable_ipv6=0
#sysctl -w net.ipv6.conf.all.disable_ipv6=0
#sysctl -w net.ipv6.conf.default.disable_ipv6=0
#sysctl -w net.ipv6.conf.all.accept_ra=1
#echo 'net.ipv6.conf.all.disable_ipv6 = 0
#net.ipv6.conf.default.disable_ipv6 = 0
#net.ipv6.conf.lo.disable_ipv6 = 0
#net.ipv6.conf.all.accept_ra = 1' | tee -a "$ifdr"/etc/sysctl.d/sysctl.conf "$ifdr"/etc/sysctl.conf
#sed -i 's/net.ipv6.conf.all.disable_ipv6.*/net.ipv6.conf.all.disable_ipv6 = 0/g'
#sed -i 's/net.ipv6.conf.default.disable_ipv6.*/net.ipv6.conf.default.disable_ipv6 = 0/g'
#sed -i 's/net.ipv6.conf.lo.disable_ipv6.*/net.ipv6.conf.lo.disable_ipv6 = 0/g'
#sed -i 's/net.ipv6.conf.all.accept_ra.*/net.ipv6.conf.all.accept_ra = 1/g'
#else
#sysctl -w net.ipv6.conf.lo.disable_ipv6=1
#sysctl -w net.ipv6.conf.all.disable_ipv6=1
#sysctl -w net.ipv6.conf.default.disable_ipv6=1
#sysctl -w net.ipv6.conf.all.accept_ra=0
#echo 'net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.lo.disable_ipv6 = 1
#net.ipv6.conf.all.disable_ipv6 = 1
#net.ipv6.conf.default.disable_ipv6 = 1
#net.ipv6.conf.all.accept_ra = 0' | tee -a "$ifdr"/etc/sysctl.d/sysctl.conf "$ifdr"/etc/sysctl.conf
#sed -i 's/net.ipv6.conf.all.disable_ipv6.*/net.ipv6.conf.all.disable_ipv6 = 1/g'
#sed -i 's/net.ipv6.conf.default.disable_ipv6.*/net.ipv6.conf.default.disable_ipv6 = 1/g'
#sed -i 's/net.ipv6.conf.lo.disable_ipv6.*/net.ipv6.conf.lo.disable_ipv6 = 1/g'
#sed -i 's/net.ipv6.conf.all.accept_ra.*/net.ipv6.conf.all.accept_ra = 0/g' ; fi








#rmmod efi_pstore cachefiles fscache cec



    #"$bb"mount -t hugetlbfs none /mnt/hugepages
    #"$bb"mount -t pstore none /sys/fs/pstore
    #"$bb"mount -t tracefs none /sys/kernel/tracing
    #"$bb"mount -t tracefs none /sys/kernel/debug/tracing
    #"$bb"mount -t cgroup2 none /sys/fs/cgroup
    #"$bb"mount -t cgroup none /dev/memcg
    #"$bb"mount -t cgroup none /dev/cpuctl
    #"$bb"mount -t cgroup none /acct
    #"$bb"mount -t debugfs none /sys/kernel/debug
    #"$bb"umount /sys/fs/pstore
    #"$bb"umount /sys/kernel/tracing
    #"$bb"umount /sys/kernel/debug/tracing
    #"$bb"umount /sys/fs/cgroup
    #"$bb"umount /dev/memcg
    #"$bb"umount /dev/cpuctl
    #"$bb"umount /acct
    #"$bb"umount /sys/kernel/debug











    if [ $firstrun = yes ] && [ -e $droidprop ] ; then
    "$bb"mount -o remount,rw /cache
    rm -rf /cache/*
    rm -rf /data/cache/*
    rm -rf /data/dalvik-cache/*
    "$bb"fstrim /cache ; fi

        # remount ro android
     if [ -f $droidprop ] ; then
    "$bb"mount -o remount,ro /system
    "$bb"mount -o remount,ro /vendor
    #"$bb"mount -o remount,ro /data
    "$bb"mount -o remount,ro rootfs /
    #"$bb"mount -o ro /dev/block/bootdevice/by-name/data /data
    #"$bb"mount -o ro /dev/block/bootdevice/by-name/vendor /vendor
    #"$bb"mount -o ro /dev/block/bootdevice/by-name/system /system
    fi

#"$bb"mount -t hugetlbfs nodev /mnt/huge










if $linux && [ $firstrun = yes ] ; then
update-grub ; grub-mkconfig ; bootctl systemd-efi-options ""$par"" 

if $(apt list | grep initramfs | grep -q installed) ; then
update-initramfs -c -k all ; mkinitramfs -c lz4 -o /boot/initrd.img-*

else

# config dracut as well in case of not using initramfs-tools
                    #if echo "$zswap" | grep -q "zswap.enabled=1" ; then draczswap=" zsmalloc z3fold" ; fi
          if [ $dracut = enabled ] ; then
        if [ ! "$(cat /etc/dracut.conf.d/*linux.conf)" = "$dracflags" ] ; then
        rm -rf /etc/dracut.conf.d/* ; echo "$dracflags" | tee /etc/dracut.conf.d/10-linux.conf ; fi
        if [ -e $systemdb ] ; then defi2=" --uefi" ; fi
        dracut --regenerate-all --lz4$defi2 --add-fstab /etc/fstab --fstab --host-only -f --strip --hostonly-cmdline$(if [ $microcode = on ] ; then echo " --early-microcode" ; fi) 




 fi ; fi 
 bootctl install ; bootctl systemd-efi-options ""$par"" ; bootctl update 

 fi










### c compiler exports ... no more o3? for future of script stuff if i ever will work on it... unfinished
# https://docs.amd.com/en-US/bundle/AMD-Instinct-MI100-High-Performance-Computing-and-Tuning-Guide-v5.2/page/Running_Applications_on_AMD_GPUs.html
# https://llvm.org/docs/AMDGPUUsage.html
# https://gcc.gnu.org/wiki/Offloading
if [ $skip = false ] ; then
compiler () {
if echo $CC | grep -q "gcc\|llvm\|clang" ; then

if [ $ARCH = x86 ] ; then export opt=native ; fi

if [ $ARCH = arm64 ]; then
export KBUILD_CFLAGS+= -fuse-ld=ld.gold
export LDFLAGS+= -plugin LLVMgold.so
else export KBUILD_CFLAGS+= -fuse-ld=lld ; fi

#polly=/usr/lib/llvm*/lib/LLVMPolly.so
#ldgold=/usr/lib/llvm*/lib/LLVMgold.so
echocc() {
echo '
subdir-ccflags-y := -O3 -ffast-math -fforce-addr --param=ssp-buffer-size=32 -D_FORTIFY_SOURCE=2 -D_REENTRANT -fassociative-math -fasynchronous-unwind-tables -feliminate-unused-debug-types -fexceptions -fno-semantic-interposition \
-fno-signed-zeros -fno-strict-aliasing -fno-trapping-math -ldl -lhmmer -lm -lncurses -lpthread -lsquid -m64 -pthread -Wall -Wformat-security -mcpu=native -g -fno-stack-protector \
-fwrapv -lpgcommon -lpgport -lpq -lrt -lcrypt -mtune=native -march=native -fomit-frame-pointer -pipe -Wno-error -funroll-loops -ftree-vectorize -Wno-frame-address -fopenmp -mabi=native -mfpu=native -mfloat-abi=native -fgraphite-identity -floop-strip-mine -floop-nest-optimize -fno-semantic-interposition -fipa-pta -fdevirtualize-at-ltrans -flto -flto-partition=one

export LDFLAGS_MODULE= --strip-debug

export LDFLAGS= -O3 -plugin-opt=-function-sections -plugin-opt=-data-sections -plugin-opt=new-pass-manager -plugin-opt=O3 -plugin-opt=mcpu=native -plugin LLVMPolly.so --gc-sections -ffast-math -pipe -fPIE -march=native -mtune=native --param=ssp-buffer-size=32 -D_FORTIFY_SOURCE=2 -D_REENTRANT -fassociative-math -fasynchronous-unwind-tables -feliminate-unused-debug-types -fno-semantic-interposition -fno-signed-zeros -fno-strict-aliasing -fno-trapping-math -m64 -pthread -Wnoformat-security -fno-stack-protector -fwrapv -funroll-loops -ftree-vectorize -fforce-addr -Wl,-O3 -Wl,-z,now -Wl,--as-needed -Wl,--no-copy-dt-needed-entries -Wl,--sort-common -Wl,--hash-style=gnu



#export KBUILD_CFLAGS+=  -mllvm -polly \
                        -mllvm -polly-run-inliner \
                        -mllvm -polly-opt-fusion=max \
                        -mllvm -polly-omp-backend=LLVM \
                        -mllvm -polly-scheduling=dynamic \
                        -mllvm -polly-scheduling-chunksize=1 \
                        -mllvm -polly-opt-maximize-bands=yes \
                        -mllvm -polly-ast-detect-parallel \
                        -mllvm -polly-ast-use-context \
                        -mllvm -polly-opt-simplify-deps=no \
                        -mllvm -polly-rtc-max-arrays-per-group=40 \
                        -mllvm -polly-parallel 
                        
                        #export LDFLAGS+=-plugin LLVMPolly.so

export KBUILD_CFLAGS+= --param=ssp-buffer-size=32 \
        -D_FORTIFY_SOURCE=2 \
        -D_REENTRANT \
        -fassociative-math \
        -fasynchronous-unwind-tables \
        -feliminate-unused-debug-types \
        -fexceptions \
        -ffast-math \
        -fforce-addr \
        -fno-semantic-interposition \
        -fno-signed-zeros \
        -fno-stack-protector \
        -fno-strict-aliasing \
        -fno-trapping-math \
        -fomit-frame-pointer \
        -fopenmp \
        -ftree-vectorize \
        -funroll-loops \
        -fwrapv \
        -g \
        -lcrypt \
        -ldl \
        -lhmmer \
        -lm \
        -lncurses \
        -lpgcommon \
        -lpgport \
        -lpq \
        -lpthread \
        -lrt \
        -lsquid \
        -m64 \
        -mabi=native \
        -mcpu=native \
        -mfloat-abi=native \
        -mfpu=native \
        -mtune=native \
        -O3 \
        -pipe \
        -pthread \
        -Wall \
        -Wno-error \
        -Wno-format-security \
        -Wno-frame-address \
        -Wno-maybe-uninitialized \
        -Wno-trigraphs \
        -Wundef \
        -fgraphite-identity -floop-strip-mine -floop-nest-optimize -fno-semantic-interposition -fipa-pta -fdevirtualize-at-ltrans -flto -flto-partition=one \
        -Wl,-z -Wl,now -Wl,relro -ffat-lto-objects -fno-trapping-math -Wl,-sort-common -Wl,--enable-new-dtags -Wa,-mbranches-within-32B-boundaries

KBUILD_USERHOSTCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
			 -O3 -fomit-frame-pointer -std=gnu11 \
			 -Wdeclaration-after-statement


export KBUILD_CFLAGS:= "$cflags"

export subdir-ccflags-y:= "$cflags"
# these flags are from old setup, just kept for reference
'
}

ccg=gcc-"$(apt-cache search gcc | awk '{print $1}' | grep "gcc-.*-linux-gnu" | cut -c5-6 | sort -n | tail -n 1)"
ccl=llvm-"$(apt-cache search llvm | awk '{print $1}' | grep "llvm-.*-runtime" | sort -n | tail -n 1 | cut -c6-7)"
#ccl=llvm-"$(apt-cache search llvm | awk '{print $1}' | grep llvm- | tail  | head -n 1 | cut -c6-7)"

if [ $CC = gcc ] ; then export CC=$ccg ; fi

if [ $CC = llvm ] ; then export CC=$ccl ; fi
fi }
fi
if [ $firstrun = yes ] ; then
    balooctl suspend
    balooctl disable & pkill -f balooctl
    akonadictl stop & pkill -f akonadictl
pkill -f kded5
pkill -f kdeconnectd
pkill -f kalendarac
pkill -f kaccess
pkill -f ksystemstats
pkill -f kglobalaccel5
pkill -f drkonqi

if [ $level = high ] ; then 

    journalctl --vacuum-size=1
    journalctl --vacuum-time=2weeks
    pkill -f journalctl
loginctl unlock-sessions
fi
mv /usr/share/dbus-1/services/org.kde.runners.baloo.service /usr/share/dbus-1/services/org.kde.runners.baloo.service.disable
mv /usr/share/dbus-1/services/org.kde.kglobalaccel.service /usr/share/dbus-1/services/org.kde.kglobalaccel.service.disable
mv /usr/share/dbus-1/services/org.freedesktop.Akonadi.Control.service /usr/share/dbus-1/services/org.freedesktop.Akonadi.Control.service.disable
mv /usr/share/dbus-1/services/org.fedoraproject.Config.Printing.service /usr/share/dbus-1/services/org.fedoraproject.Config.Printing.service.disable


sh /etc/environment

# setenforce 1
sysctl -p /etc/sysctl.conf
kdebugsettings --disable-full-debug
kdebugsettings --debug-mode Off
cd "$(pwd)" ; rm -rf tmp
# drop all caches upon finalizing
    sysctl -w vm.drop_caches=3
    if [ $? = 1 ] ; then echo 3 > /proc/sys/vm/drop_caches ; fi
rm -rf /~
rm -rf tmp

#tuned -p network-throughput

echo "script ran from $scriptdir"
exit 0

fi


rm -rf /home/$himri/.ccache/ccache.conf.tmp*


# avoid security flaws
cp -rf /root/.zshrc /home/$himri/.zshrc
cp -rf /root/.bashrc /home/$himri/.bashrc
cp -rf /root/.p10k.zsh /home/$himri/.p10k.zsh
cp -rf /root/.config/fish/* /home/$himri/.config/fish/*

chown root /home/$himri/.zshrc
chown root /home/$himri/.bashrc
chown root /home/$himri/.p10k.zsh
chown root /home/$himri/.config/fish/*

if [ $webcam = yes ] ; then for i in videodev uvcvideo v4l2loopback ; do modprobe $i ; done ; fi


#######################!!!!!!!!!!!!!!!!!! sync values from basic-linux-setup for openwrt & linux !!!!!!!!!!!#####
if [ $script_autoupdate = yes ] && [ ! $override = yes ] ; then
# if online
ping -c3 "$ping"
  if [ $? -eq 0 ]; then echo "*BLS*=ONLINE SYNCING SCRIPTS!"
# if linux desktop
    if $linux ; then rm -rf tmp/${file} ; mkdir -p tmp ; wget --connect-timeout=10 --continue -4 --retry-connrefused ${rawlink}/${file} -O tmp/${file} ; if [ -f tmp/${file} ] ; then rm -rf /etc/rc.local && cp tmp/${file} /etc/rc.local && chmod +x /etc/rc.local && rm -rf tmp
    fi ; fi
# if wrt
      if $wrt ; then echo "*BLS*=OPENWRT found" &&
grep -q "ping -c3 "$ping"" /etc/rc.local
        if [ $? -eq 1 ] ; then echo "*BLS*=OPENWRT found but no rc.local. adding now!" && echo "$wrtsh" | tee /etc/rc.local && sed -i 's/$ping/'"$ping"'/g' /etc/rc.local && chmod +x /etc/rc.local ; else echo "*BLS*=rc.local up to date"
        fi
      fi
# if android
          if [ -f $droidprop ] ; then rm -rf ${file} && "$bb"wget ${rawlink}/${file} && if [ -f /system/xbin/sh ] ; then sed -i 's/#!\/bin\/sh/#!\'"$droidshell"'/g' ${file} ; else sed -i 's/#!\/bin\/sh/#!\/system\/bin\/sh/g' ${file} ; fi ; "$bb"chmod 755 ${file} ; "$bb"chmod +x ${file} ; "$bb"cp ${file} /data/adb/service.d/${file} ; if "$(cat /proc/cmdline )" | "$(! grep -q mitigations)" ; then ln -s /data/adb/service.d/${file} /system/etc/init.d/${file} ; ln -s /data/adb/service.d/${file} /system/etc/rc.local ; fi
### download browser stuff for android - leave this out for now the setup of flags for x86 doesnt work well on android
#if $(! grep -q quic /data/data/com.android.chrome/app_chrome/Default/Preferences) ; then wget https://github.com/thanasxda/basic-linux-setup/blob/master/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Default/Preferences ; "$bb"cp -f Preferences /data/data/com.android.chrome/app_chrome/Default/Preferences ; wget https://github.com/thanasxda/basic-linux-setup/raw/master/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Local%20State ; "$bb"cp -f "Local State" "/data/data/com.android.chrome/app_chrome/Local State" ; fi
          fi
# general devices and other distros
            elif ping -c3 "$ping"
[ $? -eq 0 ] && $(! $wrt) ; then -rm -rf /tmp/${file} ; wget ${rawlink}/${file} -O /tmp/${file} ; if [ -f tmp/${file} ] ; then cp /tmp/${file} /etc/rc.local && chmod +x /etc/rc.local ; fi
  fi
fi
#######################!!!!!!!!!!!!!!!!!! sync values from basic-linux-setup for openwrt & linux !!!!!!!!!!!#####

if [ $script_autoupdate != yes ] ; then cp -f $PWD/init.sh /etc/rc.local ; fi

if [ $uninstall = yes ] ; then

for i in "$ifdr"/etc/environment.d/env* "$ifdr"/etc/crontabs "$ifdr"/etc/crontab "$ifdr"/etc/cron.d/@reboot "$ifdr"/etc/anacrontab "$ifdr"/etc/update_hosts.sh "$ifdr"/root/cmdline "$ifdr"/etc/profile.d/kwin.sh "$ifdr"/etc/init.d/${file} "$ifdr"/etc/sysctl.conf "$ifdr"/etc/sysctl.d/sysctl.conf "$ifdr"/etc/rc.local /data/adb/post-fs-data.d/${file} /data/adb/service.d/${file} "$ifdr"/home/$himri/.config/plasma-workspace/env "$ifdr"/home/x/.x* "$ifdr"/home/x/.X* ; do
if [ -e $i ] ; then rm -rf $i ; fi ; done

\cp -rf /etc/bak/* /
if grep -q mitigations=off /etc/default/grub ; then sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX="splash quiet"' /etc/default/grub ; sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"' /etc/default/grub ; fi
if grep -q "cmdline" /etc/fstab "$fstab" ; then sed -i '/cmdline/c\' "$fstab" ; fi
rm -rf /DO_NOT_DELETE ; rm -rf /etc/sysctl.d/sysctl.conf ; fi

if $wrt && [ $persistent = yes ] ; then if $(! grep -qi thanas /etc/rc.local) ; then cat $PWD/init.sh | tee /etc/rc.local && chmod +x /etc/rc.local ; fi ; fi

if [ $restore_backup = yes ] ; then \cp -rf /etc/bak/* / ; rm -rf /DO_NOT_DELETE ; fi

if [ -e $PWD/.blsconfig ] ; then echo "\n local config present, if correct values are specified within $PWD/.blsconfig they will be used.
current modified config:
$(cat $PWD/.blsconfig)" ; fi
######
### still configuring this script, tips are welcome
### might still contain double or bad values...
exit 0
