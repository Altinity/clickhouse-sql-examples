# Samples for talk on ClickHouse storage internals

This directory contains scripts and examples used in the 23 November 
2023 Altinity webinar on ClickHouse storage internals. 

Run scripts as shown in the following examples. 
```
alias cc-batch='clickhouse-client -m -n --verbose -t --echo -f Pretty'
cc-batch < sql-03-measure-ontime.sql
```
