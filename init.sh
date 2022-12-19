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
# setup meant as universal config for:
# x86, android, openwrt & general
droidprop="/system/build.prop"
wrt="grep -q wrt /etc/os-release"
debian="grep -q debian /etc/os-release"
     ### script execution delay
                if [ $testing = yes ] ; then echo " skip delay, testing..." ; else
  if [ -f $droidprop ] ; then
if [ "$(grep "bogomips\|BogoMIPS" /proc/cpuinfo | awk -F ":" '{print $2}' | awk -F '.' '{print $1}' | head -n 1)" -le 4000 ] ; then echo " slow device boot delay 200 seconds..." ; sleep 200
elif [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 8 ] ; then echo " less or equal to android 8, sleep 60 seconds..." ; sleep 60
else echo " android 9 or above found, sleep 30 seconds..." ; sleep 30 ; fi
  fi
if [ ! -f $droidprop ] && [ "$(grep "bogomips\|BogoMIPS" /proc/cpuinfo | awk -F ":" '{print $2}' | awk -F '.' '{print $1}' | head -n 1)" -le 4000 ] ; then echo " bogomips less or equal to 4000, sleep 30 seconds..." ; sleep 30 
elif [ ! -f $droidprop ] ; then echo " script starting..." ; sleep 5 ; fi
                fi
### busybox for android
if [ -f $doidprop ] ; then 
if [ -f /sbin/sh ] ; then export bb="/sbin/" ; fi 
if [ -f /bin/sh ] ; then export bb="/bin/" ; fi 
if [ -f /system/bin/sh ] ; then export bb="/system/bin/" ; fi 
if [ -f /system/xbin/sh ] ; then export bb="/system/xbin/" ; fi 
fi
#s="sudo"

 ### <<<< VARIABLES >>>> - UNDERNEATH VARIABLES ARE SETUP RELATED >>>>>>>>>>>>>>>>>>>>>>>>>>>> 

      ### < SCRIPT AUTO-UPDATE >
        script_autoupdate="yes"
        sourceslist_update="no"
      # clean /etc/apt/sources.list.d/* with the exception of extras.list which isn't synced
        clean_sources_list_d="yes"
      # to avoid much maintenance is partial
        restore_backup="no"
        uninstall="no"
      # due to compatibility reasons script is present over many devices. if choosing to edit the script then enable override variable underneath
        override="no"



      ### < MISC >
      # ipv6 "on" to enable
        ipv6="off"
      # dns servers
        dns1="1.1.1.1"
        dns2="1.0.0.1"
        dns61="2606:4700:4700::1111"
        dns62="2606:4700:4700::1001"
      # preferred address to ping
        pingaddr="1.1.1.1"




      ### < I/O SCHEDULER >
      # - i/o scheduler for block devices - none/kyber/bfq/mq-deadline (remember they are configured low latency in this setup) can vary depending on kernel version. [none] is recommended for nvme
        if ls /dev/nvme* ; then sched="none" ; else sched="bfq" ; fi
      # - only used when /dev/sd* ssd hdd etc.
        sdsched="bfq"
        mtdsched="bfq"
        mmcsched="cfq"
        if $(! grep -q cfq /sys/block/mmc*/queue/scheduler) ; then mmcsched="bfq" ; fi




      ### < CPU GOVERNOR >
      # - linux kernel cpu governor
        governor="performance"




      ### < MITIGATIONS > - an easy switch for ppl complaining while running windows... mainly for x86 anyways. hijacking /proc/cmdline doesnt even work lol
        mitigations="off"




      ### < TCP CONGESTION CONTROL >
      # - linux kernel tcp congestion algorithm
        tcp_con="bbr"
        if [ ! -f /proc/sys/net/core/default_qdisc ] ; then if grep -q westwood /proc/sys/net/ipv4/tcp_allowed_congestion_control ; then export tcp_con=westwood ; else export tcp_con="cubic" ; fi ; fi



      ### < QDISC >
      # - queue managment
        qdisc="fq_codel"
        #if $wrt ; then export qdisc="cake" ; fi




      ### < WIRELESS REG-DB >
      # - wireless regulatory settings per country 00 for global
        country="00"

        # meanwhile serves as list to make me remember how to figure out user. srry ppl with x in name. lazy
        if $wrt || uname -n | grep -q "x" || ls /home | grep -q "x" || grep -q "x" /etc/hostname /proc/sys/kernel/hostname || "$(getent passwd | grep 1000 | awk -F ':' '{print $1}')" | grep -q "x" || [ $LOGNAME = x ] || $(whoami) | grep -q "x" || [ $USER = x ] || echo $HOME | grep -q x || $SUDO_USER = x ; then country="GR" ; fi #$s xinput set-button-map 8 1 2 3 0 0 0 0 ; fi # disable my buggy scroll meanwhile




      ### < WIFI SETTINGS >
      # - basic wifi settings
        beacons="50"
        frag="2346"
        rts="2347"
        txpower="auto"
        pwrsave="off"
        distance="10"




      ### < ETHERNET SETTINGS >
      # - ethernet offloading
        rx="4096"
        tx="4096"
        fl="on"
      # -
        duplex="full"
        autoneg="on"




      ### < FSTAB FLAGS >
      # - /etc/fstab - let fstrim.timer handle discard
      # https://www.kernel.org/doc/Documentation/filesystems/ext4.txt
      # https://www.kernel.org/doc/Documentation/filesystems/f2fs.txt
      # https://www.kernel.org/doc/Documentation/filesystems/xfs.txt
        if $(! $droidprop) ; then export errorsmnt=",errors=remount-ro" ; fi
        xfs="defaults,rw,lazytime,noquota,nodiscard,attr2,inode64,logbufs=8,logbsize=128k,allocsize=64m,largeio,swalloc,filestreams"
       ext4="defaults,rw,lazytime,noquota,nodiscard,commit=60,data=writeback,nobarrier,noauto_da_alloc,user_xattr,max_batch_time=120,nomblk_io_submit,init_itable=0'"$errorsrmnt"'"
       f2fs="defaults,rw,lazytime,noquota,nodiscard,background_gc=on,no_heap,inline_xattr,inline_data,inline_dentry,flush_merge,extent_cache,mode=adaptive,alloc_mode=default,fsync_mode=posix,ram_thresh=20,cp_interval=120,nodiscard"
       vfat="defaults,rw,lazytime,fmask=0022,dmask=0022,shortname=mixed,utf8,errors=remount-ro"
      tmpfs="defaults,rw,lazytime,mode=1777"
       swap="sw,lazytime"

#f2fs
#active_logs=
#ext4 flags
#lazy_itable_init=0,lazy_journal_init=0

      ### < EXTRAS >
        idle="poll"
        energef="on"
        perfamdgpu="auto" #"performance" for automatic scaling till highest clocks when necessary "high" for highest constant clocks and "auto" for default # more info here https://wiki.archlinux.org/title/AMDGPU
        cpumaxcstate="0"
        cec="off"
        zpool="z3fold"
        zpoolpercent="40"
        pagec="0"
        ksm="0"






      ### < STORAGE >
      # - linux storage devices only used for hdparm. wildcard picks up all
        #hdd="/dev/hd*"
        #ssd="/dev/sd*"
        #nvme="/dev/nvme*"
        #blktool
        #strg=$(fdisk -l | grep "Linux filesystem" | awk '{print $1}')
        #rootfs="/dev/sda2"
        #storage=$(fdisk -l | grep "Disk /dev" | grep -v zram | awk '{print $2}'  | sed 's/://g')
        #scsi="off"
        # in case of using dracut
        #raid="no"
        ls -f /fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /fstab*) ; fi
        ls -f /etc/fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /etc/fstab*) ; fi
        ls -f /vendor/fstab* | grep -q fstab ; if [ $? = 0 ] ; then export fstab=$(ls /vendor/fstab*) ; fi


        # android dirs
    if [ -f $droidprop ] ; then
#droidfstab=$(if [ -f $droidprop ] ; then "$bb"find / -name "fstab*" -type f -not -name "*bak" | grep -v "sbin\|storage\|sdcard" | sort -u ; fi)
droidresolv="/system/etc/resolv.conf"
droidsysctl="/system/etc/sysctl.conf"
droidhosts="/system/etc/hosts"
droidcmdline="/system/etc/root/cmdline"
droidshell="/system\/xbin\/sh" # only shebang
#if $(! grep -q lazytime "$fstab") ; then export droidshell="/system\/bin\/sh" ; fi
#if [ $testing = yes ] ; then export droidshell="/bin\/sh" ; fi
    "$bb"mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
    "$bb"mount -o rw /dev/block/bootdevice/by-name/system /system
    "$bb"mount -o rw /dev/block/bootdevice/by-name/data /data
    "$bb"mount -o remount,rw /system
    "$bb"mount -o remount,rw /vendor
    "$bb"mount -o remount,rw /data
    "$bb"mount -o remount,rw rootfs /
    fi


      ### < MEMORY ALLOCATION >
      # - if memory under 2gb or swap or zram considered low spec if not high spec
      # lowspec options scripted for 2g exactly


export zram='#!/bin/sh
modprobe zram
modprobe lz4
modprobe lz4_compress
echo lz4 > /sys/block/zram0/comp_algorithm
echo "$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo | cut -c1-1)"G  > /sys/block/zram0/disksize
if [ "$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo )" -lt 1000000 ] ; then
echo "0."$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo | cut -c1-1)"G"  > /sys/block/zram0/disksize ; fi
echo 2 > /sys/block/zram0/max_comp_streams
mkswap -L zram0 /dev/zram0
swapon -p 1000 /dev/zram0
if $(! grep "lz4" /etc/modules) ; then
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
echo 1 > /sys/module/zswap/parameters/enabled
echo lz4 > /sys/module/zswap/parameters/compressor
sudo sed -i '\''s/#ALGO.*/ALGO=lz4/g'\'' /etc/default/zramswap
sudo sed -i '\''s/PERCENT.*/PERCENT=40/g'\'' /etc/default/zramswap; fi'





# if NOT tv box OR openwrt then 2 gb and 1 gb zram+zwap, if more than 2 gb none of both. different hugepages and /dev/shm tmpfs, overriding more settings regarding memory. read to know. note big hugepages need hardware support. 'grep Huge /proc/meminfo' adjust to your needs.
# all
overcommit=3
oratio=150
shmmax=100000000
shmmni=1600000
shmall=35000000
echo always > /sys/kernel/mm/transparent_hugepage/enabled
echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
hpages=' transparent_hugepage=madvise'
hugepages="8"
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio

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

if $(! $wrt) ; then

hpages=' transparent_hugepage=never'
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag

# 8gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-1)" -ge 8 ] ; then
devshm=",size=4G"
vmalloc="256"
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
hugepages="512"
hugepagesz="2MB"
#echo 'soft memlock 1024000
#hard memlock 1024000' | tee -a /etc/security/limits.conf
shmmax=4000000000
shmmni=64000000
shmall=100000000
overcommit=3
oratio=200
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=20%/g' /etc/initramfs-tools/initramfs.conf ; fi

# 16 gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-2)" -ge 16 ] ; then
devshm=",size=6G"
vmalloc="512"
hugepages="1024"
hugepagesz="2MB"
#echo 'soft memlock 2048000
#hard memlock 2048000' | tee -a /etc/security/limits.conf
shmmax=6000000000
shmmni=64000000
shmall=100000000
overcommit=3
oratio=250
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=25%/g' /etc/initramfs-tools/initramfs.conf ; fi

# 32 gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-2)" -ge 32 ] ; then
devshm=",size=12G"
vmalloc="1024"
hugepages="2048"
hugepagesz="2MB"
sysctl -w =$hugepages
#echo 'soft memlock 4096000
#hard memlock 4096000' | tee -a /etc/security/limits.conf
shmmax=12000000000
shmmni=64000000
shmall=100000000
overcommit=3
oratio=400
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=30%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 4gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-1)" -le 4 ] ; then
devshm=",size=512m"
vmalloc="128"
hugepages="64"
hugepagesz="2MB"
#echo 'soft memlock 512000
#hard memlock 512000' | tee -a /etc/security/limits.conf
overcommit=2
oratio=180
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=15%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 2gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 2200000 ] ; then
devshm=",size=128m"
vmalloc="128"
hugepages="32"
hugepagesz="2MB"
echo madvise > /sys/kernel/mm/transparent_hugepage/enabled
echo madvise > /sys/kernel/mm/transparent_hugepage/shmem_enabled
echo 1 > /sys/kernel/mm/transparent_hugepage/khugepaged/defrag
hpages=' kvm.nx_huge_pages=on transparent_hugepage=always'
shmmax=1000000000
shmmni=16000000
shmall=350000000
#echo 'soft memlock 262144
#hard memlock 262144' | tee -a /etc/security/limits.conf
zswap=" zswap.enabled=1 zswap.max_pool_percent=$zpoolpercent zswap.zpool=$zpool zswap.compressor=lz4"
if $droidprop ; then export droidzram="/system" ; fi
echo 1 > /sys/module/zswap/parameters/enabled ; $s echo lz4 > /sys/module/zswap/parameters/compressor ; echo "$zram" | $s tee "$droidzram"/etc/zram.sh ; if $(! grep -q "zram" /etc/crontab /etc/anacrontabs) ; then echo "@reboot root sh /etc/zram.sh >/dev/null" | $s tee -a /etc/crontab && echo "@reboot sh /etc/zram.sh >/dev/null" | $s tee /etc/anacrontabs && $s chmod +x /etc/zram.sh && $s sh /etc/zram.sh ; if $droidprop ; then echo "$zram" | $s tee "$droidzram"/etc/zram.sh ; chown root /system/etc/zram.sh ; chmod +x /system/etc/zram.sh &&  "$bb"sh /system/etc/zram.sh ; fi ; fi
overcommit=1
oratio=140
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=10%/g' /etc/initramfs-tools/initramfs.conf ; fi

# less than 1gb
if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 1100000 ] ; then
devshm=",size=64m"
vmalloc="128"
hugepages="16"
hugepagesz="2MB"
shmmax=100000000
shmmni=1600000
shmall=35000000
#echo 'soft memlock 102400
#hard memlock 102400' | tee /etc/security/limits.conf
overcommit=1
oratio=100
sysctl -w vm.nr_overcommit_hugepages=$overcommit
sysctl -w vm.nr_hugepages=$hugepages
sysctl -w kernel.shmmax=$shmmax
sysctl -w kernel.shmmni=$shmmni
sysctl -w kernel.shmall=$shmall
sysctl -w vm.overcommit_ratio=$oratio
sed -i 's/RUNSIZE=.*/RUNSIZE=10%/g' /etc/initramfs-tools/initramfs.conf ; fi

# all mem amounts but not generic devices
# removed
fi

#
ping=$(echo ''"$pingaddr"'')

# bootarg scripting for options # in a weird order due to my own testing # be careful with spacing, i think it lead me to bootloop. edit flags during grub boot to boot if it fails. dunno if this was reason, part is really buggy but as is underneath stable.


# zswap, only if 2gb or under
zsw="$(if echo "$zswap" | grep -q "zswap.enabled=1" ; then echo "$zswap" ; else echo " zswap.enabled=0"; fi)"
# mitigations
x0="$(if [ $mitigations = off ] ; then
echo " mitigations=off cpu_spec_mitigations=off ibpb=off ibrs=off l1tf=off noibpb noibrs pti=off nopti nospec_store_bypass_disable nospectre_v1 nospectre_v2 retbleed=off spec_store_bypass_disable=off spectre_v1=off spectre_v2=off spectre_v2_user=off ssbd=force-off tsx_async_abort=off kpti=0 mds=off nobp=0 mmio_stale_data=off nospectre_bhb kvm-intel.vmentry_l1d_flush=never kvm.nx_huge_pages=off" ; else echo " mitigations=on" ; fi)"
# cpu amd or intel
x1="$( if lscpu | grep -q AMD ; then echo " amd_iommu=pgtbl_v2 amd_pstate=passive kvm-amd.avic=1 amd_iommu_intr=vapic notsx kvm-amd.nested=1" ; elif lscpu | grep -q Intel ; then echo " intel_idle.max_cstate=$cpumaxcstate intel_pstate=per_cpu_perf_limits kvm-intel.nested=1 intel=intel_iommu=on tsx=on kvm-intel.vmentry_l1d_flush=never intel.power_save=0" ; fi)"
# logging
x2=" audit=0 log_priority=0 loglevel=0 mminit_loglevel=0 udev.log_priority=0 rd.udev.log_level=0 udev.log_level=0"
# security
x3=" apparmor=1 lsm=lockdown,capability,landlock,yama,apparmor,tomoyo,bpf"
# timer
x4=" clocksource=tsc tsc=reliable hpet=disable"
# debugging
x5=" kvm.mmu_audit=0 cryptomgr.notests dma_debug=off migration_debug=0 no_debug_objects noirqdebug schedstats=disable apic=quiet rd.systemd.show_status=false systemd.show_status=false"
# unused stuff
x6=" parport=0 floppy=0 agp=0 gpt lp=0"
# cgroups
x7=" cgroup_disable=cpuset,cpu,cpuacct,blkio,memory,devices,freezer,net_cls,pids cgroup_no_v1=all noautogroup"
# power management
x8=" acpi=force pci_aspm=force pcie_bus_perf lapic apm=on"
# numa
x9=" workqueue.disable_numa numa_balancing=disable numa=off"
# cpu microcode
#x10=" dis_ucode_ldr"
# delays
x11=" boot_delay=0 carrier_timeout=1 io_delay=none rootdelay=0"
# cpu stuff
x12=" no_entry_flush no_stf_barrier no_uaccess_flush"
# random extras
x13=" acpi_osi=Linux align_va_addr=on gcov_persist=0 iommu=pt libahci.ignore_sss=1 nfs.enable_ino64=1 nmi_watchdog=0 no_uaccess_flush nohz=on nowatchdog nvme_core.default_ps_max_latency_us=0 rcupdate.rcu_normal=0 rcupdate.rcu_expedited=1 rcutree.kthread_prio=99 rootflags=lazytime scsi_mod.use_blk_mq=1 skew_tick=1 slab_merge slub_merge support_acpi_ppc usb-storage.quirks=p workqueue.watchdog_thresh=0 xmon=off vdso=1"
#
x14=" sysfs.deprecated=0 vt.default_utf8=1 nf_conntrack.acct=0"
#
x15=" nodelayacct preempt=full kunit.enable=0 kmemleak=off"
#
x16=" vsyscall=emulate highres=off clk_ignore_unused"
#
x17=" debugfs=off cpu_init_udelay=1 csdlock_debug=0 nopku hugetlb_free_vmemmap=on memtest=0 noresume"
# manually set irq, disable irqbalancer
x18=" acpi_irq_balance rcutree.use_softirq=0 irqaffinity=1"
#
x19="$( if [ $energef = on ] ; then echo " acpi_sleep=s4_hwsig mem_sleep_default=deep" ; fi)"
# disable radeon and have just amdgpu workaround for performance degradation in some gpus. need to unlock for manual control of voltages, didnt work for me
unlockgpu="$(printf 'amdgpu.ppfeaturemask=0x%x\n' "$(($(cat /sys/module/amdgpu/parameters/ppfeaturemask) | 0x4000))")"
x20="$( if dmesg | grep -q amdgpu ; then echo " radeon.cik_support=0 radeon.si_support=0 amdgpu.cik_support=1 amdgpu.si_support=1 amdgpu.dc=1 amdgpu.modeset=1 amdgpu.dpm=1 amdgpu.audio=1 $unlockgpu" ; fi)"
#
x21="$( if dmesg | grep -q nouvaeu ; then echo " nouveau.modeset=0 nvidia-drm.modeset=1 nvidia-uvm.modeset=1" ; else echo " rdblacklist=nouveau nouveau.blacklist=1 nouveau.modeset=0 nouveau.runpm=0" ; fi)"
#
x22="$( if dmesg | grep -q i915 ; then echo " i915.modeset=1 i915.enable_ppgtt=3 i915.fastboot=0 i915.enable_fbc=1 i915.enable_guc=3 i915.lvds_downclock=1 i915.semaphores=1 i915.reset=0 i915.enable_dc=2 i915.enable_psr=0 i915.enable_cmd_parser=1 i915.enable_rc6=0 i915.lvds_use_ssc=0 i915.use_mmio_flip=1 i915.disable_power_well=1 i915.powersave=1 i915.enable_execlists=0" ; else echo " i915.enable_rc6=0" ; fi)"
#
x23="$( if dmesg | grep -q iwlwifi ; then echo " iwlmvm_power_scheme=2" ; fi)"
#
x24="$( if [ ! $ipv6 = on ] || $wrt ; then echo " autoconf=0 ipv6.disable=1 disable=1" ; else echo " autoconf=1 ipv6.disable=0 disable=0" ; fi)"
#
x25=" processor.max_cstate=$cpumaxcstate biosdevname=0 drm.vblankoffdelay=0 vt.global_cursor_default=0 plymouth.ignore-serial-consoles page_poison=0 page_alloc.shuffle=1 init_on_free=0 init_on_alloc=0 acpi_enforce_resources=lax acpi_backlight=vendor sk nosoftlockup enable_mtrr_cleanup mtrr_spare_reg_nr=1 nopcid msr.allow_writes=on ahci.mobile_lpm_policy=0 disable_power_well=0 fastboot=1 acpi_rev_override=1 enable_fbc=1 rd.fstab=no fstab=yes trusted.rng=default stack_depot_disable=true reboot=j,g,a,k,f,t,e random.trust_cpu=off random.trust_bootloader=off powersave=off tp_printk_stop_on_boot"
#
x26=" realloc pnp.debug=0 printk.always_kmsg_dump=0 selinux=0 S pci=noacpi,nocrs,noaer,nobios,pcie_bus_perf waitdev=0 autoswap rd.udev.exec_delay=0 udev.exec_delay=0 systemd.gpt_auto=1 rd.systemd.gpt_auto=1 systemd.default_timeout_start_sec=0 ftrace_enabled=0 skip_duc=1 skip_ddc=1 ide*=noprobe big_root_window log_buf_len=1M printk.devkmsg=off smt uhci-hcd.ignore_oc=Y usbcore.usbfs_snoop=0 ipcmni_extend checkreqprot swiotlb=force nohalt processor.ignore_tpc=1 processor.bm_check_disable=1"
#
x27=" ip=:::::::$dns1:$dns2:"
#
x28="$( if grep -q xfs /etc/fstab ; then echo " fsck.mode=skip" ; fi)"
#
x29="$(if [ $cec = off ] ; then echo " cec_disable mce=off" ; fi)"
#
xx1=" nr_cpus=-1 rcu_nocb_poll smt=-1 maxcpus=-1 processor.ignore_ppc=1"
#
xx2=$(if $(lscpu | grep -q Pentium) ; then export hugepagesz="4MB" ; else echo " mem=nopentium" ; fi)
#
xx3=$( if [ $cpumaxcstate = 0 ] ; then echo " processor.latency_factor=1" ; fi)
#
xx4=" isolcpus=1-$(nproc --all) nohz_full=1-$(nproc --all) idle=$idle elevator=$sched hugepages=$hugepages cpufreq.default_governor=$governor hugepagesz=$hugepagesz vmalloc=$vmalloc$hpages$zsw"



                                    ### < LINUX KERNEL BOOT PARAMETERS >
                                        # - /proc/cmdline or /root/cmdline - Ctrl+F & Google are your friends here...
                                        # https://raw.githubusercontent.com/torvalds/linux/master/Documentation/admin-guide/kernel-parameters.txt

                                          bootargvars="$(echo "$x0$x1$x2$x3$x4$x5$x6$x7$x8$x9$x10$x11$x12$x13$x14$x15$x16$x17$x18$x19$x20$x21$x22$x23$x24$x25$x26$x27$x28$x29$xx1$xx2$xx3$xx4")"

                                        export par="splash quiet$bootargvars"



# notes for myself
#test diff extra in test isolcpus=1-$(nproc --all)  rcu_nocbs=1-$(nproc --all) nohz_full=1-$(nproc --all) driver_async_probe=* init=/init printk.disable_uart=1 noirqbalance irqaffinity=0 acpi=noirq managed_irq ioapicreroute acpi_irq_nobalance
# nohz_full=1-$(nproc --all) isolcpus=1-$(nproc --all) #intel_idle.max_cstate=9 acpi_irq_balance
# sysfs.deprecated=0 smt=4  preempt=full parport=0 numa_balancing=disable nodelayacct no_timer_check mem_sleep_default=deep kvm.mmu_audit=0 kunit.enable=0 kmemleak=off intel_idle.max_cstate=9 intel_pstate=per_cpu_perf_limits hwp_only gpt highres=on floppy=0 debugfs=off dis_ucode_ldr disable=1 consoleblank=0 cpu0_hotplug cpu_init_udelay=2000 checkreqprot clk_ignore_unused carrier_timeout=1 cec_disable apm=on agp=0 acpi_pm_good
#test diff extra in stable
#acpi=force vga=0
#kvm-intel.vmentry_l1d_flush=never
#rcu_nocbs=1
#noreplace-smp
#testing
# intel_idle.max_cstate=9 cpu0_hotplug rcu_nocbs=1 mem_sleep_default=deep isolcpus=no_kthreads,1
#test="dyndbg=  vm_debug= trace_options=nop  ftrace_filter=nop"


      ### amdgpu
       echo manual > /sys/class/drm/card0/device/power_dpm_force_performance_level
       echo $perfamdgpu > /sys/class/drm/card0/device/power_dpm_force_performance_level

#if lscpu | grep -q x86 ; then wg="--random-wait " ; fi




  ### < ADDITIONAL BLOCKLISTS FOR HOSTS FILE > - not on openwrt
        list1=
        list2=
        list3=
        list4=

  ### < BLOCKLISTS >
    # - /etc/hosts & /etc/update_hosts.sh - not on openwrt
blocklist='#!/bin/sh
### pihole default blocklists & more, /etc/hosts weekly updated
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
ping -c3 '"$ping"'
if [ $? -eq 0 ]; then
rm -rf /etc/hosts /etc/hosts_temp &&
mkdir -p /etc/hosts_temp && cd /etc/hosts_temp
'"$bb"'echo '\''options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 rotate single-request-reopen no-tld-query
127.0.0.1 localhost'\'' | tee /etc/hosts '"$droidhosts"'
echo "127.0.1.1 $(cat /etc/hostname)" | tee -a /etc/hosts '"$droidhosts"'
x1="$('"$bb"'wget $u1 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u1)"
x2="$('"$bb"'wget $u2 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u2)"
x3="$('"$bb"'wget $u3 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u3)"
x4="$('"$bb"'wget $u4 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u4)"
x5="$('"$bb"'wget $u5 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u5)"
x6="$('"$bb"'wget $u6 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u6)"
x7="$('"$bb"'wget $u7 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u7)"
x8="$('"$bb"'wget $u8 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u8)"
x9="$('"$bb"'wget $u9 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u9)"
x10="$('"$bb"'wget $u10  --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u10)"
$x1 || $x2 && $x2 || $x3 && $x3 || $x4 && $x4 || $x5 && $x5 || $x6 && $x6 || $x7 && $x7 || $x8 && $x8 || $x9 && $x9 || $x10 && $x10 || echo fail

              ### yours
              l1='"$list1"'
              l2='"$list2"'
              l3='"$list3"'
              l4='"$list4"'
              c1="$('"$bb"'wget $l1 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u7)"
              c2="$('"$bb"'wget $l2 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u8)"
              c3="$('"$bb"'wget $l3 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u9)"
              c4="$('"$bb"'wget $l4 --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/hosts_temp/u10)"
            if echo $l1 | grep -q http ; then $c1 || $c2 && $c2 || $c3 && $c3 || $c4 && $c4 || echo fail ; fi

cd /etc/hosts_temp && grep "127.0.0.1\|0.0.0.0" * | awk '\''{print "0.0.0.0 " $2}'\'' | tee -a /etc/hosts
cd "$(pwd)" && rm -rf /etc/hosts_temp
else echo "Offline"; fi'





  ### < RC.LOCAL OPENWRT >
    # - /etc/rc.local & /etc/sysctl.conf, /tmp/init.sh for openwrt
wrtsh='#!/bin/sh
### get script update on reboot on /tmp/init.sh and run...
link=https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh
while [ ! -f /tmp/init.sh ];
sleep 10
do ping -c3 '"$ping"'
if [ $? -eq 0 ]; then wget --continue -4 "$link" -O /tmp/init.sh ; fi
if grep -q thanas /tmp/init.sh
then chmod +x /tmp/init.sh && sh /tmp/init.sh && echo "succes"; exit 0; fi
done'





########################################################################
########################################################################

  ### help identifying basic-linux-setup debug output
    echo "*BLS*=SUCCESS, EXECUTING BLS SCRIPT.
    .........................................
    .........................................
    .........................................
    ........................................"












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


    ### first run of script does more
        if [ -f $droidprop ] && [ ! -f /data/adb/service.d/init.sh ] || [ ! -f $doidprop ] && $(! grep thanas /etc/rc.local) ; then 
        export firstrun=yes ; fi



        # droid
if [ -f $droidprop ] ; then
  if [ ! -f /etc/bak$fstab ] && [ -f $fstab ] ; then
  for i in $("$bb"echo "$("$bb"echo "$fstab" | sed 's/fstab*/ /g' | awk '{print $1}')") ; do mkdir -p /etc/bak$i ; done
  for i in "$bb"echo "$fstab" ; do "$bb"cp -n $i /etc/bak$i ; done ; fi
  if [ ! -f /etc/bak$droidhosts ] && [ -f $droidhosts ] ; then "$bb"cp -rf $droidhosts /etc/bak$droidhosts ; fi
  if [ ! -f /etc/bak$droidresolv ] && [ -f $droidresolv ] ; then "$bb"cp -rf $droidresolv /etc/bak$droidresolv ; fi
  if [ ! -f /etc/bak$droidsysctl ] && [ -f $droidsysctl ] ; then "$bb"cp -rf $droidresolv /etc/bak$droidresolv ; fi
  if [ ! -f /etc/bak/$droidcmdline ] ; then mkdir -p /etc/bak/system/etc/root ; cat /proc/cmdline | tee /etc/bak$droidcmdline ; fi
  if [ ! -f /etc/bak$droidprop ] ; then "$bb"cp -rf $droidprop /etc/bak$droidprop ; fi
    # don't know if this is the way to go about it...
  #if [ -f $droidprop ] && [ -f /system/xbin/sh ] && [ ! -f /etc/bak/DO_NOT_DELETE ] ; then /system/xbin/cp -rf /system/xbin/* /system/bin/ ; /system/xbin/echo "DON'T DELETE THESE FILES, SCRIPT USES PARTS OF THIS BACKUP. ONLY EASY WAY OF RESTORING IF BRICKED" | tee /etc/bak/DO_NOT_DELETE ; fi
fi



  # all ( but exceptions, like openwrt not)
  if [ ! -f /etc/bak/etc/environment ] ; then \cp -rf /etc/environment /etc/bak/etc/environment ; fi



  # all but droid
if [ ! -f $droidprop ] ; then
  if [ ! -f /etc/bak/etc/fstab ] ; then \cp -rf /etc/fstab /etc/bak/etc/fstab ; fi
  if [ ! -f /etc/bak/root/cmdline ] ; then mkdir -p /etc/bak/root ; cat /proc/cmdline | tee /etc/bak/root/cmdline ; fi
fi



# debian only
if $debian ; then
  if [ ! -f /etc/bak/etc/NetworkManager/NetworkManager.conf ] ; then mkdir -p /etc/bak/etc/NetworkManager ; \cp -rf /etc/NetworkManager/NetworkManager.conf /etc/bak/etc/NetworkManager/NetworkManager.conf ; fi
  if [ ! -f /etc/bak/etc/default/grub ] ; then mkdir -p /etc/bak/etc/default ; \cp -rf /etc/default/grub /etc/bak/etc/default/grub ; fi
fi



      ### services to disable and start. more at end of this script but are device dependent so no need for doubles here. this only disables services it finds active of the list underneath. for the rest manually use 'rcconf'. underneath works with regex too since being grep. careful, add exclusions if necessary.
    disable_services="avahi-daemon\|plymouth-quit-wait.service\|cgroupfs-mount\|cron\|cups\|pulseaudio-enable-autospawn\|rsync\|exim4\|saned\|smartmontools\|speech-dispatcher\|x11-common\|lynis\|wait-online\|printer\|journal\|log\|rpcbind\|remote-fs\|upower\|pstore"

    #enable_services="firewalld\|apparmor\|run-shm.mount"
    # for accidental protection
    exclude_from_disabling="sudo\|alsa\|anacron\|apparmor\|firewalld\|ufw\|run-shm.mount\|rtkit"




  ### pls put repos in /etc/apt/sources.list.d/extras.list idc im removing urs
  if [ $clean_sources_list_d = yes ] ; then
	find /etc/apt/sources.list.d/* -type f -not -name 'extras.list' -delete ; fi






  ### script binds dirs later on again
    "$bb"umount -f /root/cmdline # just to avoid binding it 20 times
    "$bb"umount -f /system/etc/root/cmdline
    "$bb"umount -f /etc/sysctl.conf







  ### < BLOCKLISTS >
  ### if NOT wrt, update /etc/hosts weekly - script in /etc/update_hosts.sh & cronjob
    # add script /etc/update_hosts.sh
    if $(! $wrt) ; then
    blsync="$(echo "$blocklist" | tee /etc/update_hosts.sh)"
    if systemctl list-unit-files | grep -q anacron ; then
    if $(! grep update_hosts.sh /etc/anacrontabs) ; then echo "@weekly sh /etc/update_hosts.sh >/dev/null" | tee -a /etc/anacrontabs && "$blsync" ; fi
  elif $(! grep update_hosts.sh /etc/crontab /etc/crontab/root) ; then echo "0 0 * * 0 root sh /etc/update_hosts.sh >/dev/null" | tee -a /etc/crontab /etc/crontabs/root && "$blsync" ; fi ; fi








  ### < CRONJOB INIT.SH >
    if systemctl list-unit-files | grep -q anacron ; then
    if $(! grep rc.local /etc/anacrontabs) ; then echo "@reboot sh /etc/rc.local >/dev/null" | tee -a /etc/anacrontabs && "$blsync" ; fi
  elif $(! grep rc.local /etc/crontabs/root /etc/crontab) ; then echo "@reboot root sh /etc/rc.local >/dev/null" | tee -a /etc/crontabs/root /etc/crontab ; fi

    # cronjob kernel - daily seek for update mainline kernel only from experimental branch. since i dont trust debian experimental repositories no more and am in no mood to fight with the packages and dependencies...
    if $debian ; then
    if $(! grep -q "linux-image-amd64" /etc/anacrontabs) ; then
    echo "@daily \sh -c 'apt -f -y install -t experimental linux-image-amd64 && grub-mkconfig'" | tee -a /etc/anacrontabs ; fi ; fi






  ### < SOURCES.LIST >
  ### if ID_LIKE=debian sync sources.list on boot
          if grep -q kali /etc/os-release && [ $sourceslist_update = yes ] ; then
          ping -c3 "$ping"
          if [ $? -eq 0 ]; then
          echo "*BLS*=Syncing sources.list." && "$(wget --connect-timeout=10 --continue -4 --retry-connrefused https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/sources.list -O /etc/apt/sources.list)" ; fi ; fi







  ### < HIJACK CMDLINE >
  ### detect if linux or openwrt/android to hijack cmdline to adjust bootargs from userspace (gets applied with '# cat /proc/cmdline' not sure if it works though)
      #if $(! $debian) ; then echo "*BLS*=FOUND DEBIAN NOT HIJACKING CMDLINE"
      #if $debian ; then echo "$par" | tee /root/cmdline &&
      #mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi
  ### openwrt
      if $wrt ; then echo "$(cat /etc/bak/root/cmdline) $par" | tee /root/cmdline &&
      mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi
  ### android
      if [ -f $droidprop ] ; then mkdir -p /system/etc/root ; "$bb"echo "$(cat /etc/bak/system/root/cmdline) '"$par"'" | tee /system/etc/root/cmdline ; "$bb"mount -n --bind -o ro /system/etc/root/cmdline /proc/cmdline ; else
      mkdir -p /system/etc/root ; echo "$par" | tee /system/etc/root/cmdline &&
      mount -n --bind -o ro /system/etc/root/cmdline /proc/cmdline ; fi
      #if $(! $debian) ; then
      #if $(! grep -q "/proc/cmdline" $fstab) && [ ! $droidfstab ] ; then echo "/etc/root/cmdline /proc/cmdline ro 0 0" | tee -a $fstab ; elif $(! grep -q "/proc/cmdline" $fstab) &&  [ -f $droidfstab ] ; then echo "/system/etc/root/cmdline /proc/cmdline ro 0 0" | tee -a $fstab ; fi
      #fi
      # echo "doesnt work anyways" ; else echo "$par" | tee /root/cmdline &&
      #mount -n --bind -o ro /root/cmdline /proc/cmdline ; fi





#

  ### < GRUB KERNEL PARAMETERS >
  ### kernel parameters grub linux
  resolution="$(xrandr --current | grep current | awk '{print $8$9$10}' | sed 's/\,.*//')"
    $s sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=""' /etc/default/grub
    $s sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX=""' /etc/default/grub
    $s sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="'"$par"'"/g' /etc/default/grub
    $s sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="splash quiet'"$x0"'"/g' /etc/default/grub
    $s sed -i "/GRUB_TIMEOUT/c\GRUB_TIMEOUT=1" /etc/default/grub
    $s sed -i "/#GRUB_DISABLE_OS_PROBER=false/c\GRUB_DISABLE_OS_PROBER=false" /etc/default/grub
    if $(! grep -q "GRUB_GFXPAYLOAD_LINUX" /etc/default/grub) ; then echo "GRUB_GFXPAYLOAD_LINUX=" | tee -a /etc/default/grub ; fi
    $s sed -i 's/GRUB_GFXPAYLOAD_LINUX=.*/GRUB_GFXPAYLOAD_LINUX="'"$resolution"'"/g' /etc/default/grub
    $s sed -i 's/#GRUB_GFXMODE=.*/GRUB_GFXMODE="'"$resolution"'"/g' /etc/default/grub









  ### < FSTAB UPDATE >
  ### fstab update
  if [ $(uname -r | cut -c1-1) -gt 3 ] ; then
    $s sed -i 's/xfs .*/xfs     '"$xfs"' 0 0/g' /etc/fstab #$fstab
    $s sed -i 's/ext4 .*/ext4     '"$ext4"' 0 0/g' /etc/fstab #$fstab
    $s sed -i 's/f2fs .*/f2fs     '"$f2fs"' 0 0/g' /etc/fstab #$fstab
    $s sed -i 's/vfat .*/vfat     '"$vfat"' 0 0/g' /etc/fstab #$fstab
    $s sed -i 's/swap .*/swap     '"$swap"' 0 0/g' /etc/fstab #$fstab
  fi


       # i hope there are no bash fuckups running legacy stuff here. rip
    if [ -f $droidprop ] ; then
      # f2fs droid                                                                                                    # adjust if needed. left the last sed part here intentionally
      dataf2fsdroid=$(grep data "$fstab" | grep ext4 | sed 's/ext4/f2fs/g' | awk '{print $1, $2, $3, "'"$f2fs"',nosuid,nodev", $5 }' | sed 's/,ro/,rw/g')
      cachef2fsdroid=$(grep cache "$fstab" | grep ext4 | sed 's/ext4/f2fs/g' | awk '{print $1, $2, $3, "'"$f2fs"',nosuid,nodev", $5 }' | sed 's/,ro/,rw/g')
        dataf2fsreplace=$(grep data "$fstab" | grep f2fs)
        cachef2fsreplace=$(grep data "$fstab" | grep f2fs)
      # ext4 droid
      dataext4droid=$(grep data "$fstab" | grep ext4 | awk '{print $1, $2, $3, "'"$ext4"',nosuid,nodev,lazytime", $5 }' | sed 's/,ro/,rw/g')
      cacheext4droid=$(grep cache "$fstab" | grep ext4 | awk '{print $1, $2, $3, "'"$ext4"',nosuid,nodev,lazytime", $5 }' | sed 's/,ro/,rw/g')
        dataext4replace=$(grep data "$fstab" | grep ext4)
        cacheext4replace=$(grep data "$fstab" | grep ext4)
              systemext4droid=$(grep system "$fstab" | grep ext4 | awk '{print $1, $2, $3, '"$ext4"', $5 }' | sed 's/,rw/,ro/g')
              systemext4replace=$(grep system "$fstab" | grep ext4)

        if $(! grep -q f2fs "$fstab") ; then
echo $dataf2fsdroid | tee -a "$fstab"
echo $cachef2fsdroid | tee -a "$fstab"
        fi

sed -i 's/'"$dataf2fsreplace"'/'"$dataf2fsdroid"'/g' "$fstab"
sed -i 's/'"$cachef2fsreplace"'/'"$cachef2fsdroid"'/g' "$fstab"
sed -i 's/'"$dataext4replace"'/'"$dataext4droid"'/g' "$fstab"
sed -i 's/'"$cacheext4replace"'/'"$cacheext4droid"'/g' "$fstab"
sed -i 's/'"$systemext4replace"'/'"$systemext4droid"'/g' "$fstab"
    fi




 ### < FSTAB TMPFS > - AVOID IF ZRAM or SWAP IS FOUND
  ### temporarily enable zram for myself
  $s sh /etc/zram.sh

  
  if [ ! $droidprop ] ; then
  ### fstab tmpfs on ram
    tmpfsadd=$(if grep -q "tmpfs" "$fstab" ; then echo "*BLS*=TMPFS found not applying to /etc/fstab."; else echo "*BLS*=TMPFS added to /etc/fstab." &&
    $s echo 'tmpfs    /tmp        tmpfs    '"$tmpfs"'         0 0' | $s tee -a "$fstab"
    $s echo 'tmpfs    /var/tmp    tmpfs    '"$tmpfs"'         0 0' | $s tee -a "$fstab"
    $s echo 'tmpfs    /run/shm    tmpfs    '"$tmpfs"'         0 0' | $s tee -a "$fstab"
    $s echo 'tmpfs    /dev/shm    tmpfs    '"$tmpfs"''"$devshm"' 0 0' | $s tee -a "$fstab"
    $s echo 'tmpfs    /var/lock   tmpfs    '"$tmpfs"'         0 0' | $s tee -a "$fstab"
    $s echo 'tmpfs    /var/run    tmpfs    '"$tmpfs"'         0 0' | $s tee -a "$fstab" ; fi)
    #$s echo 'tmpfs    /var/log    tmpfs    '"$tmpfs"',mode=1755,size=10m  0 0' | $s tee -a /etc/fstab
    #$s echo 'tmpfs    /var/spool  tmpfs    '"$tmpfs"',mode=1750,size=4m   0 0' | $s tee -a /etc/fstab
 ### check if zram to avoid tmpfs on ram
 # if [ $s dmesg | grep -q zram ] || [ grep -q swap /etc/fstab ]; then echo "*BLS*=ZRAM and or SWAP found, whatever adding tmpfs on ram despite. Too fast." && $tmpfsadd ; else $tmpfsadd ; fi ### dont add additional flags for tmpfs, will slow it down

 $tmpfsadd # and then there was tmpfs for all.

  ### update tmpfs values
    $s sed -i 's/\/tmp        tmpfs.*/\/tmp        tmpfs    '"$tmpfs"'         0 0/g' "$fstab"
    $s sed -i 's/\/var\/tmp    tmpfs.*/\/var\/tmp    tmpfs    '"$tmpfs"'         0 0/g' "$fstab"
    $s sed -i 's/\/run\/shm    tmpfs.*/\/run\/shm    tmpfs    '"$tmpfs"'         0 0/g' "$fstab"
    $s sed -i 's/\/dev\/shm    tmpfs.*/\/dev\/shm    tmpfs    '"$tmpfs"''"$devshm"' 0 0/g' "$fstab"
    $s sed -i 's/\/var\/lock   tmpfs.*/\/var\/lock   tmpfs    '"$tmpfs"'         0 0/g' "$fstab"
    $s sed -i 's/\/var\/run   tmpfs.*/\/var\/run   tmpfs    '"$tmpfs"'         0 0/g' "$fstab"
  fi
  
  if [ $(uname -r | cut -c1-1) -gt 3 ] ; then
    sed -i 's/noatime/lazytime/g' "$fstab"
    sed -i 's/nodiratime/lazytime/g' "$fstab"
    sed -i 's/relatime/lazytime/g' "$fstab" 
    sed -i 's/,errors=remount-ro//g' "$fstab" ; else
    sed -i 's/lazytime/noatime/g' "$fstab"
    sed -i 's/relatime/noatime/g' "$fstab" 
    sed -i 's/,lazy_itable_init=0,lazy_journal_init=0//g' "$fstab" 
    sed -i 's/,errors=remount-ro//g' "$fstab" ; fi






  ### < ADDITIONAL LINUX CONFIG >
  # ssh
      if $s grep -q "Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com," ~/.ssh/config ; then
      $s echo "Flag exists"; else $s echo 'Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      Compression yes' | $s tee -a ~/.ssh/config /root/.ssh/config ; fi
      $s sed -i "/#PermitRootLogin prohibit-password/c\PermitRootLogin no" /etc/ssh/sshd_config
      $s sed -i "/X11Forwarding yes/c\X11Forwarding no" /etc/ssh/sshd_config
      $s sed -i "/#AllowTcpForwarding yes/c\AllowTcpForwarding no" /etc/ssh/sshd_config
      $s sed -i "/#PermitTTY yes/c\PermitTTY no" /etc/ssh/sshd_config




  # samba
      if $s grep -q "deadtime = 30" /etc/samba/smb.conf ; then $s echo "Flag exists" ; else $s echo 'deadtime = 30
      use sendfile = yes
      min receivefile size = 16384
      socket options = IPTOS_LOWDELAY TCP_NODELAY IPTOS_THROUGHPUT SO_RCVBUF=131072 SO_SNDBUF=131072' | $s tee /etc/samba/smb.conf ; fi


  # bluetooth
      sed -i 's/AutoEnable.*/AutoEnable=false/' /etc/bluetooth/main.conf
      sed -i 's/#FastConnectable.*/FastConnectable = false/' /etc/bluetooth/main.conf
      sed -i 's/ReconnectAttempts.*/ReconnectAttempts = 1/' /etc/bluetooth/main.conf
      sed -i 's/ReconnectIntervals.*/ReconnectIntervals = 1/' /etc/bluetooth/main.conf
     # if [ ! -f $droidprop ] ; then rm -rfd /var/lib/bluetooth/* ; fi


  # journaling and more
      if $s grep -q "Storage=none" /etc/systemd/journald.conf ; then $s echo "Flag exists" ; else $s echo "Storage=none" | $s tee -a /etc/systemd/journald.conf ; fi
      sed -i s"/\Storage=.*/Storage=none/"g /etc/systemd/coredump.conf
      sed -i s"/\Seal=.*/Seal=no/"g /etc/systemd/coredump.conf




  # ccache & path
    if $s grep -q "USE_CCACHE=1" ~/.zshrc ; then echo "Flag exists"; else
    $s sed -i "\$aexport USE_CCACHE=1" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport USE_PREBUILT_CACHE=1" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport PREBUILT_CACHE_DIR=~/.ccache" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport CCACHE_DIR=~/.ccache" ~/.zshrc ~/.bashrc
    $s sed -i "\$accache -M 30G >/dev/null" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport PATH=/usr/lib/ccache/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport LD_LIBRARY_PATH=$PATH/../lib:$PATH/../lib64:$LD_LIBRARY_PATH" ~/.zshrc ~/.bashrc ; fi
    if $s grep -q "export PATH" ~/.zshrc; then echo "Flag exists"
    else $s sed -i "\$aexport PATH=/usr/lib/ccache/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:$PATH" ~/.zshrc ~/.bashrc
    $s sed -i "\$aexport LD_LIBRARY_PATH=$PATH/../lib:$PATH/../lib64:$LD_LIBRARY_PATH" ~/.zshrc ~/.bashrc ; fi
ccache --set-config=sloppiness=locale,time_macros



  # force apt only to use ipv4
    if [ ! $ipv6 = on ] ; then echo 'Acquire::ForceIPv4 "true";' | $s tee -a /etc/apt/apt.conf.d/99force-ipv4 ; else echo 'Acquire::ForceIPv4 "false";' | $s tee -a /etc/apt/apt.conf.d/99force-ipv4 ; fi
  # dont aquire translations for apt
    if $s grep -q 'Acquire::Languages "none";' /etc/apt/apt.conf.d/00aptitude; then $s echo "Flag exists"
    else $s echo 'Acquire::Languages "none";' | $s tee -a /etc/apt/apt.conf.d/00aptitude ; fi




  # selinux - we have apparmor, but leave this in passively config devices who have selinux instead
    sed -i "/SELINUX=permissive/c\SELINUX=enforcing" /etc/selinux/config
    sed -i "/SELINUXTYPE=/c\SELINUXTYPE=mls" /etc/selinux/config
    #echo 1 > /sys/fs/selinux/enforce
    #setenforce 1




  # firewall
    $s sed -i "/shields-down/c\shields-down=public" /etc/firewall/applet.conf
    $s sed -i "/shields-up/c\shields-up=block" /etc/firewall/applet.conf
    $s sed -i "/DefaultZone/c\DefaultZone=block" /etc/firewalld/firewalld.conf
    $s ufw deny 22/tcp
    $s ufw deny 22/udp
    $s ufw deny 23/tcp
    $s ufw deny 23/udp
    $s ufw deny 53/tcp
    $s ufw deny 53/udp
    $s ufw deny 80/tcp
    $s ufw deny 80/udp
    $s ufw deny 443/tcp
    $s ufw deny 443/udp
    $s ufw default deny incoming
    $s ufw default allow outgoing
    $s ufw deny in on lo
    $s ufw deny out on lo
    sysctl net.ipv4.conf.all.rp_filter
    sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'
if $(! grep -q 'order bind,hosts' /etc/host.conf) ; then
echo 'order bind,hosts
multi on' | tee -a /etc/host.conf ; fi



  # dns
    if $(! grep -q "$dns61" /etc/resolv.conf) ; then
echo 'nameserver '"$dns1"'
nameserver '"$dns2"'
nameserver 127.0.0.1
#nameserver ::1
#nameserver '"$dns61"'
#nameserver '"$dns62"'' | tee /etc/resolv.conf $droidresolv ; fi

if [ $ipv6 = on ] ; then sed -i 's/#nameserver ::1
#nameserver '"$dns61"'
#nameserver '"$dns62"'/nameserver ::1
nameserver '"$dns61"'
nameserver '"$dns62"'/g' /etc/resolv/conf $droidresolv ; fi

    if $(! grep -q edns0 /etc/resolv.conf) ; then
    echo 'options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 rotate single-request-reopen no-tld-query' | tee -a /etc/resolv.conf $droidresolv ; fi



  if $(! grep -q "filterwin2k " /etc/hosts) ; then
echo 'options no-resolv local-use bogus-priv filterwin2k stop-dns-rebind domain-needed no-dhcp-interface=lo ncache-size=8192 local-ttl=300 neg-ttl=120 edns0 rotate timeout:1 attempts:3 rotate single-request-reopen no-tld-query
127.0.0.1 localhost
::1 localhost' | tee -a /etc/hosts $droidhosts ; fi
    if $(! grep -a "127.0.1.1 "$(cat /etc/hostname)"" /etc/hosts $droidhosts) ; then
    echo "127.0.1.1 "$(cat /etc/hostname)"" | tee -a /etc/hosts $droidhosts ; fi


  # clean
    rm -rf /var/crash/*



  # extras
    if $(! $wrt) ; then

  # disable file indexer
    balooctl suspend
    balooctl disable

  # dpkg
    $s dpkg --add-architecture i386

  # gpg workaround
    $s rsync --ignore-existing /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d

  # hdd write caching and power management
    #$s hdparm -W 1 $hdd
    #$s hdparm -W 1 $ssd
    #$s hdparm -W 1 $nvme
    #$s hdparm -B 254 $hdd
    #$s hdparm -B 254 $ssd
    #$s hdparm -B 254 $nvme

  #for i in $storage ; do
  for i in $(ls /dev/hd* ; ls /dev/sd* ; ls /dev/nvm*) ; do
  blktool $i wcache on
  hdparm -W 1 $i
  hdparm -B 254 $i ; done



  # more ALL RANDOM STUFF GOES HERE
    systemctl set-default graphical.target
    sed -i 's/^#ForwardToSyslog=yes/ForwardToSyslog=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToKMsg=yes/ForwardToKMsg=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToConsole=yes/ForwardToConsole=no/' /etc/systemd/journald.conf
    sed -i 's/^#ForwardToWall=yes/ForwardToWall=no/' /etc/systemd/journald.conf
    echo "kernel.core_pattern=/dev/null" | tee /etc/sysctl.d/50-coredump.conf
    if grep -q DefaultTimeoutStopSec /etc/systemd/system.conf ; then
    sed -i 's/DefaultTimeoutStopSec/DefaultTimeoutStopSec=1s/' ; elif
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
    sed -i 's/pam_permit.so/pam_limits.so/g' /etc/pam.d/common-session /etc/pam.d/common-session-noninteractive
    sed -i 's/#LLMNR=yes/LLMNR=no/g' /etc/systemd/resolved.conf
    sed -i 's/# SHA_CRYPT_MIN_ROUNDS 5000/SHA_CRYPT_MIN_ROUNDS 5000/g' /etc/login.defs
    sed -i 's/# SHA_CRYPT_MAX_ROUNDS 5000/SHA_CRYPT_MAX_ROUNDS 50000/g' /etc/login.defs
    sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
    sed -i 's/^#DumpCore=.*/DumpCore=no/' /etc/systemd/system.conf /etc/systemd/user.conf
    sed -i 's/^#CrashShell=.*/CrashShell=no/' /etc/systemd/system.conf /etc/systemd/user.conf
    chmod 0600 /etc/hosts.allow
    chmod 0600 /etc/hosts.deny ; chmod 0750 /home/* ; umask 002 ; fi
    if $(! grep -q rngd /etc/modules) ; then
    sed -i -r '/^fscache?/D' /etc/modules
cat <<EOL>> /etc/modules
jitterentropy-rngd
rngd
urngd
haveged
acpi_cpufreq
cpufreq_performance
msr
kvm
fsache
EOL
fi
        sed -i 's/CONCURRENCY="none"/CONCURRENCY="makefile"/g' /etc/init.d/rc
        # prevent bruteforce
 iptables -A INPUT -p tcp --dport 22 -m recent --update --seconds 60 \
 --hitcount 4 --rttl -j DROP
  iptables -A INPUT -p tcp --dport 23 -m recent --update --seconds 60 \
 --hitcount 4 --rttl -j DROP

        # config dracut as well in case of not using initramfs-tools - note mdadm probably is raid. reconsidering it probably isnt so no harm. dracut buggy. just use google do ur own homework. setup already to big for me
            #if $debian ; then
            #dracflags="hostonly=yes use_fstab=yes add_fstab+=/etc/fstab mdadmconf='$raid' lvmconf=no early_microcode=yes stdloglvl=0 sysloglvl=0 fileloglvl=0 show_modules=yes do_strip=yes nofscks=no kernel_cmdline='mitigations=$mitigations' compress=lz4 hostonly_cmdline=yes"
        #if [ ! "$(cat /etc/dracut.conf.d/*debian.conf)" = "$dracflags" ] ; then
        #echo "$dracflags" | tee /etc/dracut.conf.d/10-debian.conf ; fi

        # omit_dracutmodules+='iscsi brltty' dracutmodules+='systemd dash rootfs-block udev-rules usrmount base fs-lib shutdown rngd fips busybox rescue caps'

    #scsiblack=$(if [ $scsi = off ] ; then
    #echo 'scsi_mod
#scsi_common
#sd_mod' ; fi)
    #cecblack=$(if [ $cec = off ] ; then echo "cec" ; fi)


    sysctl -w vm.min_free_order_shift=4
    sysctl -w kernel.msgmni=32000
    sysctl -w kernel.msgmax=8192
    sysctl -w kernel.msgmnb=16384
    sysctl -w kernel.sem='250 32000 100 128'
    echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
    echo "64" > /sys/kernel/mm/ksm/pages_to_scan
    echo "500" > /sys/kernel/mm/ksm/sleep_millisecs

    if $(! grep -q fscache /etc/initramfs-tools/modules) ; then
    echo cachefiles >> /etc/initramfs-tools/modules
    echo fscache >> /etc/initramfs-tools/modules
    systemctl start --now cachefilesd
    systemctl enable --now cachefilesd ; fi
    sed -i 's/#RUN=.*/RUN=yes/g' /etc/default/cachefilesd
    if $(! grep -q jitterentropy /etc/initramfs-tools/modules) ; then
    echo jitterentropy-rngd >> /etc/initramfs-tools/modules
    echo haveged >> /etc/initramfs-tools/modules
    echo kvm >> /etc/initramfs-tools/modules
    echo msr >> /etc/initramfs-tools/modules
    echo acpi_cpufreq >> /etc/initramfs-tools/modules
    echo cpufreq_performance >> /etc/initramfs-tools/modules
    echo processor >> /etc/initramfs-tools/modules ; fi
    if dmesg | grep -q amdgpu && ! grep -q amdgpu /etc/initramfs-tools/modules ; then
    echo amdgpu >> /etc/initramfs-tools/modules ; elif dmesg | "$( ! grep -q amdgpu )" ; then sed -i 's/amdgpu//g' /etc/initramfs-tools/modules ; fi


    sed -i 's/^#DumpCore=.*/DumpCore=no/' /etc/systemd/system.conf
    sed -i 's/^#CrashShell=.*/CrashShell=no/' /etc/systemd/system.conf
    sed -i 's/^#DumpCore=.*/DumpCore=no/' /etc/systemd/user.conf
    sed -i 's/^#CrashShell=.*/CrashShell=no/' /etc/systemd/user.conf

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
echo 60 > /proc/sys/net/ipv4/tcp_default_init_rwnd
echo 2 > /sys/module/tcp_cubic/parameters/hystart_detect
echo N > /sys/module/mmc_core/parameters/crc
echo N > /sys/module/mmc_core/parameters/removable
echo N > /sys/module/mmc_core/parameters/use_spi_crc
echo N > /sys/module/mmc_core/parameters/removable
echo 64 > /sys/block/zram0/queue/read_ahead_kb
echo N > /sys/kernel/sched/gentle_fair_sleepers
echo Y > /sys/kernel/sched/arch_power
echo ARCH_CAPACITY > /sys/kernel/debug/sched_features
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
echo Y > /proc/sys/kernel/sched_enable_power_aware ; else echo N > /proc/sys/kernel/sched_enable_power_aware ; fi
echo Y > /proc/sys/kernel/power_aware_timer_migration
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
#echo "1" > /sys/module/tpd_setting/parameters/tpd_mode
#echo "63" > /sys/module/hid_magicmouse/parameters/scroll_speed


echo "0-3, 6-$(nproc -all)" > /dev/cpuset/camera-daemon/cpus
echo "0-$(nproc -all)" > /dev/cpuset/top-app/cpus
echo "0-$(nproc -all)" /dev/cpuset/foreground/cpus
echo "0" > /dev/cpuset/restricted/cpus
#echo "0-7" /dev/cpuset/background/cpus
#echo "0-7" /dev/cpuset/system-background/cpus
#echo "0-3" > /dev/cpuset/kernel/cpus

echo "0" > /sys/module/workqueue/parameters/power_efficient
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

echo $qdisc > /proc/sys/net/core/default_qdisc

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
##echo 1000000 > /proc/sys/kernel/sched_min_granularity_ns
##echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
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



echo "0" > /sys/module/workqueue/parameters/power_efficient

echo "0" > /sys/devices/system/cpu/cpu0/core_ctl/enable
##echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo "5000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
##echo "1324800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo "75" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable


echo "0" > /sys/devices/system/cpu/cpu4/core_ctl/enable
##echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo "5000" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
##echo "1574400" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo "75" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable

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

########################
#echo "1" > /proc/sys/vm/overcommit_memory
#echo "0" > /proc/sys/vm/oom_dump_tasks
#echo "0" /proc/sys/vm/overcommit_ratio
echo "1" > /proc/sys/vm/compact_unevictable_allowed
#echo "15" > /proc/sys/vm/dirty_background_ratio
#echo "500" > /proc/sys/vm/dirty_expire_centisecs
#echo "60" > /proc/sys/vm/dirty_ratio
#echo "3000" > /proc/sys/vm/dirty_writeback_centisecs

echo "1" > /proc/sys/vm/oom_kill_allocating_task
#echo "1200" > /proc/sys/vm/stat_interval
#echo "0" > /proc/sys/vm/swap_ratio
#echo "0" > /proc/sys/vm/swappiness
#echo "10" > /proc/sys/vm/vfs_cache_pressure

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
#echo 1000000 > /proc/sys/kernel/sched_min_granularity_ns
#echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
#echo 980000 > /proc/sys/kernel/sched_rt_runtime_us
echo 40000 > /proc/sys/kernel/sched_latency_ns
#echo '0:1324800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '1:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '2:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
#echo '3:748800' > /sys/module/cpu_boost/parameters/input_boost_freq
echo 40 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 1200 > /sys/module/cpu_boost/parameters/powerkey_input_boost_ms
echo "0" > /sys/module/workqueue/parameters/power_efficient

echo "0" > /sys/devices/system/cpu/cpu0/core_ctl/enable
#echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
echo "5000" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
#echo "1324800" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq
echo "75" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
echo "1" > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable

echo "0" > /sys/devices/system/cpu/cpu4/core_ctl/enable
#echo "schedutil" > /sys/devices/system/cpu/cpufreq/policy4/scaling_governor
echo "1000" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
echo "5000" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
#echo "1574400" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq
echo "75" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_load
echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
echo "1" > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable


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

echo "10" > /sys/class/thermal/thermal_message/sconfig

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

echo 0 > /sys/module/binder/parameters/debug_mask
echo Y > /sys/module/bluetooth/parameters/disable_ertm
echo Y > /sys/module/bluetooth/parameters/disable_esco
echo 0 > /sys/module/debug/parameters/enable_event_log
echo 0 > /sys/module/dwc3/parameters/ep_addr_rxdbg_mask
echo 0 > /sys/module/dwc3/parameters/ep_addr_txdbg_mask
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ce
echo 0 > /sys/module/edac_core/parameters/edac_mc_log_ue
echo 0 > /sys/module/glink/parameters/debug_mask
echo N > /sys/module/hid_magicmouse/parameters/emulate_3button
echo N > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
echo 0 > /sys/module/ip6_tunnel/parameters/log_ecn_error
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
echo 0 > /sys/module/mdss_fb/parameters/backlight_dimmer
echo 0 > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo 0 > /sys/module/msm_smd/parameters/debug_mask
echo 0 > /sys/module/msm_smem/parameters/debug_mask
echo N > /sys/module/otg_wakelock/parameters/enabled
echo 0 > /sys/module/service_locator/parameters/enable
echo N > /sys/module/sit/parameters/log_ecn_error
echo 0 > /sys/module/smem_log/parameters/log_enable
echo 0 > /sys/module/smp2p/parameters/debug_mask
echo Y > /sys/module/sync/parameters/fsync_enabled
echo 0 > /sys/module/touch_core_base/parameters/debug_mask
echo 0 > /sys/module/usb_bam/parameters/enable_event_log
echo Y > /sys/module/printk/parameters/console_suspend
echo 0 > /sys/module/wakelock/parameters/debug_mask
echo 0 > /sys/module/userwakelock/parameters/debug_mask
echo 0 > /sys/module/earlysuspend/parameters/debug_mask
echo 0 > /sys/module/alarm/parameters/debug_mask
echo 0 > /sys/module/alarm_dev/parameters/debug_mask
echo 0 > /sys/module/binder/parameters/debug_mask
echo 0 > /sys/devices/system/edac/cpu/log_ce
echo 0 > /sys/devices/system/edac/cpu/log_ue

sysctl -w kernel.panic_on_oops=0
sysctl -w kernel.panic=0

for i in $( find /sys/ -name debug_mask) ; do
 echo 0 > $i
done

if [ -e /sys/module/logger/parameters/log_mode ] ; then
 echo 0 > /sys/module/logger/parameters/log_mode
fi


#settings put global device_idle_constants light_after_inactive_to=5000,light_pre_idle_to=10000,light_max_idle_to=86400000,light_idle_to=43200000,light_idle_maintenance_max_budget=20000,light_idle_maintenance_min_budget=5000,min_time_to_alarm=60000,inactive_to=120000,motion_inactive_to=120000,idle_after_inactive_to=5000,locating_to=2000,sensing_to=120000,idle_to=7200000,wait_for_unlock=true


#adb -d shell pm grant org.kde.kdeconnect_tp android.permission.READ_LOGS;
##adb -d shell appops set org.kde.kdeconnect_tp SYSTEM_ALERT_WINDOW allow;
##adb -d shell am force-stop org.kde.kdeconnect_tp;


# above from old android scripts, need to sort all and put correct values thats why i left them up here for now.

  ### < START PARAMETER CONFIG >
##########################################################################################################
# legacy dump from 3.x kernel for compatibility
# command for you: grep -H '' $(ls /sys/module/*/parameters/*) | sed 's/:/ /g' | awk '{print "echo",  $2, ">", $1}'
echo 0 > /sys/module/alarm/parameters/debug_mask
echo 0 > /sys/module/alarm_dev/parameters/debug_mask
echo 0 > /sys/module/bcmdhd/parameters/clockoverride
echo 0 > /sys/module/bcmdhd/parameters/dhd_console_ms
#echo 1 > /sys/module/bcmdhd/parameters/dhd_doflow
echo 0 > /sys/module/bcmdhd/parameters/dhd_dpcpoll
#echo -1 > /sys/module/bcmdhd/parameters/dhd_oob_gpio_num
echo 0 > /sys/module/bcmdhd/parameters/disable_proptx
#echo Driver > /sys/module/bcmdhd/parameters/info_string
#echo Firmware > /sys/module/bcmdhd/parameters/info_string
#echo Chip > /sys/module/bcmdhd/parameters/info_string
echo 0 > /sys/module/bcmdhd/parameters/op_mode
echo 0 > /sys/module/binder/parameters/debug_mask
echo N > /sys/module/binder/parameters/proc_no_lock
echo 0 > /sys/module/binder/parameters/stop_on_user_error
echo 0 > /sys/module/block/parameters/events_dfl_poll_msecs
#echo N > /sys/module/bluetooth/parameters/disable_ertm
#echo N > /sys/module/bluetooth/parameters/disable_esco
#echo N > /sys/module/bluetooth/parameters/enable_le
#echo N > /sys/module/bluetooth/parameters/enable_mgmt
#echo Y > /sys/module/bnep/parameters/compress_dst
#echo Y > /sys/module/bnep/parameters/compress_src
#echo Y > /sys/module/board_espresso_pmic/parameters/enable_sr
echo 0 > /sys/module/brd/parameters/max_part
echo 0 > /sys/module/brd/parameters/rd_nr
#echo 8192 > /sys/module/brd/parameters/rd_size
echo N > /sys/module/cfg80211/parameters/cfg80211_disable_40mhz_24ghz
echo $country > /sys/module/cfg80211/parameters/ieee80211_regdom
echo N > /sys/module/cpuidle44xx/parameters/disallow_smp_idle
echo N > /sys/module/cpuidle44xx/parameters/keep_core_on
echo N > /sys/module/cpuidle44xx/parameters/keep_mpu_on
echo 0 > /sys/module/cpuidle44xx/parameters/max_state
echo 0 > /sys/module/cpuidle44xx/parameters/only_state
echo N > /sys/module/cpuidle44xx/parameters/skip_off
echo 0 > /sys/module/dns_resolver/parameters/debug
echo 0 > /sys/module/dsscomp/parameters/debug
echo 0 > /sys/module/earlysuspend/parameters/debug_mask
echo 0 > /sys/module/ehci_hcd/parameters/hird
echo Y > /sys/module/ehci_hcd/parameters/ignore_oc
echo 0 > /sys/module/ehci_hcd/parameters/log2_irq_thresh
echo 0 > /sys/module/ehci_hcd/parameters/park
#echo 312 > /sys/module/fuse/parameters/max_user_bgreq
#echo 312 > /sys/module/fuse/parameters/max_user_congthresh
#echo (null) > /sys/module/g_android/parameters/dev_addr
#echo (null) > /sys/module/g_android/parameters/host_addr
#echo 5 > /sys/module/g_android/parameters/qmult
#echo N > /sys/module/hci_uart/parameters/reset
echo 0 > /sys/module/hid/parameters/debug
#echo 1 > /sys/module/hid_apple/parameters/fnmode
#echo 1 > /sys/module/hid_apple/parameters/iso_layout
#echo Y > /sys/module/hid_magicmouse/parameters/emulate_3button
#echo Y > /sys/module/hid_magicmouse/parameters/emulate_scroll_wheel
#echo Y > /sys/module/hid_magicmouse/parameters/report_touches
#echo N > /sys/module/hid_magicmouse/parameters/report_undeciphered
#echo N > /sys/module/hid_magicmouse/parameters/scroll_acceleration
#echo 32 > /sys/module/hid_magicmouse/parameters/scroll_speed
#echo 1 > /sys/module/hid_ntrig/parameters/activate_slack
#echo 32 > /sys/module/hid_ntrig/parameters/activation_height
#echo 64 > /sys/module/hid_ntrig/parameters/activation_width
#echo 4 > /sys/module/hid_ntrig/parameters/deactivate_slack
#echo 0 > /sys/module/hid_ntrig/parameters/min_height
#echo 0 > /sys/module/hid_ntrig/parameters/min_width
echo N > /sys/module/hid_prodikeys/parameters/enable
echo "(null)" > /sys/module/hid_prodikeys/parameters/id
echo 0 > /sys/module/hid_prodikeys/parameters/index
echo $( if [ $ipv6 = on ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/autoconf
echo $( if [ $ipv6 = off ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/disable
echo $( if [ $ipv6 = off ] ; then echo "1" ; else echo "0" ; fi) > /sys/module/ipv6/parameters/disable_ipv6
#echo 4 > /sys/module/kernel/parameters/alignment
echo N > /sys/module/kernel/parameters/initcall_debug
#echo N > /sys/module/kernel/parameters/nousb
echo 0 > /sys/module/kernel/parameters/panic
echo 0 > /sys/module/kernel/parameters/pause_on_oops
echo 0 > /sys/module/loop/parameters/max_loop
echo 0 > /sys/module/loop/parameters/max_part
echo 32 > /sys/module/lowmemorykiller/parameters/cost
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level
#echo 18432,23040,27648,32256,36864,46080 > /sys/module/lowmemorykiller/parameters/minfree
#echo 256 > /sys/module/mailbox/parameters/mbox_kfifo_size
#echo N > /sys/module/mmc_core/parameters/removable
#echo 8 > /sys/module/mmcblk/parameters/perdev_minors
#echo 200 > /sys/module/mousedev/parameters/tap_time
#echo 1024 > /sys/module/mousedev/parameters/xres
#echo 768 > /sys/module/mousedev/parameters/yres
echo N > /sys/module/nf_conntrack/parameters/acct
#echo 1024 > /sys/module/nf_conntrack/parameters/expect_hashsize
#echo 14653 > /sys/module/nf_conntrack/parameters/hashsize
#echo 300 > /sys/module/nf_conntrack_amanda/parameters/master_timeout
#echo kmp > /sys/module/nf_conntrack_amanda/parameters/ts_algo
#echo N > /sys/module/nf_conntrack_ftp/parameters/loose
#echo 21 > /sys/module/nf_conntrack_ftp/parameters/ports
#echo Y > /sys/module/nf_conntrack_h323/parameters/callforward_filter
#echo 300 > /sys/module/nf_conntrack_h323/parameters/default_rrq_ttl
#echo 1 > /sys/module/nf_conntrack_h323/parameters/gkrouted_only
#echo 14653 > /sys/module/nf_conntrack_ipv4/parameters/hashsize
#echo 300 > /sys/module/nf_conntrack_irc/parameters/dcc_timeout
#echo 8 > /sys/module/nf_conntrack_irc/parameters/max_dcc_channels
#echo 6667 > /sys/module/nf_conntrack_irc/parameters/ports
#echo 3 > /sys/module/nf_conntrack_netbios_ns/parameters/timeout
#echo 6566 > /sys/module/nf_conntrack_sane/parameters/ports
#echo 69 > /sys/module/nf_conntrack_tftp/parameters/ports
echo N > /sys/module/omapdss/parameters/debug
echo N > /sys/module/omapfb/parameters/debug
echo N > /sys/module/omapfb/parameters/test
echo 0 > /sys/module/omaprpc/parameters/debug
echo N > /sys/module/otg_wakelock/parameters/enabled
echo N > /sys/module/pl2303/parameters/debug
#echo Y > /sys/module/printk/parameters/time
echo 0 > /sys/module/pvrsrvkm/parameters/gPVRDebugLevel
#echo 0 > /sys/module/rcutree/parameters/rcu_cpu_stall_suppress
#echo -1 > /sys/module/rfcomm/parameters/channel_mtu
#echo N > /sys/module/rfcomm/parameters/disable_cfc
#echo N > /sys/module/rfcomm/parameters/l2cap_ertm
#echo 1013 > /sys/module/rfcomm/parameters/l2cap_mtu
#echo 1 > /sys/module/rfkill/parameters/default_state
#echo 0 > /sys/module/sch_htb/parameters/htb_hysteresis
#echo 0 > /sys/module/scsi_mod/parameters/default_dev_flags
#echo 20 > /sys/module/scsi_mod/parameters/inq_timeout
#echo 512 > /sys/module/scsi_mod/parameters/max_luns
#echo 511 > /sys/module/scsi_mod/parameters/max_report_luns
#echo sync > /sys/module/scsi_mod/parameters/scan
echo 0 > /sys/module/scsi_mod/parameters/scsi_logging_level
#echo 0 > /sys/module/sg/parameters/allow_dio
#echo 32768 > /sys/module/sg/parameters/def_reserved_size
#echo 32768 > /sys/module/sg/parameters/scatter_elem_sz
#echo 1 > /sys/module/snd/parameters/cards_limit
#echo 116 > /sys/module/snd/parameters/major
#echo "(null)" > /sys/module/snd/parameters/slots
#echo 4 > /sys/module/snd_pcm/parameters/maximum_substreams
#echo 1 > /sys/module/snd_pcm/parameters/preallocate_dma
#echo 1 > /sys/module/snd_timer/parameters/timer_limit
#echo 1 > /sys/module/snd_timer/parameters/timer_tstamp_monotonic
#echo Y > /sys/module/snd_usb_audio/parameters/async_unlink
#echo 0 > /sys/module/snd_usb_audio/parameters/device_setup
#echo Y > /sys/module/snd_usb_audio/parameters/enable
#echo "(null)" > /sys/module/snd_usb_audio/parameters/id
echo Y > /sys/module/snd_usb_audio/parameters/ignore_ctl_error
#echo -1 > /sys/module/snd_usb_audio/parameters/index
#echo 8 > /sys/module/snd_usb_audio/parameters/nrpacks
#echo -1 > /sys/module/snd_usb_audio/parameters/pid
#echo -1 > /sys/module/snd_usb_audio/parameters/vid
echo 0 > /sys/module/spurious/parameters/irqfixup
echo Y > /sys/module/spurious/parameters/noirqdebug
#echo 717 > /sys/module/tcp_cubic/parameters/beta
#echo 41 > /sys/module/tcp_cubic/parameters/bic_scale
#echo 1 > /sys/module/tcp_cubic/parameters/fast_convergence
#echo 1 > /sys/module/tcp_cubic/parameters/hystart
#echo 2 > /sys/module/tcp_cubic/parameters/hystart_ack_delta
#echo 3 > /sys/module/tcp_cubic/parameters/hystart_detect
#echo 16 > /sys/module/tcp_cubic/parameters/hystart_low_window
#echo 0 > /sys/module/tcp_cubic/parameters/initial_ssthresh
#echo 1 > /sys/module/tcp_cubic/parameters/tcp_friendliness
echo 0 > /sys/module/tiler/parameters/alloc_debug
#echo 41943040 > /sys/module/tiler/parameters/cache
#echo 128 > /sys/module/tiler/parameters/grain
#echo Y > /sys/module/tiler/parameters/offset_lookup
#echo Y > /sys/module/tiler/parameters/security
#echo Y > /sys/module/tiler/parameters/ssptr_id
#echo Y > /sys/module/tiler/parameters/ssptr_lookup
#echo 1 > /sys/module/usb_storage/parameters/delay_use
#echo 1 > /sys/module/usb_storage/parameters/option_zero_cd
#echo 1 > /sys/module/usb_storage/parameters/swi_tru_install
#echo 2 > /sys/module/usbcore/parameters/autosuspend
echo N > /sys/module/usbcore/parameters/blinkenlights
#echo 5000 > /sys/module/usbcore/parameters/initial_descriptor_timeout
echo N > /sys/module/usbcore/parameters/old_scheme_first
echo N > /sys/module/usbcore/parameters/usbfs_snoop
#echo Y > /sys/module/usbcore/parameters/use_both_schemes
echo 0 > /sys/module/usbhid/parameters/ignoreled
echo 0 > /sys/module/usbhid/parameters/mousepoll
#echo "(null)" > /sys/module/usbhid/parameters/quirks
#echo -1 > /sys/module/usblp/parameters/proto_bias
echo N > /sys/module/usbserial/parameters/debug
echo 0 > /sys/module/userwakelock/parameters/debug_mask
echo 0 > /sys/module/wakelock/parameters/debug_mask
#echo N > /sys/module/xpad/parameters/dpad_to_buttons
#echo N > /sys/module/xpad/parameters/sticks_to_null
#echo N > /sys/module/xpad/parameters/triggers_to_buttons
#echo 438 > /sys/module/xt_qtaguid/parameters/ctrl_perms
#echo Y > /sys/module/xt_qtaguid/parameters/ctrl_write_limited
echo 0 > /sys/module/xt_qtaguid/parameters/debug_mask
#echo 292 > /sys/module/xt_qtaguid/parameters/iface_perms
#echo 1024 > /sys/module/xt_qtaguid/parameters/max_sock_tags
#echo N > /sys/module/xt_qtaguid/parameters/passive
#echo 292 > /sys/module/xt_qtaguid/parameters/stats_perms
#echo Y > /sys/module/xt_qtaguid/parameters/stats_readall_limited
#echo N > /sys/module/xt_qtaguid/parameters/tag_tracking_passive
#echo 112 > /sys/module/xt_quota2/parameters/event_num
#echo 0 > /sys/module/xt_quota2/parameters/gid
#echo 420 > /sys/module/xt_quota2/parameters/perms
#echo 0 > /sys/module/xt_quota2/parameters/uid


### kernel 6.x underneath
# systunedump --all | sed 's/:/ /g' | awk '{print "echo "$2" > "$1}' > text
# just dumped this still needs editing
echo 120 > /sys/fs/f2fs/*/cp_interval
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
echo 3 > /proc/sys/fs/xfs/error_level
echo 3000 > /proc/sys/fs/xfs/filestream_centisecs
echo 1 > /proc/sys/fs/xfs/inherit_noatime
echo 1 > /proc/sys/fs/xfs/inherit_nodefrag
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
echo 10000 > /proc/sys/fs/xfs/xfssyncd_centisecs
echo 4 > /proc/sys/kernel/acct
echo 0 > /proc/sys/kernel/acpi_video_flags
echo 0 > /proc/sys/kernel/apparmor_display_secid_mode
echo 0 > /proc/sys/kernel/auto_msgmni
echo 0 > /proc/sys/kernel/bpf_stats_enabled
echo 1 > /proc/sys/kernel/cad_pid
echo |/bin/false > /proc/sys/kernel/core_pattern
echo 0 > /proc/sys/kernel/core_pipe_limit
echo 1 > /proc/sys/kernel/core_uses_pid
echo 0 > /proc/sys/kernel/ctrl-alt-del
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
echo 65536 > /proc/sys/kernel/numa_balancing_promote_rate_limit_MBps
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
echo 1 > /proc/sys/kernel/randomize_va_space
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
echo kill_process > /proc/sys/kernel/seccomp/actions_logged
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
echo 15285 > /proc/sys/kernel/threads-max
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
if $(! $wrt) ; then
echo 1 > /proc/sys/net/core/bpf_jit_enable
echo 0 > /proc/sys/net/core/bpf_jit_harden
echo 0 > /proc/sys/net/core/bpf_jit_kallsyms
echo 264241152 > /proc/sys/net/core/bpf_jit_limit
echo 50 > /proc/sys/net/core/busy_poll
echo 50 > /proc/sys/net/core/busy_read
echo $qdisc > /proc/sys/net/core/default_qdisc
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
echo 0 > /proc/sys/net/ipv4/conf/default/accept_local
echo 0 > /proc/sys/net/ipv4/conf/default/accept_redirects
echo 1 > /proc/sys/net/ipv4/conf/default/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/default/arp_accept
echo 0 > /proc/sys/net/ipv4/conf/default/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/default/arp_evict_nocarrier
echo 0 > /proc/sys/net/ipv4/conf/default/arp_filter
echo 1 > /proc/sys/net/ipv4/conf/default/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/default/arp_notify
echo 0 > /proc/sys/net/ipv4/conf/default/bc_forwarding
echo 0 > /proc/sys/net/ipv4/conf/default/bootp_relay
echo 0 > /proc/sys/net/ipv4/conf/default/disable_policy
echo 0 > /proc/sys/net/ipv4/conf/default/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/default/drop_gratuitous_arp
echo 0 > /proc/sys/net/ipv4/conf/default/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv4/conf/default/force_igmp_version
echo 1 > /proc/sys/net/ipv4/conf/default/forwarding
echo 10000 > /proc/sys/net/ipv4/conf/default/igmpv2_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv4/conf/default/igmpv3_unsolicited_report_interval
echo 0 > /proc/sys/net/ipv4/conf/default/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv4/conf/default/log_martians
echo 0 > /proc/sys/net/ipv4/conf/default/medium_id
echo 0 > /proc/sys/net/ipv4/conf/default/promote_secondaries
echo 0 > /proc/sys/net/ipv4/conf/default/proxy_arp
echo 0 > /proc/sys/net/ipv4/conf/default/proxy_arp_pvlan
echo 0 > /proc/sys/net/ipv4/conf/default/route_localnet
echo 2 > /proc/sys/net/ipv4/conf/default/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/default/secure_redirects
echo 0 > /proc/sys/net/ipv4/conf/default/send_redirects
echo 1 > /proc/sys/net/ipv4/conf/default/shared_media
echo 0 > /proc/sys/net/ipv4/conf/default/src_valid_mark
echo 0 > /proc/sys/net/ipv4/conf/default/tag
echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_local
echo 0 > /proc/sys/net/ipv4/conf/eth0/accept_redirects
echo 1 > /proc/sys/net/ipv4/conf/eth0/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/eth0/arp_accept
echo 0 > /proc/sys/net/ipv4/conf/eth0/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/eth0/arp_evict_nocarrier
echo 0 > /proc/sys/net/ipv4/conf/eth0/arp_filter
echo 1 > /proc/sys/net/ipv4/conf/eth0/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/eth0/arp_notify
echo 0 > /proc/sys/net/ipv4/conf/eth0/bc_forwarding
echo 0 > /proc/sys/net/ipv4/conf/eth0/bootp_relay
echo 0 > /proc/sys/net/ipv4/conf/eth0/disable_policy
echo 0 > /proc/sys/net/ipv4/conf/eth0/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/eth0/drop_gratuitous_arp
echo 0 > /proc/sys/net/ipv4/conf/eth0/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv4/conf/eth0/force_igmp_version
echo 1 > /proc/sys/net/ipv4/conf/eth0/forwarding
echo 10000 > /proc/sys/net/ipv4/conf/eth0/igmpv2_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv4/conf/eth0/igmpv3_unsolicited_report_interval
echo 0 > /proc/sys/net/ipv4/conf/eth0/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv4/conf/eth0/log_martians
echo 0 > /proc/sys/net/ipv4/conf/eth0/medium_id
echo 0 > /proc/sys/net/ipv4/conf/eth0/promote_secondaries
echo 0 > /proc/sys/net/ipv4/conf/eth0/proxy_arp
echo 0 > /proc/sys/net/ipv4/conf/eth0/proxy_arp_pvlan
echo 0 > /proc/sys/net/ipv4/conf/eth0/route_localnet
echo 2 > /proc/sys/net/ipv4/conf/eth0/rp_filter
echo 0 > /proc/sys/net/ipv4/conf/eth0/secure_redirects
echo 0 > /proc/sys/net/ipv4/conf/eth0/send_redirects
echo 1 > /proc/sys/net/ipv4/conf/eth0/shared_media
echo 0 > /proc/sys/net/ipv4/conf/eth0/src_valid_mark
echo 0 > /proc/sys/net/ipv4/conf/eth0/tag
echo 0 > /proc/sys/net/ipv4/conf/lo/accept_local
echo 1 > /proc/sys/net/ipv4/conf/lo/accept_redirects
echo 1 > /proc/sys/net/ipv4/conf/lo/accept_source_route
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_accept
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
echo 1 > /proc/sys/net/ipv4/conf/lo/arp_evict_nocarrier
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_filter
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
echo 0 > /proc/sys/net/ipv4/conf/lo/arp_notify
echo 0 > /proc/sys/net/ipv4/conf/lo/bc_forwarding
echo 0 > /proc/sys/net/ipv4/conf/lo/bootp_relay
echo 1 > /proc/sys/net/ipv4/conf/lo/disable_policy
echo 1 > /proc/sys/net/ipv4/conf/lo/disable_xfrm
echo 0 > /proc/sys/net/ipv4/conf/lo/drop_gratuitous_arp
echo 0 > /proc/sys/net/ipv4/conf/lo/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv4/conf/lo/force_igmp_version
echo 1 > /proc/sys/net/ipv4/conf/lo/forwarding
echo 10000 > /proc/sys/net/ipv4/conf/lo/igmpv2_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv4/conf/lo/igmpv3_unsolicited_report_interval
echo 0 > /proc/sys/net/ipv4/conf/lo/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv4/conf/lo/log_martians
echo 0 > /proc/sys/net/ipv4/conf/lo/medium_id
echo 0 > /proc/sys/net/ipv4/conf/lo/promote_secondaries
echo 0 > /proc/sys/net/ipv4/conf/lo/proxy_arp
echo 0 > /proc/sys/net/ipv4/conf/lo/proxy_arp_pvlan
echo 0 > /proc/sys/net/ipv4/conf/lo/route_localnet
echo 0 > /proc/sys/net/ipv4/conf/lo/rp_filter
echo 1 > /proc/sys/net/ipv4/conf/lo/secure_redirects
echo 1 > /proc/sys/net/ipv4/conf/lo/send_redirects
echo 1 > /proc/sys/net/ipv4/conf/lo/shared_media
echo 0 > /proc/sys/net/ipv4/conf/lo/src_valid_mark
echo 0 > /proc/sys/net/ipv4/conf/lo/tag
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
echo $tcp_con > /proc/sys/net/ipv4/tcp_allowed_congestion_control
echo 31 > /proc/sys/net/ipv4/tcp_app_win
echo 0 > /proc/sys/net/ipv4/tcp_autocorking
echo 1024 > /proc/sys/net/ipv4/tcp_base_mss
echo 2147483647 > /proc/sys/net/ipv4/tcp_challenge_ack_limit
echo 0 > /proc/sys/net/ipv4/tcp_child_ehash_entries
echo 1000000 > /proc/sys/net/ipv4/tcp_comp_sack_delay_ns
echo 44 > /proc/sys/net/ipv4/tcp_comp_sack_nr
echo 100000 > /proc/sys/net/ipv4/tcp_comp_sack_slack_ns
echo $tcp_con > /proc/sys/net/ipv4/tcp_congestion_control
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
echo 0 > /proc/sys/net/ipv4/tcp_timestamps
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
echo 0 > /proc/sys/net/ipv6/conf/all/use_tempaddr
echo 1 > /proc/sys/net/ipv6/conf/default/accept_dad
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_defrtr
echo 0 > /proc/sys/net/ipv6/conf/default/accept_ra_from_local
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_min_hop_limit
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_mtu
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_pinfo
echo 0 > /proc/sys/net/ipv6/conf/default/accept_ra_rt_info_max_plen
echo 0 > /proc/sys/net/ipv6/conf/default/accept_ra_rt_info_min_plen
echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_rtr_pref
echo 0 > /proc/sys/net/ipv6/conf/default/accept_redirects
echo 0 > /proc/sys/net/ipv6/conf/default/accept_source_route
echo 0 > /proc/sys/net/ipv6/conf/default/accept_untracked_na
echo 0 > /proc/sys/net/ipv6/conf/default/addr_gen_mode
echo 1 > /proc/sys/net/ipv6/conf/default/autoconf
echo 1 > /proc/sys/net/ipv6/conf/default/dad_transmits
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
echo 0 > /proc/sys/net/ipv6/conf/default/disable_policy
echo 0 > /proc/sys/net/ipv6/conf/default/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv6/conf/default/drop_unsolicited_na
echo 1 > /proc/sys/net/ipv6/conf/default/enhanced_dad
echo 0 > /proc/sys/net/ipv6/conf/default/force_mld_version
echo 0 > /proc/sys/net/ipv6/conf/default/force_tllao
echo 0 > /proc/sys/net/ipv6/conf/default/forwarding
echo 64 > /proc/sys/net/ipv6/conf/default/hop_limit
echo 0 > /proc/sys/net/ipv6/conf/default/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv6/conf/default/ioam6_enabled
echo 65535 > /proc/sys/net/ipv6/conf/default/ioam6_id
echo 4294967295 > /proc/sys/net/ipv6/conf/default/ioam6_id_wide
echo 0 > /proc/sys/net/ipv6/conf/default/keep_addr_on_down
echo 16 > /proc/sys/net/ipv6/conf/default/max_addresses
echo 600 > /proc/sys/net/ipv6/conf/default/max_desync_factor
echo 10000 > /proc/sys/net/ipv6/conf/default/mldv1_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv6/conf/default/mldv2_unsolicited_report_interval
echo 1280 > /proc/sys/net/ipv6/conf/default/mtu
echo 1 > /proc/sys/net/ipv6/conf/default/ndisc_evict_nocarrier
echo 0 > /proc/sys/net/ipv6/conf/default/ndisc_notify
echo 0 > /proc/sys/net/ipv6/conf/default/ndisc_tclass
echo 0 > /proc/sys/net/ipv6/conf/default/optimistic_dad
echo 0 > /proc/sys/net/ipv6/conf/default/proxy_ndp
echo 1024 > /proc/sys/net/ipv6/conf/default/ra_defrtr_metric
echo 3 > /proc/sys/net/ipv6/conf/default/regen_max_retry
echo 60 > /proc/sys/net/ipv6/conf/default/router_probe_interval
echo 1 > /proc/sys/net/ipv6/conf/default/router_solicitation_delay
echo 4 > /proc/sys/net/ipv6/conf/default/router_solicitation_interval
echo 3600 > /proc/sys/net/ipv6/conf/default/router_solicitation_max_interval
echo -1 > /proc/sys/net/ipv6/conf/default/router_solicitations
echo 0 > /proc/sys/net/ipv6/conf/default/rpl_seg_enabled
echo 0 > /proc/sys/net/ipv6/conf/default/seg6_enabled
echo 0 > /proc/sys/net/ipv6/conf/default/seg6_require_hmac
echo 1 > /proc/sys/net/ipv6/conf/default/suppress_frag_ndisc
echo 86400 > /proc/sys/net/ipv6/conf/default/temp_prefered_lft
echo 604800 > /proc/sys/net/ipv6/conf/default/temp_valid_lft
echo 0 > /proc/sys/net/ipv6/conf/default/use_oif_addrs_only
echo 0 > /proc/sys/net/ipv6/conf/default/use_optimistic
echo 0 > /proc/sys/net/ipv6/conf/default/use_tempaddr
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_dad
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_ra_defrtr
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra_from_local
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_ra_min_hop_limit
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_ra_mtu
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_ra_pinfo
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra_rt_info_max_plen
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_ra_rt_info_min_plen
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_ra_rtr_pref
echo 1 > /proc/sys/net/ipv6/conf/eth0/accept_redirects
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_source_route
echo 0 > /proc/sys/net/ipv6/conf/eth0/accept_untracked_na
echo 1 > /proc/sys/net/ipv6/conf/eth0/addr_gen_mode
echo 1 > /proc/sys/net/ipv6/conf/eth0/autoconf
echo 1 > /proc/sys/net/ipv6/conf/eth0/dad_transmits
echo 1 > /proc/sys/net/ipv6/conf/eth0/disable_ipv6
echo 0 > /proc/sys/net/ipv6/conf/eth0/disable_policy
echo 0 > /proc/sys/net/ipv6/conf/eth0/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv6/conf/eth0/drop_unsolicited_na
echo 1 > /proc/sys/net/ipv6/conf/eth0/enhanced_dad
echo 0 > /proc/sys/net/ipv6/conf/eth0/force_mld_version
echo 0 > /proc/sys/net/ipv6/conf/eth0/force_tllao
echo 0 > /proc/sys/net/ipv6/conf/eth0/forwarding
echo 64 > /proc/sys/net/ipv6/conf/eth0/hop_limit
echo 0 > /proc/sys/net/ipv6/conf/eth0/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv6/conf/eth0/ioam6_enabled
echo 65535 > /proc/sys/net/ipv6/conf/eth0/ioam6_id
echo 4294967295 > /proc/sys/net/ipv6/conf/eth0/ioam6_id_wide
echo 0 > /proc/sys/net/ipv6/conf/eth0/keep_addr_on_down
echo 16 > /proc/sys/net/ipv6/conf/eth0/max_addresses
echo 600 > /proc/sys/net/ipv6/conf/eth0/max_desync_factor
echo 10000 > /proc/sys/net/ipv6/conf/eth0/mldv1_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv6/conf/eth0/mldv2_unsolicited_report_interval
echo 1500 > /proc/sys/net/ipv6/conf/eth0/mtu
echo 1 > /proc/sys/net/ipv6/conf/eth0/ndisc_evict_nocarrier
echo 0 > /proc/sys/net/ipv6/conf/eth0/ndisc_notify
echo 0 > /proc/sys/net/ipv6/conf/eth0/ndisc_tclass
echo 0 > /proc/sys/net/ipv6/conf/eth0/optimistic_dad
echo 0 > /proc/sys/net/ipv6/conf/eth0/proxy_ndp
echo 1024 > /proc/sys/net/ipv6/conf/eth0/ra_defrtr_metric
echo 3 > /proc/sys/net/ipv6/conf/eth0/regen_max_retry
echo 60 > /proc/sys/net/ipv6/conf/eth0/router_probe_interval
echo 1 > /proc/sys/net/ipv6/conf/eth0/router_solicitation_delay
echo 4 > /proc/sys/net/ipv6/conf/eth0/router_solicitation_interval
echo 3600 > /proc/sys/net/ipv6/conf/eth0/router_solicitation_max_interval
echo -1 > /proc/sys/net/ipv6/conf/eth0/router_solicitations
echo 0 > /proc/sys/net/ipv6/conf/eth0/rpl_seg_enabled
echo 0 > /proc/sys/net/ipv6/conf/eth0/seg6_enabled
echo 0 > /proc/sys/net/ipv6/conf/eth0/seg6_require_hmac
echo 1 > /proc/sys/net/ipv6/conf/eth0/suppress_frag_ndisc
echo 86400 > /proc/sys/net/ipv6/conf/eth0/temp_prefered_lft
echo 604800 > /proc/sys/net/ipv6/conf/eth0/temp_valid_lft
echo 0 > /proc/sys/net/ipv6/conf/eth0/use_oif_addrs_only
echo 0 > /proc/sys/net/ipv6/conf/eth0/use_optimistic
echo 0 > /proc/sys/net/ipv6/conf/eth0/use_tempaddr
echo -1 > /proc/sys/net/ipv6/conf/lo/accept_dad
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra_defrtr
echo 0 > /proc/sys/net/ipv6/conf/lo/accept_ra_from_local
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra_min_hop_limit
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra_mtu
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra_pinfo
echo 0 > /proc/sys/net/ipv6/conf/lo/accept_ra_rt_info_max_plen
echo 0 > /proc/sys/net/ipv6/conf/lo/accept_ra_rt_info_min_plen
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_ra_rtr_pref
echo 1 > /proc/sys/net/ipv6/conf/lo/accept_redirects
echo 0 > /proc/sys/net/ipv6/conf/lo/accept_source_route
echo 0 > /proc/sys/net/ipv6/conf/lo/accept_untracked_na
echo 0 > /proc/sys/net/ipv6/conf/lo/addr_gen_mode
echo 1 > /proc/sys/net/ipv6/conf/lo/autoconf
echo 1 > /proc/sys/net/ipv6/conf/lo/dad_transmits
echo 1 > /proc/sys/net/ipv6/conf/lo/disable_ipv6
echo 0 > /proc/sys/net/ipv6/conf/lo/disable_policy
echo 0 > /proc/sys/net/ipv6/conf/lo/drop_unicast_in_l2_multicast
echo 0 > /proc/sys/net/ipv6/conf/lo/drop_unsolicited_na
echo 1 > /proc/sys/net/ipv6/conf/lo/enhanced_dad
echo 0 > /proc/sys/net/ipv6/conf/lo/force_mld_version
echo 0 > /proc/sys/net/ipv6/conf/lo/force_tllao
echo 0 > /proc/sys/net/ipv6/conf/lo/forwarding
echo 64 > /proc/sys/net/ipv6/conf/lo/hop_limit
echo 0 > /proc/sys/net/ipv6/conf/lo/ignore_routes_with_linkdown
echo 0 > /proc/sys/net/ipv6/conf/lo/ioam6_enabled
echo 65535 > /proc/sys/net/ipv6/conf/lo/ioam6_id
echo 4294967295 > /proc/sys/net/ipv6/conf/lo/ioam6_id_wide
echo 0 > /proc/sys/net/ipv6/conf/lo/keep_addr_on_down
echo 16 > /proc/sys/net/ipv6/conf/lo/max_addresses
echo 600 > /proc/sys/net/ipv6/conf/lo/max_desync_factor
echo 10000 > /proc/sys/net/ipv6/conf/lo/mldv1_unsolicited_report_interval
echo 1000 > /proc/sys/net/ipv6/conf/lo/mldv2_unsolicited_report_interval
echo 65536 > /proc/sys/net/ipv6/conf/lo/mtu
echo 1 > /proc/sys/net/ipv6/conf/lo/ndisc_evict_nocarrier
echo 0 > /proc/sys/net/ipv6/conf/lo/ndisc_notify
echo 0 > /proc/sys/net/ipv6/conf/lo/ndisc_tclass
echo 0 > /proc/sys/net/ipv6/conf/lo/optimistic_dad
echo 0 > /proc/sys/net/ipv6/conf/lo/proxy_ndp
echo 1024 > /proc/sys/net/ipv6/conf/lo/ra_defrtr_metric
echo 3 > /proc/sys/net/ipv6/conf/lo/regen_max_retry
echo 60 > /proc/sys/net/ipv6/conf/lo/router_probe_interval
echo 1 > /proc/sys/net/ipv6/conf/lo/router_solicitation_delay
echo 4 > /proc/sys/net/ipv6/conf/lo/router_solicitation_interval
echo 3600 > /proc/sys/net/ipv6/conf/lo/router_solicitation_max_interval
echo -1 > /proc/sys/net/ipv6/conf/lo/router_solicitations
echo 0 > /proc/sys/net/ipv6/conf/lo/rpl_seg_enabled
echo 0 > /proc/sys/net/ipv6/conf/lo/seg6_enabled
echo 0 > /proc/sys/net/ipv6/conf/lo/seg6_require_hmac
echo 1 > /proc/sys/net/ipv6/conf/lo/suppress_frag_ndisc
echo 86400 > /proc/sys/net/ipv6/conf/lo/temp_prefered_lft
echo 604800 > /proc/sys/net/ipv6/conf/lo/temp_valid_lft
echo 0 > /proc/sys/net/ipv6/conf/lo/use_oif_addrs_only
echo 0 > /proc/sys/net/ipv6/conf/lo/use_optimistic
echo -1 > /proc/sys/net/ipv6/conf/lo/use_tempaddr
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
echo 0 > /proc/sys/net/netfilter/nf_conntrack_acct

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
echo NONE > /proc/sys/net/netfilter/nf_log/9
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
echo 8192 > /proc/sys/vm/admin_reserve_kbytes
echo 1 > /proc/sys/vm/compact_unevictable_allowed
echo 0 > /proc/sys/vm/compaction_proactiveness
#echo 0 > /proc/sys/vm/dirty_background_bytes
echo 90 > /proc/sys/vm/dirty_background_ratio
#echo 0 > /proc/sys/vm/dirty_bytes
echo 500 > /proc/sys/vm/dirty_expire_centisecs
echo 90 > /proc/sys/vm/dirty_ratio
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
echo $overcommit > /proc/sys/vm/nr_overcommit_hugepages
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
echo 10 > /proc/sys/vm/swappiness
echo 0 > /proc/sys/vm/unprivileged_userfaultfd
echo 60896 > /proc/sys/vm/user_reserve_kbytes
echo 50 > /proc/sys/vm/vfs_cache_pressure
echo 15000 > /proc/sys/vm/watermark_boost_factor
echo 200 > /proc/sys/vm/watermark_scale_factor
echo 0 > /proc/sys/vm/zone_reclaim_mode

#
echo 1 > /sys/devices/system/cpu/cpufreq/boost
#
echo "N" > /sys/module/rt2800soc/parameters/nohwcrypt
echo "N" > /sys/module/watchdog/parameters/handle_boot_enabled
echo "1" > /sys/module/watchdog/parameters/stop_on_reboot
echo "Y" > /sys/module/mac80211/parameters/minstrel_vht_only
echo '1' > /proc/sys/crypto/fips_enabled


echo $cpumaxcstate > /sys/module/processor/parameters/max_cstate
echo 1 > /sys/module/processor/parameters/ignore_ppc
echo 1 > /sys/module/processor/parameters/bm_check_disable
if [ $cpumaxcstate = 0 ] ; then
echo 1 > /sys/module/processor/parameters/latency_factor
fi
echo 1 > /sys/module/processor/parameters/ignore_tpc
echo 0 > /sys/module/processor/parameters/nocst

echo $ksm > /sys/kernel/mm/ksm/run
echo 1 > /sys/kernel/mm/ksm/merge_across_nodes



echo "1" > /sys/module/subsystem_restart/parameters/disable_restart_work

echo "(null)" > /sys/kernel/cgroup/features


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
echo 1 > /sys/module/amdgpu/parameters/cik_support
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
echo 0 > /sys/module/amdgpu/parameters/msi
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
echo HWS > /sys/module/amdgpu/parameters/sched_policy
#echo -1 > /sys/module/amdgpu/parameters/sdma_phase_quantum
#echo -1 > /sys/module/amdgpu/parameters/send_sigterm
echo 1 > /sys/module/amdgpu/parameters/si_support
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

echo 0 > /sys/module/radeon/parameters/agpmode
#echo -1 > /sys/module/radeon/parameters/aspm
echo 0 > /sys/module/radeon/parameters/audio
#echo -1 > /sys/module/radeon/parameters/auxch
#echo -1 > /sys/module/radeon/parameters/backlight
#echo -1 > /sys/module/radeon/parameters/bapm
echo 0 > /sys/module/radeon/parameters/benchmark
#echo -1 > /sys/module/radeon/parameters/cik_support
#echo -1 > /sys/module/radeon/parameters/connector_table
#echo -1 > /sys/module/radeon/parameters/deep_color
#echo -1 > /sys/module/radeon/parameters/disp_priority
#echo -1 > /sys/module/radeon/parameters/dpm
#echo -1 > /sys/module/radeon/parameters/dynclks
echo 1 > /sys/module/radeon/parameters/fastfb
#echo -1 > /sys/module/radeon/parameters/gartsize
#echo -1 > /sys/module/radeon/parameters/hard_reset
#echo -1 > /sys/module/radeon/parameters/hw_i2c
#echo -1 > /sys/module/radeon/parameters/lockup_timeout
#echo -1 > /sys/module/radeon/parameters/modeset
echo 0 > /sys/module/radeon/parameters/msi
#echo -1 > /sys/module/radeon/parameters/no_wb
#echo -1 > /sys/module/radeon/parameters/pcie_gen2
#echo -1 > /sys/module/radeon/parameters/r4xx_atom
#echo -1 > /sys/module/radeon/parameters/runpm
#echo -1 > /sys/module/radeon/parameters/si_support
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
echo $zpool > /sys/module/zswap/parameters/zpool
fi

if [ $ipv6 = off ] && ! $wrt ; then
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
echo N > /sys/module/printk/parameters/ignore_loglevel
echo Y >  /sys/module/random/parameters/ratelimit_disable
echo 1 > /sys/module/rcupdate/parameters/rcu_expedited
echo 0 > /sys/module/rcupdate/parameters/rcu_normal
echo 99 > /sys/module/rcutree/parameters/kthread_prio
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
echo $overcommit > /sys/kernel/mm/hugepages/hugepages*/nr_overcommit_hugepages
echo 0x0000 > /sys/kernel/mm/lru_gen/enabled
echo false > /sys/kernel/mm/numa/demotion_enabled

echo 1 > /sys/kernel/reboot/cpu
echo 1 > /sys/kernel/reboot/force
echo warm > /sys/kernel/reboot/mode
echo triple > /sys/kernel/reboot/type

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
echo "(null)" > /sys/module/pstore/parameters/backend

# general and omit debugging android, x86 and more
/etc/init.d/syslogd stop
sysctl dev.em.0.debug=0
echo Y > /sys/module/8250/parameters/skip_txen_test
echo 0 > /proc/sys/kernel/tracepoint_printk
echo 0 > /sys/kernel/profiling
echo 0 > /sys/kernel/tracing/tracing_on
echo "0 0 0 0" > /proc/sys/kernel/printk
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









### io scheduler, governor and more
#scheduler
if [ ! -f  $droidprop ] ; then
# nvme
for i in $(find /sys/block -type l); do
  echo "$sched" > $i/queue/scheduler;
  echo "0" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "512" > $i/queue/nr_requests
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
  echo "0" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "1024" > $i/queue/nr_requests
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
  echo "0" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "1024" > $i/queue/nr_requests
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
  echo "0" > $i/queue/add_random;
  echo "0" > $i/queue/iostats;
  echo "0" > $i/queue/io_poll
  echo "2" > $i/queue/nomerges
  echo "1024" > $i/queue/nr_requests
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

echo 1 > /sys/module/processor/parameters/ignore_ppc

if $(! grep -q "options processor ignore_ppc=1" /etc/modprobe.d/ignore_ppc.conf) ; then
echo 'options processor ignore_ppc=1' | tee /etc/modprobe.d/ignore_ppc.conf ; fi

#x86_energy_perf_policy --hwp-enable --force
x86_energy_perf_policy --all 1 --force

if $(! grep -q acpi-cpufreq /etc/modules) ; then
echo acpi-cpufreq >> /etc/modules ; fi

if $(! grep -q "options acpi-cpufreq force=1" /etc/modprobe.d/acpi-cpufreq.modprobe) ; then
echo options acpi-cpufreq force=1 >> /etc/modprobe.d/acpi-cpufreq.modprobe ; fi

cpupower frequency-set -g $governor

echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
echo 1 > /sys/devices/system/cpu/cpufreq/boost
x86_energy_perf_policy --turbo-enable 1 --force

echo $governor > /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# governor
for i in $(find /sys/devices/system/cpu/cpufreq); do
  echo "$governor" > $i/scaling_governor;
done;

echo "$governor" > /sys/module/cpufreq/parameters/default_governor
echo "GOVERNOR="$governor"" | tee /etc/default/cpufrequtils


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
echo 500000 > /sys/kernel/debug/sched/migration_cost_ns
echo 500000 > /sys/kernel/debug/sched/min_granularity_ns
echo 500000 > /sys/kernel/debug/sched/wakeup_granularity_ns
echo 8 > /sys/kernel/debug/sched/nr_migrate

# different path under 5.10
sysctl -w kernel.sched_scaling_enable=1
sysctl /proc/sys/kernel/sched_scaling_enable=1
sysctl /proc/sys/kernel/sched_tunable_scaling=0
sysctl /proc/sys/kernel/sched_child_runs_first=1
sysctl /proc/sys/kernel/sched_min_granularity_ns=500000
sysctl /proc/sys/kernel/sched_wakeup_granularity_ns=500000
sysctl /proc/sys/kernel/sched_latency_ns=40000
sysctl -w kernel.sched_scaling_enable=1
sysctl /proc/sys/kernel/debug/sched/scaling_enable=1
sysctl /proc/sys/kernel/debug/sched/tunable_scaling=0
sysctl /proc/sys/kernel/debug/sched/child_runs_first=1
sysctl /proc/sys/kernel/debug/sched/min_granularity_ns=500000
sysctl /proc/sys/kernel/debug/sched/wakeup_granularity_ns=500000
sysctl /proc/sys/kernel/debug/sched/latency_ns=40000
echo '0' > /sys/kernel/debug/tunable_scaling
echo '500000' > /sys/kernel/debug/sched/min_granularity_ns
echo '500000' > /sys/kernel/debug/sched/wakeup_granularity_ns
echo '40000' > /sys/kernel/debug/sched/latency_ns
echo 0 > /proc/sys/kernel/debug/sched/min_task_util_for_colocation
echo 32 > /proc/sys/kernel/debug/sched/nr_migrate
echo 0 > /proc/sys/kernel/sched_min_task_util_for_colocation
echo 32 > /proc/sys/kernel/sched_nr_migrate
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



# some paths changed since 5.10 so double
# there are more than listed here though:
# https://github.com/torvalds/linux/blob/master/kernel/sched/features.h
for i in $(echo /sys/kernel/debug/sched/ ; echo /sys/kernel/debug/sched_ ) ; do
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
echo 500000 > "$i"migration_cost_ns
echo 500000 > "$i"min_granularity_ns
echo 32 > "$i"nr_migrate
echo full > "$i"preempt
echo 0 > "$i"tunable_scaling
echo N > "$i"verbose
echo 500000 > "$i"wakeup_granularity_ns
#echo ? > "$i"cpu*
#echo ? > "$i"hot_threshold_ms
#echo ? > "$i"scan_delay_ms
#echo ? > "$i"scan_period_max_ms
#echo ? > "$i"scan_period_min_ms
#echo ? > "$i"scan_size_mb
done

if [ -f $droidprop ] && ! grep -q tv $droidprop ; then
for i in $(echo /sys/kernel/debug/sched/ ; echo /sys/kernel/debug/sched_ ) ; do
echo ENERGY_AWARE >> "$i"features ; done ; fi

echo 3 > /sys/bus/workqueue/devices/writeback/cpumask
echo 3 > /sys/devices/virtual/workqueue/cpumask

echo 2 > /proc/irq/49/smp_affinity
echo 2 > /proc/irq/50/smp_affinity
### fs & vm etc
echo 1 > /proc/sys/vm/page_lock_unfairness
echo 0 > /proc/sys/vm/zone_reclaim_mode
echo $overcommit > /proc/sys/vm/overcommit_memory
echo $oratio > /proc/sys/vm/overcommit_ratio
echo "1" /proc/sys/fs/leases-enable
echo "0" > /proc/sys/fs/dir-notify-enable
echo "20" > /proc/sys/fs/lease-break-time
echo "1" > /proc/sys/vm/compact_unevictable_allowed
echo "90" > /proc/sys/vm/dirty_background_ratio
echo "500" > /proc/sys/vm/dirty_expire_centisecs
echo "90" > /proc/sys/vm/dirty_ratio
echo "1000" > /proc/sys/vm/dirty_writeback_centisecs
echo "1" > /proc/sys/vm/oom_dump_tasks
echo "1" > /proc/sys/vm/oom_kill_allocating_task
echo "60" > /proc/sys/vm/stat_interval
echo "50" > /proc/sys/vm/vfs_cache_pressure
echo "10" > /proc/sys/vm/swappiness
echo 0 > /proc/sys/vm/compaction_proactiveness
sysctl -e -w kernel.panic_on_oops=0
sysctl -e -w kernel.panic=0
sysctl net.core.somaxconn=1000
sysctl fs.file-max=2097152
sysctl fs.xfs.xfssyncd_centisecs=10000


# lmk
echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "1" > /sys/module/lowmemorykiller/parameters/lmk_fast_run
echo "1" > /sys/module/lowmemorykiller/parameters/oom_reaper
chmod 666 /sys/module/lowmemorykiller/parameters/minfree
chown root /sys/module/lowmemorykiller/parameters/minfree
echo '2181,2908,3636,4363,5090,6181' > /sys/module/lowmemorykiller/parameters/minfree



### network
echo 0 > /proc/sys/net/ipv4/tcp_tso_rtt_log
echo 0 > /proc/sys/net/ipv4/icmp_echo_enable_probe
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo 0 > /proc/sys/net/ipv4/icmp_errors_use_inbound_ifaddr
echo 1 > /proc/sys/net/ipv4/icmp_ignore_bogus_error_responses
echo 0 > /proc/sys/net/ipv4/icmp_msgs_burst
echo 0 > /proc/sys/net/ipv4/icmp_msgs_per_sec
echo 0 > /proc/sys/net/ipv4/icmp_ratelimit
echo 0 > /proc/sys/net/ipv4/icmp_ratemask

sysctl -w net.ipv4.tcp_moderate_rcvbuf=1
echo 1 > /proc/sys/net/core/enable_tcp_offloading
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
echo "0" >/proc/sys/net/ipv4/tcp_timestamps
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
echo "$tcp_con" > /proc/sys/net/ipv4/tcp_congestion_control
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
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_low_latency
echo "0" > /proc/sys/net/ipv4/net.ipv4.ip_no_pmtu_disc
echo "1" > /proc/sys/net/ipv4/net.ipv4.tcp_mtu_probing
echo "2" > /proc/sys/net/ipv4/net.ipv4.tcp_frto
echo "2" > /proc/sys/net/ipv4/net.ipv4.tcp_frto_response
echo "1" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo 1 > /sys/module/printk/parameters/console_no_auto_verbose
for i in $(find /sys/class/net -type l); do
  echo "128" > $i/tx_queue_len;
done;
echo 262144 > /proc/sys/net/core/rmem_max
echo 262144 > /proc/sys/net/core/wmem_max
echo "4096 16384 262144" > /proc/sys/net/ipv4/tcp_wmem
echo "4096 87380 262144" > /proc/sys/net/ipv4/tcp_rmem
echo 1000 > /proc/sys/net/core/netdev_max_backlog
echo 16384 > /proc/sys/net/ipv4/netfilter/ip_conntrack_max
echo 16384 > /sys/module/nf_conntrack/parameters/hashsize
wl -i eth* && ifconfig eth* txqueuelen 2
sysctl net.ipv4.tcp_fastopen=3
sysctl net.ipv4.tcp_slow_start_after_idle=0
sysctl fs.file-max=2097152
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
sysctl net.ipv4.ip_local_port_range=30000 65535

sysctl -w net.core.rmem_max=16777216

sysctl kernel.ftrace_enabled=0


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
for i in $(echo wlan0 ; echo wlan1 ; echo phy0-ap0 ; echo phy0-ap1) ; do
iw dev $i set beacon_int $beacons
iw dev $i set txpwr $txpower
iw dev $i set power_save $pwrsave ; done

for i in $(echo phy0 ; echo phy1) ; do
iw phy $i set beacon_int $beacons
iw phy $i set txpwr $txpower
iw phy $i set power_save $pwrsave
iw phy $i set distance $distance
iw phy $i set rts $rts
iw phy $i set frag $frag ; done ; fi


# skip disk defragment & fstrim on every boot
#$s xfs_fsr $rootfs
#$s fstrim /
touch /etc/rc.local
touch /etc/sysctl.conf















### SYSCTL.CONF IN SAME FILE
### values for sysctl.conf ( /etc/sysctl.conf is a replica of /etc/rc.local and bound to it as well just for convenience)

echo '# sysctl

#
# more

net.ipv4.conf.default.rp_filter=2
net.ipv4.conf.all.rp_filter=2
kernel.shmall = '"$shmall"'
kernel.shmmax = '"$shmmax"'
kernel.shmmni = '"$shmmni"'
vm.nr_hugepages = '"$hugepages"'
vm.nr_hugepages_mempolicy = '"$hugepages"'
if $(! '"$wrt"') ; then
abi.vsyscall32 = 0
fi
crypto.fips_enabled = 1
debug.exception-trace = 0
debug.kprobes-optimization = 1
dev.cdrom.debug = 0
dev.hpet.max-user-freq = 64
dev.i915.perf_stream_paranoid = 0
dev.scsi.logging_level = 0
dev.tty.ldisc_autoload = 1
energy_perf_bias = performance
if [ '"$cpumaxcstate"' = 0 ] ; then
force_latency = 1
fi
fs.aio-max-nr = 1048576
fs.aio-nr = 0
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
fs.xfs.filestream_centisecs = 3000
fs.xfs.inherit_noatime = 1
fs.xfs.inherit_nodefrag = 1
fs.xfs.inherit_nodump = 1
fs.xfs.inherit_nosymlinks = 0
fs.xfs.inherit_sync = 1
fs.xfs.irix_sgid_inherit = 0
fs.xfs.irix_symlink_mode = 0
fs.xfs.panic_mask = 0
fs.xfs.rotorstep = 1
fs.xfs.speculative_cow_prealloc_lifetime = 300
fs.xfs.speculative_prealloc_lifetime = 300
fs.xfs.stats_clear = 0
fs.xfs.xfssyncd_centisecs = 50000
governor = '"$governor"'
kernel.acct = 4 2       30
kernel.acpi_video_flags = 0
kernel.apparmor_display_secid_mode = 0
kernel.auto_msgmni = 0
kernel.bpf_stats_enabled = 0
kernel.cad_pid = 1
kernel.cap_last_cap = 40
kernel.core_pattern = |/bin/false
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
kernel.randomize_va_space = 1
kernel.real-root-dev = 0
kernel.sched_autogroup_enabled = 0
kernel.sched_cfs_bandwidth_slice_us = 500
kernel.sched_child_runs_first = 1
kernel.sched_compat_yield = 0
kernel.sched_deadline_period_max_us = 500000
kernel.sched_deadline_period_min_us = 100
kernel.sched_energy_aware = 0
kernel.sched_latency_ns = 40000
kernel.sched_migration_cost_ns = 250000
kernel.sched_min_granularity_ns = 40000
kernel.sched_min_task_util_for_colocation = 0
kernel.sched_nr_migrate = 32
kernel.sched_rr_timeslice_ms = -1
kernel.sched_rt_period_us = -1
kernel.sched_rt_runtime_us = -1
kernel.sched_scaling_enable = 1
kernel.sched_schedstats = 0
kernel.sched_tunable_scaling = 0
kernel.sched_wakeup_granularity_ns = 40000
kernel.seccomp.actions_avail = NONE
kernel.seccomp.actions_logged = NONE
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
kernel.threads-max = 15285
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
kernel.watchdog_cpumask = 0-3
kernel.watchdog_thresh = 60
kernel.yama.ptrace_scope = 0
min_perf_pct = 100
net.core.bpf_jit_enable = 1
net.core.bpf_jit_harden = 0
net.core.bpf_jit_kallsyms = 0
net.core.bpf_jit_limit = 264241152
net.core.busy_poll = 50
net.core.busy_read = 50
net.core.default_qdisc = '"$qdisc"'
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
net.ipv4.tcp_congestion_control = '"$tcp_con"'
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_early_demux = 1
net.ipv4.tcp_early_retrans = 2
net.ipv4.tcp_ecn = 1
net.ipv4.tcp_ecn_fallback = 1
net.ipv4.tcp_ehash_entries = 16384
net.ipv4.tcp_fack = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_fastopen_blackhole_timeout_sec = 0
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_frto = 1
net.ipv4.tcp_frto_response = 2
net.ipv4.tcp_fwmark_accept = 0
net.ipv4.tcp_invalid_ratelimit = 500
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_l3mdev_accept = 0
net.ipv4.tcp_limit_output_bytes = 1048576
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_max_orphans = 16384
net.ipv4.tcp_max_reordering = 300
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_mem = 22740        30320   45480
net.ipv4.tcp_migrate_req = 0
net.ipv4.tcp_min_rtt_wlen = 300
net.ipv4.tcp_min_snd_mss = 48
net.ipv4.tcp_min_tso_segs = 2
net.ipv4.tcp_moderate_rcvbuf = 1
net.ipv4.tcp_mtu_probe_floor = 48
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_no_metrics_save = 1 \r
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
net.ipv4.tcp_rfc1337 = 1
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_sack = 0
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_stdurg = 0
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_thin_dupack = 1
net.ipv4.tcp_thin_linear_timeouts = 0
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tso_rtt_log = 0
net.ipv4.tcp_tso_win_divisor = 3
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_workaround_signed_windows = 0
net.ipv4.udp_early_demux = 1
net.ipv4.udp_l3mdev_accept = 0
net.ipv4.udp_mem = 45480        60640   90960
net.ipv4.udp_rmem_min = 4096
net.ipv4.udp_wmem_min = 8192
net.ipv4.xfrm4_gc_thresh = 32768
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.default.forwarding = 0
net.ipv6.icmp.echo_ignore_all = 1
net.mptcp.add_addr_timeout = 120
net.mptcp.allow_join_initial_addr_port = 1
net.mptcp.checksum_enabled = 0
net.mptcp.enabled = 1
net.mptcp.pm_type = 0
net.mptcp.stale_loss_cnt = 4
net.netfilter.nf_conntrack_acct = 0
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
net.netfilter.nf_log_all_netns = 0
net.nf_conntrack_max = 65536
net.unix.max_dgram_qlen = 512
sk_rcvbuf = 125336
sysctl -w kernel.core_pattern='\''|/bin/false'\''
sysctl.net.core.busy_poll = 50
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
#vm.dirty_background_bytes = 4194304
vm.dirty_background_ratio = 90
#vm.dirty_bytes = 4194304
vm.dirty_expire_centisecs = 500
vm.dirty_ratio = 90
vm.dirty_writeback_centisecs = 100
#vm.dirtytime_expire_seconds = 43200
vm.extfrag_threshold = 750
vm.hugetlb_optimize_vmemmap = 1
vm.hugetlb_shm_group = 1
vm.laptop_mode = 0
vm.legacy_va_layout = 0
vm.lowmem_reserve_ratio = 8   4     2      0       0
vm.max_map_count = 1600000
vm.memory_failure_early_kill = 1
vm.memory_failure_recovery = 1
vm.min_free_kbytes = 5571
vm.min_slab_ratio = 30
vm.min_unmapped_ratio = 1
vm.mmap_min_addr = 65536
vm.mmap_rnd_bits = 28
vm.mmap_rnd_compat_bits = 8
vm.nr_overcommit_hugepages = '"$overcommit"'
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
vm.swappiness = 10
vm.unprivileged_userfaultfd = 0
vm.user_reserve_kbytes = 60896
vm.vfs_cache_pressure = 50
vm.watermark_boost_factor = 15000
vm.watermark_scale_factor = 200
vm.zone_reclaim_mode = 0
#include = latency-performance
stack_erasing = 0' | tee /etc/sysctl.conf /etc/sysctl.d/sysctl.conf $droidsysctl

if $(! $wrt) ; then
echo 'net.ipv4.cipso_cache_bucket_size = 0
net.ipv4.cipso_cache_enable = 0
net.ipv4.cipso_rbm_optfmt = 0
net.ipv4.cipso_rbm_strictvalid = 0
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
net.ipv4.conf.all.force_igmp_version = 0
net.ipv4.conf.all.forwarding = 1
net.ipv4.conf.all.igmpv2_unsolicited_report_interval = 10000
net.ipv4.conf.all.igmpv3_unsolicited_report_interval = 1000
net.ipv4.conf.all.ignore_routes_with_linkdown = 0
net.ipv4.conf.all.log_martians = 0
net.ipv4.conf.all.mc_forwarding = 0
net.ipv4.conf.all.medium_id = 0
net.ipv4.conf.all.promote_secondaries = 0
net.ipv4.conf.all.proxy_arp = 0
net.ipv4.conf.all.proxy_arp_pvlan = 0
net.ipv4.conf.all.route_localnet = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.shared_media = 1
net.ipv4.conf.all.src_valid_mark = 0
net.ipv4.conf.all.tag = 0
net.ipv4.conf.default.accept_local = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.default.accept_source_route = 1
net.ipv4.conf.default.arp_accept = 0
net.ipv4.conf.default.arp_announce = 0
net.ipv4.conf.default.arp_evict_nocarrier = 1
net.ipv4.conf.default.arp_filter = 0
net.ipv4.conf.default.arp_ignore = 1
net.ipv4.conf.default.arp_notify = 0
net.ipv4.conf.default.bc_forwarding = 0
net.ipv4.conf.default.bootp_relay = 0
net.ipv4.conf.default.disable_policy = 0
net.ipv4.conf.default.disable_xfrm = 0
net.ipv4.conf.default.drop_gratuitous_arp = 0
net.ipv4.conf.default.drop_unicast_in_l2_multicast = 0
net.ipv4.conf.default.force_igmp_version = 0
net.ipv4.conf.default.forwarding = 1
net.ipv4.conf.default.igmpv2_unsolicited_report_interval = 10000
net.ipv4.conf.default.igmpv3_unsolicited_report_interval = 1000
net.ipv4.conf.default.ignore_routes_with_linkdown = 0
net.ipv4.conf.default.log_martians = 0
net.ipv4.conf.default.mc_forwarding = 0
net.ipv4.conf.default.medium_id = 0
net.ipv4.conf.default.promote_secondaries = 0
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.conf.default.proxy_arp_pvlan = 0
net.ipv4.conf.default.route_localnet = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.default.shared_media = 1
net.ipv4.conf.default.src_valid_mark = 0
net.ipv4.conf.default.tag = 0
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
net.ipv4.igmp_qrv = 2
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
net.ipv4.ip_local_reserved_ports =
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
net.ipv4.neigh.eth0.anycast_delay = 100
net.ipv4.neigh.eth0.app_solicit = 0
net.ipv4.neigh.eth0.base_reachable_time_ms = 30000
net.ipv4.neigh.eth0.delay_first_probe_time = 5
net.ipv4.neigh.eth0.gc_stale_time = 60
net.ipv4.neigh.eth0.interval_probe_time_ms = 5000
net.ipv4.neigh.eth0.locktime = 100
net.ipv4.neigh.eth0.mcast_resolicit = 0
net.ipv4.neigh.eth0.mcast_solicit = 3
net.ipv4.neigh.eth0.proxy_delay = 80
net.ipv4.neigh.eth0.proxy_qlen = 64
net.ipv4.neigh.eth0.retrans_time_ms = 1000
net.ipv4.neigh.eth0.ucast_solicit = 3
net.ipv4.neigh.eth0.unres_qlen = 101
net.ipv4.neigh.eth0.unres_qlen_bytes = 212992
net.ipv4.neigh.lo.anycast_delay = 100
net.ipv4.neigh.lo.app_solicit = 0
net.ipv4.neigh.lo.base_reachable_time_ms = 30000
net.ipv4.neigh.lo.delay_first_probe_time = 5
net.ipv4.neigh.lo.gc_stale_time = 60
net.ipv4.neigh.lo.interval_probe_time_ms = 5000
net.ipv4.neigh.lo.locktime = 100
net.ipv4.neigh.lo.mcast_resolicit = 0
net.ipv4.neigh.lo.mcast_solicit = 3
net.ipv4.neigh.lo.proxy_delay = 80
net.ipv4.neigh.lo.proxy_qlen = 64
net.ipv4.neigh.lo.retrans_time_ms = 1000
net.ipv4.neigh.lo.ucast_solicit = 3
net.ipv4.neigh.lo.unres_qlen = 101
net.ipv4.neigh.lo.unres_qlen_bytes = 212992
net.ipv4.nexthop_compat_mode = 1
net.ipv4.ping_group_range = 100 100
net.ipv4.raw_l3mdev_accept = 1
net.ipv4.route.error_burst = 1250
net.ipv4.route.error_cost = 250
net.ipv4.route.gc_elasticity = 8
net.ipv4.route.gc_interval = 60
net.ipv4.route.gc_min_interval = 0
net.ipv4.route.gc_min_interval_ms = 500
net.ipv4.route.gc_thresh = -1
net.ipv4.route.gc_timeout = 300
net.ipv4.route.max_size = 2147483647
net.ipv4.route.min_adv_mss = 256
net.ipv4.route.min_pmtu = 552
net.ipv4.route.mtu_expires = 600
net.ipv4.route.redirect_load = 5
net.ipv4.route.redirect_number = 9
net.ipv4.route.redirect_silence = 5120
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0' | tee -a /etc/sysctl.conf /etc/sysctl.d/sysctl.conf $droidsysctl ; fi


if dmesg | grep -q raid ; then
sysctl -w dev.raid.speed_limit_min=1000000
sysctl -w dev.raid.speed_limit_max=1000000
echo 8 > /sys/block/md0/md/group_thread_cnt; fi



if $(! $wrt) ; then
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.all.forwarding=0
sysctl -w net.ipv6.conf.all.forwarding=0
sysctl -w net.ipv4.conf.all.mc_forwarding=0
sysctl -w net.ipv6.conf.all.mc_forwarding=0
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0 ; fi



#################################################################################################

# debian stuff
if $debian ; then



if [ ! -f /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/brave-flags.conf ] ; then
echo "--type=renderer --event-path-policy=0 --change-stack-guard-on-fork=enable --num-raster-threads="$(nproc --all)" --enable-zero-copy --disable-partial-raster --enable-features=CanvasOopRasterization,CastStreamingAv1,CastStreamingVp9,EnableDrDc,ForceGpuMainThreadToNormalPriorityDrDc,ParallelDownloading,RawDraw,Vp9kSVCHWDecoding,WindowsScrollingPersonality,enable-pixel-canvas-recording.enable-accelerated-video-encode --ignore-gpu-blacklist --enable-webgl --force-device-scale-factor=1.00 --enable-gpu-rasterization --enable-native-gpu-memory-buffers --enable-zero-copy --enable-accelerated-mjpeg-decode --enable-accelerated-video --use-gl=egl --disable-gpu-driver-bug-workarounds --enable-features=UseOzonePlatform --ozone-platform=wayland --smooth-scrolling --enable-quic --enable-raw-draw --canvas-oop-rasterization --force-gpu-main-thread-to-normal-priority-drdc --enable-drdc --enable-vp9-kSVC-decode-acceleration --windows-scrolling-personality --back-forward-cache --enable-pixel-canvas-recording --enable-accelerated-video-encode --memlog-sampling-rate=5242880 --enable-parallel-downloading --enable-features=VaapiVideoDecoder --use-gl=desktop" | tee /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/brave-flags.conf /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/chromium-flags.conf ; fi





if dmesg | grep -q amdgpu && ! grep -q amdgpu /etc/modules ; then echo 'amdgpu' | tee -a /etc/modules ; fi

if [ ! -f /etc/dxvk.conf ] ; then wget https://raw.githubusercontent.com/doitsujin/dxvk/master/dxvk.conf --connect-timeout=10 --continue -4 --retry-connrefused -O /etc/dxvk.conf ; fi



# xorg screen
echo 'Section "Screen"
       Identifier     "Screen"
       DefaultDepth    24
       SubSection      "Display"
       Depth           24
       #FbBpp           24
       #Visual          Directcolor
       #DefaultFbBpp    24
       Option "Accel" "true"
       #Option "GlxVendorLibrary" "mesa"
       EndSubSection
EndSection' | tee /etc/X11/xorg.conf.d/10-screen.conf


# pulseaudio
 sed -i 's|load-module module-switch-on-connect|#load-module module-switch-on-connect|g' /etc/pulse/default.pa
 sed -i 's|load-module module-esound-protocol-unix|#load-module module-esound-protocol-unix|g' /etc/pulse/default.pa




# debian extra conf
sed -i 's/3/2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
echo "options iwlwifi 11n_disable=8" | tee /etc/modprobe.d/iwlwifi-speed.conf
sed --in-place 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
rm -f /etc/xdg/autostart/tracker-miner-fs-3.desktop /etc/xdg/autostart/snap-userd-autostart.desktop /etc/xdg/autostart/gnome-keyring*.desktop /etc/xdg/autostart/geoclue-demo-agent.desktop /etc/xdg/autostart/org.kde.kdeconnect.daemon.desktop /etc/xdg/autostart/baloo_file.desktop /etc/xdg/autostart/org.gnome.SettingsDaemon.DiskUtilityNotify.desktop /etc/xdg/autostart/org.kde.discover.notifier.desktop



#git config --global http.sslverify "false"



# drirc
if $(! grep -q "<vblank_mode>" /etc/drirc) ; then
echo '<driconf>
   <device driver="amdgpu">
      <application name="Default">
         <option name="force_s3tc_enable" value="true"/>
         <option name="precise_trig" value="true"/>
         <option name="tcl_mode" value="3"/>
         <option name="fthrottle_mode" value="1"/>
         <option name="vblank_mode" value="0" />
         <option name="stub_occlusion_query" value="true" />
         <option name="fragment_shader" value="true" />
      </application>
   </device>
   <device driver="amdgpu">
      <application name="Default">
         <option name="force_s3tc_enable" value="true"/>
         <option name="precise_trig" value="true"/>
         <option name="tcl_mode" value="3"/>
         <option name="fthrottle_mode" value="1"/>
         <option name="vblank_mode" value="0" />
         <option name="stub_occlusion_query" value="true" />
         <option name="fragment_shader" value="true" />
      </application>
   </device>
</driconf>' | tee /home/$(ls /home)/.drirc /root/.drirc /etc/drirc
if dmesg | grep -q nvidia ; then sed -i 's/<device driver="amdgpu">/<device driver="nvidia">/g' /home/$(ls /home)/.drirc /root/.drirc /etc/drirc ; elif dmesg | grep -q iris ; then sed -i 's/<device driver="amdgpu">/<device driver="iris">/g' /home/$(ls /home)/.drirc /root/.drirc /etc/drirc ; fi ; fi





# prevent motd news
sed -i -e 's/ENABLED=.*/ENABLED=0/' /etc/default/motd-news






if grep -q btrfs /etc/fstab ; then
# btrfs tweaks if disk is
systemctl enable btrfs-scrub@home.timer
systemctl enable btrfs-scrub@-.timer
btrfs balance start -musage=0 -dusage=50 / ; fi





# mpv video player codec stuff
echo 'vo=vdpau
profile=opengl-hq
hwdec=vdpau
hwdec-codecs=all
scale=ewa_lanczossharp
cscale=ewa_lanczossharp
interpolation
tscale=oversample' | tee /etc/.config/mpv/mpv.conf





# kde config linux, debian
$s mkdir -p /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env






# disable polling gpu
if $(! grep -q poll=0 /etc/modprobe.d/modprobe.conf) ; then
echo 'options drm_kms_helper poll=0' | tee -a /etc/modprobe.d/modprobe.conf ; fi





# enable kde compose cache on disk
mkdir -p /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.compose-cache





# stop akonadi-server
$s sed -i 's/StartServer.*/StartServer=false/' /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/akonadi/akonadiserverrc

#resolution=$(echo $(xrandr --current | head -n 6 | tail -n 1 | awk '{print $1}'))
#resolution=$(echo $(xrandr --current | grep current | awk '{print $8$9$10}' | sed 's/\,.*//'))



#echo '[General]
#DisplayServer=wayland
#GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
#CompositorCommand=kwin_wayland --no-lockscreen' | $s tee /etc/sddm.conf.d/10-wayland.conf





# enable dri 3 for amdgpu
# https://manpages.ubuntu.com/manpages/kinetic/en/man4/intel.4.html
# https://manpages.ubuntu.com/manpages/kinetic/en/man5/xorg.conf.5.html
if $(! grep -q 'DDC' /usr/share/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) /etc/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu)) ; then
echo 'Section "OutputClass"
  Identifier "AMDgpu"
  MatchDriver "amdgpu"
  Driver "amdgpu"
  Option "DRI" "3"
  Option "DRI3" "true"
  Option "DRI2" "false"
  Option "TearFree" "true"
  Option "SwapbuffersWait" "true"
  Option "EnablePageFlip" "on"
  Option "NoAccel" "false"
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
EndSection' | tee /usr/share/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) /etc/X11/xorg.conf.d/$(ls /usr/share/X11/xorg.conf.d | grep amdgpu) ; fi




echo '[connection]
# 0 (default) 1 (ignore) 2 (disable) 3 (enable)
wifi.powersave = 2' | tee /etc/NetworkManager/conf.d/wifi-powersave-off.conf





# xrandr auto scaling
for output in $(xrandr --prop | grep -E -o -i "^[A-Z\-]+-[0-9]+"); do xrandr --output "$output" --set "scaling mode" "Full aspect"; done





# set true for disabling tty
if $(! grep -q 'Option "DontVTSwitch" "False"' /etc/X11/xorg.conf.d/1-notty.conf) ; then
echo 'Section "ServerFlags"
    Option "DontVTSwitch" "False"
EndSection' | tee /etc/X11/xorg.conf.d/1-notty.conf ; fi





# disable x11 running on root
if $(! grep -q 'needs_root_rights = no' /etc/X11/Xwrapper.config) ; then echo 'needs_root_rights = no' | tee -a /etc/X11/Xwrapper.config ; fi



if [ $raid = yes ] ; then systemctl enable $(systemctl list-unit-files | grep mda | awk '{print $1}' | awk -v RS=  '{$1=$1}1' | sed 's/\mdadm-waitidle.service//') ; fi







# ~/.config/kwinrc
echo '[$Version]
update_info=kwin.upd:replace-scalein-with-scale,kwin.upd:port-minimizeanimation-effect-to-js,kwin.upd:port-scale-effect-to-js,kwin.upd:port-dimscreen-effect-to-js,kwin.upd:auto-bordersize,kwin.upd:animation-speed,kwin.upd:desktop-grid-click-behavior,kwin.upd:no-swap-encourage,kwin.upd:make-translucency-effect-disabled-by-default,kwin.upd:remove-flip-switch-effect,kwin.upd:remove-cover-switch-effect,kwin.upd:remove-cubeslide-effect,kwin.upd:remove-xrender-backend,kwin.upd:enable-scale-effect-by-default,kwin.upd:overview-group-plugin-id,kwin.upd:animation-speed-cleanup

[Compositing]
AllowTearing=false
AnimationSpeed=0
Backend=OpenGL
CheckIsSafe=false
DisableChecks=true
Enabled=true
GLColorCorrection=false
GLCore=true
GLLegacy=false
GLDirect=true
#GLMode=TFP
GLPreferBufferSwap=e
GLStrictBinding=true
GLTextureFilter=0
#GLVSync=true
#GLPlatformInterface=
GraphicsSystem=native
LatencyPolicy=Medium
#MaxFPS=
#RefreshRate=
RenderTimeEstimator=Minimum
HiddenPreviews=0
OpenGLIsUnsafe=true
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
blurEnabled=false
contrastEnabled=true
kwin4_effect_dialogparentEnabled=false
kwin4_effect_fadingpopupsEnabled=false
kwin4_effect_frozenappEnabled=false
kwin4_effect_fullscreenEnabled=false
kwin4_effect_loginEnabled=false
kwin4_effect_logoutEnabled=false
kwin4_effect_maximizeEnabled=false
kwin4_effect_morphingpopupsEnabled=false
kwin4_effect_translucencyEnabled=true
screenedgeEnabled=false
slidingpopupsEnabled=false
wobblywindowsEnabled=true

[Script-desktopchangeosd]
TextOnly=true

[TabBox]
BorderActivate=9
DesktopLayout=org.kde.breeze.desktop
DesktopListLayout=org.kde.breeze.desktop
LayoutName=org.kde.breeze.desktop
TouchBorderActivate=9

[Windows]
ElectricBorders=1
BorderlessMaximizedWindows=false

[org.kde.kdecoration2]
BorderSize=Large
BorderSizeAuto=false
ButtonsOnLeft=MS
ButtonsOnRight=HIAX
CloseOnDoubleClickOnMenu=false
ShowToolTips=true
library=org.kde.kwin.aurorae
theme=__aurorae__svg__Glassy' | $s tee /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/kwinrc




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
fi









# kde environment variables
echo '#!/bin/sh
export KWIN_NO_XI2=1
export KWIN_GL_DEBUG=0
export KWIN_DIRECT_GL=1
export KWIN_NO_REMOTE=1
export __GL_FSAA_MODE=0
export __GL_LOG_MAX_ANISO=0
export KWIN_USE_BUFFER_AGE=1
export KWIN_PERSISTENT_VBO=1
export LIBGL_DEBUG=0
export KDE_IS_PRELINKED=1
export KDE_UTF8_FILENAMES=1
export KDE_MALLOC=1
export KDE_NOUNLOAD=1
export PLASMA_PRELOAD_POLICY=none
export PLASMA_ENABLE_QML_DEBUG=0
export KDE_DEBUG=0
export DRI_PRIME=1
export WAYLAND_DEBUG=0
export POWERSHELL_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export __GL_YIELD=USLEEP
export KWIN_DRM_PREFER_COLOR_DEPTH=24
export KDE_NO_IPV6=1
export KDE_USE_IPV6=no
export KDEWM=kwin_gles
export KWIN_EXPLICIT_SYNC=0

#if [ $XDG_SESSION_TYPE = wayland ] ; then
#export KWIN_OPENGL_INTERFACE=egl_wayland
#export QT_QPA_PLATFORM=wayland-egl
#fi

#if [ ! $XDG_SESSION_TYPE = wayland ] ; then
export KWIN_OPENGL_INTERFACE=EGL
#fi

  #export XDG_SESSION_TYPE=wayland
export KWIN_TRIPLE_BUFFER=1
  #export XDG_CURRENT_DESKTOP=KDE
  #export DESKTOP_SESSION=plasmawayland
  #export QT_AUTO_SCREEN_SCALE_FACTOR=0
  #export QT_WAYLAND_FORCE_DPI=$kcmfonts_general_forcefontdpiwayland
  #export KDE_FULL_SESSION=true
  #export KDE_FAILSAFE=1
#export KWIN_COMPOSE=O2ES
  #export XLIB_SKIP_ARGB_VISUALS=0
  #export KWIN_FORCE_LANCZOS=0' | $s tee /etc/profile.d/kwin.sh /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env/kwin_env.sh && $s chmod +x /etc/profile.d/kwin.sh && $s chmod +x /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}'
)"/.config/plasma-workspace/env/kwin_env.sh



if [ $ipv6 = on ]
then
sed -i '/export KDE_NO_IPV6=/c\export KDE_NO_IPV6=1' /etc/profile.d/kwin.sh /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env/kwin_env.sh
sed -i '/export KDE_USE_IPV6=/c\export KDE_USE_IPV6=no' /etc/profile.d/kwin.sh /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env/kwin_env.sh
else
sed -i '/export KDE_NO_IPV6=/c\export KDE_NO_IPV6=0' /etc/profile.d/kwin.sh /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env/kwin_env.sh
sed -i '/export KDE_USE_IPV6=/c\export KDE_USE_IPV6=yes' /etc/profile.d/kwin.sh /home/"$(getent passwd | grep 1000 | awk -F ':' '{print $1}')"/.config/plasma-workspace/env/kwin_env.sh ; fi

if [ $ipv6 = on ]
then
sed -i 's/user_pref("network.dns.disableIPv6", true);/user_pref("network.dns.disableIPv6", false);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
sed -i 's/user_pref("network.notify.IPv6", false);/user_pref("network.notify.IPv6", true);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
else
sed -i 's/user_pref("network.dns.disableIPv6", false);/user_pref("network.dns.disableIPv6", true);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js
sed -i 's/user_pref("network.notify.IPv6", true);/user_pref("network.notify.IPv6", false);/g' /home/*/.mozilla/firefox/*.default-release/prefs.js ; fi

fi
#########  DEBIAN ONLY SECTION STOPPED HERE ###############

if $(! $wrt) ; then
    if $debian ; then cclm="-16" ; fi
# /etc/environment variables
# test what works for you, kde desktop runs on opengl backend. turning all these on makes it lag.
# for more info: https://docs.mesa3d.org/envvars.html
# https://cgit.freedesktop.org/mesa/mesa/tree/docs/features.txt?h=staging/22.3
echo '#!/bin/sh -x
export PATH=/usr/lib/ccache/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/usr/local/games:/usr/games:$PATH
export COMMAND_NOT_FOUND_INSTALL_PROMPT=1
export POWERSHELL_UPDATECHECK=Off
export POWERSHELL_TELEMETRY_OPTOUT=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export WINEPREFIX=~/.wine
export WINE_LARGE_ADDRESS_AWARE=1
export WINEFSYNC_SPINCOUNT=24
export WINEESYNC=1
export WINEFSYNC=1
export WINEFSYNC_FUTEX2=1
export WINE_SKIP_GECKO_INSTALLATION=1
export WINE_SKIP_MONO_INSTALLATION=1
export STAGING_WRITECOPY=1
export STAGING_SHARED_MEMORY=1
export STAGING_RT_PRIORITY_SERVER=4
export STAGING_RT_PRIORITY_BASE=2
export STAGING_AUDIO_PERIOD=13333
export WINE_FSR_OVERRIDE=1
export WINE_FULLSCREEN_FSR=1
export WINE_VK_USE_FSR=1
export PROTON_LOG=0
export PROTON_USE_WINED3D=1
export PROTON_FORCE_LARGE_ADDRESS_AWARE=1
export PROTON_NO_ESYNC=1
export STEAM_FRAME_FORCE_CLOSE=0
export VKD3D_CONFIG=no_upload_hvv
export DXVK_ASYNC=1
#export GCC_SPECS=
export SDL_VIDEODRIVER=wayland
export KIRIGAMI_LOWPOWER_HARDWARE=1
export COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer
export ELM_ACCEL=opengl
export WLR_DRM_NO_ATOMIC=1
export VGL_READBACK=pbo
export SDL_VIDEO_X11_DGAMOUSE=0
export SDL_VIDEO_FULLSCREEN_HEAD=0
export WLR_DRM_NO_MODIFIERS=1
export QT_WEBENGINE_DISABLE_WAYLAND_WORKAROUND=1
export PIPEWIRE_PROFILE_MODULES=default,rtkit
export GST_AUDIO_RESAMPLER_QUALITY_DEFAULT=9
export GLSLC=glslc
export QT_GRAPHICSSYSTEM=raster
export DRI_NO_MSAA=1
export DRAW_NO_FSE=1
export WLR_RENDERER=vulkan
export GDK_GL=gles
export GDK_BACKEND="x11,wayland"
export CLUTTER_BACKEND=x11
export VDPAU_DRIVER=va_gl
export EGL_PLATFORM=x11
export KEYTIMEOUT=1
export GST_VAAPI_ALL_DRIVERS=1
export DRAW_USE_LLVM=1
export SOFTPIPE_USE_LLVM=1
export INTEL_BATCH=1
export WL_OUTPUT_SUBPIXEL_NONE=none
export LP_NO_RAST=1
export LIBGL_NO_DRAWARRAYS=1
export LIBGL_THROTTLE_REFRESH=1
export WGL_SWAP_INTERVAL=1
export SDL_VIDEO_YUV_HWACCEL=1
export WINIT_HIDPI_FACTOR=2
export PIPEWIRE_LATENCY=512/48000
export PIPEWIRE_LINK_PASSIVE=1
export HISTCONTROL=ignoreboth
export HISTSIZE=0
export LESSHISTFILE=-
export LESSHISTSIZE=0
export LESSSECURE=1
export PAGER=less
export QT_LOGGING_RULES='\''*=false'\''
export MESA_DEBUG=silent
export LIBGL_DEBUG=0
export GNUTLS_CPUID_OVERRIDE=0x1
export MESA_NO_DITHER=1
export MESA_NO_ERROR=1

export mesa_glthread=true
export DRI_PRIME=1
export __GL_FSAA_MODE=0
export WGL_FORCE_MSAA=0
export DRI_NO_MSAA
export __GL_LOG_MAX_ANISO=0
export RADV_TEX_ANISO=0
export LIBGL_DRI2_DISABLE=1
export __GL_YIELD=USLEEP
export KWIN_OPENGL_INTERFACE=EGL
export LIBGL_ALWAYS_SOFTWARE=0
export QT_SELECT=6
export QT_QPA_PLATFORMTHEME=qt6ct
#export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/radeon_icd.i686.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json

if [ $XDG_SESSION_TYPE = wayland ] ; then export KWIN_OPENGL_INTERFACE=egl_wayland ; export QT_QPA_PLATFORM=wayland-egl ; fi
if [ ! $XDG_SESSION_TYPE = wayland ] ; then export KWIN_OPENGL_INTERFACE=EGL ;  fi

export VAAPI_MPEG4_ENABLED
if [ ! "$(awk '\''/MemTotal/ { print $2 }'\'' /proc/meminfo | cut -c1-1)" -le 4 ] ; then
export CONFIG_SND_HDA_PREALLOC_SIZE=4
fi

export ANV_ENABLE_PIPELINE_CACHE=1
export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export MESA_GLSL_CACHE_DISABLE=false
export MESA_SHADER_CACHE_DISABLE=false

export __GL_THREADED_OPTIMIZATIONS=1

export LP_PERF=no_mipmap,no_linear,no_mip_linear,no_tex,no_blend,no_depth,no_alphatest

export MESA_GL_VERSION_OVERRIDE=4.6
export COGL_ATLAS_DEFAULT_BLIT_MODE=framebuffer

  #export MESA_BACK_BUFFER=ximage
  #export DXVK_HUD=compile
  #export vblank_mode=1
  #export __GL_SYNC_TO_VBLANK=1
  #export AMD_VULKAN_ICD=amdvlk
export RADV_PERFTEST=aco,sam,nggc,rt
export RADV_FORCE_VRS=2x2
export RADV_DEBUG=novrsflatshading
export __GLX_VENDOR_LIBRARY_NAME=mesa
  #export __GLVND_DISALLOW_PATCHING=0
export __GL_MaxFramesAllowed="$(xrandr --current | tail -n 2 | head -n 1 | awk -F '\''.'\'' '\''{print $1}'\'' | awk '\''{print $2}'\'')"
export __GL_VRR_ALLOWED=1
  #export ENABLE_VKBASALT=1
  #export LIBGL_DRI3_DISABLE=1
  #export MESA_LOADER_DRIVER_OVERRIDE=iris
export RTLD_LAZY=1
export LD_BIND_NOW=0
#export LD_DEBUG=0
export LD_DEBUG_OUTPUT=0
#export LD_AUDIT=0
#export LD_PRELOAD=
#export LD_TRACE_LOADED_OBJECTS=0
if $(! '"$debian"') ; then cclm=$(echo "") ; fi
export LD="LD=ld.lld'"$cclm"'"
export LD_LIBRARY_PATH=""$PATH"/../lib:"$PATH"/../lib64:$LD_LIBRARY_PATH"
export CC=clang'"$cclm"'
export HOSTCC=clang'"$cclm"'
export AR=llvm-ar'"$cclm"'
export NM=llvm-nm'"$cclm"'
export OBJCOPY=llvm-objcopy'"$cclm"'
export OBJDUMP=llvm-objdump'"$cclm"'
export READELF=llvm-readelf'"$cclm"'
export OBJSIZE=llvm-size'"$cclm"'
export STRIP=llvm-strip'"$cclm"'
export DXVK_LOG_LEVEL=0
export DXVK_FAKE_DX10_SUPPORT=1
export DXVK_FAKE_DX11_SUPPORT=1
export DXVK_CONFIG_FILE=/etc/dxvk.conf
export QT_STYLE_OVERRIDE=kvantum
export GTK_USE_PORTAL=1

export tlink="https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh"

export OBS_USE_EGL=1

# statements dont seem to work btw, read online people using them... doesnt work

#if [ $(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1) = radeon ] ; then
export radeonsi_enable_nir=true
#fi

#if [ $XDG_SESSION_TYPE = wayland ] ; then
#export KWIN_OPENGL_INTERFACE=egl_wayland
#export QT_QPA_PLATFORM=wayland-egl
#fi

#if [ ! $XDG_SESSION_TYPE = wayland ] ; then
export KWIN_OPENGL_INTERFACE=EGL
#fi

#if dmesg | grep -q amdgpu ; then
export amdgpusi_enable_nir=true
#fi

#if [ $XDG_SESSION_TYPE = x11 ] ; then
export MOZ_X11_EGL=1
export MOZ_ENABLE_WAYLAND=0
#fi

#if [ $XDG_SESSION_TYPE = wayland ] ; then
#export MOZ_ENABLE_WAYLAND=1
#export MOZ_X11_EGL=0
f#i

#VDPAU_DRIVER=$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)si
#LIBVA_DRIVER_NAME=$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)si

#VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)_icd.i686.json:/usr/share/vulkan/icd.d/$(dmesg | grep "use gpu addr" | awk '\''{print $3}'\'' | head -n 1)_icd.x86_64.json
for i in "$(cat /etc/profile.d/kwin.sh | awk '\''{print $2}'\'')" ; do export $i ; done' | tee /etc/environment /etc/environment.d/10-config.dat ; fi












### IF ANDROID
# android props etc
# since script aims for broad range of devices legacy props included
# wont get applied on newer devices anyway. no harm. these are bullshit though. only the dalvik vm shit probably works. most i will be disabled by default. check what is used for your device
# leave gpu rendering disabled in developers options
if [ -f $droidprop ] ; then
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

vm.dirty_background_ratio=90
vm.dirty_ratio=90
ro.config.low_ram=true
vm.min_free_kbytes=4096
vm.vfs_cache_pressure=50
ro.vold.umsdirtyratio=90

####
# debugging and stuff

profiler.force_disable_err_rpt=true
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
net.ipv4.tcp_timestamps=1
net.ipv4.tcp_window_scaling=1
net.ipv4.tcp_wmem=4096 39000 18700
wifi.supplicant_scan_interval=180
persist.telephony.support.ipv6=0
persist.telephony.support.ipv4=1

####
# some of these do work but cause drainage

#BOARD_EGL_NEEDS_LEGACY_FB=false
#POWER_SAVE_PRE_CLEAN_MEMORY_TIME=1800
CPU_MIN_CHECK_DURATION=false
#CONTENT_APP_IDLE_OFFSET=false
#EMPTY_APP_IDLE_OFFSET=false
#ENFORCE_PROCESS_LIMIT=false
#MAX_SERVICE_INACTIVITY=false
#MIN_CRASH_INTERVAL=false
#MIN_HIDDEN_APPS=false
#MIN_RECENT_TASKS=false
GC_TIMEOUT=false
PROC_START_TIMEOUT=false
APP_SWITCH_DELAY_TIME=false
#ACTIVITY_INACTIVE_RESET_TIME=false
#ACTIVITY_INACTIVITY_RESET_TIME=false

####
# deprecated bs that slows down system mostly. part from some that still apply and test very good
# left all in for you to decide depending on which android version youre in. most dont apply today in latest source and some are device related. left them in unused despite

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
debug.performance.tuning=1
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
sem_enhanced_cpu_responsiveness=1
speed_mode=1
speed_mode_enable=1
speed_mode_on=1
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


audio.deep_buffer.media=true
audio.offload.buffer.size.kb=32
audio.offload.gapless.enabled=true
audio.offload.pcm.16bit.enable=true
audio.offload.pcm.24bit.enable=true
audio.offload.track.enable=true
audio.offload.video=true


debug.doze.component=0
app_auto_restriction_enabled=1
app_restriction_enabled=true
app_standby_enabled=1
cached_apps_freezer=enabled
debug.kill_allocating_task=1
usb_wakeup=enable
ro.ksm.default='"$ksm"'

adaptive_battery_management_enabled=1
ro.board_ram_size=low
ro.config.low_ram=true

window_animation_scale=0.0
#view.scroll_friction=0
#view.touch_slop=1
animator_duration_scale=0.0
debug.hwui.force_dark=true
debug.hwui.level=0
transition_animation_scale=0.0
slider_animation_duration=0
tap_duration_threshold=0.0
touch.distance.scale=0
touch.pressure.scale=0.1
touch.size.bias=0
touch_blocking_period=0.0
sys.disable_ext_animation=1
#ro.sf.lcd_density=500
ro.DontUseAnimate=true

persist.sys.purgeable_assets=1
persist.sys.root_access=1
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
debug.sf.ddms=0
#debug.sf.swaprect=1
#debug.sf.use_phase_offsets_as_durations=1
#debug.sqlite.syncmode=1
debug.stagefright.ccodec=1
#dev.bootcomplete=0
dev.pm.dyn_samplingrate=1
#display_color_mode=0
doze.pickup.vibration.threshold=2000
doze.pulse.brightness=15
doze.pulse.delay.in=200
doze.pulse.duration.in=1000
doze.pulse.duration.out=1000
doze.pulse.duration.visible=5000
doze.pulse.notifications=0
doze.pulse.notifications=true
doze.pulse.proxcheck=0
doze.pulse.schedule.resets=3
doze.pulse.schedule=1s,10s,30s,60s,120s
doze.pulse.sigmotion=0
doze.shake.acc.threshold=10
doze.use.accelerometer=0
doze.vibrate.sigmotion=0
drm.service.enabled=true
enhanced_processing=1
fancy_ime_animations=0
forced_app_standby_enabled=1
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
mm.enable.smoothstreaming=true
mobile_data_always_on=0
mot.proximity.delay=25
mpq.audio.decode=true
#multi_press_timeout=250
multicore_packet_scheduler=1
omap.enhancement=true
#persist.adb.notify=0
persist.android.strictmode=0
#persist.audio.hifi=true
#persist.bootanim.preload=1
#persist.cust.tel.eons=1
persist.device_config.runtime_native.usap_pool_enabled=true
persist.device_config.runtime_native_boot.iorap_perfetto_enable=true
persist.device_config.runtime_native_boot.iorap_readahead_enable=true
persist.dpm.feature=1
persist.mm.enable.prefetch=true
persist.preload.common=1
persist.radio.add_power_save=1
#persist.radio.data_no_toggle=1
persist.radio.ramdump=0
#persist.ril.uart.flowctrl=
persist.sampling_profiler=0
persist.service.xloud.enable=0
persist.speaker.prot.enable=false
persist.sys.binary_xml=false
persist.sys.job_delay=false
persist.sys.lowcost=1
persist.sys.purgeable_assets=1
persist.sys.sf.color_saturation=1.25
persist.sys.ssr.enable_ramdumps=0
persist.sys.storage_preload=1
persist.traced.enable=0
persist.vendor.sys.ssr.enable_ramdumps=0
#persyst.sys.usb.config=mtp,adb
pm.sleep_mode=1
power.saving.mode=1
power_supply.wakeup=enable
rakuten_denwa=0
ram_expand_size_list=1
#refresh_rate_mode=2
remote_control=0
restricted_device_performance=1.0
ro.allow.mock.location=1
ro.am.reschedule_service=true
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
ro.config.disable.hw_accel=false
#ro.config.ehrpd=true
ro.config.enable.hw_accel=true
#ro.config.fha_enable=true
#ro.config.htc.nocheckin=1
ro.config.hw_fast_dormancy=1
ro.config.hw_power_saving=true
ro.config.hw_quickpoweron=true
ro.config.low_mem=true
ro.config.low_ram.mod=true
ro.config.low_ram=true
ro.config.nocheckin=1
ro.config.rm_preload_enabled=1
ro.fast.dormancy=1
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
ro.kernel.android.checkjni=0
ro.kernel.checkjni=0
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
ro.product.gpu.driver=1
ro.recentMode=0
ro.ril.disable.power.collapse=1
#ro.ril.enable.3g.prefix=1
#ro.ril.enable.a52=1
#ro.ril.enable.a53=1
#ro.ril.enable.amr.wideband=1
#ro.ril.enable.dtm=1
#ro.ril.enable.fd.plmn.prefix=23402,23410,23411
#ro.ril.enable.gea3=1
#ro.ril.enable.sdr=0
ro.ril.fast.dormancy.rule=1
#ro.ril.gprsclass=12
#ro.ril.hep=1
#ro.ril.hsdpa.category=28
#ro.ril.hsupa.category=7
#ro.ril.hsxpa=3
#ro.ril.htcmaskw1.bitmask=4294967295
#ro.ril.htcmaskw1=14449
ro.ril.power_collapse=0
#ro.ril.sensor.sleep.control=1
ro.secure=0
#ro.semc.sound_effects_enabled=true
#ro.semc.xloud.supported=true
ro.service.remove_unused=1
ro.sf.compbypass.enable=0
ro.sf.disable_triple_buffer=0
ro.storage_manager.enabled=true
ro.support.signalsmooth=true
#ro.surface_flinger.has_wide_color_display=false
#ro.surface_flinger.use_content_detection_for_refresh_rate=true
#ro.sys.fw.bservice_enable=true
ro.sys.fw.use_trim_settings=true
ro.tb.mode=1
#ro.telephony.call_ring.delay=0
#ro.telephony.call_ring.multiple=0
ro.tether.denied=false
ro.trim.config=true
ro.trim.memory.font_cache=1
ro.trim.memory.launcher=1
ro.vendor.perf.scroll_opt=true
ro.warmboot.capability=1
ro.warranty_bit=0
ro.wmt.blcr.enable=0
#screen_auto_brightness_adj=0
#sys.config.activelaunch_enable=true
#sys.config.phone_start_early=true
unused_static_shared_lib_min_cache_period_ms=3600

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


if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-1)" -ge 8 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=768m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=1566m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-2)" -ge 12 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=1024m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=2048m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-2)" -ge 32 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=2048m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=4096m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo | cut -c1-1)" -le 4 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=256m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=512m/g' $droidprop
fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 2200000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=128m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=512m/g' $droidprop

fi

if [ "$(awk '/MemTotal/ { print $2 }' /proc/meminfo)" -le 1100000 ] ; then
sed -i 's/dalvik.vm.heapgrowthlimit=.*/dalvik.vm.heapgrowthlimit=64m/g' $droidprop
sed -i 's/dalvik.vm.heapsize=.*/dalvik.vm.heapsize=256m/g' $droidprop
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
sed -i 's/#debug.hwui.renderer=.*/debug.hwui.renderer=opengl/g' $droidprop
sed -i 's/#debug.egl.hw=.*/debug.egl.hw=1/g' $droidprop
sed -i 's/#debug.egl.profiler=.*/debug.egl.profiler=1/g' $droidprop
sed -i 's/#debug.egl.buffcount=.*/debug.egl.buffcount=3/g' $droidprop
sed -i 's/#debug.composition.type=.*/debug.composition.type=c2d/g' $droidprop
sed -i 's/#persist.sys.composition.type=.*/persist.sys.composition.type=c2d/g' $droidprop
sed -i 's/#debug.sf.enable_gl_backpressure=.*/debug.sf.enable_gl_backpressure=1/g' $droidprop
sed -i 's/#debug.gr.numframebuffers=.*/debug.gr.numframebuffers=3/g' $droidprop
sed -i 's/#debug.enable.sglscale=.*/debug.enable.sglscale=1/g' $droidprop 
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

if [ "$(grep "ro.build.version.release=" $droidprop | awk -F '=' '{print $2}'  | cut -c 1-2 | sed 's/\.//g')" -le 6  ]; then
setprop debug.hwui.renderer gpu
sed -i 's/debug.hwui.renderer=.*/debug.hwui.renderer=gpu/g' $droidprop
fi

if [ $testing = yes ] ; then echo "skip..." ; else

# setprop breaks system i remember from past as well with some flags so leave them in build.prop only. depending on rom ofcourse.
"$bb"sh -cx 'for i in $(cat /system/build.prop) ; do
"$(setprop $(echo "$i" | sed '\''s/=/ /g'\'' | grep -v "#" | awk '\''{print $1, $2}'\'' ))"
done'
# afai remember works good on high end device only
#setprop sys.use_fifo_ui 1

fi

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



#umount /vendor || true
#mount -o rw /dev/block/bootdevice/by-name/vendor /vendor
sed -i 's/noatime/lazytime/g' "$fstab"
sed -i 's/nodiratime/lazytime/g' "$fstab"
sed -i 's/relatime/lazytime/g' "$fstab"


#for part in system data
#do if mount | grep -q "/$part" ; then mount -o rw,remount "/$part" "/$part" && ui_print "/$part remounted rw"
#else mount -o rw "/$part" && ui_print "/$part mounted rw" || ex "/$part cannot mounted" ; fi ; done

"$bb"fstrim /data
"$bb"fstrim /cache
"$bb"fstrim /system

if [ $firstrun = yes ] ; then

     pm disable-user --user 0 com.android.apps.tag
     pm disable-user --user 0 com.android.bbklog
     pm disable-user --user 0 com.android.bbkmusic
     pm disable-user --user 0 com.android.bbksoundrecorder
     pm disable-user --user 0 com.android.bips
     pm disable-user --user 0 com.android.bookmarkprovider
     pm disable-user --user 0 com.android.browser
     pm disable-user --user 0 com.android.calllogbackup
     pm disable-user --user 0 com.android.documentsui
     pm disable-user --user 0 com.android.egg
     pm disable-user --user 0 com.android.email
     pm disable-user --user 0 com.android.exchange
     pm disable-user --user 0 com.android.hotwordenrollment.okgoogle
     pm disable-user --user 0 com.android.hotwordenrollment.xgoogle
     pm disable-user --user 0 com.android.localtransport
     pm disable-user --user 0 com.android.location.fused
     pm disable-user --user 0 com.android.mms
     pm disable-user --user 0 com.android.mms.service
     pm disable-user --user 0 com.android.partnerbrowsercustomizations
     pm disable-user --user 0 com.android.providers.downloads.ui
     pm disable-user --user 0 com.android.providers.partnerbookmarks
     pm disable-user --user 0 com.android.providers.userdictionary
     pm disable-user --user 0 com.android.sharedstoragebackup
     pm disable-user --user 0 com.android.soundrecorder
     pm disable-user --user 0 com.android.thememanager
     pm disable-user --user 0 com.android.thememanager.module
     pm disable-user --user 0 android.autoinstalls.config.Xiaomi.pine
     pm disable-user --user 0 com.alibaba.aliexpresshd
     pm disable-user --user 0 com.allgoritm.youla
     pm disable-user --user 0 com.app.market
     pm disable-user --user 0 com.asurion.android.protech.att
     pm disable-user --user 0 com.asurion.android.verizon.vms
     pm disable-user --user 0 com.att.android.attsmartwifi
     pm disable-user --user 0 com.att.dh
     pm disable-user --user 0 com.att.dtv.shaderemote
     pm disable-user --user 0 com.att.myWireless
     pm disable-user --user 0 com.att.tv
     pm disable-user --user 0 com.audible.application
     pm disable-user --user 0 com.aura.oobe.samsung
     pm disable-user --user 0 com.baidu.duersdk.opensdk
     pm disable-user --user 0 com.bbk.account
     pm disable-user --user 0 com.bbk.cloud
     pm disable-user --user 0 com.bbk.iqoo.logsystem
     pm disable-user --user 0 com.bbk.photoframewidget
     pm disable-user --user 0 com.bbk.scene.indoor
     pm disable-user --user 0 com.bbk.SuperPowerSave
     pm disable-user --user 0 com.bbk.theme
     pm disable-user --user 0 com.bbk.theme.resources
     pm disable-user --user 0 com.bleacherreport.android.teamstream
     pm disable-user --user 0 com.booking
     pm disable-user --user 0 coloros.gamespaceui
     pm disable-user --user 0 com.coloros.activation
     pm disable-user --user 0 com.coloros.activation.overlay.common
     pm disable-user --user 0 com.coloros.aftersalesservice
     pm disable-user --user 0 com.coloros.appmanager
     pm disable-user --user 0 com.coloros.assistantscreen
     pm disable-user --user 0 com.coloros.athena
     pm disable-user --user 0 com.coloros.avastofferwall
     pm disable-user --user 0 com.coloros.backuprestore
     pm disable-user --user 0 com.coloros.backuprestore.remoteservice
     pm disable-user --user 0 com.coloros.bootreg
     pm disable-user --user 0 com.coloros.childrenspace
     pm disable-user --user 0 com.coloros.cloud
     pm disable-user --user 0 com.coloros.compass2
     pm disable-user --user 0 com.coloros.encryption
     pm disable-user --user 0 com.coloros.floatassistant
     pm disable-user --user 0 com.coloros.focusmode
     pm disable-user --user 0 com.coloros.gallery3d
     pm disable-user --user 0 com.coloros.gamespace
     pm disable-user --user 0 com.hunge.app
     pm disable-user --user 0 com.coloros.healthcheck
     pm disable-user --user 0 com.coloros.healthservice
     pm disable-user --user 0 com.coloros.music
     pm disable-user --user 0 com.coloros.musiclink
     pm disable-user --user 0 com.coloros.oppomultiapp
     pm disable-user --user 0 com.coloros.oshare
     pm disable-user --user 0 com.coloros.phonenoareainquire
     pm disable-user --user 0 com.coloros.pictorial
     pm disable-user --user 0 com.coloros.resmonitor
     pm disable-user --user 0 com.coloros.safesdkproxy
     pm disable-user --user 0 com.coloros.sauhelper
     pm disable-user --user 0 com.coloros.sceneservice
     pm disable-user --user 0 com.coloros.securepay
     pm disable-user --user 0 com.coloros.smartdrive
     pm disable-user --user 0 com.coloros.smartsidebar
     pm disable-user --user 0 com.coloros.soundrecorder
     pm disable-user --user 0 com.coloros.speechassist
     pm disable-user --user 0 com.coloros.translate.engine
     pm disable-user --user 0 com.coloros.video
     pm disable-user --user 0 com.coloros.wallet
     pm disable-user --user 0 com.coloros.weather.service
     pm disable-user --user 0 com.coloros.weather2
     pm disable-user --user 0 com.coloros.widget.smallweather
     pm disable-user --user 0 com.coloros.wifibackuprestore
     pm disable-user --user 0 com.diotek.sec.lookup.dictionary
     pm disable-user --user 0 com.drivemode
     pm disable-user --user 0 com.dropboxchmod
     pm disable-user --user 0 com.dsi.ant.plugins.antplus
     pm disable-user --user 0 com.dsi.ant.sample.acquirechannels
     pm disable-user --user 0 com.dsi.ant.server
     pm disable-user --user 0 com.dsi.ant.service.socket
     pm disable-user --user 0 com.duokan.phone.remotecontroller
     pm disable-user --user 0 com.enhance.gameservice
     pm disable-user --user 0 com.facemoji.lite.xiaomi
     pm disable-user --user 0 com.foxnextgames.m3
     pm disable-user --user 0 com.gameloft.android.GloftANPH
     pm disable-user --user 0 com.gameloft.android.GloftDBMF
     pm disable-user --user 0 com.gameloft.android.GloftDMKF
     pm disable-user --user 0 com.gameloft.android.GloftPDMF
     pm disable-user --user 0 com.gameloft.android.GloftSMIF
     pm disable-user --user 0 com.google.android.apps.docs
     pm disable-user --user 0 com.google.android.apps.docs.editors.docs
     pm disable-user --user 0 com.google.android.apps.docs.editors.sheets
     pm disable-user --user 0 com.google.android.apps.docs.editors.slides
     pm disable-user --user 0 com.google.android.apps.genie.geniewidget
     pm disable-user --user 0 com.google.android.apps.maps
     pm disable-user --user 0 com.google.android.apps.restore
     pm disable-user --user 0 com.google.android.apps.tachyon
     pm disable-user --user 0 com.google.android.apps.work.oobconfig
     pm disable-user --user 0 com.google.android.feedback
     pm disable-user --user 0 com.google.android.gm
     pm disable-user --user 0 com.google.android.gms.location.history
     pm disable-user --user 0 com.google.android.googlequicksearchbox
     pm disable-user --user 0 com.google.android.keep
     pm disable-user --user 0 com.google.android.marvin.talkback
     pm disable-user --user 0 com.google.android.music
     pm disable-user --user 0 com.google.android.partnersetup
     pm disable-user --user 0 com.google.android.printservice.recommendation
     pm disable-user --user 0 com.google.android.setupwizard
     pm disable-user --user 0 com.google.android.syncadapters.calendar
     pm disable-user --user 0 com.google.android.syncadapters.contacts
     pm disable-user --user 0 com.google.android.talk
     pm disable-user --user 0 com.google.android.tts
     pm disable-user --user 0 com.google.android.videos
     pm disable-user --user 0 com.google.ar.core
     pm disable-user --user 0 com.google.audio.hearing.visualization.accessibility.scribe
     pm disable-user --user 0 com.google.vr.vrcorr
     pm disable-user --user 0 com.greatbigstory.greatbigstory
     pm disable-user --user 0 com.gsn.android.tripeaks
     pm disable-user --user 0 com.heytap.browser
     pm disable-user --user 0 com.heytap.cloud
     pm disable-user --user 0 com.heytap.colorfulengine
     pm disable-user --user 0 com.heytap.datamigration
     pm disable-user --user 0 com.heytap.habit.analysis
     pm disable-user --user 0 com.heytap.market
     pm disable-user --user 0 com.heytap.mcs
     pm disable-user --user 0 com.heytap.openid
     pm disable-user --user 0 com.heytap.pictorial
     pm disable-user --user 0 com.heytap.themestore
     pm disable-user --user 0 com.heytap.usercenter
     pm disable-user --user 0 com.heytap.usercenter.overlay
     pm disable-user --user 0 com.hiya.star
     pm disable-user --user 0 com.honor.global
     pm disable-user --user 0 com.huaqin.diaglogger
     pm disable-user --user 0 com.huawei.android.thememanager
     pm disable-user --user 0 com.huawei.android.tips
     pm disable-user --user 0 com.huawei.android.wfdft
     pm disable-user --user 0 com.huawei.himovie
     pm disable-user --user 0 com.huawei.KoBackup
     pm disable-user --user 0 com.ibimuyu.lockscreen
     pm disable-user --user 0 com.innogames.foeandroid
     pm disable-user --user 0 com.iqoo.engineermode
     pm disable-user --user 0 com.iqoo.secure
     pm disable-user --user 0 com.linkedin.android
     pm disable-user --user 0 com.mediatek.gnssdebugreport
     pm disable-user --user 0 com.mediatek.mdmlsample
     pm disable-user --user 0 com.mediatek.mtklogger
     pm disable-user --user 0 com.mediatek.omacp
     pm disable-user --user 0 com.mi.android.globalminusscreen
     pm disable-user --user 0 com.mi.globalbrowser
     pm disable-user --user 0 com.mi.globallayout
     pm disable-user --user 0 com.mi.globalTrendNews
     pm disable-user --user 0 com.mi.webkit.core
     pm disable-user --user 0 com.microsoft.appmanager
     pm disable-user --user 0 com.microsoft.office.excel
     pm disable-user --user 0 com.microsoft.office.officehubrow
     pm disable-user --user 0 com.microsoft.office.outlook
     pm disable-user --user 0 com.microsoft.office.powerpoint
     pm disable-user --user 0 com.microsoft.office.word
     pm disable-user --user 0 com.microsoft.skydrive
     pm disable-user --user 0 com.milink.service
     pm disable-user --user 0 com.mipay.wallet.id
     pm disable-user --user 0 com.miui.analytics
     pm disable-user --user 0 com.miui.android.fashiongallery
     pm disable-user --user 0 com.miui.aod
     pm disable-user --user 0 com.miui.audiomonitor
     pm disable-user --user 0 com.miui.backup
     pm disable-user --user 0 com.miui.bugreport
     pm disable-user --user 0 com.miui.cloudbackup
     pm disable-user --user 0 com.miui.contentcatcher
     pm disable-user --user 0 com.miui.daemon
     pm disable-user --user 0 com.miui.enbbs
     pm disable-user --user 0 com.miui.extraphoto
     pm disable-user --user 0 com.miui.face
     pm disable-user --user 0 com.miui.freeform
     pm disable-user --user 0 com.miui.global.packageinstaller
     pm disable-user --user 0 com.miui.miservice
     pm disable-user --user 0 com.miui.mishare.connectivity
     pm disable-user --user 0 com.miui.misound
     pm disable-user --user 0 com.miui.msa.global
     pm disable-user --user 0 com.miui.phrase
     pm disable-user --user 0 com.miui.player
     pm disable-user --user 0 com.miui.powerkeeper
     pm disable-user --user 0 com.miui.providers.weather
     pm disable-user --user 0 com.miui.smsextra
     pm disable-user --user 0 com.miui.sysopt
     pm disable-user --user 0 com.miui.touchassistant
     pm disable-user --user 0 com.miui.userguide
     pm disable-user --user 0 com.miui.videoplayer
     pm disable-user --user 0 com.miui.virtualsim
     pm disable-user --user 0 com.miui.vsimcore
     pm disable-user --user 0 com.miui.whetstone
     pm disable-user --user 0 com.miui.wmsvc
     pm disable-user --user 0 com.miui.securityadd 
     pm disable-user --user 0 com.mobeam.barcodeService
     pm disable-user --user 0 com.mobiletools.systemhelper
     pm disable-user --user 0 com.motricity.verizon.ssodownloadable
     pm disable-user --user 0 com.mygalaxy
     pm disable-user --user 0 com.nearme.atlas
     pm disable-user --user 0 com.nearme.browser
     pm disable-user --user 0 com.nearme.gamecenter
     pm disable-user --user 0 com.nearme.statistics.rom
     pm disable-user --user 0 com.nearme.themestore
     pm disable-user --user 0 com.netflix.mediaclient
     pm disable-user --user 0 com.netflix.partner.activation
     pm disable-user --user 0 com.opera.browser
     pm disable-user --user 0 com.opera.preinstall
     pm disable-user --user 0 com.oppo.aod
     pm disable-user --user 0 com.oppo.atlas
     pm disable-user --user 0 com.oppo.bttestmode
     pm disable-user --user 0 com.oppo.criticallog
     pm disable-user --user 0 com.oppo.gestureservice
     pm disable-user --user 0 com.oppo.gmail.overlay
     pm disable-user --user 0 com.oppo.lfeh
     pm disable-user --user 0 com.oppo.logkit
     pm disable-user --user 0 com.oppo.logkitservice
     pm disable-user --user 0 com.oppo.market
     pm disable-user --user 0 com.oppo.mimosiso
     pm disable-user --user 0 com.oppo.music
     pm disable-user --user 0 com.oppo.nw
     pm disable-user --user 0 com.oppo.operationmanual
     pm disable-user --user 0 com.oppo.ovoicemanager
     pm disable-user --user 0 com.oppo.partnerbrowsercustomizations
     pm disable-user --user 0 com.oppo.qualityprotect
     pm disable-user --user 0 com.oppo.quicksearchbox
     pm disable-user --user 0 com.oppo.rftoolkit
     pm disable-user --user 0 com.oppo.ScoreAppMonitor
     pm disable-user --user 0 com.oppo.sos
     pm disable-user --user 0 com.oppo.startlogkit
     pm disable-user --user 0 com.oppo.tzupdate
     pm disable-user --user 0 com.oppo.usageDump
     pm disable-user --user 0 com.oppo.usercenter
     pm disable-user --user 0 com.oppo.webview
     pm disable-user --user 0 com.oppo.wifirf
     pm disable-user --user 0 com.oppoex.afterservice
     pm disable-user --user 0 com.osp.app.signin
     pm disable-user --user 0 com.pandora.android
     pm disable-user --user 0 com.playstudios.popslots
     pm disable-user --user 0 com.playwing.acu.huawei
     pm disable-user --user 0 com.qti.dpmserviceapp
     pm disable-user --user 0 com.qti.qualcomm.datastatusnotification
     pm disable-user --user 0 com.qti.qualcomm.deviceinfo
     pm disable-user --user 0 com.qti.xdivert
     pm disable-user --user 0 com.qualcomm.embms
     pm disable-user --user 0 com.qualcomm.location
     pm disable-user --user 0 com.qualcomm.qti.autoregistration
     pm disable-user --user 0 com.qualcomm.qti.callfeaturessetting
     pm disable-user --user 0 com.qualcomm.qti.cne
     pm disable-user --user 0 com.qualcomm.qti.dynamicddsservice
     pm disable-user --user 0 com.qualcomm.qti.ims
     pm disable-user --user 0 com.qualcomm.qti.lpa
     pm disable-user --user 0 com.qualcomm.qti.modemtestmode
     pm disable-user --user 0 com.qualcomm.qti.performancemode
     pm disable-user --user 0 com.qualcomm.qti.poweroffalarm
     pm disable-user --user 0 com.qualcomm.qti.qdma
     pm disable-user --user 0 com.qualcomm.qti.qmmi
     pm disable-user --user 0 com.qualcomm.qti.seccamservice
     pm disable-user --user 0 com.qualcomm.qti.uceShimService
     pm disable-user --user 0 com.qualcomm.qti.uim
     pm disable-user --user 0 com.qualcomm.qti.uimGbaApp
     pm disable-user --user 0 com.qualcomm.uimremoteclient
     pm disable-user --user 0 com.qualcomm.uimremoteserver
     pm disable-user --user 0 com.realme.logtool
     pm disable-user --user 0 com.redteamobile.roaming
     pm disable-user --user 0 com.redteamobile.roaming.deamon
     pm disable-user --user 0 com.samsung.android.allshare.service.mediashare
     pm disable-user --user 0 com.samsung.android.app.aodservice
     pm disable-user --user 0 com.samsung.android.app.appsedge
     pm disable-user --user 0 com.samsung.android.app.camera.sticker.facearavatar.preload
     pm disable-user --user 0 com.samsung.android.app.dressroom
     pm disable-user --user 0 com.samsung.android.app.galaxyfinder
     pm disable-user --user 0 com.samsung.android.app.ledbackcover
     pm disable-user --user 0 com.samsung.android.app.omcagent
     pm disable-user --user 0 com.samsung.android.app.reminder
     pm disable-user --user 0 com.samsung.android.app.routines
     pm disable-user --user 0 com.samsung.android.app.sbrowseredge
     pm disable-user --user 0 com.samsung.android.app.settings.bixby
     pm disable-user --user 0 com.samsung.android.app.simplesharing
     pm disable-user --user 0 com.samsung.android.app.social
     pm disable-user --user 0 com.samsung.android.app.spage
     pm disable-user --user 0 com.samsung.android.app.tips
     pm disable-user --user 0 com.samsung.android.app.vrsetupwizardstub
     pm disable-user --user 0 com.samsung.android.app.watchmanager
     pm disable-user --user 0 com.samsung.android.app.watchmanagerstub
     pm disable-user --user 0 com.samsung.android.ardrawing
     pm disable-user --user 0 com.samsung.android.aremoji
     pm disable-user --user 0 com.samsung.android.aremojieditor
     pm disable-user --user 0 com.samsung.android.arzone
     pm disable-user --user 0 com.samsung.android.authfw
     pm disable-user --user 0 com.samsung.android.beaconmanager
     pm disable-user --user 0 com.samsung.android.bixby.agent
     pm disable-user --user 0 com.samsung.android.bixby.agent.dummy
     pm disable-user --user 0 com.samsung.android.bixby.service
     pm disable-user --user 0 com.samsung.android.bixby.wakeup
     pm disable-user --user 0 com.samsung.android.bixbyvision.framework
     pm disable-user --user 0 com.samsung.android.cameraxservice
     pm disable-user --user 0 com.samsung.android.da.daagent
     pm disable-user --user 0 com.samsung.android.drivelink.stub
     pm disable-user --user 0 com.samsung.android.dsms
     pm disable-user --user 0 com.samsung.android.easysetup
     pm disable-user --user 0 com.samsung.android.email.provider
     pm disable-user --user 0 com.samsung.android.emojiupdater
     pm disable-user --user 0 com.samsung.android.forest
     pm disable-user --user 0 com.samsung.android.game.gamehome
     pm disable-user --user 0 com.samsung.android.game.gametools
     pm disable-user --user 0 com.samsung.android.game.gos
     pm disable-user --user 0 com.samsung.android.gametuner.thin
     pm disable-user --user 0 com.samsung.android.hmt.vrshell
     pm disable-user --user 0 com.samsung.android.hmt.vrsvc
     pm disable-user --user 0 com.samsung.android.honeyboard
     pm disable-user --user 0 com.samsung.android.keyguardmgsupdator
     pm disable-user --user 0 com.samsung.android.kidsinstaller
     pm disable-user --user 0 com.samsung.android.knox.analytics.uploader
     pm disable-user --user 0 com.samsung.android.livestickers
     pm disable-user --user 0 com.samsung.android.mateagent
     pm disable-user --user 0 com.samsung.android.mfi
     pm disable-user --user 0 com.samsung.android.mobileservice
     pm disable-user --user 0 com.samsung.android.networkdiagnostic
     pm disable-user --user 0 com.samsung.android.oneconnect
     pm disable-user --user 0 com.samsung.android.rubin.app
     pm disable-user --user 0 com.samsung.android.samsungpass
     pm disable-user --user 0 com.samsung.android.samsungpassautofill
     pm disable-user --user 0 com.samsung.android.scloud
     pm disable-user --user 0 com.samsung.android.sdk.handwriting
     pm disable-user --user 0 com.samsung.android.sdk.professionalaudio.utility.jammonitor
     pm disable-user --user 0 com.samsung.android.sdm.config
     pm disable-user --user 0 com.samsung.android.service.aircommand
     pm disable-user --user 0 com.samsung.android.service.livedrawing
     pm disable-user --user 0 com.samsung.android.service.peoplestripe
     pm disable-user --user 0 com.samsung.android.setupindiaservicestnc
     pm disable-user --user 0 com.samsung.android.spay
     pm disable-user --user 0 com.samsung.android.spayfw
     pm disable-user --user 0 com.samsung.android.spaymini
     pm disable-user --user 0 com.samsung.android.spdf
     pm disable-user --user 0 com.samsung.android.svcagent
     pm disable-user --user 0 com.samsung.android.svoiceime
     pm disable-user --user 0 com.samsung.android.themestore
     pm disable-user --user 0 com.samsung.android.universalswitch
     pm disable-user --user 0 com.samsung.android.visionarapps
     pm disable-user --user 0 com.samsung.android.visioncloudagent
     pm disable-user --user 0 com.samsung.android.visionintelligence
     pm disable-user --user 0 com.samsung.android.voc
     pm disable-user --user 0 com.samsung.android.widgetapp.yahooedge.finance
     pm disable-user --user 0 com.samsung.android.widgetapp.yahooedge.sport
     pm disable-user --user 0 com.samsung.app.highlightplayer
     pm disable-user --user 0 com.samsung.attvvm
     pm disable-user --user 0 com.samsung.desktopsystemui
     pm disable-user --user 0 com.samsung.ecomm.global
     pm disable-user --user 0 com.samsung.hiddennetworksetting
     pm disable-user --user 0 com.samsung.knox.securefolder
     pm disable-user --user 0 com.samsung.safetyinformation
     pm disable-user --user 0 com.samsung.sree
     pm disable-user --user 0 com.samsung.storyservice
     pm disable-user --user 0 com.samsung.systemui.bixby2
     pm disable-user --user 0 com.samsung.vmmhux
     pm disable-user --user 0 com.samsung.vvm
     pm disable-user --user 0 com.sec.android.app.billing
     pm disable-user --user 0 com.sec.android.app.camera
     pm disable-user --user 0 com.sec.android.app.clockpackage
     pm disable-user --user 0 com.sec.android.app.desktoplauncher
     pm disable-user --user 0 com.sec.android.app.dexonpc
     pm disable-user --user 0 com.sec.android.app.kidshome
     pm disable-user --user 0 com.sec.android.app.popupcalculator
     pm disable-user --user 0 com.sec.android.app.samsungapps
     pm disable-user --user 0 com.sec.android.app.sbrowser
     pm disable-user --user 0 com.sec.android.app.setupwizardlegalprovider
     pm disable-user --user 0 com.sec.android.app.shealth
     pm disable-user --user 0 com.sec.android.app.voicenote
     pm disable-user --user 0 com.sec.android.cover.ledcover
     pm disable-user --user 0 com.sec.android.daemonapp
     pm disable-user --user 0 com.sec.android.desktopmode.uiservice
     pm disable-user --user 0 com.sec.android.easyMover.Agent
     pm disable-user --user 0 com.sec.android.easyonehand
     pm disable-user --user 0 com.sec.android.gallery3d
     pm disable-user --user 0 com.sec.android.mimage.avatarstickers
     pm disable-user --user 0 com.sec.android.service.health
     pm disable-user --user 0 com.sec.android.splitsound
     pm disable-user --user 0 com.sec.android.widgetapp.samsungapps
     pm disable-user --user 0 com.sec.android.widgetapp.webmanual
     pm disable-user --user 0 com.sec.location.nsflp2
     pm disable-user --user 0 com.sec.penup
     pm disable-user --user 0 com.sec.spp.push
     pm disable-user --user 0 com.synchronoss.dcs.att.r2g
     pm disable-user --user 0 com.ted.number
     pm disable-user --user 0 com.tencent.soter.soterserver
     pm disable-user --user 0 com.trustonic.teeservice
     pm disable-user --user 0 com.vcast.mediamanager
     pm disable-user --user 0 com.vivo.appfilter
     pm disable-user --user 0 com.vivo.appstore
     pm disable-user --user 0 com.vivo.assistant
     pm disable-user --user 0 com.vivo.browser
     pm disable-user --user 0 com.vivo.carmode
     pm disable-user --user 0 com.vivo.collage
     pm disable-user --user 0 com.vivo.compass
     pm disable-user --user 0 com.vivo.doubleinstance
     pm disable-user --user 0 com.vivo.doubletimezoneclock
     pm disable-user --user 0 com.vivo.dream.music
     pm disable-user --user 0 com.vivo.dream.weather
     pm disable-user --user 0 com.vivo.easyshar
     pm disable-user --user 0 com.vivo.email
     pm disable-user --user 0 com.vivo.ewarranty
     pm disable-user --user 0 com.vivo.favorite
     pm disable-user --user 0 com.vivo.floatingball
     pm disable-user --user 0 com.vivo.fuelsummary
     pm disable-user --user 0 com.vivo.gamewatch
     pm disable-user --user 0 com.vivo.globalsearch
     pm disable-user --user 0 com.vivo.hiboard
     pm disable-user --user 0 com.vivo.magazine
     pm disable-user --user 0 com.vivo.mediatune
     pm disable-user --user 0 com.vivo.minscreen
     pm disable-user --user 0 com.vivo.motormode
     pm disable-user --user 0 com.vivo.numbermark
     pm disable-user --user 0 com.vivo.pushservice
     pm disable-user --user 0 com.vivo.setupwizard
     pm disable-user --user 0 com.vivo.smartmultiwindow
     pm disable-user --user 0 com.vivo.smartshot
     pm disable-user --user 0 com.vivo.translator
     pm disable-user --user 0 com.vivo.unionpay
     pm disable-user --user 0 com.vivo.video.floating
     pm disable-user --user 0 com.vivo.videoeditor
     pm disable-user --user 0 com.vivo.vivokaraoke
     pm disable-user --user 0 com.vivo.weather
     pm disable-user --user 0 com.vivo.weather.provider
     pm disable-user --user 0 com.vivo.website
     pm disable-user --user 0 com.vivo.widget.calendar
     pm disable-user --user 0 com.vzw.hs.android.modlite
     pm disable-user --user 0 com.vzw.hss.myverizon
     pm disable-user --user 0 com.wavemarket.waplauncher
     pm disable-user --user 0 com.wb.goog.dcuniverse
     pm disable-user --user 0 com.wb.goog.got.conquest
     pm disable-user --user 0 com.wsomacp
     pm disable-user --user 0 com.xiaomi.ab
     pm disable-user --user 0 com.xiaomi.account
     pm disable-user --user 0 com.xiaomi.bsp.gps.nps
     pm disable-user --user 0 com.xiaomi.discover
     pm disable-user --user 0 com.xiaomi.finddevice
     pm disable-user --user 0 com.xiaomi.location.fused
     pm disable-user --user 0 com.xiaomi.micloud.sdk
     pm disable-user --user 0 com.xiaomi.midrop
     pm disable-user --user 0 com.xiaomi.miplay_client
     pm disable-user --user 0 com.xiaomi.powerchecker
     pm disable-user --user 0 com.xiaomi.providers.appindex
     pm disable-user --user 0 com.xiaomi.simactivate.service
     pm disable-user --user 0 com.xiaomi.upnp
     pm disable-user --user 0 com.xiaomi.xmsf
     pm disable-user --user 0 com.xiaomi.xmsfkeeper
     pm disable-user --user 0 flipboard.boxer.app
     pm disable-user --user 0 jp.gocro.smartnews.android
     pm disable-user --user 0 net.aetherpal.device
     pm disable-user --user 0 om.oppo.aod
     pm disable-user --user 0 org.kman.AquaMail
     pm disable-user --user 0 Samsung AR Emoji
     pm disable-user --user 0 se.dirac.acs
     pm disable-user --user 0 vendor.qti.hardware.cacert.server
     pm uninstall -k --user 0 com.alibaba.aliexpresshd
     pm uninstall -k --user 0 com.android.galaxy4
     pm uninstall -k --user 0 com.android.stk
     pm uninstall -k --user 0 com.android.stk2
     pm uninstall -k --user 0 com.android.thememanager
     pm uninstall -k --user 0 com.android.thememanager.module
     pm uninstall -k --user 0 com.android.traceur
     pm uninstall -k --user 0 com.autonavi.minimap
     pm uninstall -k --user 0 com.ebay.carrier
     pm uninstall -k --user 0 com.ebay.mobile
     pm uninstall -k --user 0 com.facebook.appmanager
     pm uninstall -k --user 0 com.facebook.katana
     pm uninstall -k --user 0 com.facebook.services
     pm uninstall -k --user 0 com.facebook.system
     pm uninstall -k --user 0 com.google.android.apps.docs
     pm uninstall -k --user 0 com.google.android.apps.googleassistant
     pm uninstall -k --user 0 com.google.android.apps.magazines
     pm uninstall -k --user 0 com.google.android.apps.maps
     pm uninstall -k --user 0 com.google.android.apps.podcasts
     pm uninstall -k --user 0 com.google.android.apps.subscriptions.red
     pm uninstall -k --user 0 com.google.android.apps.tachyon
     pm uninstall -k --user 0 com.google.android.apps.wellbeing
     pm uninstall -k --user 0 com.google.android.apps.youtube.music
     pm uninstall -k --user 0 com.google.android.googlequicksearchbox
     pm uninstall -k --user 0 com.google.android.marvin.talkback
     pm uninstall -k --user 0 com.google.android.music
     pm uninstall -k --user 0 com.google.android.onetimeinitializer
     pm uninstall -k --user 0 com.google.android.play.games
     pm uninstall -k --user 0 com.google.android.projection.gearhead
     pm uninstall -k --user 0 com.google.android.tts
     pm uninstall -k --user 0 com.google.android.videos
     pm uninstall -k --user 0 com.huaqin.wifibtrxtx
     pm uninstall -k --user 0 com.mfashiongallery.emag
     pm uninstall -k --user 0 com.mi.android.globalminusscreen
     pm uninstall -k --user 0 com.mi.android.globalpersonalassistant
     pm uninstall -k --user 0 com.mi.AutoTest
     pm uninstall -k --user 0 com.mi.global.bbs
     pm uninstall -k --user 0 com.mi.global.shop
     pm uninstall -k --user 0 com.mi.globalbrowser
     pm uninstall -k --user 0 com.micredit.in
     pm uninstall -k --user 0 com.mipay.wallet.id
     pm uninstall -k --user 0 com.mipay.wallet.in
     pm uninstall -k --user 0 com.miui.cloudservice
     pm uninstall -k --user 0 com.miui.cloudservice.sysbase
     pm uninstall -k --user 0 com.miui.compass
     pm uninstall -k --user 0 com.miui.gallery
     pm uninstall -k --user 0 com.miui.huanji
     pm uninstall -k --user 0 com.miui.hybrid
     pm uninstall -k --user 0 com.miui.hybrid.accessory
     pm uninstall -k --user 0 com.miui.klo.bugreport
     pm uninstall -k --user 0 com.miui.micloudsync
     pm uninstall -k --user 0 com.miui.newmidrive
     pm uninstall -k --user 0 com.miui.player
     pm uninstall -k --user 0 com.miui.translation.kingsoft
     pm uninstall -k --user 0 com.miui.translation.youdao
     pm uninstall -k --user 0 com.miui.translationservice
     pm uninstall -k --user 0 com.miui.videoplayer
     pm uninstall -k --user 0 com.miui.weather2
     pm uninstall -k --user 0 com.miui.yellowpage
     pm uninstall -k --user 0 com.monotype.android.font.foundation
     pm uninstall -k --user 0 com.monotype.android.font.samsungone
     pm uninstall -k --user 0 com.netflix.mediaclient
     pm uninstall -k --user 0 com.netflix.partner.activation
     pm uninstall -k --user 0 com.opera.browser
     pm uninstall -k --user 0 com.opera.preinstall
     pm uninstall -k --user 0 com.samsung.android.wellbeing
     pm uninstall -k --user 0 com.spotify.music
     pm uninstall -k --user 0 com.swiftkey.swiftkeyconfigurator
     pm uninstall -k --user 0 com.touchtype.swiftkey
     pm uninstall -k --user 0 com.xiaomi.glgm
     pm uninstall -k --user 0 com.xiaomi.joyose
     pm uninstall -k --user 0 com.xiaomi.mbnloader
     pm uninstall -k --user 0 com.xiaomi.mi_connect_service
     pm uninstall -k --user 0 com.xiaomi.midrop
     pm uninstall -k --user 0 com.xiaomi.mipicks
     pm uninstall -k --user 0 com.xiaomi.mirecycle
     pm uninstall -k --user 0 com.xiaomi.oversea.ecom
     pm uninstall -k --user 0 com.xiaomi.payment
     pm uninstall -k --user 0 com.yandex.zen
     pm uninstall -k --user 0 com.yandex.zenkitpartnerconfig
     pm uninstall -k --user 0 com.zhiliaoapp.musically
     pm uninstall -k --user 0 in.amazon.mShop.android.shopping
     pm uninstall -k --user 0 ru.yandex.money
     pm uninstall -k --user 0 ru.yandex.money.service
     pm uninstall -k --user 0 ru.yandex.searchplugin
     pm uninstall -k --user 0 uninstall.voice.activation
     cmd shortcut reset-all-throttling
     pm bg-dexopt-job
     pm compile -a -f --check-prof false --compile-layouts
     pm compile -a -f --check-prof false -m speed; fi 
 fi

### ANDROID SECTION STOPPED HERE

if [ ! -f /sbin/f2fs-hot.list ] ; then
if grep -q f2fs "$fstab" ; then
if [ $firstrun = yes ] ; then
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
fi
fi

chmod 666 /sys/module/sync/parameters/fsync_enabled
chown root /sys/module/sync/parameters/fsync_enabled
echo "Y" > /sys/module/sync/parameters/fsync_enabled







# IRQ
# manually set irq but not working for me - but already set as kernel parameter in bootargs so delete irqbalance. hijacking /proc/cmdline probably doesnt do anything on other devices. unless the kernel is compiled with support to pickup on parameters which isnt the case of openwrt. double check if parameters get applied. otherwise its only true for x86
#for i in /proc/irq/*; do $(if [ -d $i ]; then echo '1' | sudo tee $i/smp_affinity || true ; else echo '1' | sudo tee $i || true ; fi) ; done






    ### < RANDOM PER DEVICE STUFF >


    ### modprobe kmods
modprobe deflate crypto_acompress zlib_deflate zlib_inflate configs nft_numgen nls_utf8 dns_resolver cryptodev jitterentropy_rng xt_FLOWOFFLOAD tcp_bbr bfq nft_flow_offload loop rng urngd urandom_seed nf_flow_table_inet nf_flow_table_ipv4 cachefiles fscache

if ifconfig | grep -q "phy\|wlan\|radio" ; then modprobe lib80211_crypt_ccmp cfg80211 mac80211 lib80211 ; fi

if $wrt && grep -q "ppp" $iface ; then modprobe pppox pppoe ppp_mppe ppp_generic ppp_async ralink-gdma ; fi


# blacklist
if $(! grep -q mac_hid /etc/modprobe.d/nomisc.conf) ; then
echo 'blacklist pcspkr
blacklist snd_pcsp
blacklist lpc_ich
blacklist gpio-ich
blacklist iTCO_wdt
blacklist joydev
blacklist mousedev
blacklist mac_hid
blacklist uvcvideo
'"$scsiblack"'
'"$cecblack"'' | tee /etc/modprobe.d/nomisc.conf ; fi


  #
    systemctl daemon-reload
    $s pkill -f systemd-corecump


# if anacron no cron
if $(! $debian) ; then
if systemctl list-unit-files | grep -q anacron ; then systemctl disable cron && systemctl mask cron ; else systemctl start cron && systemctl enable cron && /etc/init.d/cron start && /etc/initd.cron enable; fi ; fi









# stop some kmod for all but wrt again
if $(! $wrt) && [ ! $ipv6 = on ] ; then echo "blacklist ipv6" | sudo tee /etc/modprobe.d/blacklist-ipv6.conf ; fi

if [ $ipv6 = on ] ; then rm -rf /etc/modprobe.d/blacklist-ipv6.conf ; fi


# blacklist old radeon cards - if you cant boot remove this blacklist
#if $(! grep -q "blacklist radeon" /etc/modprobe.d/radeon.conf) ; then echo "blacklist radeon" | sudo tee /etc/modprobe.d/radeon.conf ; fi




# if dbusbroker stop dbus - buggy for me
# if systemctl list-unit-files | grep dbus-broker ; then systemctl enable dbus-broker && systemctl start dbus-broker && systemctl disable dbus && systemctl mask dbus ; fi




#journalctl --vacuum-size=100M
#journalctl --vacuum-time=2weeks


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


# compare par to cmdline, if not equal update. fkn bugs everywhere
grubpar=$(awk '/GRUB_CMDLINE_LINUX_DEFAULT/ { print }' /etc/default/grub | sed 's/GRUB_CMDLINE_LINUX_DEFAULT="//g' | sed 's/"//g')
cmdlinepar=$(cat /proc/cmdline)
if [ "$grubpar" = "$cmdlinepar" ] ; then echo "no parameter bugs" ; else grub-mkconfig ; fi

### reapply updated parameters
$s update-grub



scriptdir=$(echo "$( pwd; )/$( basename -- "$0"; )")

if [ $override = yes ] ; then
sed 's/script_autoupdate="yes/script_autoupdate=no/g' "$scriptdir"
if $droidprop ; then \cp -f "$scriptdir" /etc/bak/data/adb/service.d
if $(! grep -q mitigations /proc/cmdline) ; then ln -s "$scriptdir" /etc/init.d/init.sh ; fi ; fi
\cp -f "$scriptdir" /etc/rc.local ; fi


#######################!!!!!!!!!!!!!!!!!! sync values from basic-linux-setup for openwrt & linux !!!!!!!!!!!#####
if [ $script_autoupdate = yes ] && [ ! $override = yes ] ; then
# if online
ping -c3 "$ping"
  if [ $? -eq 0 ]; then echo "*BLS*=ONLINE SYNCING SCRIPTS!"
# if debian
    if $debian ; then rm -rf tmp/init.sh ; wget --connect-timeout=10 --continue -4 --retry-connrefused https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh -O tmp/init.sh ; if [ -f tmp/init.sh ] ; then rm -rf /etc/rc.local && cp tmp/init.sh /etc/rc.local && chmod +x /etc/rc.local && rm -rf tmp
    fi ; fi
# if wrt
      if $wrt ; then echo "*BLS*=OPENWRT found" &&
grep -q "ping -c3 "$ping"" /etc/rc.local
        if [ $? -eq 1 ] ; then echo "*BLS*=OPENWRT found but no rc.local. adding now!" && echo "$wrtsh" | tee /etc/rc.local && sed -i 's/$ping/'"$ping"'/g' /etc/rc.local && chmod +x /etc/rc.local ; else echo "*BLS*=rc.local up to date"
        fi
      fi
# if android
          if [ -f $droidprop ] ; then rm -rf init.sh && "$bb"wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh && if [ -f /system/xbin/sh ] ; then sed -i 's/#!\/bin\/sh/#!\'"$droidshell"'/g' init.sh ; else sed -i 's/#!\/bin\/sh/#!\/system\/bin\/sh/g' init.sh ; fi ; "$bb"chmod 755 init.sh ; "$bb"chmod +x init.sh ; "$bb"cp init.sh /data/adb/service.d/init.sh ; if "$(cat /proc/cmdline )" | "$(! grep -q mitigations)" ; then ln -s /data/adb/service.d/init.sh /system/etc/init.d/init.sh ; ln -s /data/adb/service.d/init.sh /system/etc/rc.local ; fi
### download browser stuff for android - leave this out for now the setup of flags for x86 doesnt work well on android
#if $(! grep -q quic /data/data/com.android.chrome/app_chrome/Default/Preferences) ; then wget https://github.com/thanasxda/basic-linux-setup/blob/master/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Default/Preferences ; "$bb"cp -f Preferences /data/data/com.android.chrome/app_chrome/Default/Preferences ; wget https://github.com/thanasxda/basic-linux-setup/raw/master/.basicsetup/.config/BraveSoftware/Brave-Browser-Nightly/Local%20State ; "$bb"cp -f "Local State" "/data/data/com.android.chrome/app_chrome/Local State" ; fi
          fi
# general devices and other distros
            elif ping -c3 "$ping"
[ $? -eq 0 ] && $(! $wrt) ; then -rm -rf /tmp/init.sh ; wget --continue -4 --retry-connrefused https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh -O /tmp/init.sh && cp /tmp/init.sh /etc/rc.local && chmod +x /etc/rc.local
  fi
fi
#######################!!!!!!!!!!!!!!!!!! sync values from basic-linux-setup for openwrt & linux !!!!!!!!!!!#####




service procps force-reload






# disable bluetooth for all but android
if [ ! -f $droidprop ] ; then systemctl disable bluetooth && systemctl mask bluetooth ; else echo "blacklist btusb" | sudo tee /etc/modprobe.d/blacklist-bluetooth.conf && echo "blacklist hci_uart" | sudo tee -a /etc/modprobe.d/blacklist-bluetooth.conf ; fi






        ### < SERVICES >



disableserv=$(systemctl list-unit-files | grep "$disable_services" | grep enabled | awk -F '.' '{print $1}' | grep -v "$exclude_from_disabling" | awk -v RS=  '{$1=$1}1')
maskdisable=$(systemctl list-unit-files | grep "$disable_services" | grep enabled | grep -v "mask" | awk -F '.' '{print $1}' | grep -v "$exclude_from_disabling" | awk -v RS=  '{$1=$1}1')

#startserv=$(systemctl list-unit-files | grep "$enable_services" | grep disabled | awk '{print $1}')
#maskenable=$(systemctl list-unit-files | grep "$enable_services" | grep "disabled\|mask" | awk '{print $1}')

# dunno if mdadm is needed for raid. checkout to be sure
if $(! $wrt) ; then  systemctl disable ModemManager && systemctl mask ModemManager &&
systemctl stop $disableserv
systemctl disable $disableserv
systemctl mask $maskdisable

#systemctl unmask $maskenable
#systemctl start --now $startserv
#systemctl enable $startserv
fi

if $(! grep -q "ipv6.conf.all.disable_ipv6" /etc/sysctl.conf) || [ $ipv6 = on ] ; then
echo 'net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv6.conf.all.accept_ra = 1' | tee -a /etc/sysctl.d/sysctl.conf /etc/sysctl.conf $droidsysctl
sed -i 's/net.ipv6.conf.all.disable_ipv6.*/net.ipv6.conf.all.disable_ipv6 = 0/g'
sed -i 's/net.ipv6.conf.default.disable_ipv6.*/net.ipv6.conf.default.disable_ipv6 = 0/g'
sed -i 's/net.ipv6.conf.lo.disable_ipv6.*/net.ipv6.conf.lo.disable_ipv6 = 0/g'
sed -i 's/net.ipv6.conf.all.accept_ra.*/net.ipv6.conf.all.accept_ra = 1/g'
else echo 'net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.all.accept_ra = 0' | tee -a /etc/sysctl.d/sysctl.conf /etc/sysctl.conf $droidsysctl
sed -i 's/net.ipv6.conf.all.disable_ipv6.*/net.ipv6.conf.all.disable_ipv6 = 1/g'
sed -i 's/net.ipv6.conf.default.disable_ipv6.*/net.ipv6.conf.default.disable_ipv6 = 1/g'
sed -i 's/net.ipv6.conf.lo.disable_ipv6.*/net.ipv6.conf.lo.disable_ipv6 = 1/g'
sed -i 's/net.ipv6.conf.all.accept_ra.*/net.ipv6.conf.all.accept_ra = 0/g' ; fi















### c compiler exports ... no more o3? for future of script stuff if i ever will work on it... unfinished
if [ skip = false ] ; then
if echo $CC | grep -q "gcc\|llvm\|clang" ; then

if [ $ARCH = x86 ] ; then export opt=native ; fi

if [ $ARCH = arm64 ]; then
export KBUILD_CFLAGS+= -fuse-ld=ld.gold
export LDFLAGS+= -plugin LLVMgold.so
else export KBUILD_CFLAGS+= -fuse-ld=lld ; fi

#polly=/usr/lib/llvm*/lib/LLVMPolly.so
#ldgold=/usr/lib/llvm*/lib/LLVMgold.so

export LDFLAGS_MODULE= --strip-debug

export LDFLAGS+= -O3 -plugin-opt=-function-sections \
                  -plugin-opt=-data-sections \
                  -plugin-opt=new-pass-manager \
                  -plugin-opt=O3 \
                  -plugin-opt=mcpu=$opt

export KBUILD_USERCFLAGS:= -Wall -Wmissing-prototypes \
                           -Wstrict-prototypes \
                           -O3 -fomit-frame-pointer -std=gnu89

if [ $CC = llvm ] ; then
export KBUILD_CFLAGS+=  -mllvm -polly \
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
                        -mllvm -polly-parallel ;
                        export LDFLAGS += -plugin LLVMPolly.so ; fi

cflags="--param=ssp-buffer-size=32 \
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
        -mabi=$opt \
        -mcpu=$opt \
        -mfloat-abi=$opt \
        -mfpu=$opt \
        -mtune=$opt \
        -O3 \
        -pipe \
        -pthread \
        -Wall \
        -Wno-error \
        -Wno-format-security \
        -Wno-frame-address \
        -Wno-maybe-uninitialized \
        -Wno-trigraphs \
        -Wundef"


      # -fgraphite-identity -floop-strip-mine -floop-nest-optimize -fno-semantic-interposition -fipa-pta -flto -fdevirtualize-at-ltrans -flto-partition=one

export KBUILD_CFLAGS:= "$cflags"

export subdir-ccflags-y:= "$cflags"

ccg=gcc-"$(apt-cache search gcc | awk '{print $1}' | grep "gcc-.*-linux-gnu" | cut -c5-6 | sort -n | tail -n 1)"
ccl=llvm-"$(apt-cache search llvm | awk '{print $1}' | grep "llvm-.*-runtime" | sort -n | tail -n 1 | cut -c6-7)"
#ccl=llvm-"$(apt-cache search llvm | awk '{print $1}' | grep llvm- | tail  | head -n 1 | cut -c6-7)"

if [ $CC = gcc ] ; then export CC=$ccg ; fi

if [ $CC = llvm ] ; then export CC=$ccl ; fi
fi
fi




# interesting stuff not yet included will be placed here:
# https://docs.kernel.org/admin-guide/bcache.html https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/snapshot/bcache-tools-1.1.tar.gz






if [ $restore_backup = yes ] ; then \cp -rf /etc/bak/* / ; rm -rf /DO_NOT_DELETE ; fi

if [ $uninstall = yes ] ; then
rm -rf /etc/environment.d/10-config.dat /etc/crontabs /etc/crontab /etc/anacrontab /etc/update_hosts.sh /root/cmdline /etc/root/cmdline /system/etc/root/cmdline /system/etc/init.d/init.sh /etc/sysctl.conf /etc/sysctl.d/sysctl.conf /etc/rc.local /data/adb/post-fs-data.d/init.sh /data/adb/service.d/init.sh ; \cp -rf /etc/bak/* /
if grep -q mitigations=off /etc/default/grub ; then sed -i '/GRUB_CMDLINE_LINUX=/c\GRUB_CMDLINE_LINUX="splash quiet"' /etc/default/grub ; sed -i '/GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"' /etc/default/grub ; fi
if grep -q "cmdline" /etc/fstab "$fstab" ; then sed -i '/cmdline/c\' "$fstab" ; fi
rm -rf /DO_NOT_DELETE ; rm -rf /etc/sysctl.d/sysctl.conf ; fi

    "$bb"mount -t pstore none /sys/fs/pstore 
    "$bb"mount -t tracefs none /sys/kernel/tracing
    "$bb"mount -t tracefs none /sys/kernel/debug/tracing
    "$bb"mount -t cgroup2 none /sys/fs/cgroup
    "$bb"mount -t cgroup none /dev/memcg
    "$bb"mount -t cgroup none /dev/cpuctl
    "$bb"mount -t cgroup none /acct
    "$bb"mount -t debugfs none /sys/kernel/debug
    "$bb"umount pstore
    "$bb"umount tracefs
    "$bb"umount cgroup2
    "$bb"umount cgroup
    "$bb"umount debugfs

    # remount ro android

    if [ $firstrun = yes ] ; then
    "$bb"mount -o remount,rw /cache
    rm -rf /cache/*
    rm -rf /data/cache/*
    rm -rf /data/dalvik-cache/*
    "$bb"fstrim /cache ; fi

    if [ -f $droidprop ] ; then
    "$bb"mount -o remount,ro /system
    "$bb"mount -o remount,ro /vendor
    #"$bb"mount -o remount,ro /data
    "$bb"mount -o remount,ro rootfs /
    #"$bb"mount -o ro /dev/block/bootdevice/by-name/data /data
    "$bb"mount -o ro /dev/block/bootdevice/by-name/vendor /vendor
    "$bb"mount -o ro /dev/block/bootdevice/by-name/system /system ; fi

if [ $firstrun = yes ] ; then rm -rf ~/.config/kdeconnect /home/$(getent passwd | grep 1000 | awk -F ':' '{print $1}')/.config/kdeconnect ; fi

# drop all caches upon finalizing
    sysctl -w vm.drop_caches=3
    if [ $? = 1 ] ; then echo 3 > /proc/sys/vm/drop_caches ; fi

setenforce 1

#tuned -p network-throughput

echo "script ran from $scriptdir"

######
### still configuring this script, tips are welcome
### might still contain double or bad values...
exit 0
