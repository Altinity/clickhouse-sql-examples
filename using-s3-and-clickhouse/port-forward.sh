#!/bin/bash
set -x
kubectl port-forward svc/clickhouse-demo 8123:8123 &
kubectl port-forward svc/clickhouse-demo 9000:9000 &
