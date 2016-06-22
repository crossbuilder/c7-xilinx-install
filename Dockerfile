FROM crossbuilder/c7-xilinx-base:testing

MAINTAINER crossbuilder

LABEL Version 0.1

VOLUME [ "/xilinstall" ]

#COPY sshd/* /etc/ssh/
#RUN chown root:ssh_keys /etc/ssh/ssh_host* ; chown root:root /etc/ssh/ssh_host*.pub
#RUN chown 640 /etc/ssh/ssh_host* ; chown 644 /etc/ssh/ssh_host*.pub

# not needed since 2016.1 : 
# COPY Xilinx.lic /root/Xilinx.lic

COPY add_to_prepare install_config.txt accept.exp install_xilinx.sh /root/
#COPY startxil /usr/bin
#COPY startsdk /usr/bin
#RUN chmod ugo+x /usr/bin/startxil 
#RUN chown -R ${XPRA_USER}:users /home/${XPRA_USER}/.Xilinx
RUN mkdir /tftpboot ; chmod ugo+rwx /tftpboot
VOLUME [ "/home" ]

#CMD /usr/bin/startxil

#EXPOSE 22 10010

