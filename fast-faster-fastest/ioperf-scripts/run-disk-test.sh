#!/bin/bash
# Script to run disk data test, leaving results in .out files. 
set -x
sudo mkdir -p /data/test
sudo sync
sudo echo 1 > /proc/sys/vm/drop_caches
sudo ./ioperf disk --operation=write --size 512   --threads=4 \
  --iterations=50 --files=50 --fsync \
  --dir-path /data/test --csv |tee disk.write.out

sudo sync
sudo echo 1 > /proc/sys/vm/drop_caches
sudo ./ioperf disk --operation=read --threads=4 \
  --iterations=500 --files=50 \
  --dir-path /data/test --csv |tee disk.read.out
