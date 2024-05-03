#!/bin/bash
set -x
# Kill port-forward commands.
pkill kubectl 
# Remove ClickHouse installations. 
kubectl delete chi demo
kubectl delete chi demo2
# Uninstall keeper. 
helm uninstall keeper
# Free storage in the namespace. 
kubectl delete pvc  -l clickhouse.altinity.com/chi=demo2
kubectl delete pvc -l app=keeper-keeper
