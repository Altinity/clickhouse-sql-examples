#!/bin/bash
set -x
docker pull clickhouse/clickhouse-server:23.3.3.52
docker tag clickhouse/clickhouse-server:23.3.3.52 clickhouse:my-fortress
