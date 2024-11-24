#!/bin/bash
echo 'Trigger too many connection errors'
set -x
# Trigger error with default login
clickhouse-benchmark -t 3 -c 26 --ignore-error \
 --query='select avg(number) from numbers(1000000000)'

# Demonstrate how to avoid it with profiles. This generates too many 
# simultaneous queries for all users. 
clickhouse-benchmark --user=tm1 --password=topsecret -t 3 -c 12 --ignore-error \
 --query='select avg(number) from numbers(1000000000)' &
clickhouse-benchmark --user=tm2 --password=topsecret -t 3 -c 12 --ignore-error \
 --query='select avg(number) from numbers(1000000000)' 

# This generates too many simultaneous queries for a single user. 
clickhouse-benchmark --user=tm1 --password=topsecret -t 3 -c 18 --ignore-error \
 --query='select avg(number) from numbers(1000000000)' 

# Try fixing the query!! 
clickhouse-benchmark -t 3 -c 26 --ignore-error \
 --query='select (1000000000 - 1) / 2'
