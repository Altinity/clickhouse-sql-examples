#/bin/bash
set -x
#ch-client.sh --database=test < 00-clean.sql 
#ch-client.sh --database=test < 01-create-table.sql
#ch-client.sh --database=test < 02-load-data.sql
ch-client.sh --database=test \
  --param_AWS_S3_BUCKET="$AWS_S3_BUCKET" \
  --param_AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  --param_AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" < 03-store-to-s3.sql
