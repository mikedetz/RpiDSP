#!/bin/sh
set -eu

AUREUS_ROOT="/opt/aureus-build"
install -d -m 0755 "$AUREUS_ROOT"

CAMILLADSP_VERSION="${CAMILLADSP_VERSION:-4.1.0}"
URL="https://github.com/HEnquist/camilladsp/releases/download/v${CAMILLADSP_VERSION}/camilladsp-linux-aarch64.tar.gz"

echo "Installing CamillaDSP v${CAMILLADSP_VERSION}"
curl -fL --retry 5 --retry-delay 2 "$URL" -o /tmp/camilladsp.tar.gz
tar -xzf /tmp/camilladsp.tar.gz -C /tmp
install -m 0755 /tmp/camilladsp /usr/local/bin/camilladsp
rm -f /tmp/camilladsp.tar.gz /tmp/camilladsp

install -d -m 0755 /var/lib/aureus
install -d -m 0755 /var/log/aureus
install -d -m 0755 /etc/aureus

# Make the system headless/lightweight.
systemctl disable --now NetworkManager.service 2>/dev/null || true
systemctl disable --now bluetooth.service 2>/dev/null || true
systemctl disable --now hciuart.service 2>/dev/null || true

# Do not enable a desktop or sound server.
systemctl mask pulseaudio.service pipewire.service pipewire-pulse.service 2>/dev/null || true

rm -f /etc/systemd/system/getty.target.wants/getty@tty1.service 2>/dev/null || true

echo "AUREUS DSP image customization complete."
