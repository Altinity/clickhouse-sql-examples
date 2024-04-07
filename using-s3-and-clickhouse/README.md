# Examples for Using S3 with ClickHouse

This directory contains examples that demonstrate using S3 storage
with ClickHouse MergeTree tables. 

## Server Startup

The server is defined in Kubernetes. Run these commands to start. The 
script to generate the secret requires environmental values to be 
set in the environment. Here's a sample of what that might look like. 

```
export EXT_AWS_ACCESS_KEY_ID=B.....F
export EXT_AWS_SECRET_ACCESS_KEY=r.....z
export EXT_AWS_S3_URL="https://s3.us-west-2.amazonaws.com/bucket/"
```

Now you can start the server. 
```
# Create secret and load to K8s. 
./generate_secret.sh
# Start server.
kubectl apply -f demo-s3-01.yaml
```
After server is started, run `port-forward.sh` to make ports 
accessible. 

## S3 Tables and Benchmark Scripts

Use the SQL scripts to create tables and run benchmark scripts. 
```
alias cc-batch='clickhouse-client -m -n --verbose -t --echo -f Pretty'
# Single server scripts. 
cc-batch < sql-00-check-liveness.sql
cc-batch < sql-01-create-s3-tables.sql
cc-batch < sql-02-insert-data.sql
cc-batch < sql-03-statistics.sql
cc-batch < sql-04-benchmark.sql
# Parquet files need to substitute values of EXT_AWS_S3_URL.
(cat sql-06a-create-parquet-tables.sql |envsubst) |cc-batch
(cat sql-06b-insert-parquet-data.sql |envsubst) |cc-batch
(cat sql-06c-benchmark-parquet-tables.sql |envsubst) |cc-batch

## Replicated Cluster

Set up replicated cluster. Example requires a running ZooKeeper. 
```
kubectl delete chi/demo
kubectl apply -f demo2-s3-01.yaml
```

Run test scripts. sql-03 and sql-05 scripts run against replicated server
without change. 
```
# Clustered server scripts. 
cc-batch < sql-11-create-s3-replicated.sql  
cc-batch < sql-12-insert-data-replicated.sql  
cc-batch < sql-03-statistics.sql
cc-batch < sql-14-benchmark.sql
cc-batch < sql-05-telemetry.sql
```

## Metrics and Counters for S3

There are lots of them. Look in sql-05-telemetry for a sample of 
how to monitor S3 performance. 

Count the actual bytes stored in S3 with a command like the following:
```
aws s3 ls --summarize --human-readable --recursive s3://bucket/clickhouse/s3/mergetree/
```

## Cleaning up [Zoo]Keeper

It's easy to mess up Keeper metdata when managing data in S3. If so you may run into 
the dreaded REPLICA_ALREADY_EXISTS problem like the following: 

```
Received exception from server (version 23.7.4):
Code: 253. DB::Exception: Received from localhost:9000. DB::Exception: There was an error on [chi-demo2-s3-0-0:9000]: Code: 253. DB::Exception: Replica /clickhouse/s3/tables/0/default/test_local/replicas/chi-demo2-s3-0-0 already exists. (REPLICA_ALREADY_EXISTS) (version 23.7.4.5 (official build)). (REPLICA_ALREADY_EXISTS)
(query: CREATE TABLE IF NOT EXISTS test_local ON CLUSTER `{cluster}`
```

Check for invalid replicas using SELECT. 
```
SELECT * FROM system.zookeeper WHERE path = '/clickhouse/s3/tables/0/default/test_local/replicas/'
```

If you see an invalid replica use the following command to prune it from the 
Keeper path.

```
SYSTEM DROP REPLICA 'chi-demo2-s3-0-0' FROM ZKPATH '/clickhouse/s3/tables/0/default/test_local'
```

After running the command the replicas should be gone. 
