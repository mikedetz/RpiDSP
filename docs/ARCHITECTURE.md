# AUREUS DSP V1 architecture

```text
Windows 11
    |
    | USB-C
    v
RPi 4 DWC2 peripheral
    |
    v
Linux UAC2 ConfigFS gadget
    |
    v
ALSA capture: UAC2Gadget
    |
    v
CamillaDSP
    |  FIR / IIR / gain / mixer / drift correction
    v
ALSA playback
    |
    v
RPi 4 USB host
    |
    | USB-A
    v
Audiophonics EVO-Sabre
```

The USB gadget advertises a set of PCM rates in the UAC2 descriptor. Windows selects the active rate. The ALSA gadget's active `hw_params` is read from `/proc/asound`, and the runner starts CamillaDSP at that rate.

When CamillaDSP detects a capture rate change it stops. The runner then starts it again using the newly active rate.

`enable_rate_adjust: true` is intentional: the Windows USB gadget and the EVO-Sabre have independent clocks. Current CamillaDSP supports clock tuning for USB Audio Gadget on Linux, which is preferable to inserting an unnecessary resampler.
