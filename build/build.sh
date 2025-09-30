#!/bin/bash

set -ouex pipefail

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
  podman-compose

systemctl enable podman.socket
systemctl enable cockpit.socket
systemctl enable firewalld

podman save plex.tar docker.io/linuxserver/plex:latest

# Add firewall rule to allow access to services
firewall-offline-cmd --add-service=cockpit
