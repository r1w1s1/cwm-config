# cwm-config

Minimal CWM setup for Slackware Linux.

This repository is the practical showcase of [Window Manager Agnostic Workflows](https://github.com/r1w1s1/code-notes/blob/main/notes/Window_Manager_Agnostic_Workflows.txt). It is the keyboard-driven X11 desktop I use day to day, built around CWM, sxhkd, dmenu-style helpers, and small shell scripts. The CWM configuration stays focused on window-management behavior, while global desktop actions live outside the window manager.

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
  |     |     +-- xautolock
  |     |     +-- keyboard layout
  |     |     +-- sxhkd ------------ global shortcuts
  |     |     +-- xhidecursor
  |     |     +-- root-daynight.sh - root window background
  |     |
  |     +-- exec cwm --------------- window management
  |
  +-- sxhkd and shell helpers remain outside CWM
```

## Idea

The setup follows a window-manager-agnostic workflow:

- CWM handles focus, groups, window movement, resizing, and borders.
- sxhkd handles global shortcuts that should remain stable across WMs.
- shell scripts handle desktop helpers such as wallpaper/root-window behavior.
- `.xinitrc.common` starts shared session components.
- `.xinitrc.cwm` prepares the X session and selects CWM as the final window manager.

## Workflow

The configuration is divided into two kinds of behavior:

- CWM-specific actions stay in `.cwmrc`: focus, groups, movement, resizing, and appearance.
- Global desktop actions stay in `sxhkd` and shell helpers: launching programs, locking, screenshots, audio, brightness, and background changes.

This keeps the daily keyboard workflow separate from the window manager. CWM can
change without requiring the global shortcuts and desktop helpers to be rebuilt.

More background:

- [Window Manager Agnostic Workflows](https://r1w1s1.srht.site/posts/window-manager-agnostic-workflows/) - the design principle behind keeping global shortcuts and desktop helpers outside CWM.
- [Developer blog: jasper@: cwm in Xenocara](https://undeadly.org/cgi?action=article;sid=20070712103624) - historical CWM context from the OpenBSD Journal (2007), including its keyboard-driven and deliberately lightweight character.
- [Getting started with cwm](https://undeadly.org/cgi?action=article;sid=20090502141551) - practical background on groups, `sticky`, `autogroup`, and keyboard-driven configuration.
- [cwm, just right](https://williamjansson.com/posts/cwm/) - a recent personal perspective on CWM's small size, stacking model, and low cognitive load.

## Files

- [`.cwmrc`](.cwmrc) - CWM appearance, groups, mouse bindings, and WM-specific keybindings.
- [`.xinitrc.cwm`](.xinitrc.cwm) - X session entrypoint for CWM.
- [`.xinitrc.common`](.xinitrc.common) - shared X session helpers used before starting the WM.
- [`sxhkd/sxhkdrc`](sxhkd/sxhkdrc) - global WM-agnostic keybindings.
- [`bin/root-daynight.sh`](bin/root-daynight.sh) - time-based X11 root background helper.
- [`bin/dmenu_run.sh`](bin/dmenu_run.sh) - styled `dmenu_run` launcher wrapper.
- [`bin/menu`](bin/menu) - small dmenu-based desktop menu.
- [`bin/screenshot-full.sh`](bin/screenshot-full.sh) - full-screen screenshot helper.
- [`bin/screenshot-area.sh`](bin/screenshot-area.sh) - selected-area screenshot helper.
- [`bin/toggle-call-audio.sh`](bin/toggle-call-audio.sh) - personal PipeWire/Bluetooth audio toggle.
- [`cwm.png`](cwm.png) - screenshot of the setup.

## .cwmrc

```conf
# Appearance, adapted from the dwm config.
fontname "Iosevka Term:size=11:antialias=true"

borderwidth 1
snapdist 32

color activeborder "#cccccc"
color inactiveborder "#3a3a3a"
color menubg "#1c1c1c"
color menufg "#cccccc"
color font "#cccccc"
color selfont "#1c1c1c"

# Applications.
command term "tabbed -c -n termtab -r 2 st -w '' -e tmux"
command firefox "firefox"

# Use cwm groups like dwm tags/workspaces.
sticky yes
autogroup 1 firefox
ignore xosview

# Main bindings, using Super/Mod4 like the dwm config.
bind-key 4S-Return terminal
bind-key 4-j window-cycle
bind-key 4-k window-rcycle
bind-key 4-c window-close
bind-key 4S-q quit
bind-key 4-r restart

# cwm equivalents for maximize, fullscreen, and minimize/hide.
bind-key 4-m window-maximize
bind-key 4-f window-fullscreen
bind-key 4-h window-hide
bind-key 4S-space window-freeze
bind-key 4-v window-vtile
bind-key 4S-v window-htile

# Groups: Super+number switches, Super+Shift+number moves window.
bind-key 4-1 group-only-1
bind-key 4-2 group-only-2
bind-key 4-3 group-only-3
bind-key 4-4 group-only-4
bind-key 4-5 group-only-5
bind-key 4-6 group-only-6
bind-key 4-7 group-only-7
bind-key 4-8 group-only-8
bind-key 4-9 group-only-9

bind-key 4S-1 window-movetogroup-1
bind-key 4S-2 window-movetogroup-2
bind-key 4S-3 window-movetogroup-3
bind-key 4S-4 window-movetogroup-4
bind-key 4S-5 window-movetogroup-5
bind-key 4S-6 window-movetogroup-6
bind-key 4S-7 window-movetogroup-7
bind-key 4S-8 window-movetogroup-8
bind-key 4S-9 window-movetogroup-9

# Mouse behavior like dwm: Super+left moves, Super+right resizes.
bind-mouse 4-1 window-move
bind-mouse 4-3 window-resize
```

## Dependencies

- Core: CWM, X11, `sxhkd`, and `startx`.
- Workflow: `dmenu`, `st`, `tabbed`, and `tmux`.
- Session helpers: `xautolock`, `slock`, `setxkbmap`, and `xhidecursor`.
- Desktop helpers: `xsetroot`, `hsetroot`, ImageMagick `import`, `brightnessctl`, and PipeWire `pactl`.
- [Iosevka-core](https://slackbuilds.org/repository/15.0/system/Iosevka-core/) - provides the Iosevka font used by CWM and dmenu.

Bluetooth support for `toggle-call-audio.sh` additionally requires
`bluetoothctl` and matching local PipeWire device names.

## Notes

This is not a full desktop environment or a turnkey installer. It is the daily
configuration of `r1w1s1` and a reference implementation of a modular CWM/X11
workflow. It can be copied selectively or adapted into another portable X11
workflow.

Some paths, hardware names, and personal commands need adjustment before use.
