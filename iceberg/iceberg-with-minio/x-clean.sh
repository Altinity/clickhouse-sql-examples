#!/bin/bash
echo "Killing live containers"
for c in $(docker ps -q)
do 
  echo $c; docker kill $c; 
done
echo "Removing dead containers"
for c in $(docker ps -q -a)
do 
  echo $c; docker rm $c; 
done
echo "Removing volumes"
for v in $(docker volume ls -q |grep iceberg)
do 
  docker volume rm $v; 
done
