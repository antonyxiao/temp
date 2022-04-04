confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            exit
    esac
}

confirm "Would you like to perform update/dist-upgrade/auto-remove/clean?"
sudo apt update
sudo apt --auto-remove dist-upgrade
sudo apt clean
sudo apt install -y python3 python3-pip git jupyter neofetch neovim default-jdk default-jre tree tmux unzip wget

# For raspberry pi - power/ethernet through USB-C
confirm "Would you like to configure the raspberry pi?"
sudo echo "dtoverlay=dwc2" >> /boot/config.txt
sudo echo "modules-load=dwc2" >> /boot/cmdline.txt
sudo touch /boot/ssh
sudo echo "libcomposite" >> /etc/modules
# if dhcpcd.conf does not exit
[ ! -f /etc/dhcpcd.conf ] && sudo touch /etc/dhcpcd.conf
sudo echo "denyinterfaces usb0" >> /etc/dhcpcd.conf

sudo apt-get install -y dnsmasq
sudo touch /etc/dnsmasq.d/usb
sudo echo "interface=usb0" >> /etc/dnsmasq.d/usb
sudo echo "dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h" >> /etc/dnsmasq.d/usb
sudo echo "dhcp-option=3" >> /etc/dnsmasq.d/usb
sudo echo "leasefile-ro" >> /etc/dnsmasq.d/usb

sudo touch /etc/network/interfaces.d/usb0
sudo echo "auto usb0
allow-hotplug usb0
iface usb0 inet static
  address 10.55.0.1
  netmask 255.255.255.248" >> /etc/network/interfaces.d/usb0

sudo touch /root/usb.sh
sudo echo "#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p pi4
cd pi4
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol
mkdir -p strings/0x409
echo \"fedcba9876543211\" > strings/0x409/serialnumber
echo \"Ben Hardill\" > strings/0x409/manufacturer
echo \"PI4 USB Device\" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo \"Config 1: ECM network\" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
# see gadget configurations below
# End functions
mkdir -p functions/ecm.usb0
HOST=\"00:dc:c8:f7:75:14\" # \"HostPC\"
SELF=\"00:dd:dc:eb:6d:a1\" # \"BadUSB\"
echo \$HOST > functions/ecm.usb0/host_addr
echo \$SELF > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
udevadm settle -t 5 || :
ls /sys/class/udc > UDC
ifup usb0
service dnsmasq restart" >> /root/usb.sh
sudo chmod +x /root/usb.sh

touch temp_rc_local
sed '/exit\ 0/i /root/usb.sh' /etc/rc.local > temp_rc_local
cat temp_rc_local > /etc/rc.local
rm temp_rc_local
