#ARG BUILD_FROM
#FROM $BUILD_FROM

ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:10.0.1
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

MAINTAINER Rui Silva <avlisiur+git78@gmail.com>

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG C.UTF-8

RUN echo -e "http://nl.alpinelinux.org/alpine/v3.14/main\nhttp://nl.alpinelinux.org/alpine/v3.14/community" > /etc/apk/repositories

# Install requirements for add-on
RUN apk update && apk add --no-cache strace \
                            bash \
                            jq \
                            iw \
                            linux-firmware-other \
                            linux-firmware-ath6k \
                            linux-firmware-ath10k \
                            linux-firmware-ath9k_htc \
                            openvpn \
                            hostapd \
                            networkmanager \
                            iptables \
                            net-tools \
                            sudo \
                            busybox-extras  && \
                            rm -rf /etc/apk/repositories/* && \
                            rm -rf /tmp/* && \
                            rm -rf /var/cache/apk/*

COPY hostapd.conf /
COPY udhcpd.conf /etc/udhcpd.conf
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
