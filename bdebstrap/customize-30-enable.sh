#!/bin/sh
set -eu
systemctl enable aureus-firstboot.service
systemctl enable aureus-usb-gadget.service
systemctl enable aureus-dsp.service
systemctl enable aureus-gui.service
systemctl set-default multi-user.target
