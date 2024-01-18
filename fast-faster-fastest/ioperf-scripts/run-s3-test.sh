#!/bin/bash
# Script to run S3 tests. 
OBJECT_STORAGE_URL="s3://rhodges-us-west-2-playground-1/kioperf"
set -x
./kioperf s3 --operation=write --size 512 \
  --threads=4 --iterations=50 --files=50 \
  --path=${OBJECT_STORAGE_URL} --csv |tee s3.write.out
./kioperf s3 --operation=read \
  --threads=4 --iterations=500 --files=50 \
  --path=${OBJECT_STORAGE_URL} --csv |tee s3.read.out
