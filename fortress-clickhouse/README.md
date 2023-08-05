# Fortress ClickHouse Artifacts

Scripts and example configuration to secure ClickHouse. These 
are used in the Altinity [Fortress ClickHouse webinar](https://altinity.com/wp-content/uploads/2023/06/Fortress-ClickHouse-Secure-Your-Database-and-Foil-Evildoers-2023-06-15.pdf). 


## Start ClickHouse for demo purposes

Pull ClickHouse container, add clickhouse:my-fortress tag,
and start container with storage in local directories and
publicly available ClickHouse port.
```
./docker-pull-clickhouse-23.3.sh
./docker-run-2-with-storage.sh
```

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
