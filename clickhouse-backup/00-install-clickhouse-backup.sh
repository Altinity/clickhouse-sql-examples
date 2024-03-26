#!/bin/bash
# Example of downloading and installing clickhouse-backup to
# /usr/local/bin on amd64 hosts (Intel & AMD).
set -ex
tmpfile=tmp_$$
mkdir $tmpfile
(cd $tmpfile; \
wget https://github.com/Altinity/clickhouse-backup/releases/download/v2.4.35/clickhouse-backup-linux-amd64.tar.gz; \
tar -xf clickhouse-backup-linux-amd64.tar.gz)
exit
sudo install -o root -g root -m 0755 $tmpfile/build/linux/amd64/clickhouse-backup /usr/local/bin
/usr/local/bin/clickhouse-backup -v
rm -r $tmpfile
