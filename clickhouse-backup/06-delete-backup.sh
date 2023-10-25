#!/bin/bash
# Remove backups. 
set -x
# May need root to remove full backup if config files have bad permissions. 
sudo clickhouse-backup delete local my_backup
sudo -u clickhouse clickhouse-backup delete local mybackup_table
sudo -u clickhouse clickhouse-backup delete local mybackup_database
sudo -u clickhouse clickhouse-backup delete remote mybackup 
sudo -u clickhouse clickhouse-backup delete remote mybackup_database
