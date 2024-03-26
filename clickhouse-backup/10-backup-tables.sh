#!/bin/bash
# Demonstrate the API via system.backup_list and system.backup_actions
# tables. Server must be running with 'create_integration_tables: true' in 
# /etc/clickhouse-backup/config.yml to ensure tables are created. 
set -x
# Select current backups. 
echo 'SELECT * FROM system.backup_list FORMAT Pretty' | clickhouse-client --echo

# Start a new backup. 
echo "INSERT INTO system.backup_actions(command) VALUES ('create iex_from_actions -t \'iex.*\'')" |\
  clickhouse-client --echo

# See how the backup is doing. 
echo "SELECT * FROM system.backup_list FORMAT Pretty" | clickhouse-client --echo
sleep 10
echo "SELECT * FROM system.backup_list FORMAT Pretty" | clickhouse-client --echo

# Remove the backup
echo "INSERT INTO system.backup_actions(command) VALUES ('delete local iex_from_actions')" |\
  clickhouse-client --echo
