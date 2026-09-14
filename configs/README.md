# Configuration Files

[Português](README.pt.md)

This directory contains optional configuration files for the Linudex environment.

None of the files in this directory are required for the core Linudex stack to work.

The base system only requires:

```text
Android
└── Termux
    ├── Termux:X11
    └── PRoot-Distro
        └── Debian
            └── XFCE
```

The files stored here are intended to make the environment easier to reproduce, customize or restore after a new installation.

## Structure

```text
configs/
├── debian/
│   └── .bashrc
│
├── termux/
│   ├── .bashrc
│   ├── termux.properties
│   ├── termux-x11-preferences.txt
│   ├── README.md
│   └── README.pt.md
│
└── xfce/
    ├── xfconf/
    │   ├── xfce4-desktop.xml
    │   ├── xfce4-keyboard-shortcuts.xml
    │   ├── xfce4-panel.xml
    │   ├── xfwm4.xml
    │   └── xsettings.xml
    │
    └── panel/
        └── whiskermenu-*.rc
```

## Debian configuration

Files under `debian/` are intended for the Debian environment running inside PRoot-Distro.

For example:

```text
configs/debian/.bashrc
```

may be copied to:

```text
/home/linudex/.bashrc
```

It can contain shell aliases, environment variables, prompt customization and other Bash preferences.

## Termux configuration

Files under `termux/` are intended for the Android-side Termux environment.

They may contain:

- Bash aliases
- Shell preferences
- Termux interface settings
- Extra keyboard keys
- Terminal behavior settings
- Termux:X11 preferences

See [`termux/README.md`](termux/README.md) for details.

## XFCE configuration

Files under `xfce/` store the configuration used by the v0.2.0 graphical environment.

They include desktop, panel, keyboard shortcut, window manager, DPI and Whisker Menu settings.

## Important

These configurations are optional.

Linudex should remain functional without them, and installation scripts should not depend on cosmetic or convenience settings unless explicitly documented.
