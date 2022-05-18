dotfiles
========

My dotfiles, updated only when I set up a new computer


## TP Link Wifi dongle
https://github.com/cilynx/rtl88x2bu.git

```bash
VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
sudo dkms add -m rtl88x2bu -v ${VER}
sudo dkms build -m rtl88x2bu -v ${VER}
sudo dkms install -m rtl88x2bu -v ${VER}
sudo modprobe 88x2bu
```
To see wifi signal strength
```
nmcli dev wifi
```

## Printer Cannon MG 5200

[follow the doc](https://medium.com/@domdomegg/installing-canon-mg5200-series-drivers-on-ubuntu-20-04-868bfa0e2ac5)


## Zoom too big on 4k screen:
Setting `autoScale=false` in ~/.config/zoomus.conf

￼
## dmesg restricted for user
```
sudo sysctl kernel.dmesg_restrict=0
```
