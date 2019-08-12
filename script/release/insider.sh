#!/usr/bin/env bash

BINTRAY_USERNAME_ARG=${1}
RELEASE_COMMAND=${2}
TARGET_COMPOSE_VERSION=${3}

echo "Inside the container HOME=${HOME}"
./script/release/setup-venv.sh
./script/release/release.sh -b ${BINTRAY_USERNAME_ARG} ${RELEASE_COMMAND} ${TARGET_COMPOSE_VERSION}
