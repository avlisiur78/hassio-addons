ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Add env
ENV LANG C.UTF-8

RUN echo -e "http://nl.alpinelinux.org/alpine/v3.13/main\nhttp://nl.alpinelinux.org/alpine/v3.13/community" > /etc/apk/repositories
# install pkgs
RUN apk update
RUN apk add --no-cache jq
#RUN apk add --no-cache py-pip 
RUN apk add --no-cache py3-pip
RUN apk add --no-cache clang
RUN apk add --no-cache libgcc
RUN apk add --no-cache gcc-gnat
RUN apk add --no-cache libgc++ 
RUN apk add --no-cache g++ 
RUN apk add --no-cache make 
RUN apk add --no-cache libffi-dev
RUN apk add --no-cache openssl-dev 
#RUN apk add --no-cache python
#RUN apk add --no-cache python-dev
RUN apk add --no-cache python3
RUN apk add --no-cache python3-dev 
RUN apk add --no-cache mosquitto
RUN apk add --no-cache mosquitto-dev 
RUN apk add --no-cache mosquitto-clients 
RUN apk add --no-cache mosquitto-libs

RUN pip3 --no-cache-dir install --upgrade pyaes 
RUN pip3 --no-cache-dir install --upgrade pycrypto

# RUN pip install -U pip 
# RUN pip install -U virtualenv
RUN pip3 install -U virtualenv
RUN pip3 install -U pip 


# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ] 
