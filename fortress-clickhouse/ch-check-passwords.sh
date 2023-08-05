#!/bin/bash
echo "Checking for empty/unencrypted passwords in /etc/clickhouse-server"
docker exec -it my-fortress bash -c "grep -r '<password>.*</password>' /etc/clickhouse-server"
