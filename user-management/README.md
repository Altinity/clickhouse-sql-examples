# Examples for User Management in ClickHouse Webinar

## Prerequisites

You will need a Kubernetes cluster with the operator installed. You
can use the [Terraform AWS EKS Blueprint project](https://github.com/Altinity/terraform-aws-eks-clickhouse)
to do this.

If you use another method make sure you have a namespace set up for
the samples and that you have installed the Altinity Kubernetes
Operator for ClickHouse in it. Here are suitable commands.

```
kubectl create ns clickhouse
kubectl config set-context --current --namespace=clickhouse
helm repo add clickhouse-operator https://docs.altinity.com/clickhouse-operator/
helm install clickhouse-operator clickhouse-operator/altinity-clickhouse-operator
```

Start a Keeper server using helm.
```
helm repo add kubernetes-blueprints https://docs.altinity.com/kubernetes-blueprints-for-clickhouse
helm install keeper kubernetes-blueprints/keeper-sts
```

Set alias for running clickhouse-client. 
```
alias cc-batch='clickhouse-client --user=root --password=topsecret -m -n \
--verbose -t --echo -f PrettyCompact --output_format_pretty_row_numbers=0'
```
