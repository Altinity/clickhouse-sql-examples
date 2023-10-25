#!/bin/bash
# Creating various kinds of backups. 
set -x
# Create full backup and upload to remote storage in two steps. 
sudo -u clickhouse clickhouse-backup create my_backup --rbac --configs
sudo -u clickhouse clickhouse-backup upload my_backup

# Back up a single table locally. 
sudo -u clickhouse clickhouse-backup create my_backup_table -t default.ex2

# Back up a database directly to remote storage. 
sudo -u clickhouse clickhouse-backup create_remote my_backup_database -t 'default.*'

# List backups.
sudo -u clickhouse clickhouse-backup list 
