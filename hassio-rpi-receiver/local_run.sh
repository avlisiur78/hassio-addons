#!/bin/bash
# add '--privileged' if necessary
docker run --rm -v $PWD/data:/data ${DOCKER_REPOSITORY:-local}/hassio-$(basename $PWD)-amd64
