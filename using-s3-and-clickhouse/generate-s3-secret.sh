#!/bin/bash
# Generate a secret containing S3 credentials. Environmental variables
# have EXT prefix to prevent collision with API keys used for other 
# purposes. 
for envvar in EXT_AWS_S3_DISK_URL EXT_AWS_SECRET_ACCESS_KEY EXT_AWS_ACCESS_KEY_IDS
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
  AWS_S3_DATALAKE_URL: ${EXT_AWS_S3_URL}/datalake/
  AWS_S3_DISK_URL: ${EXT_AWS_S3_URL}/mergetree/
  AWS_ACCESS_KEY_ID: $EXT_AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY: $EXT_AWS_SECRET_ACCESS_KEY
END
kubectl get secret s3-credentials -o json
