#!/bin/bash
# Commands to list backups. 
set -x
sudo -u clickhouse clickhouse-backup list 
sudo -u clickhouse clickhouse-backup list local
sudo -u clickhouse clickhouse-backup list local latest
sudo -u clickhouse clickhouse-backup list remote
sudo -u clickhouse clickhouse-backup list remote latest
