#!/bin/bash
# Get Altinity Stable 22.8 and tag it for demo. 
set -x
docker pull altinity/clickhouse-server:22.8.15.25.altinitystable
docker tag altinity/clickhouse-server:22.8.15.25.altinitystable clickhouse:my-fortress
