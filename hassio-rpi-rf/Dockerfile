ARG BUILD_FROM
FROM $BUILD_FROM

# Add env
ENV LANG C.UTF-8
RUN apk add --no-cache jq
RUN apk add --no-cache clang
RUN apk add --no-cache build-base
RUN apk add --no-cache libgcc
RUN apk add --no-cache gcc-gnat
RUN apk add --no-cache libgc++
RUN apk add --no-cache g++
RUN apk add --no-cache make
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache openssl-dev
RUN apk add --no-cache mosquitto
RUN apk add --no-cache mosquitto-dev
RUN apk add --no-cache mosquitto-clients
RUN apk add --no-cache mosquitto-libs
RUN pip install pyaes
RUN pip install pycrypto
RUN apk add --no-cache \
    	jq \
	python3 \
	python3-dev\
 && pip3 install -U pip \
 && pip3 install -U virtualenv

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 
