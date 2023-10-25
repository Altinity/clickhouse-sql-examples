#!/bin/bash
# Show how to create an increment backup. 
set -x
# Drop a table from the default database. 
echo "DROP TABLE IF EXISTS default.test1" | clickhouse-client

# Create a full backup of the default database. 
sudo -u clickhouse clickhouse-backup delete local full_backup
sudo -u clickhouse clickhouse-backup delete remote full_backup

sudo -u clickhouse clickhouse-backup create_remote full_backup -t 'default.*'
sudo -u clickhouse clickhouse-backup delete local full_backup

# Add a table so something will be different. 
clickhouse-client -n -m <<END
CREATE TABLE default.test1 (
  id UInt32, value String
)
Engine = MergeTree
ORDER BY tuple()
;
END

# Now create an incremental backup. 
sudo -u clickhouse clickhouse-backup create_remote --diff-from-remote=full_backup \
  incremental_backup1 -t 'default.*'
sudo -u clickhouse clickhouse-backup delete local incremental_backup1

# List backups.
sudo -u clickhouse clickhouse-backup list 
