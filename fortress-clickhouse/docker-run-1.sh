#!/bin/bash
# Run a ClickHouse server without any ports open
set -x
docker run -d clickhouse:my-fortress
