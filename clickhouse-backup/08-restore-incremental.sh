#!/bin/bash
# Restore from an incremental backup. 
set -x
# Drop a table from the default database. 
echo "DROP TABLE IF EXISTS default.test1" | clickhouse-client

# Now restore from incremental backup. 
sudo -u clickhouse clickhouse-backup restore_remote incremental_backup1 -t 'default.test1'
