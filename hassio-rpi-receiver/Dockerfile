ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV LANG C.UTF-8

# install base pkgs
RUN apk update && apk add --no-cache jq py3-pip clang libgcc \
                            gcc-gnat libgc++ g++ make libffi-dev \
                            openssl-dev python3-dev mosquitto \
                            mosquitto-dev mosquitto-clients \
                            mosquitto-libs

# install dev pkgs
RUN pip3 --no-cache-dir install --upgrade pyaes pycrypto

RUN apk add --no-cache jq py-pip python	python-dev python3 \
              python3-dev
	      
RUN pip install -U pip 
RUN pip3 install -U pip 
RUN pip install -U virtualenv

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 
