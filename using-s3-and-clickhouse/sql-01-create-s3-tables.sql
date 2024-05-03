DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test_s3_disk SYNC;

DROP TABLE IF EXISTS test_s3_cached SYNC;

DROP TABLE IF EXISTS test_s3_tiered SYNC;

CREATE TABLE test
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A;

CREATE TABLE test_s3_disk
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_disk_policy';

CREATE TABLE test_s3_cached
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_disk_cache_policy';

CREATE TABLE test_s3_tiered
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A
TTL D + INTERVAL 7 DAY TO VOLUME 's3_disk_cache'
SETTINGS storage_policy = 's3_tiered_policy';
