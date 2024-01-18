#!/bin/bash
# Example of how to restart ClickHouse gracefully. 
pods=`kubectl get pods -o name -l clickhouse.altinity.com/chi=secure`
for pod in $pods
do
  echo "Shutdown $pod"
  kubectl exec -it $pod -- clickhouse-client --echo --password=topsecret -q 'SYSTEM SHUTDOWN'
  echo "Wait $pod"
  sleep 10
  kubectl wait --for=condition=Ready=true $pod
  echo "$pod is ready"
done
