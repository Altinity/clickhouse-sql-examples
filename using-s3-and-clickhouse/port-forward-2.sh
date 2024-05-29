#!/bin/bash
set -x
kubectl port-forward svc/chi-demo2-s3-0-0 8123:8123 &
kubectl port-forward svc/chi-demo2-s3-0-0 9000:9000 &
