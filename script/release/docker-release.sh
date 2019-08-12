#!/usr/bin/env bash

set -xe

RELEASE_IMAGE_AND_TAG=docker-compose-release:latest
TARGET_COMPOSE_IMAGE=docker/compose
TARGET_COMPOSE_VERSION=1.25.0-rc2
TARGET_COMPOSE_IMAGE_AND_TAG="${TARGET_COMPOSE_IMAGE}:${TARGET_COMPOSE_VERSION}"

docker image rm -f ${RELEASE_IMAGE_AND_TAG}
docker build --no-cache -f release.Dockerfile . -t ${RELEASE_IMAGE_AND_TAG} \
    --build-arg DOCKER_COMPOSE_RELEASE_VERSION=${TARGET_COMPOSE_VERSION}

function run_in_container() {
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ${RELEASE_IMAGE_AND_TAG} ${@}
}

# Build images ${TARGET_COMPOSE_IMAGE_AND_TAG}-${platform}
platforms=( alpine debian )
for platform in "${platforms[@]}"
do
    echo "--- Building ${platform} image ---"
    run_in_container \
        docker build -t ${TARGET_COMPOSE_IMAGE_AND_TAG}-${platform} . --build-arg BUILD_PLATFORM=${platform}
done

BINTRAY_USERNAME_ARG=ulyssessouza
RELEASE_COMMAND=startfake

run_in_container ./script/release/insider.sh ${BINTRAY_USERNAME_ARG} ${RELEASE_COMMAND} ${TARGET_COMPOSE_VERSION}
