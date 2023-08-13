#!/bin/bash
# Create a service account with S3 access rights. 
set -ex
aws iam create-policy --policy-name s3-bucket-access \
  --policy-document file://s3-bucket-policy.json

eksctl create iamserviceaccount --name s3-bucket-access --namespace ch \
  --cluster ubuntu-altinity-cloud-anywhere-demo \
  --role-name s3-bucket-access \
  --attach-policy-arn arn:aws:iam::407099639081:policy/s3-bucket-access \
  --approve --override-existing-serviceaccounts
