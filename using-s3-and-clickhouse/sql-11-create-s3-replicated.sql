DROP TABLE IF EXISTS test ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_disk ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_disk_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_disk_with_replica ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_disk_with_replica_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_zero_copy ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_zero_copy_local ON CLUSTER `{cluster}` SYNC;

CREATE TABLE IF NOT EXISTS test_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree
PARTITION BY D ORDER BY A;

CREATE TABLE IF NOT EXISTS test ON CLUSTER `{cluster}`
AS test_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_local, rand());

CREATE TABLE IF NOT EXISTS test_s3_disk_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_disk_policy';

CREATE TABLE IF NOT EXISTS test_s3_disk ON CLUSTER `{cluster}`
AS test_s3_disk_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_s3_disk_local, rand());

CREATE TABLE IF NOT EXISTS test_s3_disk_with_replica_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_disk_with_replica_policy';

CREATE TABLE IF NOT EXISTS test_s3_disk_with_replica ON CLUSTER `{cluster}`
AS test_s3_disk_with_replica_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_s3_disk_with_replica_local, rand());

CREATE TABLE IF NOT EXISTS test_s3_zero_copy_local ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree
PARTITION BY D
ORDER BY A
SETTINGS storage_policy = 's3_zero_copy_policy', allow_remote_fs_zero_copy_replication=1;

CREATE TABLE IF NOT EXISTS test_s3_zero_copy ON CLUSTER `{cluster}`
AS test_s3_disk_local
ENGINE = Distributed('{cluster}', currentDatabase(), test_s3_zero_copy_local, rand());
