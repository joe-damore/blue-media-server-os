#!/bin/bash

set -ouex pipefail

mkdir -p /usr/lib/mediaserver/storage

# Enable RPMFusion
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

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
  podman-compose

dnf5 -y reinstall shadow-utils

echo podman:10000:5000 > /etc/subuid
echo podman:10000:5000 > /etc/subgid
echo root:10000:5000 > /etc/subuid
echo root:10000:5000 > /etc/subgid

# Create 'mediaserver' system user
useradd -r -s /usr/sbin/nologin -m -d /var/lib/mediaserver mediaserver

cat /etc/passwd
 # cat /usr/etc/passwd
cat /usr/lib/passwd

systemctl enable podman.socket
systemctl enable cockpit.socket
systemctl enable firewalld

# Add firewall rule to allow access to services
firewall-offline-cmd --add-service=cockpit
firewall-offline-cmd --add-service=plex
# firewall-offline-cmd --add-service=jellyfin

podman pull --root /usr/lib/mediaserver/storage docker.io/linuxserver/plex:latest
podman pull --root /usr/lib/mediaserver/storage docker.io/linuxserver/jellyfin:latest
