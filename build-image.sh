#!/bin/bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD="$ROOT/build"
RPIIG="$BUILD/rpi-image-gen"
OUT="$BUILD/output"

RPIIG_TAG="v2.6.0"
CAMILLADSP_VERSION="${CAMILLADSP_VERSION:-4.1.3}"

mkdir -p "$BUILD" "$OUT"

if [ "$(uname -m)" != "aarch64" ]; then
    echo "ERROR: build must run on a 64-bit ARM64/Linux host."
    echo "Detected: $(uname -m)"
    exit 1
fi

if [ ! -x "$RPIIG/rpi-image-gen" ]; then
    echo "Installing rpi-image-gen ${RPIIG_TAG}..."

    rm -rf "$RPIIG"

    git clone \
        --depth 1 \
        --branch "$RPIIG_TAG" \
        https://github.com/raspberrypi/rpi-image-gen.git \
        "$RPIIG"

    sudo "$RPIIG/install_deps.sh"
fi

echo
echo "========================================"
echo " AUREUS DSP RPi4 V1.1"
echo " CamillaDSP ${CAMILLADSP_VERSION}"
echo "========================================"
echo

rm -rf "$BUILD/work"
mkdir -p "$BUILD/work"

cd "$RPIIG"

./rpi-image-gen build \
    -S "$ROOT" \
    -c "$ROOT/config/aureus-dsp.yaml" \
    -- "CAMILLADSP_VERSION=$CAMILLADSP_VERSION"

IMG="$(find "$RPIIG/work" -type f -name '*.img' -print -quit)"

if [ -z "$IMG" ]; then
    echo "ERROR: rpi-image-gen did not produce an image."
    exit 1
fi

cp "$IMG" "$OUT/aureus-dsp-rpi4-v1.1.img"

if [ -x "$ROOT/scripts/patch-boot-image.sh" ]; then
    "$ROOT/scripts/patch-boot-image.sh" \
        "$OUT/aureus-dsp-rpi4-v1.1.img"
fi

sha256sum \
    "$OUT/aureus-dsp-rpi4-v1.1.img" \
    | tee "$OUT/aureus-dsp-rpi4-v1.1.img.sha256"

echo
echo "========================================"
echo " IMAGE READY"
echo "========================================"
echo "$OUT/aureus-dsp-rpi4-v1.1.img"
