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

# basic preconfig openwrt/x-wrt

pkglist="base-files bridger busybox ca-bundle dnsmasq dropbear ethtool firewall4 fstools haveged htop iptables-mod-conntrack-extra iptables-mod-ipopt iptables-nft irqbalance kernel kmod kmod-asn1-decoder kmod-br-netfilter kmod-cfg80211 kmod-crypto-acompress kmod-crypto-aead kmod-crypto-arc4 kmod-crypto-cbc kmod-crypto-ccm kmod-crypto-cmac kmod-crypto-crc32c kmod-crypto-ctr kmod-crypto-cts kmod-crypto-des kmod-crypto-ecb kmod-crypto-gcm kmod-crypto-gf128 kmod-crypto-ghash kmod-crypto-hash kmod-crypto-hmac kmod-crypto-kpp kmod-crypto-lib-chacha20 kmod-crypto-lib-chacha20poly1305 kmod-crypto-lib-curve25519 kmod-crypto-lib-poly1305 kmod-crypto-manager kmod-crypto-md4 kmod-crypto-md5 kmod-crypto-null kmod-crypto-rng kmod-crypto-seqiv kmod-crypto-sha1 kmod-crypto-sha256 kmod-crypto-sha512 kmod-cryptodev kmod-dnsresolver kmod-gpio-button-hotplug kmod-ifb kmod-iosched-bfq kmod-ipt-conntrack kmod-ipt-conntrack-extra kmod-ipt-core kmod-ipt-ipopt kmod-ipt-ipset kmod-ipt-nat kmod-ipt-offload kmod-ipt-raw kmod-iptunnel kmod-iptunnel4 kmod-ipvlan kmod-leds-gpio kmod-lib-crc-ccitt kmod-lib-crc16 kmod-lib-crc32c kmod-lib-lzo kmod-lib-textsearch kmod-lib-zlib-deflate kmod-lib-zlib-inflate kmod-lib80211 kmod-libphy kmod-loop kmod-mac80211 kmod-mppe kmod-mtd-rw kmod-nf-conntrack kmod-nf-ipt kmod-nf-log kmod-nf-nat kmod-nf-nathelper kmod-nf-nathelper-extra kmod-nf-reject kmod-nf-socket kmod-nf-tproxy kmod-nfnetlink kmod-nfnetlink-queue kmod-nft-arp kmod-nft-bridge kmod-nft-compat kmod-nft-core kmod-nft-fib kmod-nft-nat kmod-nft-netdev kmod-nft-offload kmod-nft-queue kmod-nft-socket kmod-nft-tproxy kmod-nls-base kmod-nls-utf8 kmod-oid-registry kmod-phylink kmod-ppp kmod-ppp-synctty kmod-pppoe kmod-random-core kmod-sched kmod-sched-cake kmod-sched-core kmod-sit kmod-slhc kmod-swconfig kmod-tcp-bbr kmod-tun kmod-udptunnel4 kmod-usb-core kmod-usb-ehci kmod-usb-ohci kmod-usb2 libc libgcrypt libkmod libuci2 libustream-wolfssl logd luci-app-attendedsysupgrade luci-app-bcp38 luci-app-commands luci-app-simple-adblock luci-ssl macchanger mtd netifd nftables-json odhcp6c odhcpd-ipv6only opkg ppp ppp-mod-pppoe procd procd-seccomp procd-ujail px5g-wolfssl swconfig uboot-envtools uci uclient-fetch uhttpd-mod-lua umdns urandom-seed urngd usteer wireless-regdb wireless-tools wpad-basic-wolfssl xtables-nft zlib"

wrtsh='#!/bin/bash
### get script update on reboot on /tmp/init.sh and run...
link=https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/init.sh
while [ ! -f /tmp/init.sh ];
sleep 10
do ping 1.1.1.1 -c 4
if [ $? -eq 0 ]; then wget --timeout=10 -4 "$link" -O /tmp/init.sh ; fi
if grep -q thanas /tmp/init.sh
then chmod +x /tmp/init.sh && sh /tmp/init.sh && echo "succes"; exit 0; fi
done'

### remove unused x-wrt stock packages
opkg update && opkg remove --force-removal-of-dependent-packages --force-depends luci-app-dawn luci-app-ddns luci-app-ksmbd luci-app-mwan3 luci-app-natcap luci-app-natflow-users luci-app-p910nd luci-app-xwan luci-app-upnp *dawn* *ddns* *ksmbd* *mwan* *natcap* *natflow* *p910* *xwan* *upnp* *wsdd2* *pptpd* *zh-cn* *wireguard* *wizard* *dashboard* *mesh* *macvlan*

### install some pkgs & enable
### when too lazy to compile x-wrt
echo "" && echo "" && echo $pkglist && echo "" && echo "Above is the recommended packagelist..." && echo ""
while true; do read -p "Do you have enough space installing the full packageset? type y/n, confirm with enter:" yn
case $yn in
[Yy]* ) opkg install --force-depends $pkglist ; break;;
[Nn]* ) opkg install --force-depends kmod libkmod ; break;;
* ) echo "Please answer yes or no.";;
esac ; done


if ! grep -q "rc.local" /etc/crontabs/root ; then echo "@reboot root sh /etc/rc.local >/dev/null" | tee -a /etc/crontabs/root; fi

/etc/init.d/cron start
/etc/init.d/cron enable

### touch fw_env.config
#echo -e "# MTD device name	Device offset	Env. size	Flash sector size
### WARNING MIWIFI MINI ONLY unhash for use
#/dev/mtd1               0x0000          0x1000         0x10000" | tee /etc/fw_env.config

### basic wrt config - disable kmod-nf-offload for x-wrt only
if ! grep -q "x-wrt" /etc/os-release ; then 
sed -i "/option flow_offloading/c\        option flow_offloading '1'" /etc/config/firewall
sed -i "/option flow_offloading_hw/c\        option flow_offloading_hw '1'" /etc/config/firewall ; fi
sed -i "/option max_requests/c\        option max_requests '1'" /etc/config/uhttpd
sed -i "/option redirect_https/c\        option redirect_https 'on'" /etc/config/uhttpd
sed -i "/list listen_http /c\        #list listen_http" /etc/config/uhttpd
sed -i "/option rfc1918_filter/c\        option rfc1918_filter '1'" /etc/config/uhttpd
sed -i "/option upgrade_packages/c\        option upgrade_packages '1'" /etc/config/attendedsysupgrade
sed -i "/option auto_search/c\        option auto_search '1'" /etc/config/attendedsysupgrade
sed -i "/option advanced_mode/c\        option advanced_mode '1'" /etc/config/attendedsysupgrade
sed -i "/option drop_invalid/c\        option drop_invalid '1'" /etc/config/firewall
sed -i "/option ttylogin/c\        option ttylogin '1'" /etc/config/system
sed -i "/option enabled/c\        option enabled '1'" /etc/config/system
sed -i "/option Interface/c\        option Interface 'lan'" /etc/config/dropbear
sed -i "/option PasswordAuth/c\        option PasswordAuth 'on'" /etc/config/dropbear
sed -i "/option holdoff/c\        option holdoff '1'" /etc/config/luci
sed -i "/option timeout/c\        option timeout '1'" /etc/config/luci
sed -i "/option display/c\        option display '1'" /etc/config/luci
sed -i "/option enable/c\        option enable '1'" /etc/config/luci

if ! grep ktune /etc/ppp/options ; then
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
sync
' | tee /etc/ppp/options ; fi

if [ ! -f /etc/config/wireless.bak ] ; then
### create example for /etc/config/wireless config
### vars
key='ChangeThisPassword'
mac='Sp:00:fT:h1:sM:4c'
echo -e "

config wifi-device 'radio0'
	option type 'mac80211'
	option path 'pci0000:00/0000:00:00.0/0000:01:00.0'
	option band '5g'
	option htmode 'VHT80'
	option cell_density '0'
	option wmm '1'
	option greenfield '1'
	option frameburst '1'
	option bursting '1'
	option short_gi_80 '1'
	option short_gi_40 '1'
	option short_preamble '1'
	option ht_coex '1'
	option ff '1'
	option xr '1'
	option ar '1'
	option compression '1'
	option isolate '1'
	option distance '10'
	option frag '2346'
	option rts '2347'
	option noscan '1'
	option beacon_int '50'
	option powersave '0'
	option turbo '1'
	option bgscan '0'
	option disabled '1'
	option country 'GR'
	option txpower '22'
	option channel '36'
	option vendor_vht '1'


config wifi-device 'radio1'
	option type 'mac80211'
	option path 'platform/10180000.wmac'
	option channel '1'
	option band '2g'
	option htmode 'HT40'
	option country 'GR'
	option cell_density '0'
	option wmm '1'
	option greenfield '1'
	option frameburst '1'
	option bursting '1'
	option short_gi_40 '1'
	option short_gi_20 '1'
	option short_preamble '1'
	option ht_coex '1'
	option ff '1'
	option xr '1'
	option ar '1'
	option compression '1'
	option isolate '1'
	option distance '10'
	option frag '2346'
	option rts '2347'
	option noscan '1'
	option beacon_int '50'
	option powersave '0'
	option turbo '1'
	option bgscan '0'
	option dsss_cck_40 '1'
	list ht_capab 'RXLDPC'
	list ht_capab 'TX-STBC'
	list ht_capab 'RX-STBC12'
	list ht_capab 'MAX-A-MPDU-LEN-EXP6'
	list htc_capab 'MAX-AMSDU-3839'
	option disabled '1'
	option txpower '20'
	option vendor_vht '1'


config wifi-iface 'wifinet0'
	option device 'radio0'
	option encryption 'sae'
	option skip_inactivity_poll '1'
	option disassoc_low_ack '0'
	option key '$key'
	option network 'lan'
	option macaddr '$mac'
	option mode 'ap'
	option ssid 'OpenWrt'
	option isolate '1'
	option hidden '1'
	option disabled '1'
	option rsn_preauth '1'

config wifi-iface 'default_radio1'
	option device 'radio1'
	option skip_inactivity_poll '1'
	option disassoc_low_ack '0'
	option key '$key'
	option network 'lan'
	option mode 'ap'
	option ssid 'OpenWrt'
	option isolate '1'
	option macaddr '$mac'
	option encryption 'sae-mixed'
	option disabled '1'
	option rsn_preauth '1'

" | tee /etc/config/wireless.bak ; fi

if [ ! -f /etc/pkglist.bak ] ; then
echo "$pkglist" | tee /etc/pkglist.bak ; fi

### commit changes & apply config
uci commit

### sync
echo "$wrtsh" | tee /etc/rc.local ; chmod +x /etc/rc.local ; cp /tmp/init.sh /etc/sysctl.conf ; sh /etc/rc.local 

wget https://raw.githubusercontent.com/thanasxda/basic-linux-setup/master/.basicsetup/wrt/profile -O /etc/profile


### done
reboot 
