#!/bin/bash
# Demonstrate the API via system.backup_list and system.backup_actions
# tables. You should enable 'create_integration_tables: true' in 
# /etc/clickhouse-backup/config.yml to ensure tables are created. 
set -x
# You may need to type your password to make this work. 
sudo -u clickhouse clickhouse-backup server 

# Hit ^C to terminate the server. 
