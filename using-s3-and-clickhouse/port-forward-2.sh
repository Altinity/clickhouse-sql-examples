#!/bin/bash
set -x
kubectl port-forward svc/clickhouse-demo2 8123:8123 &
kubectl port-forward svc/clickhouse-demo2 9000:9000 &
