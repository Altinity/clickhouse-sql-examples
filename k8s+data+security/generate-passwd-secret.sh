#!/bin/bash
# Generate a secret file with ClickHouse SHA265-encoded passwords. 

# First generate and print the passwords. 
gen_pwd() {
  pwd=$(base64 < /dev/urandom | head -c8);
  pwd_256=$(echo -n "$pwd" | sha256sum | tr -d '-' | xargs)
  echo $pwd $pwd_256
}
read -r DEFAULT_PWD DEFAULT_PWD_256 < <(gen_pwd)
echo "Password for default: $DEFAULT_PWD"
echo "Password for default (SHA256): $DEFAULT_PWD_256"
read -r ROOT_PWD ROOT_PWD_256 < <(gen_pwd)
echo "Password for root: $ROOT_PWD"
echo "Password for root (SHA256): $ROOT_PWD_256"

# Next generate the secret. 
SECRET="`cat  <<END
apiVersion: v1
kind: Secret
metadata:
  name: db-passwords
type: Opaque
stringData:
  default_password_sha256: $DEFAULT_PWD_256
  root_password_sha256: $ROOT_PWD_256
END`"

# Finally apply. Set -x prints commands so we can see the applied resource.
# Last command prints the resource minus the metadata tag, so you can see
# what Kubernetes thinks it has without clutter. 
set -x
kubectl delete secret db-passwords
echo "$SECRET" | kubectl apply -f -
kubectl get secret db-passwords -o json |jq 'del(.metadata)'
