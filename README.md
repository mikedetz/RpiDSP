# AUREUS DSP — Raspberry Pi 4 V1

Minimal USB PCM DSP appliance:

Windows 11 USB PCM OUT → Raspberry Pi 4 USB-C UAC2 Gadget → ALSA → CamillaDSP → USB Host → Audiophonics EVO-Sabre

**V1 deliberately excludes DSD/DoP.**

## Build target

- Raspberry Pi 4 / 1 GB RAM
- 64-bit Raspberry Pi OS / Debian Trixie base
- ALSA only; no PulseAudio, PipeWire, Volumio or desktop
- UAC2 USB gadget on the Pi 4 USB-C port
- USB host output to the EVO-Sabre
- CamillaDSP 4.x
- HDMI status display
- PCM rates advertised to Windows: 44.1, 48, 88.2, 96, 176.4, 192, 352.8, 384, 705.6, 768 kHz
- PCM formats: 24/32-bit
- Automatic rate detection/restart
- Safe startup volume: -40 dB
- First preset: `AUREUS LINEAR 01`

## Important hardware note

The Pi 4 USB-C port must be connected to the Windows 11 PC for gadget input.
The EVO-Sabre is connected to one of the Pi 4 USB-A host ports.

This repository uses the Linux UAC2 ConfigFS function. The kernel exposes the UAC2 gadget as an ALSA capture device. Current CamillaDSP documentation also notes that USB Audio Gadget clock tuning can be used for long-term drift correction.

## Build host

The supported/recommended build host for `rpi-image-gen` is a 64-bit Debian Bookworm/Trixie or Raspberry Pi OS host. `rpi-image-gen` is the current Raspberry Pi image generator and is pinned to v2.6.0 by this project.

Install dependencies and build:

    ./build-image.sh

Output:

    build/output/aureus-dsp-rpi4-v1.img

The script installs rpi-image-gen v2.6.0 into `build/rpi-image-gen/`, builds the image, then patches the generated boot partition with the Pi 4 USB OTG settings.

## Flash

Use Raspberry Pi Imager → Use Custom, select the generated `.img`, then select the microSD card.

Or on Linux:

    sudo ./flash-sd.sh /dev/sdX

The script intentionally requires a block device argument and refuses obvious system disks.

## First boot

1. Connect HDMI.
2. Connect the Pi 4 USB-C port to Windows 11.
3. Connect EVO-Sabre USB-B to a Pi USB-A port.
4. Power the Pi.
5. Windows should enumerate `AUREUS DSP` as a USB Audio Class 2 playback device.
6. Select it as the Windows output.
7. Start playback.

The HDMI display initially shows `WAITING FOR USB`, then the active PCM sample rate and current CamillaDSP volume.

## Current limitations

This is V1, deliberately small:

- no DSD
- no DoP
- no network/web GUI
- no physical volume encoder
- no preset buttons
- HDMI is display-only
- automatic rate switching is implemented by restarting CamillaDSP after a rate change
- 768 kHz is advertised by the UAC2 gadget, but must be verified with the specific Windows 11 USB stack and source application before treating it as production-ready

## Source projects

- Raspberry Pi rpi-image-gen: https://github.com/raspberrypi/rpi-image-gen
- CamillaDSP: https://github.com/HEnquist/camilladsp
- RPi-CamillaDSP reference: https://github.com/mdsimon2/RPi-CamillaDSP
