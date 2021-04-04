ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV LANG C.UTF-8

RUN apk add --no-cache wget \
        nano \
        jq \
        clang \
        build-base \
        python3 \
        python3-dev \
        py3-pip \
        g++ \
        build-base
        
pip3 install -U wheel
pip3 install -U "RPi.GPIO>=0.7.1a2"
pip3 install -U rpi-rf

# Copy script for receive 
COPY rpi-rf_receive.py /share/

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 

# Labels
LABEL \
    org.opencontainers.image.title="RF Receiver" \
    org.opencontainers.image.description="433 MHz RF Receiver" 
