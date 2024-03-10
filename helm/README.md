# Sample Helm charts for ClickHouse and ClickHouse Keeper

The samples in this directory illustrate simple Helm charts that can be 
used to deploy ClickHouse and Keeper resources. 

We do not make an effort to show everything users can do with Helm. The
samples provide a starting point for further embroidery. 

## Prerequisites

You'll need to do the following to get started. 

* Get administrative access to Kubernetes. For testing clickhouse-hello, [Minikube](https://minikube.sigs.k8s.io/docs/start/) will do. 
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/)
* Install [helm](https://helm.sh/docs/intro/install/)
* Use helm to install the [clickhouse-operator](https://github.com/Altinity/clickhouse-operator/tree/master/deploy/helm) using the commands shown below. 

```
helm repo add clickhouse-operator https://docs.altinity.com/clickhouse-operator/
helm install clickhouse-operator clickhouse-operator/altinity-clickhouse-operator
```

Please note the Altinity Operator project instructions regarding operator
upgrade with Helm. You need to run the custom resource definition files
independently.

## Quick Start

### Install Helm chart for hello server
Clone this repo and install the Helm clickhouse-hello chart directly from the file system. 

```
git clone https://github.com/Altinity/clickhouse-sql-examples.git
cd clickhouse-sql-examples/helm
helm install hello clickhouse-hello
```

If you would like to see what deviltry is afoot before installing, run
the following to see the manifests. 

```
helm install --debug --dry-run test clickhouse-hello
```

### Connect to your new ClickHouse server. 

Here's how to connect and make sure ClickHouse can see the Keeper server. 

```
kubectl exec -it chi-hello-ch-0-0-0 -- clickhouse-client
SELECT * FROM system.zookeeper WHERE path = '/'
```

If things are correctly wired, both commands will succeed and you'll see a 
list of path names in Keeper. 

### Modifying and Upgrading

You can change the settings in values.yaml and reapply the chart. 

```
helm upgrade hello clickhouse-hello
```

You can also override using your own values. 
```
helm upgrade hello clickhouse-hello -f newvalues.yaml
```

### Removing

Remove the sample CHI and CHK resources using `helm uninstall`. You'll also 
have to delete PVCs explicitly. This is a safety precaution to prevent
accidental deletion of clusters and their storage.

```
helm uninstall hello
kubectl delete pvc -l application_group=hello
```

## AWS EKS Sample Helm Chart

The clickhouse-aws chart shows how to run ClickHouse on AWS EKS across AZs using 
a nodeSelector to pin resources to run on specific VMs types. 

## Bugs and Issues

Please log issues on this project and/or submit PRs if you have solutions to them. 
