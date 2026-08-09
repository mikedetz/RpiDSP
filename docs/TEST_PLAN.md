# V1 test plan

## 1. Gadget

On the Pi:

    systemctl status aureus-usb-gadget
    arecord -l
    cat /sys/kernel/config/usb_gadget/aureus/functions/uac2.usb0/c_srate

Expected UAC2 rates:

44100 48000 88200 96000 176400 192000 352800 384000 705600 768000

## 2. Windows

Open Sound settings → More sound settings → Playback → AUREUS DSP → Properties → Advanced.

Test each rate one at a time. Start with 44.1/48/96/192, then 352.8/384, and finally 705.6/768.

## 3. DAC

On the Pi:

    aplay -l
    aplay -D hw:<EVO_CARD> /usr/share/sounds/alsa/Front_Left.wav

Use a known-good USB cable and the EVO-Sabre USB input.

## 4. DSP

Check:

    journalctl -u aureus-dsp -f
    aureus-status

The HDMI screen should show the selected rate and -40.0 dB.

## 5. Long-run clock test

Run a continuous 96 kHz test for at least 2 hours. Check:

    journalctl -u aureus-dsp
    dmesg | grep -Ei 'underrun|overrun|xrun'

The rate-adjust feature is expected to prevent long-term drift between the Windows gadget clock and the EVO-Sabre playback clock.
