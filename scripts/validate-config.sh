#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -x "$ROOT/build/rpi-image-gen/rpi-image-gen" ] || {
  echo "Run ./build-image.sh once to install rpi-image-gen."
  exit 2
}
"$ROOT/build/rpi-image-gen/rpi-image-gen" metadata --lint "$ROOT/layer/aureus-dsp.yaml"
