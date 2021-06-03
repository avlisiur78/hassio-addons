ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install requirements
RUN apk update && apk add --no-cache jq openvpn && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Copy data
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
