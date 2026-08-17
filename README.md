# cwm configurations, workflows and desktop showcase

My minimal CWM setup for Slackware Linux, along with a small, curated showcase
of real-world CWM desktops.

This repository is the practical showcase of [Window Manager Agnostic Workflows](https://github.com/r1w1s1/code-notes/blob/main/notes/Window_Manager_Agnostic_Workflows.txt). It is the keyboard-driven X11 desktop I use day to day, built around CWM, dmenu-style helpers, and small shell scripts. CWM handles window management and the global keyboard workflow.

![CWM desktop screenshot](cwm.png)

## How It Works

`.xinitrc.cwm` prepares the X session, starts the shared helpers, and then
executes CWM. The window manager is the last component in the startup chain.

```text
startx
  |
  +-- .xinitrc.cwm
  |     |
  |     +-- load .xprofile, X resources, and keymaps
  |     +-- start the DBus session bus
  |     +-- source .xinitrc.common
  |     |     |
   |     |     +-- optional screen saver / DPMS
   |     |     +-- keyboard layout
   |     |     +-- xhidecursor
   |     |     +-- wallpaper
   |     |
   |     +-- exec cwm --------------- window management
   |
   +-- CWM and shell helpers provide the desktop workflow
```

## Idea

The setup follows a window-manager-agnostic workflow:

- CWM handles focus, groups, window movement, resizing, and borders.
- CWM handles global shortcuts for launching programs, locking, screenshots, audio, and brightness.
- shell scripts provide the desktop helpers used by those shortcuts.
- `.xinitrc.common` starts shared session components.
- `.xinitrc.cwm` prepares the X session and selects CWM as the final window manager.

## Workflow

The configuration is divided into two kinds of behavior:

- CWM-specific actions stay in `.cwmrc`: focus, groups, movement, resizing, and appearance.
- Global desktop actions stay in `.cwmrc` and shell helpers: launching programs, locking, screenshots, audio, and brightness.

This keeps the daily keyboard workflow separate from the window manager. CWM can
change without requiring the global shortcuts and desktop helpers to be rebuilt.

## Screenshots

The [screenshots gallery](screenshots/README.md) is a small, manually curated
collection of CWM desktops. Screenshots from other users remain attributed to
their original authors and link back to the original Reddit post. This
repository does not claim ownership of those images.

### Preview

<a href="screenshots/README.md#cwm-cyberbird"><img src="screenshots/reddit/debian-cyberbird.png" alt="CWM: Cyberbird" width="220"></a>
<a href="screenshots/README.md#cwm-my-genera-inspired-unix-machine"><img src="screenshots/reddit/alpine-xzwordfeudzx.png" alt="CWM: My Genera inspired Unix machine" width="220"></a>
<a href="screenshots/README.md#cwm-my-quiet-space"><img src="screenshots/reddit/netbsd-quiet-space.png" alt="CWM: My quiet space" width="220"></a>
<a href="screenshots/README.md#cwm-thinkpad-endgame"><img src="screenshots/reddit/thinkpad-cwm.png" alt="CWM: ThinkPad endgame" width="220"></a>
<a href="screenshots/README.md#cwm-openbsd-simple-practical"><img src="screenshots/reddit/openbsd-simple-practical.png" alt="CWM: OpenBSD simple, practical" width="220"></a>
<a href="screenshots/README.md#cwm-astigmatism-friendly"><img src="screenshots/reddit/debian-astigmatism-friendly.png" alt="CWM: Astigmatism friendly" width="220"></a>

## Resources

More background:

- [Window Manager Agnostic Workflows](https://r1w1s1.srht.site/posts/window-manager-agnostic-workflows/) - the design principle behind keeping global shortcuts and desktop helpers outside CWM.
- [Developer blog: jasper@: cwm in Xenocara](https://undeadly.org/cgi?action=article;sid=20070712103624) - historical CWM context from the OpenBSD Journal (2007), including its keyboard-driven and deliberately lightweight character.
- [Getting started with cwm](https://undeadly.org/cgi?action=article;sid=20090502141551) - practical background on groups, `sticky`, `autogroup`, and keyboard-driven configuration.
- [cwm, just right](https://williamjansson.com/posts/cwm/) - a recent personal perspective on CWM's small size, stacking model, and low cognitive load.

## Files

- [`.cwmrc`](.cwmrc) - CWM appearance, groups, mouse bindings, and WM-specific keybindings.
- [`.xinitrc.cwm`](.xinitrc.cwm) - X session entrypoint for CWM.
- [`.xinitrc.common`](.xinitrc.common) - shared X session helpers used before starting the WM.
- [`bin/dmenu_run.sh`](bin/dmenu_run.sh) - styled `dmenu_run` launcher wrapper.
- [`bin/menu`](bin/menu) - small dmenu-based desktop menu.
- [`bin/screenshot-full.sh`](bin/screenshot-full.sh) - full-screen screenshot helper.
- [`bin/screenshot-area.sh`](bin/screenshot-area.sh) - selected-area screenshot helper.
- [`bin/toggle-call-audio.sh`](bin/toggle-call-audio.sh) - personal PipeWire/Bluetooth audio toggle.
- [`cwm.png`](cwm.png) - screenshot of the setup.
- [`screenshots/`](screenshots/) - curated CWM desktop showcase.

## .cwmrc

The [`.cwmrc`](.cwmrc) contains the complete CWM configuration, including
appearance, window management, groups, and the system-wide keyboard shortcuts
for the current setup.

## Dependencies

- Core: CWM, X11, and `startx`.
- Workflow: `dmenu`, `st`, `tabbed`, and `tmux`.
- Session helpers: `setxkbmap` and `xhidecursor`.
- Optional screen saver: `xscreensaver`, `xscreensaver-command`, and `xset` for display power management.
- Desktop helpers: ImageMagick `import`, `brightnessctl`, and PipeWire `pactl`.
- [uw-ttyp0](https://slackbuilds.org/repository/15.0/system/uw-ttyp0/) - provides the Ttyp0 font used by CWM and dmenu.

Bluetooth support for `toggle-call-audio.sh` additionally requires
`bluetoothctl` and matching local PipeWire device names.

## Notes

This is not a full desktop environment or a turnkey installer. It is the daily
configuration of `r1w1s1` and a reference implementation of a modular CWM/X11
workflow. It can be copied selectively or adapted into another portable X11
workflow.

Some paths, hardware names, and personal commands need adjustment before use.
