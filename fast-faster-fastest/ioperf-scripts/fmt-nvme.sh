#!/bin/bash
# Script to format file system on raw block device. 
RAW_DEVICE="/dev/nvme1n1"
set -x
lsblk
sudo file -s ${RAW_DEVICE}
sudo mkfs -t xfs ${RAW_DEVICE}
sudo mkdir /data
sudo mount ${RAW_DEVICE} /data
