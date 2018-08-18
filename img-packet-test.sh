#!/bin/bash

# Date for dev-image file name:
DATE=`date '+%m-%d_%H:%M'`

# Pull Latest Commits from My Branch:
echo "[INFO] Going into ignition third_party directory:"
cd /home/cherylfong/trunk/src/third_party/ignition
echo "[INFO] Checking if on the right branch!"
echo "[USER INPUT] What branch to checkout?"
git branch | xargs echo 
read branchname
git checkout $branchname
echo "[INFO] Pulling from bubblemelon remote branch:"
git pull bubblemelon $branchname

# Using ignition ebuild:
#cros_workon start ignition
# Check if above worked: should show sys-apps/ignition
#cros-workon list 

# Installing & Checking Dependencies:
echo "[INFO] Going into ~ folder:"
cd
echo "[INFO] Finding dependencies:"
emerge-amd64-usr ignition coreos-kernel


# Build IMAGE and Format Binary 
echo "[INFO] Going into Scripts folder"
cd /home/cherylfong/trunk/src/scripts
echo "[USER INTERACTION] ASKS TO SET UP PASSWORD:"
./set_shared_user_password.sh
echo "[INFO] Run Building Image Script"
./build_image
echo "[INFO] Building Image to VM in Packet format"
./image_to_vm.sh --format packet



# Put image Binary on Google Cloud: 
echo "[INFO] Going into latest folder:"
cd /home/cherylfong/trunk/src/build/images/amd64-usr/latest

# Bzip Binary:
echo "[INFO] BZIP the Binary!"
bzip2 -vvvv coreos_production_packet_image.bin   

echo "[INFO] Using GUTIL"
echo "gsutil cp ...packet_image.bin gs://.../cherylfong/dev-img-zipped_$DATE"
gsutil cp coreos_production_packet_image.bin.bz2 gs://users.developer.core-os.net/cherylfong/dev-img-zipped_$DATE

# Creating an instance 
echo "[INFO] Kola Spawing!"
echo "[USER INPUT] What is the image url ?"
read imgurl
echo "[USER INPUT] Specify the config file"
ls /home/cherylfong/ignition_configs
read configfile
echo "[INFO] Entering ~ Directory"
cd
echo "[INFO] Spawns starts now"
kola spawn -p packet --packet-image-url $imgurl -u ~/ignition_configs/$configfile --verbose
