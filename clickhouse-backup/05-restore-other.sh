#!/bin/bash
# Show how to restore configs and RBAC metadata only. 
backup_name="my_backup"
set -x
# Restore config files. 
sudo -u clickhouse clickhouse-backup restore --configs-only $backup_name 

# Restore RBAC objects. 
sudo -u clickhouse clickhouse-backup restore --rbac-only $backup_name 
