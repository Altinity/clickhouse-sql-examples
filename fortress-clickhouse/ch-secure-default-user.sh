#!/bin/bash
# Show how to lock down the default user. 
mkdir -p data/users.d
cat << EOF > data/users.d/default.xml
<clickhouse>
    <users>
        <default>
	    <!-- WLNj00x/ -->
            <password remove='1' />
            <password_sha256_hex>f8cff8b0931a6d9d2367b36cc803fd60c210e2f97500da699a26e05f1d23d8b5</password_sha256_hex>
            <networks>
                <ip>::1</ip>
                <ip>127.0.0.1</ip>
            </networks>
            <access_management>1</access_management>
        </default>
    </users>
</clickhouse>
EOF
