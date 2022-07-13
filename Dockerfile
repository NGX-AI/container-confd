# reverse engineering base image version from `johz/confd:0.16.0`
# original basic image `alpine:3.11.6`
FROM alpine:3.16

#
ARG ENV_ENABLE_PROXY
ARG ENV_CONFD_VER="0.16.0"

# install basic deps
RUN set -x \
 && (test "${ENV_ENABLE_PROXY}" != "true" || /bin/sed -i 's,http://dl-cdn.alpinelinux.org,https://mirrors.aliyun.com,g' /etc/apk/repositories) \
 && apk add --no-cache bash libstdc++ curl

# install confd
RUN set -x \
 && ARCH=$(arch | sed -e "s/aarch64/arm64/" -e "s/x86_64/amd64/") \
 && curl -o /usr/local/bin/confd -L "https://github.com/kelseyhightower/confd/releases/download/v${ENV_CONFD_VER}/confd-${ENV_CONFD_VER}-linux-${ARCH}" \
 && chmod 755 /usr/local/bin/confd

CMD ["/usr/local/bin/confd"]

STOPSIGNAL SIGQUIT
