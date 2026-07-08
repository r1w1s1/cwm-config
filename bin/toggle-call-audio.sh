#!/bin/sh

STATE_FILE="$HOME/.mic_toggle_state"

# Devices (new phone)
BT_SINK="bluez_output.50_1B_6A_B5_A0_54.1"
BT_SOURCE="bluez_input.50:1B:6A:B5:A0:54"
INTERNAL_SINK="alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink"
INTERNAL_SOURCE="alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source"

if [ -f "$STATE_FILE" ]; then
  echo "🎧 Switching to internal audio"
  pactl set-default-sink "$INTERNAL_SINK"
  pactl set-default-source "$INTERNAL_SOURCE"
  rm "$STATE_FILE"
else
  echo "🎧 Switching to Bluetooth audio"
  bluetoothctl connect 50:1B:6A:B5:A0:54
  sleep 3
  pactl set-default-sink "$BT_SINK"
  pactl set-default-source "$BT_SOURCE"
  touch "$STATE_FILE"
fi

