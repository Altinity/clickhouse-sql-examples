# Iceberg Data Lake Examples

This directory contains samples for construction an Iceberg-based data 
using Docker Compose. 

## Operations

### Bring up the data lake

```
./x-up.sh
```

### Bring down the data lake.

Minio loses its data when you do this even though the volumes are
external. 
```
./x-up.sh
```

### Cleaning up

This deletes all containers and volumes for a fresh start. 
```
./x-clean.sh
```
