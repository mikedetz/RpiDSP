#!/bin/bash
set -euo pipefail

IMG="$1"
MNT="$(mktemp -d)"
LOOP=""

cleanup() {
  set +e
  mountpoint -q "$MNT" && sudo umount "$MNT"
  [ -n "$LOOP" ] && sudo losetup -d "$LOOP" || true
  rmdir "$MNT" 2>/dev/null || true
}
trap cleanup EXIT

LOOP="$(sudo losetup --find --show --partscan "$IMG")"
sleep 1
BOOT="${LOOP}p1"
[ -b "$BOOT" ] || BOOT="${LOOP}p1"

sudo mount "$BOOT" "$MNT"
CFG="$MNT/config.txt"

if ! grep -q '^dtoverlay=vc4-kms-v3d' "$CFG" 2>/dev/null; then
  printf '\n# AUREUS DSP: HDMI DRM/KMS\n' | sudo tee -a "$CFG" >/dev/null
  printf 'dtoverlay=vc4-kms-v3d\n' | sudo tee -a "$CFG" >/dev/null
fi

if ! grep -q '^dtoverlay=dwc2' "$CFG" 2>/dev/null; then
  printf '\n# AUREUS DSP: USB-C UAC2 gadget\n' | sudo tee -a "$CFG" >/dev/null
  printf 'dtoverlay=dwc2,dr_mode=peripheral\n' | sudo tee -a "$CFG" >/dev/null
fi

sudo sync
