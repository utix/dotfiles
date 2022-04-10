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
