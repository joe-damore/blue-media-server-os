#!/bin/bash

set -ouex pipefail

image=$1
additional_copy_args=${2:-""}

mkdir -p /usr/lib/image-cache
sha=$(echo "$image" | sha256sum | awk '{ print $1 }')
skopeo copy $additional_copy_args --preserve-digests docker://$image dir:/usr/lib/image-cache/$sha
echo "$image,$sha" >> /usr/lib/image-cache/mapping.txt
