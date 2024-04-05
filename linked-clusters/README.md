# Linked ClickHouse Clusters

The samples here show how to deploy a pair of linked ClickHouse clusters
that share a single Keeper instance and replicate between tables in both
cluster. 

Provided you start with the same table schema in both clusters you can start
them independently without difficulty. 

The samples provided here will work in any location. For convenience you can 
run them in a single namespace to test. 

## Installing the example.

Set up the demonstration topology. 
```
# Create the namespace. 
kubectl create ns linked
kubectl config set-context --current --namespace=linked
# Start Clickhouse Keeper. 
kubectl apply -f clickhouse-keeper-1-node.yaml
# Start linked clusters. 
kubectl apply -f ord.yaml
kubectl apply -f sfo.yaml
```

Make ports available externally. (Best done in a separate terminal window.)
```
kubectl port-forward service/clickhouse-ord 9001:tcp &
kubectl port-forward service/clickhouse-sfo 9002:tcp &
```

Load schema and data. 
```
clickhouse-client --port 9001 --multiline --multiquery --echo < ddl.sql
clickhouse-client --port 9002 --multiline --multiquery --echo < ddl.sql

clickhouse-client --port 9002 --echo --query='INSERT INTO default.shared(id, value) Format CSV' < data.csv
```

At the end you'll see data and schema in tables on both servers. You can now add 
replicas to either cluster and they will pick up both schema and existing data 
automatically. 

## Exercises for the reader 

To make this work between Kubernetes clusters you will need to do the following: 

* Ensure pod and service DNS names are resolvable on both clusters.
* Ensure that traffic is routable between IP addresses in both clusters. 
