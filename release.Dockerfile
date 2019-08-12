ARG UBUNTU_VERSION_ARG=19.04
ARG DOCKER_VERSION_ARG=19.03.1
ARG BINTRAY_TOKEN_ARG=unknown
ARG BINTRAY_USERNAME_ARG=unknown
ARG GITHUB_TOKEN_ARG=unknown
ARG DOCKER_COMPOSE_RELEASE_VERSION=unknown
ARG GIT_COMMIT=unknown
ARG BUILD_PLATFORM=debian

FROM docker:${DOCKER_VERSION_ARG}
ENV BINTRAY_TOKEN=$BINTRAY_TOKEN_ARG
ENV GITHUB_TOKEN=$GITHUB_TOKEN_ARG
ENV DOCKER_BUILDKIT=1

RUN apk add --no-cache \
    bash \
    curl \
    git \
    python3

# Switch back to git clone when done
# RUN git clone https://github.com/docker/compose.git /compose

COPY . /compose

WORKDIR /compose
