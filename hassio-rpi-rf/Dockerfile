ARG BUILD_FROM
FROM hassioaddons/debian-base-armv7:3.2.3
# Add env 
ENV LANG C.UTF-8

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Get dependencies
RUN apt-get update \
\
&& apt-get install  -y --no-install-recommends \
        git \
        cmake \
        libmosquittopp-dev \
        autoconf \ 
        automake\
        pkg-config \
        libtool \
        autoconf-archive \
        libgpiod-dev \
        build-essential \
        sudo \
        sed
# add "gpiod" for "gpioinfo"

# Clone and build nexus433
RUN git clone --branch "v1.0.1" --depth=1 https://github.com/aquaticus/nexus433 /tmp/nexus433  \
&& mkdir /tmp/debug \
&& cd /tmp/debug \
&& cmake ../nexus433 -DCMAKE_BUILD_TYPE=DEBUG -DBOARD=RASPBERRYPI \
&& make \
&& make install 
RUN chmod a+x /usr/local/bin/nexus433

# Copy root filesystem
COPY rootfs /

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Carsten Hess" \
