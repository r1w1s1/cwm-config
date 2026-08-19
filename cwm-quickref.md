# CWM Quick Reference

A concise reference for day-to-day use of the [Calm Window Manager (CWM)](https://www.openbsd.org/cwm.html).

This is a quick reference, not a replacement for the [`cwm(1)`](https://man.openbsd.org/cwm) and [`cwmrc(5)`](https://man.openbsd.org/cwmrc) manual pages.

## Notation

```text
C     Control
M     Meta / Alt
S     Shift
4     Super / Mod4
M1    left mouse button
M2    middle mouse button
M3    right mouse button
```

Bindings are written with modifiers first. For example, `CM-Return` means
Control+Alt+Return, while `4S-1` means Super+Shift+1.

## Basic Window Management

These are the standard CWM bindings. A `.cwmrc` can change them.

```text
CM-Return    open a terminal
M-Tab        cycle through visible windows
MS-Tab       cycle backward through visible windows
M-/          search for windows
C-/          search for applications
CM-x         close the current window
M-Return     hide the current window
CM-f         toggle fullscreen
CM-m         toggle maximize
CMS-f        freeze the current window geometry
CMS-r        restart CWM
CMS-q        quit CWM
```

## Groups

Groups can be used as lightweight virtual desktops. Windows may belong to one
or more groups, and `sticky yes` makes new windows inherit the current group.

```text
CM-1 ... CM-9     toggle group visibility
CM-a              toggle all groups
CM-g              toggle current window's group membership
CM-s              make the current window sticky
M-Right           cycle to the next group
M-Left            cycle to the previous group
```

To automatically assign applications to groups, use their X11 window name and
class in `.cwmrc`. Inspect these values with `xprop`:

```cwmrc
autogroup 1 "urxvt"
autogroup 1 "xterm"
autogroup 2 "chromium,Chromium"
autogroup 2 "Navigator,Firefox"
```

The last form matches both the window name and window class. Application names
and classes vary between versions, so check them on the target system.

## Movement and Resizing

```text
M-h / M-j / M-k / M-l       move the window a small amount
MS-h / MS-j / MS-k / MS-l   move the window a large amount
CM-h / CM-j / CM-k / CM-l   resize the window a small amount
CMS-h / CMS-j / CMS-k / CMS-l resize the window a large amount
M-M1                        move the window with the mouse
M-M2                        resize the window with the mouse
```

The manual tiling commands place the current floating window into a simple
master-and-stack layout:

```text
window-vtile    vertical master and stack
window-htile    horizontal master and stack
```

They can be assigned to keys in `.cwmrc`, for example:

```cwmrc
bind-key 4-v  window-vtile
bind-key 4S-v window-htile
```

## Application Commands

Applications declared with `command` appear in CWM's application menu.

```cwmrc
command term    "xterm"
command browser "firefox"
```

The command can also be a longer shell command:

```cwmrc
command top "xterm -e top"
```

## Configuration

CWM reads `~/.cwmrc` when it starts. Use the [`cwmrc(5)`](https://man.openbsd.org/cwmrc) manual page for all options and binding functions.

To inspect an application's window properties, run `xprop` and click the
window. To test a configuration without starting the window manager:

```sh
cwm -n -c ~/.cwmrc
```

After editing the file, restart CWM with `CMS-r` or send it a `SIGHUP`.

## This Repository's Bindings

The personal configuration in this repository uses Super/Mod4 for its main
workflow. These bindings are examples, not CWM defaults:

```text
4-j / 4-k       cycle through windows
4-1 ... 4-9     show one group
4S-1 ... 4S-9   move the current window to a group
4-v             vertical tiling
4S-v            horizontal tiling
4-M1 / 4-M3    mouse move / resize
```

See the [real `.cwmrc`](.cwmrc) and the [generic example](examples/cwmrc) for
complete configurations.

## Further Reading

- [`cwm(1)`](https://man.openbsd.org/cwm)
- [`cwmrc(5)`](https://man.openbsd.org/cwmrc)
- [Commented generic `.cwmrc`](examples/cwmrc)
- [CWM desktop showcase](screenshots/)
