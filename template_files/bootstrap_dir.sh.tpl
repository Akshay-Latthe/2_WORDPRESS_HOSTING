#!/bin/bash

## Use this when you reired to Using same AWS EFS to share multiple directories  >> 

echo "EFS Drive should be mounted to the machine at perticluter location {/path/path....} "
## create folder location if rqeired 
sudo mkdir -p /var/media/
sudo mkdir -p /var/var/
sleep 120

echo "update pakeges ..."
sudo apt-get update -y 
sudo apt-get install -y amazon-efs-utils
sudo apt-get install -y nfs-common
sleep 10
# Once the directory exists, proceed with mounting the EFS drive

echo "defining veriables for coamnds reoired for EFS MOUNT ...."
efs_host="${efs_name}"
efs_id="${efs_id}"
region="${region}"
efs_path="${efs_location}"

echo "veriables check  if reqired ..."
echo $efs_host
echo $efs_id
echo $region


## CODITION 1) "bootstrap_wp.sh.tpl" filre


#CODITION 2) Use this when you reired to Using same AWS EFS to share multiple directories  >> 
## https://stackoverflow.com/questions/57260276/using-same-aws-efs-to-share-multiple-directories

###  ==== Using same AWS EFS to share multiple directories ====="
mkdir -p /mnt/efs
echo "$efs_id.efs.$region.amazonaws.com:/   /mnt/efs   nfs4    defaults" >> /etc/fstab
mount -a
ln -s /var/media /mnt/efs/media
ln -s /var/var /mnt/efs/var


