#!/bin/bash

set -ouex pipefail

podman system migrate

sudo podman pull docker.io/linuxserver/plex:latest
podman pull docker.io/linuxserver/jellyfin:latest
