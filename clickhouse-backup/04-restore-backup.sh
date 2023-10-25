#!/bin/bash
# Practice restoring files. 
backup_name="my_backup"
set -x
# Restore data for a table. 
sudo -u clickhouse clickhouse-backup restore -t default.ex2 my_backup

# Restore only schema for a table. 
sudo -u clickhouse clickhouse-backup restore -t default.bar --schema my_backup

# Restore selected default database tables to default2. 
sudo -u clickhouse clickhouse-backup restore \
  -t 'default.ex2,default.bar' \
  -m 'default:default2' my_backup
