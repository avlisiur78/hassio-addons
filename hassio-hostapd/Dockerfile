ARG BUILD_FROM=hassioaddons/base:7.0.2
#ARG BUILD_FROM
#FROM $BUILD_FROM
#FROM %%BASE_IMAGE%%
MAINTAINER Rui Silva <avlisiur+git78@gmail.com>

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG C.UTF-8

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
