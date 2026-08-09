# Build notes

The repository deliberately pins `rpi-image-gen` to v2.6.0, which is the latest release at the time this project was created.

The build host must have network access because it downloads:
1. rpi-image-gen
2. Debian/Raspberry Pi packages
3. CamillaDSP aarch64 binary

The resulting image is a normal bootable Raspberry Pi image and can be selected with Raspberry Pi Imager's `Use Custom` function.
