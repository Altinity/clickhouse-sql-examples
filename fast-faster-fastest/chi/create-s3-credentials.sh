#!/bin/bash
if [ -z "$AWS_S3_DISK_URL" ]; then echo "AWS_S3_DISK_URL not set"; exit 1; fi
if [ -z "$AWS_ACCESS_KEY_ID" ]; then echo "AWS_ACCESS_KEY_ID not set"; exit 1; fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then echo "AWS_SECRET_ACCESS_KEY not set"; exit 1; fi
cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: s3-credentials
type: Opaque
data:
  AWS_S3_DISK_URL: $(echo $AWS_S3_URL |base64)
  AWS_ACCESS_KEY_ID: $(echo $AWS_ACCESS_KEY_ID |base64)
  AWS_SECRET_ACCESS_KEY: $(echo $AWS_SECRET_ACCESS_KEY |base64)
EOF
