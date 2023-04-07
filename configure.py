#!/usr/bin/env python3
# basic-linux-setup @ github.com/thanasxda
# run script as sudo for permissions
# not aiming for perfection here, just quick config
# this script creates a local configuration...
# which overrides the setup defaults even when syncing

# import tkinter & os libs
from tkinter import *
import os
import subprocess
from PIL import Image, ImageTk
import importlib

# main window
root = Tk()
root.title('basic-linux-setup')

# logo
path = ".basicsetup/logo.png"
load = Image.open(path)
load.resize((170,150), Image.Resampling.LANCZOS)
render = ImageTk.PhotoImage(load)
root.iconphoto(False, render)
cv = Canvas(root, highlightthickness=0, height=80, width=340)
cv['bg']='black'
cv.grid(column=1, columnspan=2)
cv.create_image(170, 0, image=render, anchor='n')

# sysctl manager
def run_external_script():
    if not run_external_script.clicked:
        run_external_script.clicked = True
        subprocess.run(["sudo", "python", "sysctl.py"])
        run_external_script.clicked = False

# service manager
def run_external_script0():
    if not run_external_script.clicked:
        run_external_script.clicked = True
        subprocess.run(["sudo", "python", "services.py"])
        run_external_script.clicked = False
        
# log analyzer
def run_external_script1():
    if not run_external_script.clicked:
        run_external_script.clicked = True
        subprocess.run(["sudo", "python", "log.py"])
        run_external_script.clicked = False

run_external_script.clicked = False

# checkboxes
cb0 = IntVar()
cb1 = IntVar()
cb2 = IntVar()
cb3 = IntVar()
cb4 = IntVar()
cb5 = IntVar()
cb6 = IntVar()
cb7 = IntVar()
cb8 = IntVar()
cb9 = IntVar()
cb10 = IntVar()
cb11 = IntVar()

# column 1
cbb0 = Checkbutton(root, text="disable mitigations", variable=cb0, onvalue=1, offvalue=0).grid(row=3, column=1)
cbb1 = Checkbutton(root, text="enable bluetooth", variable=cb1, onvalue=1, offvalue=0).grid(row=4, column=1)
cbb2 = Checkbutton(root, text="enable ipv6", variable=cb2, onvalue=1, offvalue=0).grid(row=5, column=1)
cbb3 = Checkbutton(root, text="disable nobarrier", variable=cb3, onvalue=1, offvalue=0).grid(row=6, column=1)
cbb4 = Checkbutton(root, text="enable kernel samepage merging", variable=cb4, onvalue=1, offvalue=0).grid(row=7, column=1)
cbb5 = Checkbutton(root, text="enable cpu microcode updates", variable=cb5, onvalue=1, offvalue=0).grid(row=8, column=1)
cbb6 = Checkbutton(root, text="enable raid/lvm/crypt", variable=cb6, onvalue=1, offvalue=0).grid(row=9, column=1)
cbb7 = Checkbutton(root, text="disable ethernet link auto-negotiation", variable=cb7, onvalue=1, offvalue=0).grid(row=10, column=1)
cbb8 = Checkbutton(root, text="disable ethernet offloading", variable=cb8, onvalue=1, offvalue=0).grid(row=11, column=1)
cbb9 = Checkbutton(root, text="enable auto-update script", variable=cb9, onvalue=1, offvalue=0).grid(row=12, column=1)
cbb10 = Checkbutton(root, text="enable audit", variable=cb10, onvalue=1, offvalue=0).grid(row=13, column=1)
cbb11 = Checkbutton(root, text="disable webcam", variable=cb11, onvalue=1, offvalue=0).grid(row=14, column=1)

# entries
Label(root, text='config level: low/medium/morethanmedium/high').grid(row=15, column=1)
level = StringVar(root, value='high')
levelTf = Entry(root, textvariable=level).grid(row=16, column=1)

# column 2
Label(root, text='log level: ').grid(row=1, column=2)
logl = StringVar(root, value='5')
loglTf = Entry(root, textvariable=logl).grid(row=2, column=2)
Label(root, text='1=info 7=default').grid(row=3, column=2)

Label(root, text='tcp queue disc management: ').grid(row=4, column=2)
tcpq = StringVar(root, value='fq_codel')
tcpqTf = Entry(root, textvariable=tcpq).grid(row=5, column=2)

Label(root, text='wireless-regdb: ').grid(row=6, column=2)
wreg = StringVar(root, value='00')
wregTf = Entry(root, textvariable=wreg).grid(row=7, column=2)

Label(root, text='dns server ipv4 #1: ').grid(row=8, column=2)
dns = StringVar(root, value='1.1.1.1')
dnsTf = Entry(root, textvariable=dns).grid(row=9, column=2)

Label(root, text='dns server ipv4 #2: ').grid(row=10, column=2)
dns2 = StringVar(root, value='1.0.0.1')
dns2Tf = Entry(root, textvariable=dns2).grid(row=11, column=2)

Label(root, text='ethernet duplex: ').grid(row=12, column=2)
ethd = StringVar(root, value='full')
ethdTf = Entry(root, textvariable=ethd).grid(row=13, column=2)

cat="cat /sys/block/*/queue/scheduler"
output = subprocess.check_output(cat, shell=True)
Label(root, text='i/o scheduler: ').grid(row=14, column=2)
sched = StringVar(root, value='bfq')
schedTf = Entry(root, textvariable=sched).grid(row=15, column=2)
Label(root, text=output).grid(row=16, column=2)

btn3 = Button(root, text='Sysctl manager', command=run_external_script)
btn3.grid(row=17, column=2)

btn4 = Button(root, text='Service manager', command=run_external_script0)
btn4.grid(row=18, column=2)

# column 3
Label(root, text='dns server ipv6 #1: ').grid(row=1, column=3)
dns6 = StringVar(root, value='2606:4700:4700::1111')
dns6Tf = Entry(root, textvariable=dns6).grid(row=2, column=3)

Label(root, text='dns server ipv6 #2: ').grid(row=3, column=3)
dns62 = StringVar(root, value='2606:4700:4700::1001')
dns62Tf = Entry(root, textvariable=dns62).grid(row=4, column=3)

Label(root, text='txqueuelen: ').grid(row=5, column=3)
txq = StringVar(root, value='128')
txqTf = Entry(root, textvariable=txq).grid(row=6, column=3)

Label(root, text='mtu: ').grid(row=7, column=3)
mtu = StringVar(root, value='1500')
mtuTf = Entry(root, textvariable=mtu).grid(row=8, column=3)

Label(root, text='wi-fi beacons: ').grid(row=9, column=3)
wbeac = StringVar(root, value='50')
wbeacTf = Entry(root, textvariable=wbeac).grid(row=10, column=3)

Label(root, text='ethernet rx/tx: ').grid(row=11, column=3)
ethx = StringVar(root, value='4096')
ethxTf = Entry(root, textvariable=ethx).grid(row=12, column=3)

Label(root, text='cpu governor: ').grid(row=13, column=3)
gov = StringVar(root, value='performance')
govTf = Entry(root, textvariable=gov).grid(row=14, column=3)
Label(root, text='performance schedutil ondemand etc').grid(row=15, column=3)

btn4 = Button(root, text='Log analyzer', command=run_external_script1)
btn4.grid(row=17, column=3)

# column 4
Label(root, text='wi-fi fragmentation threshold: ').grid(row=1, column=4)
wfrag = StringVar(root, value='2346')
wfragTf = Entry(root, textvariable=wfrag).grid(row=2, column=4)

Label(root, text='wi-fi rts/cts: ').grid(row=3, column=4)
wrts = StringVar(root, value='2347')
wrtsTf = Entry(root, textvariable=wrts).grid(row=4, column=4)

Label(root, text='wi-fi tx power: ').grid(row=5, column=4)
wtx = StringVar(root, value='auto')
wtxTf = Entry(root, textvariable=wtx).grid(row=6, column=4)

Label(root, text='wi-fi powersaving: ').grid(row=7, column=4)
wps = StringVar(root, value='off')
wpsTf = Entry(root, textvariable=wps).grid(row=8, column=4)

Label(root, text='wi-fi ap distance: ').grid(row=9, column=4)
wdis = StringVar(root, value='10')
wdisTf = Entry(root, textvariable=wdis).grid(row=10, column=4)

Label(root, text='transparant hugepages: ').grid(row=11, column=4)
thp = StringVar(root, value='madvise')
thpTf = Entry(root, textvariable=thp).grid(row=12, column=4)

cat="cat /proc/sys/net/ipv4/tcp_allowed_congestion_control"
output = subprocess.check_output(cat, shell=True)
Label(root, text="tcp congestion algorithm: ").grid(row=13, column=4)
tcpc = StringVar(root, value='bbr')
tcpcTf = Entry(root, textvariable=tcpc).grid(row=14, column=4)
Label(root, text=output).grid(row=15, column=4)

# column 5
Label(root, text='additional cmdline params: ').grid(row=1, column=5)
cmdl = StringVar(root, value='')
cmdlTf = Entry(root, textvariable=cmdl).grid(row=2, column=5)

Label(root, text='compositor: x11 wayland').grid(row=3, column=5)
comp = StringVar(root, value='x11')
compTf = Entry(root, textvariable=comp).grid(row=4, column=5)

Label(root, text='idle: ').grid(row=5, column=5)
idle = StringVar(root, value='nomwait')
idleTf = Entry(root, textvariable=idle).grid(row=6, column=5)

Label(root, text='cpu max cstate: ').grid(row=7, column=5)
cstate = StringVar(root, value='9')
cstateTf = Entry(root, textvariable=cstate).grid(row=8, column=5)

Label(root, text='additional hosts blocklists: ').grid(row=9, column=5)
list1 = StringVar(root, value='')
list2 = StringVar(root, value='')
list3 = StringVar(root, value='')
list1Tf = Entry(root, textvariable=list1).grid(row=10, column=5)
list2Tf = Entry(root, textvariable=list2).grid(row=11, column=5)
list3Tf = Entry(root, textvariable=list3).grid(row=12, column=5)

Label(root, text='script rawlink: ').grid(row=13, column=5)
rlink = StringVar(root, value='https://raw.github.usercontent.com/thanasxda/basic-linux-setup/master/init.sh')
rlinkTf = Entry(root, textvariable=rlink).grid(row=14, column=5)

# permissions
os.seteuid(1000)

# generate local config 
def addConf():
    os.system("git config --global --add safe.directory $PWD ; sudo rm -rf $PWD/.blsconfig")
    config = ''
    config += "compositor=" + comp.get()
    config += "\n" + "tcp_con=" + tcpc.get()
    config += "\n" + "qdisc=" + tcpq.get()
    config += "\n" + "country=" + wreg.get()
    config += "\n" + "dns1=" + dns.get()
    config += "\n" + "dns2=" + dns2.get()
    config += "\n" + "dns61=" + dns6.get()
    config += "\n" + "dns62=" + dns62.get()
    config += "\n" + "qdisc=" + tcpq.get()
    config += "\n" + "sched=" + sched.get()
    config += "\n" + "hdsched=" + sched.get()
    config += "\n" + "sdsched=" + sched.get()
    config += "\n" + "txqueuelen=" + txq.get()
    config += "\n" + "mtu=" + mtu.get()
    config += "\n" + "beacons=" + wbeac.get()
    config += "\n" + "governor=" + gov.get()
    config += "\n" + "frag=" + wfrag.get()
    config += "\n" + "rts=" + wrts.get()
    config += "\n" + "txpower=" + wtx.get()
    config += "\n" + "pwsrsave=" + wps.get()
    config += "\n" + "distance=" + wdis.get()
    config += "\n" + "thp=" + thp.get()
    config += "\n" + "loglevel=" + logl.get()
    config += "\n" + "idle=" + idle.get()
    config += "\n" + "maxcstate=" + cstate.get()
    config += "\n" + "list1=" + list1.get()
    config += "\n" + "list2=" + list2.get()
    config += "\n" + "list3=" + list3.get()
    config += "\n" + "rawlink=" + rlink.get()
    config += "\n" + "duplex=" + ethd.get()
    config += "\n" + "rx=" + ethx.get()
    config += "\n" + "tx=" + ethx.get()

    if cmdl.get():
        config += "\n" + "additional_cmdline=" + str("\"") + cmdl.get() + str("\"")
    if level.get() == str("morethanmedium"):
        config += "\n" + "morethanmedium=on"
    else:
        config += "\n" + "level=" + level.get()    
    if cbb0 == 1:
        config += "\n" + "mitigations=off"
    else:
        config += "\n" + "mitigations=on"
    if cbb1 == 1:
        config += "\n" + "bluetooth=on"
    else:
        config += "\n" + "bluetooth=off"
    if cbb2 == 1:
        config += "\n" + "ipv6=on"
    else:
        config += "\n" + "ipv6=off"
    if cbb3 == 1:
        config += "\n" + "nobarrier=off"
    else:
        config += "\n" + "nobarrier=on"
    if cbb4 == 1:
        config += "\n" + "ksm=1"
    else:
        config += "\n" + "ksm=0"
    if cbb5 == 1:
        config += "\n" + "microcode=on"
    else:
        config += "\n" + "microcode=off"
    if cbb6 == 1:
        config += "\n" + "raid=yes"
        config += "\n" + "lvm=yes"
        config += "\n" + "crypt=yes"
    else:
        config += "\n" + "raid=no"
        config += "\n" + "lvm=no"
        config += "\n" + "crypt=no"
    if cbb7 == 1:
        config += "\n" + "autoneg=off"
    else:
        config += "\n" + "autoneg=on"
    if cbb8 == 1:
        config += "\n" + "fl=off"
    else:
        config += "\n" + "fl=on"
    if cbb9 == 1:
        config += "\n" + "script_autoupdate=yes"
    else:
        config += "\n" + "script_autoupdate=no"
    if cbb10 == 1:
        config += "\n" + "audit=1"
    else:
        config += "\n" + "audit=0"
    if cbb11 == 1:
        config += "\n" + "webcam=no"
    else:
        config += "\n" + "webcam=yes"
    
    os.system("echo '"+config+"' | sudo tee $PWD/.blsconfig ; sudo cp $PWD/.blsconfig /etc/.blsconfig")

btn = Button(root, text='Save', command=addConf)
btn.grid(row=17, column=1)

# apply config
def applyConf():
    os.system("sudo cp $PWD/configure.py /etc/configure.py ; sudo cp $PWD/services.py /etc/services.py ; sudo cp $PWD/sysctl.py /etc/sysctl.py ; sudo cp $PWD/log.py /etc/log.py ; if [ -e $PWD/init.sh ] ; then sudo cp init.sh /etc/rc.local ; fi ; sudo sh /etc/rc.local")

btn2 = Button(root, text='Apply', command=applyConf)
btn2.grid(row=18, column=1)

Label(root, text='by thanasxda').grid(row=18, column=5)

root.mainloop()
