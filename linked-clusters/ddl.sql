-- Create replicated table. 
DROP TABLE IF EXISTS default.shared ON CLUSTER '{cluster}'
;

CREATE TABLE default.shared ON CLUSTER '{cluster}' (
  id UInt64,
  created_at DateTime DEFAULT now(),
  value String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/default/shared', '{replica}')
PARTITION BY toYYYYMM(created_at)
ORDER BY (id, created_at)
;
