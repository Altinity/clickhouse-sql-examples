#!/bin/bash
# Run a ClickHouse server with ports and with mounts to storage
# so we can change the configuration as well as look at logs. 
set -x
docker rm -f my-fortress
mkdir -p $(pwd)/data/conf.d
mkdir -p $(pwd)/data/users.d
mkdir -p $(pwd)/data/certs
mkdir -p $(pwd)/data/logs
docker run -d  --name my-fortress \
 -v $(pwd)/data/conf.d:/etc/clickhouse-server/conf.d \
 -v $(pwd)/data/users.d:/etc/clickhouse-server/users.d \
 -v $(pwd)/data/certs:/etc/clickhouse-server/certs \
 -v $(pwd)/data/logs:/var/log/clickhouse-server \
 -p 8123:8123 -p 9000:9000 \
 clickhouse:my-fortress 
