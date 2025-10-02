ARG BASE_IMAGE_NAME="base"
ARG BASE_IMAGE_VARIANT="main"
ARG BASE_IMAGE_FEDORA_MAJOR_VERSION="41"
ARG BASE_IMAGE_RESOLVED="ghcr.io/ublue-os/${BASE_IMAGE_NAME}-${BASE_IMAGE_VARIANT}"

FROM ${BASE_IMAGE_RESOLVED}:${BASE_IMAGE_FEDORA_MAJOR_VERSION} AS base

VOLUME /var/lib/containers
VOLUME /var/home/podman/.local/share/containers

COPY /build /tmp/build

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build/build.sh && \
    ostree container commit
