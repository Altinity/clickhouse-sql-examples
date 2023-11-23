# Samples for Fast, Faster, Fastest talk

This directory contains sample Kubernetes configurations and scripts to set up and 
run performance tests on different types of cloud storage. 

Scripts and yamls assume root (sudo) access to hosts as well as administrator 
access to K8s. 

# Running the tests.

Approximate instructions for running tests. Sample scripts show exact commands
to format storage and run tests.

## Disk test.
Exec to pod with kubectl exec.
```
mkdir -p /var/lib/clickhouse/kioperf/tools
cd /var/lib/clickhouse/kioperf/tools
wget https://github.com/hodgesrm/kioperf/releases/download/v0.0.1-prerelease/kioperf
chmod +x kioperf

mkdir /var/lib/clickhouse/kioperf/test
./kioperf disk --operation=write --size 512 \
  --threads=4 --iterations=50 --files=50 \
  --dir-path /var/lib/clickhouse/kioperf/test --csv
# Does not work on containers! (Caches global to the node)
sync; echo 1 > /proc/sys/vm/drop_caches
./kioperf disk --operation=read \
  --threads=4 --iterations=500 --files=50 \
  --dir-path /var/lib/clickhouse/kioperf --csv
```

## S3 test.

```
./kioperf s3 --operation=write --size 512 \
  --threads=4 --iterations=50 --files=50 \
  --bucket=rhodges-us-west-2-playground-1 --prefix=kioperf/ \
  --csv
./kioperf s3 --operation=read \
  --threads=4 --iterations=500 --files=50 \
  --bucket=rhodges-us-west-2-playground-1 --prefix=kioperf/ \
  --csv
```

# ClickHouse test
copy clickbench files.

```
kubectl -n test cp clickbench_clickhouse.tgz \
+  chi-nvme-ch-0-0-0:/var/lib/clickhouse/kioperf/tools
```
