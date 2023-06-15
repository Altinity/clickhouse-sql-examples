# Fortress ClickHouse Artifacts

Scripts and example configuration to secure ClickHouse. 

## Command to connect to secure ClickHouse with password. 

Password was pre-generated. 

```
clickhouse-client --host=fortress --password=WLNj00x/ --secure
```

## Command to verify certificate. 

```
openssl s_client fortress:9440 -connect fortress:9440
```

## Command to install fortress CA certificate in certificate store. 

```
cp /etc/clickhouse-server/certs/fortress_ca.crt /usr/local/share/ca-certificates
update-ca-certificates
```
