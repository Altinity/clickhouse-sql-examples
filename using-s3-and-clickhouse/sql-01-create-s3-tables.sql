DROP TABLE IF EXISTS test;

DROP TABLE IF EXISTS test_s3_direct;

DROP TABLE IF EXISTS test_s3_cached;

CREATE TABLE test
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A;

CREATE TABLE test_s3_direct
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_direct';

CREATE TABLE test_s3_cached
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = MergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_cached';
