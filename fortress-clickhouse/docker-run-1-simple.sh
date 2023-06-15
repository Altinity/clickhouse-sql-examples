#!/bin/bash
# Run a ClickHouse server without any ports open
set -x
docker run -d --name my-fortress clickhouse:my-fortress
