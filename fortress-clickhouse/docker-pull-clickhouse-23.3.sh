#!/bin/bash
# Get ClickHouse Community 23.3 and tag it for demo.
set -x
docker pull clickhouse/clickhouse-server:23.3.3.52
docker tag clickhouse/clickhouse-server:23.3.3.52 clickhouse:my-fortress
