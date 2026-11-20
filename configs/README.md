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
    └── └── xsettings.xml
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

## XFCE desktop customization

v0.5.0 adds optional Windows 10-inspired XFCE settings: Xfconf XML (panels, shortcuts, keyboard, window manager, themes), GTK CSS, Docklike/Genmon panel settings, SVGs, and the LX logo. Local files normally live under `~/.config/xfce4/xfconf/xfce-perchannel-xml/`, `~/.config/xfce4/panel/`, `~/.config/gtk-3.0/`, `~/.local/share/linudex/`, `~/.local/share/applications/`, and `~/share/icons/linudex/`. Absolute `/home/linudex` paths must be adapted for other user names.

Back up existing settings before replacing files, and stop the panel/session before restoring XML. Do not copy browser profiles, credentials, or unrelated session files. The exported development snapshot predates the latest YouTube, Netflix, and Chromium adjustments; verify the actual device files before publishing launchers. **Prefer scancodes when possible** is an Android Termux:X11 preference requiring manual activation in addition to setting XKB to `br` with an empty variant. The consolidated GTK CSS requires on-device visual validation. The wallpaper is not in the exported backup; Chromium generates individual WebApp icons during installation.

## Visual configurations — v0.5.1

The final layout uses **only the lower XFCE panel**; the upper panel was removed. When exporting `xfce4-panel.xml`, retain current plugin IDs and do not restore the obsolete v0.5.0 upper panel. The original search launcher was replaced by **LinuDex Search v3**, whose separate CSS lives at `~/.config/linudex-search/style.css` alongside its dedicated magnifier SVG.

The utilities menu is presented by a Genmon using `~/.local/share/linudex/chevron-up.svg`. Its dark stylesheet is `~/.config/linudex-quickmenu/style.css`. The Wi-Fi Genmon runs `linudex-wifi-click`; its clickable image is styled through `#genmon-14 .genmon_imagebutton image` with `-gtk-icon-transform: scale(0.75)` in the panel's GTK stylesheet. This plugin ID was validated locally and must be rechecked if a panel is recreated.

**Thunar** was assigned a standard folder icon using the launcher editor. Version only the relevant local launcher rather than replacing system-wide icons. Gallery and settings icons remain theme-provided. Before release, export the final configuration **from the device**, not older pre-v0.5.1 development snapshots.

## Important

These configurations are optional.

Linudex should remain functional without them, and installation scripts should not depend on cosmetic or convenience settings unless explicitly documented.
