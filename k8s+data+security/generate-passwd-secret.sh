#!/bin/bash
# Generate a random password. First printed value is what you use
# to login. 
echo "Generating random password and sha256sum of same"
PASSWORD=$(base64 < /dev/urandom | head -c8); 
SHA256_PASSWORD=$(echo -n "$PASSWORD" | sha256sum | tr -d '-')
echo "Password: $PASSWORD"
echo "SHA 256 : $SHA256_PASSWORD"
set -x
kubectl delete secret db-passwords
kubectl apply -f - <<END
apiVersion: v1
kind: Secret
metadata:
  name: db-passwords
type: Opaque
stringData:
  password_sha256_hex: $SHA256_PASSWORD
END
kubectl get secret db-passwords -o json
kubectl get secret db-passwords -o jsonpath='{.data.password_sha256_hex}' | base64 --decode
