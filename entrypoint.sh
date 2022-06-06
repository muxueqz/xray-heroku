#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/opt/xray"
DIR_TMP="$(mktemp -d)"

# Write V2Ray configuration
        # "port": ${PORT},
cat << EOF > ${DIR_TMP}/heroku.json
{
    "inbounds": [
    {
        "port": 8080,
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}-vmess"
            }
        }
    },
    {
        "port": ${PORT},
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "${ID}"
            }],
            "decryption": "none"
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}-vless"
            }
        }
    }
    ],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
cp -v  ${DIR_TMP}/heroku.json ${DIR_CONFIG}/config.json

rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/xray run -c ${DIR_CONFIG}/config.json
