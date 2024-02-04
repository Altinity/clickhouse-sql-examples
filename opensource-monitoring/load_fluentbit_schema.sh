#!/bin/bash
CH_CLIENT="clickhouse-client --host=logos3 --user=demo --password=demo -n -m"
set -ex
$CH_CLIENT << SQL
CREATE DATABASE IF NOT EXISTS monitoring
;
DROP TABLE IF EXISTS monitoring.fluentbit_null
;
DROP TABLE IF EXISTS monitoring.fluentbit_cpu
;
DROP TABLE IF EXISTS monitoring.fluentbit_cpu_mv
;
CREATE TABLE monitoring.fluentbit_null (
  json String
) Engine=MergeTree
ORDER BY tuple()
;
CREATE TABLE monitoring.fluentbit_cpu (
  timestamp DateTime,
  host String,
  day UInt32 default toYYYYMMDD(timestamp),
  cpu_p Float32,
  user_p Float32,
  system_p Float32,
  json String
) ENGINE=MergeTree
PARTITION BY day
ORDER BY (host, timestamp)
;
CREATE MATERIALIZED VIEW monitoring.fluentbit_cpu_mv
TO monitoring.fluentbit_cpu
AS
SELECT 
  JSONExtractString(json, 'hostname') as host,
  toDateTime(JSONExtractUInt(json, 'timestamp')) AS timestamp,
  JSONExtractFloat(json, 'cpu_p') AS cpu_p, 
  JSONExtractFloat(json, 'user_p') AS user_p, 
  JSONExtractFloat(json, 'system_p') AS system_p, 
  json
FROM monitoring.fluentbit_null
;
SQL
