DROP ROLE IF EXISTS rp_basic ON CLUSTER '{cluster}';
DROP ROLE IF EXISTS rp_special ON CLUSTER '{cluster}';
DROP USER IF EXISTS rp_user0 ON CLUSTER '{cluster}';
DROP USER IF EXISTS rp_user1 ON CLUSTER '{cluster}';
DROP USER IF EXISTS rp_user2 ON CLUSTER '{cluster}';
DROP USER IF EXISTS rp_user3 ON CLUSTER '{cluster}';

DROP TABLE IF EXISTS rp_example ON CLUSTER '{cluster}' SYNC ;

DROP ROW POLICY IF EXISTS row_policy0 ON CLUSTER '{cluster}' ON default.rp_example;
DROP ROW POLICY IF EXISTS row_policy1 ON CLUSTER '{cluster}' ON default.rp_example;
DROP ROW POLICY IF EXISTS row_policy2 ON CLUSTER '{cluster}' ON default.rp_example;
DROP ROW POLICY IF EXISTS row_policy3 ON CLUSTER '{cluster}' ON default.rp_example;

CREATE ROLE IF NOT EXISTS rp_basic ON CLUSTER '{cluster}';
GRANT ON CLUSTER '{cluster}' SELECT ON *.* TO rp_basic;

CREATE ROLE IF NOT EXISTS rp_special ON CLUSTER '{cluster}';
GRANT ON CLUSTER '{cluster}' SELECT ON *.* TO rp_special;

CREATE USER IF NOT EXISTS rp_user0 ON CLUSTER '{cluster}' NOT IDENTIFIED DEFAULT ROLE rp_basic;
CREATE USER IF NOT EXISTS rp_user1 ON CLUSTER '{cluster}' NOT IDENTIFIED DEFAULT ROLE rp_special;
CREATE USER IF NOT EXISTS rp_user2 ON CLUSTER '{cluster}' NOT IDENTIFIED DEFAULT ROLE rp_basic;
CREATE USER IF NOT EXISTS rp_user3 ON CLUSTER '{cluster}' NOT IDENTIFIED DEFAULT ROLE rp_basic;

GRANT rp_special ON CLUSTER '{cluster}' TO rp_user1;

-- Create table and load data. 
CREATE TABLE IF NOT EXISTS rp_example ON CLUSTER '{cluster}' (
  group UInt16,
  name String,
)
Engine=ReplicatedMergeTree
ORDER BY tuple()
;

INSERT INTO rp_example(group, name) VALUES
  (1, 'one'), (2, 'two'), (3, 'three'), (4, 'four'), (1, 'five'), (2, 'six')
;

-- Add row policies. 
CREATE ROW POLICY row_policy0 ON CLUSTER '{cluster}' ON default.rp_example USING group=1 AS PERMISSIVE TO ALL;
CREATE ROW POLICY row_policy1 ON CLUSTER '{cluster}' ON default.rp_example USING group<10 TO rp_special;
CREATE ROW POLICY row_policy2 ON CLUSTER '{cluster}' ON default.rp_example USING group<3 TO rp_user2;
CREATE ROW POLICY row_policy3 ON CLUSTER '{cluster}' ON default.rp_example USING group<4 TO rp_user3;
