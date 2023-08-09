#!/bin/bash
set -x
kubectl delete secret generic db-user-pass
kubectl create secret generic db-user-pass \
  --from-literal=username=root \
  --from-literal=password='S!B\*d$zDsb='
kubectl describe secret db-root-user
kubectl get secret db-user-pass -o jsonpath='{.data}'
echo UyFCXCpkJHpEc2I9 |base64 --decode
