#!/bin/bash
set -x
kubectl port-forward svc/clickhouse-replicated 8123:8123 &
kubectl port-forward svc/clickhouse-replicated 9000:9000 &
