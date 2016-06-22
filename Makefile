BRANCH=testing
#
# XILINX_INSTALL_DATA
# 
# the install_xilinx script expects to find:
# - xsetup at  ${XILINX_INSTALL_DATA}/Xilinx_Vivado_SDK_2016.1_0409_1/xsetup
# - petalinux-v2016.1-final-installer.run at ${XILINX_INSTALL_DATA}/petalinux-v2016.1-final-installer.run  
# watch out for selinux problems! if this is e.g. a nfs mount, make sure 
# to mount with -o nosharecache,context="system_u:object_r:svirt_sandbox_file_t:s0"
# e.g.
# datastore:/srv/nfs/xilinx       /srv/nfs/xilinx         nfs     auto,ro,nosharecache,context="system_u:object_r:svirt_sandbox_file_t:s0" 0 0
#
XILINX_INSTALL_DATA=/srv/nfs/xilinx



build:
	# get latest base
	sudo docker pull crossbuilder/c7-xilinx-base:${BRANCH}
	sudo docker build --rm -t local/c7-xilinx-install ./
	# remove old sdk-prep
	sudo docker rm -v c7-sdk-prep ; true
	# mount anonymous volume @/home -- this is discarded on deleting c7-sdk-prep
	# run with -e "DRY=YES" to avoid creating the user and /home/user
	sudo docker run -d -e "DRY=YES" -v ${XILINX_INSTALL_DATA}:/xilinstall:ro -v /home -d --name c7-sdk-prep local/c7-xilinx-install
	sudo docker exec -ti c7-sdk-prep /root/install_xilinx.sh
	sudo docker stop c7-sdk-prep
	sudo docker commit --change='ENV DRY=NO' c7-sdk-prep local/c7-sdk-base
	# now we could cleanup, however, for now, I keep the images, for quick testing fixes and commiting again
	# sudo docker rm -v c7-sdk-prep
	# sudo docker rmi local/c7-xilinx-install

clean:
	sudo docker info
	# stop and remove actaual sdk instance
	if sudo docker ps | grep the-sdk ; then sudo docker stop the-sdk ; fi
	if sudo docker ps -a | grep the-sdk ; then sudo docker rm -v the-sdk ; fi
	# stop and remove intermediate installation instance
	if sudo docker ps | grep c7-sdk-prep ; then sudo docker stop c7-sdk-prep ; fi
	if sudo docker ps -a | grep c7-sdk-prep ; then sudo docker rm -v c7-sdk-prep ; fi
	# remove c7-sdk-base
	#
	if sudo docker volume ls | grep local/c7-sdk-base ; then sudo docker rmi local/c7-sdk-base ; fi
	# this removes all dangling images and volumes:
	#sudo docker volume rm $(docker volume ls -qf dangling=true) ; true
	#sudo docker rmi $(docker images -q -f dangling=true)a ; true
	sudo docker info

	

