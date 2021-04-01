ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV LANG C.UTF-8

RUN apk add --no-cache build-base
RUN apk add --no-cache python3
RUN apk add --no-cache python3-dev
RUN apk add --no-cache py3-pip
RUN apk add --no-cache g++

RUN apk add --no-cache jq
RUN apk add --no-cache clang
RUN apk add --no-cache libgcc
RUN apk add --no-cache gcc-gnat
RUN apk add --no-cache libgc++
RUN apk add --no-cache make
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache mosquitto
RUN apk add --no-cache mosquitto-dev
RUN apk add --no-cache mosquitto-clients
RUN apk add --no-cache mosquitto-libs

RUN pip3 install wheel
RUN pip3 install pyaes
RUN pip3 install pycrypto
RUN pip3 install -U virtualenv
RUN pip3 install -U "RPi.GPIO>=0.7.1a2"
RUN pip3 install -U rpi-rf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 
