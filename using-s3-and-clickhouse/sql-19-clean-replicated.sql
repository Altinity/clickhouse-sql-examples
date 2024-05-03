DROP TABLE IF EXISTS test ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_disk ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_disk_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_disk_with_replica ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_disk_with_replica_local ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS test_s3_zero_copy ON CLUSTER `{cluster}` SYNC;
DROP TABLE IF EXISTS test_s3_zero_copy_local ON CLUSTER `{cluster}` SYNC;

-- Let's make sure Keeper is clean as well. 
SYSTEM DROP REPLICA 'chi-demo2-s3-0-0';
SYSTEM DROP REPLICA 'chi-demo2-s3-0-1';
