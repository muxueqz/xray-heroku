#!/bin/sh

# Global variables
DIR_CONFIG="/etc/v2ray"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write V2Ray configuration
cat << EOF > ${DIR_TMP}/heroku.json
{
    "inbounds": [
    {
        "port": ${PORT},
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
            "security":"xtls",
            "wsSettings": {
                "path": "${WSPATH}-vless-xtls"
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
cp-v  ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.json

# Install V2Ray
install -m 755 ${DIR_TMP}/xray ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/xray -config=${DIR_CONFIG}/config.json
