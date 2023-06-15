#!/bin/bash
echo "Installing net tools, curl, and vim"
docker exec -it my-fortress bash -c "apt update; apt install -y net-tools curl vim"
