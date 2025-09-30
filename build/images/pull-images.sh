#!/bin/bash

set -ouex pipefail

podman pull docker.io/linuxserver/plex:latest
podman pull docker.io/linuxserver/jellyfin:latest
