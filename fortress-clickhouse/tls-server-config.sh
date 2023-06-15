#!/bin/bash
# Set up configuration for ClickHouse encrypted networking. 
cat << EOF > data/conf.d/ssl.xml
<clickhouse>
    <!-- disable http and enable https port --> 
    <http_port remove="true"/>
    <https_port>8443</https_port>
    
    <!-- disable tcp and enable secure tcp port -->
    <tcp_port remove="true"/>
    <tcp_port_secure>9440</tcp_port_secure>
    
    <!-- disable http and enable https inter-server port -->
    <interserver_http_port remove="true"/>
    <interserver_https_port>9010</interserver_https_port>
    
    <!-- configure OpenSSL -->
    <openSSL>
        <server>
            <certificateFile>/etc/clickhouse-server/certs/server.crt</certificateFile>
            <privateKeyFile>/etc/clickhouse-server/certs/server.key</privateKeyFile>
            <caConfig>/etc/clickhouse-server/certs/fortress_ca.crt</caConfig>
            <loadDefaultCAFile>false</loadDefaultCAFile>
	    <!-- <verificationMode>strict</verificationMode> -->
            <verificationMode>relaxed</verificationMode>
            <cacheSessions>true</cacheSessions>
            <disableProtocols>sslv2,sslv3</disableProtocols>
            <preferServerCiphers>true</preferServerCiphers>
            <invalidCertificateHandler>
                <name>RejectCertificateHandler</name>
            </invalidCertificateHandler>
        </server>
        <client>
            <loadDefaultCAFile>false</loadDefaultCAFile>
            <caConfig>/etc/clickhouse-server/certs/fortress_ca.crt</caConfig>
            <certificateFile>/etc/clickhouse-server/certs/server.crt</certificateFile>
            <privateKeyFile>/etc/clickhouse-server/certs/server.key</privateKeyFile>
            <cacheSessions>true</cacheSessions>
            <disableProtocols>sslv2,sslv3</disableProtocols>
            <preferServerCiphers>true</preferServerCiphers>
            <verificationMode>strict</verificationMode>
            <invalidCertificateHandler>
                <name>RejectCertificateHandler</name>
            </invalidCertificateHandler>
        </client>
    </openSSL>
</clickhouse>
EOF
