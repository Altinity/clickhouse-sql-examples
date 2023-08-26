#!/bin/bash
# Generate a secret containing S3 credentials. 
for envvar in AWS_S3_DISK_URL AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_IDS
do
  [[ "$envvar" == "" ]] && echo "$envvar not set" && exit 1
done
kubectl delete secret s3-credentials
kubectl apply -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: s3-credentials
type: Opaque
stringData:
  AWS_S3_DISK_URL: $AWS_S3_DISK_URL
  AWS_ACCESS_KEY_ID: $AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY: $AWS_SECRET_ACCESS_KEY
END
kubectl get secret s3-credentials -o json
