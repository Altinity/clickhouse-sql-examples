#!/bin/bash
set -x
pkill kubectl
kubectl port-forward pod/chi-mych-clickhouse-mych-0-0-0 8123:8123 &
kubectl port-forward pod/chi-mych-clickhouse-mych-0-0-0 9000:9000 &
