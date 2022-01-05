FROM alpine:latest

ADD entrypoint.sh /opt/entrypoint.sh

# RUN apk add --no-cache --virtual .build-deps ca-certificates curl \

RUN apk update && \
  apk add --no-cache ca-certificates wget && \
  wget -O Xray-linux-64.zip  https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip  && \
  unzip Xray-linux-64.zip && \
  chmod +x /xray && \
  chmod +x /opt/entrypoint.sh && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["sh", "-c", "/opt/entrypoint.sh"]
