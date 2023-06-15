#!/bin/bash
echo "Checking ClickHouse ports"
docker exec -it my-fortress bash -c "netstat -tulpn | grep LISTEN"
echo "Checking the definitions of each port"
docker exec -it my-fortress bash -c "netstat -tulpn | \
grep LISTEN | \
cut -d ':' -f2 | \
cut -d ' ' -f1 | \
xargs -I {} grep -r {} /etc/clickhouse-server | \
grep _port"
