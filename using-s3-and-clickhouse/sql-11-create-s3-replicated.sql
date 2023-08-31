DROP TABLE IF EXISTS test ON CLUSTER `{cluster}`;
DROP TABLE IF EXISTS test_local ON CLUSTER `{cluster}`;

DROP TABLE IF EXISTS test_s3_direct ON CLUSTER `{cluster}`;
DROP TABLE IF EXISTS test_s3_direct_local ON CLUSTER `{cluster}`;

CREATE TABLE IF NOT EXISTS test_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/{database}/test_local', '{replica}')
PARTITION BY D ORDER BY A;

CREATE TABLE IF NOT EXISTS test ON CLUSTER `{cluster}`
AS test_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_local, rand());

CREATE TABLE IF NOT EXISTS test_s3_direct_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/{database}/test_s3_direct_local', '{replica}')
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_direct';

CREATE TABLE IF NOT EXISTS test_s3_direct ON CLUSTER `{cluster}`
AS test_s3_direct_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_s3_direct_local, rand());

