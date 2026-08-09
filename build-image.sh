#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/build"
RPIIG="$BUILD/rpi-image-gen"
OUT="$BUILD/output"
mkdir -p "$BUILD" "$OUT"

RPIIG_TAG="v2.6.0"
CAMILLADSP_VERSION="${CAMILLADSP_VERSION:-4.1.0}"

if [ ! -x "$RPIIG/rpi-image-gen" ]; then
  echo "Cloning rpi-image-gen ${RPIIG_TAG}..."
  rm -rf "$RPIIG"
  git clone --depth 1 --branch "$RPIIG_TAG" https://github.com/raspberrypi/rpi-image-gen.git "$RPIIG"
  sudo "$RPIIG/install_deps.sh"
fi

echo "Building AUREUS DSP image..."
rm -rf "$BUILD/work"
mkdir -p "$BUILD/work"

# The source tree is supplied so our local layer and hooks are preferred.
(
  cd "$RPIIG"
  ./rpi-image-gen build \
    -S "$ROOT" \
    -c "$ROOT/config/aureus-dsp.yaml" \
    -- "CAMILLADSP_VERSION=$CAMILLADSP_VERSION"
)

IMG="$(find "$RPIIG/work" -type f -name '*.img' -print -quit)"
if [ -z "$IMG" ]; then
  echo "ERROR: rpi-image-gen did not produce an .img file." >&2
  exit 1
fi

cp "$IMG" "$OUT/aureus-dsp-rpi4-v1.img"
"$ROOT/scripts/patch-boot-image.sh" "$OUT/aureus-dsp-rpi4-v1.img"

sha256sum "$OUT/aureus-dsp-rpi4-v1.img" | tee "$OUT/aureus-dsp-rpi4-v1.img.sha256"
echo
echo "READY: $OUT/aureus-dsp-rpi4-v1.img"
