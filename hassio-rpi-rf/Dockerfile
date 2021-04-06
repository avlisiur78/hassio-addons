ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
#SHELL ["/bin/bash", "-o", "pipefail", "-c"]

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
        
RUN pip3 install -U wheel
RUN pip3 install -U "RPi.GPIO>=0.7.1a2"
RUN pip3 install -U rpi-rf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 

CMD [ "cp rpi-rf_receive.py /share/" ]
