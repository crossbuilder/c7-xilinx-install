FROM crossbuilder/c7-xilinx-base:testing

MAINTAINER crossbuilder

LABEL Version 0.1

VOLUME [ "/xilinstall" ]

COPY add_to_prepare install_config.txt accept.exp install_xilinx.sh /root/

RUN mkdir /tftpboot ; chmod ugo+rwx /tftpboot

VOLUME [ "/home" ]


