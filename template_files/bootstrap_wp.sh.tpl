#!/bin/bash -x

echo "EFS Drive should be mounted to the machine at perticluter location {/path/path....} "

sleep 120

echo "update pakeges ..."

// sudo apt install nfs-common
// sudo apt install cifs-utils


sudo apt-get update -y 
sudo apt-get install -y amazon-efs-utils
sudo apt-get install -y nfs-common

sleep 10


echo "defining veriables for coamnds reoired for EFS MOUNT ...."
sleep 10
efs_host="${efs_name}"
efs_id="${efs_id}"
region="${region}"
efs_path="${efs_location}"

echo "veriables check  if reqired ..."
sleep 10
echo $efs_host
echo $efs_id
echo $region
echo $efs_path

## "if rqeired  create folder location "

## sudo mkdir -p  $efs_path

# Once the directory exists, proceed with mounting the EFS drive

##CODITION 1)EFS Drive should be mounted to the machine at perticluter directori/location /path/path....

echo "EFS Drive should be mounted to the machine at perticluter directori/location {/path/path....} "
# Use either of these mount commands based on your use case  ==BOTH CONAMDS ARE WORKING===

echo "comand1..."
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_id.efs.$region.amazonaws.com:/ $efs_path

##or
#echo "comand2..."
#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $efs_host:/ $efs_path

#CODITION 2) bootstrap_dir.sh.tpl  see this  file

# echo "EFS mounted successfully"
# ## tail -f /var/log/cloud-init-output.log
