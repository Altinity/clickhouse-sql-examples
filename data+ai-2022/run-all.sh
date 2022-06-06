#/bin/bash
set -ex
ch-client.sh --database=test < 20-clean.sql 
ch-client.sh --database=test < 21-create-table.sql
ch-client.sh --database=test < 22-load-data.sql
