#!/bin/bash
set -euo pipefail
DEV="${1:-}"
IMG="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/build/output/aureus-dsp-rpi4-v1.img"

[ -n "$DEV" ] || { echo "Usage: sudo ./flash-sd.sh /dev/sdX"; exit 2; }
[ -f "$IMG" ] || { echo "Image not found: $IMG"; exit 2; }

case "$DEV" in
  /dev/sda|/dev/nvme0n1|/dev/mmcblk0) echo "Refusing obvious system disk: $DEV"; exit 3 ;;
esac

echo "ABOUT TO ERASE: $DEV"
lsblk "$DEV"
read -r -p "Type ERASE to continue: " ANSWER
[ "$ANSWER" = ERASE ] || exit 1

sudo umount "${DEV}"* 2>/dev/null || true
sudo dd if="$IMG" of="$DEV" bs=8M status=progress conv=fsync
sync
