#!/bin/bash
# remove --test to actually push to docker hub
builder="homeassistant/amd64-builder"
docker run --rm -ti --name hassio-builder --privileged \
    -v $PWD:/src -v ~/.docker:/root/.docker -v /var/run/docker.sock:/var/run/docker.sock:ro \
    ${builder} \
    --aarch64 \
    -t /src -i hassio-$(basename $PWD)-{arch} \
    -d ${DOCKER_REPOSITORY:-local} \
    --docker-hub-check \
    --test
