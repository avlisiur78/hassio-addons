ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV LANG C.UTF-8

RUN apk add --no-cache coreutils \
        wget \
        nano \
        jq \
        clang \
        build-base \
        libgcc \
        libgc++ \
        gcc-gnat \
        g++ \
        make \
        libffi-dev \
        openssl-dev \
        mosquitto \
        mosquitto-dev \
        mosquitto-libs \
        mosquitto-clients \
        python3 \
        python3-dev \
        py3-pip

RUN pip3 install -U wheel
RUN pip3 install -U pyaes
RUN pip3 install -U pycrypto
RUN pip3 install -U virtualenv
RUN pip3 install -U "RPi.GPIO>=0.7.1a2"
RUN pip3 install -U rpi-rf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="RF Receiver" \
    io.hass.description="433 MHz RF Receiver" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="" \
    org.opencontainers.image.title="RF Receiver" \
    org.opencontainers.image.description="433 MHz RF Receiver" \
    org.opencontainers.image.vendor="" \
    org.opencontainers.image.authors="" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="" \
    org.opencontainers.image.source="https://github.com/avlisiur78/hassio-addons" \
    org.opencontainers.image.documentation="https://github.com/avlisiur78/hassio-addons/blob/master/hassio-rpi-rf/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
