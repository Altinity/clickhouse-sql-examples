-- Script to demonstrate replicated table creation with and without ZK path. 
DROP TABLE IF EXISTS demo ON CLUSTER `{cluster}` SYNC;

DROP TABLE IF EXISTS old_demo ON CLUSTER `{cluster}` SYNC;

-- Use an explicate path in ReplicatedMergeTree. 
CREATE TABLE IF NOT EXISTS old_demo ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree('/clickhouse/{cluster}/tables/{shard}/{database}/old_demo', '{replica}')
PARTITION BY D ORDER BY A;

-- Let the path argument in ReplicatedMergeTree default to path chosen by ClickHouse. 
CREATE TABLE IF NOT EXISTS demo ON CLUSTER `{cluster}`
(
    `A` Int64,
    `S` String,
    `D` Date
)
ENGINE = ReplicatedMergeTree
PARTITION BY D ORDER BY A;

INSERT INTO demo VALUES(1, 'one', now());

INSERT INTO demo VALUES(2, 'two', now());

SET show_table_uuid_in_table_create_query_if_not_nil=1;

SHOW CREATE TABLE demo FORMAT Vertical;

SELECT database, name, uuid from system.tables where database=currentDatabase();
