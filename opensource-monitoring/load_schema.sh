#!/bin/bash
CH_CLIENT="clickhouse-client --host=logos3 --user=demo --password=demo -n -m"
set -ex
$CH_CLIENT << SQL
CREATE DATABASE IF NOT EXISTS monitoring
;
DROP TABLE IF EXISTS monitoring.vmstat
;
CREATE TABLE monitoring.vmstat (
  timestamp DateTime,
  day UInt32 default toYYYYMMDD(timestamp),
  host String,
  r UInt64,
  b UInt64,
  swpd UInt64,
  free UInt64,
  buff UInt64,
  cache UInt64,
  si UInt64,
  so UInt64,
  bi UInt64,
  bo UInt64,
  in UInt64,
  cs UInt64,
  us UInt64,
  sy UInt64,
  id UInt64,
  wa UInt64,
  st UInt64
) ENGINE=MergeTree
PARTITION BY day
ORDER BY (host, timestamp)
SQL
