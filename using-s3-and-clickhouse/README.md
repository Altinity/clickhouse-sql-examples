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

## S3 Tables

Use the SQL scripts to create tables. 
```
alias cc-batch='clickhouse-client -m -n --verbose -t --echo -f Pretty'
cc-batch < sql-00-check-liveness.sql
cc-batch < sql-01-create-s3-tables.sql
cc-batch < sql-02-insert-data.sql
cc-batch < sql-03-statistics.sql
cc-batch < sql-04-benchmark.sql
# Last two need to substitute values of EXT_AWS_S3_URL.
(cat sql-06a-create-parquet-tables.sql |envsubst) |cc-batch
(cat sql-06b-benchmark-parquet-tables.sql |envsubst) |cc-batch
```

## Metrics and Counters for S3

There are lots of them. Look in sql-05-telemetry for a sample of 
how to monitor S3 performance. 
