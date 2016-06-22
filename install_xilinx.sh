#!/bin/bash
export TERM=xterm
cd /root/
# start xinetd so petalinix won't complain about missing tftp
xinetd
# add stuff to prepare.sh
cat add_to_prepare >> /root/prepare.sh

# install vivado
/xilinstall/Xilinx_Vivado_SDK_2016.1_0409_1/xsetup -b Install --agree XilinxEULA,3rdPartyEULA,WebTalkTerms -c install_config.txt

# remove this outdated lib, otherwise firefox doesn't start
rm -rf /opt/Xilinx/Vivado/2016.1/ids_lite/ISE/lib/lin64/libstdc++.so

# install petalinux
expect accept.exp

# install cable-driver
cd /opt/Xilinx/Vivado/2016.1/data/xicom/cable_drivers/lin64/install_script/install_drivers/
./install_drivers

