#!/bin/bash

set -ouex pipefail

# mkdir -p /usr/lib/mediaserver/storage
mkdir -p /usr/lib/image-cache

# Enable RPMFusion
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Add Tailscale repo
dnf5 config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo

dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

# Remove Flatpak
dnf5 -y remove flatpak

# Remove Universal Blue update services
dnf5 -y remove ublue-os-update-services ublue-update

dnf5 -y install \
  cockpit \
  cockpit-files \
  cockpit-podman \
  cockpit-selinux \
  container-selinux \
  fail2ban \
  fail2ban-firewalld \
  podman \
  podman-compose \
  skopeo \
  tailscale

dnf5 -y reinstall shadow-utils

echo podman:10000:5000 > /etc/subuid
echo podman:10000:5000 > /etc/subgid
echo root:10000:5000 > /etc/subuid
echo root:10000:5000 > /etc/subgid

# Create 'mediaserver' system user
useradd -r -s /usr/sbin/nologin -m -d /var/lib/mediaserver mediaserver

systemctl enable podman.socket
systemctl enable cockpit.socket
systemctl enable firewalld

# Add firewall rule to allow access to services
firewall-offline-cmd --add-service=cockpit
firewall-offline-cmd --add-service=plex
# firewall-offline-cmd --add-service=jellyfin

/tmp/build/embed_image.sh docker.io/linuxserver/plex:latest
# skopeo copy --preserve-digests docker://docker.io/linuxserver/plex:latest dir:/usr/lib/mediaserver/storage
# podman pull --root /usr/lib/mediaserver/storage docker.io/linuxserver/plex:latest
# podman pull --root /usr/lib/mediaserver/storage docker.io/linuxserver/jellyfin:latest
